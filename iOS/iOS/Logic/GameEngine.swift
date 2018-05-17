//
//  DBManager.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/14/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognitoIdentityProvider
import AWSUserPoolsSignIn
import AWSDynamoDB



class GameEngine {
    
    // An instance of the dynamo DB that we can use for queries. Set to US EAST region as required.
    var dynamoDBCustom : AWSDynamoDB?
    
    // The accessToken is obtained from the IdentityProvider on AWS when the user logs in, and grants the user access to Dynamo and S3.
    var accessToken    : String?
    
    // The array that holds dictionaries of all entries associated with our email address.
    var UserDBResults  : [[String : AWSDynamoDBAttributeValue]]?
    
    // The name of the child that the user has elected to play with.
    var SelectedChildIndex : Int?
    
    // The email address of the user currently signed in.
    var UserEmail      : String?
    
    // This is a container that will store information about the child as it is filled out in survey 1, as well as the consent forms.
    var NewEntry : DDBTableRow?
    
    
    init() {
        // Configuration (for Cognito)
        let GlobalAWSConfig  = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: nil)
        
        let GlobalPoolConfig = AWSCognitoIdentityUserPoolConfiguration(clientId: GlobalAppClientID, clientSecret: GlobalAppClientSecret, poolId: GlobalUserPoolID)
        
        AWSCognitoIdentityUserPool.register(with: GlobalAWSConfig, userPoolConfiguration: GlobalPoolConfig, forKey: GlobalUserPoolID)
        
        GlobalUserPool = AWSCognitoIdentityUserPool(forKey: GlobalUserPoolID)
    }
    
    
    /// This function initializes DynamoDB, which stores survey/user information./
    /// These steps are necessasry because DynamoDB table is in a different region than our Cognito User Pool.
    /// Make sure you call this function AFTER login / restoration is complete, and we have a token.
    func initializeDynamo() {
        let aws_config  = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: GlobalCredentialsProvider)
        AWSDynamoDB.register(with: aws_config!, forKey: "USEAST1Dynamo");
        dynamoDBCustom = AWSDynamoDB(forKey: "USEAST1Dynamo")
        
        // Setup object mapper for use later.
        let ObjectMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        AWSDynamoDBObjectMapper.register(with: aws_config!, objectMapperConfiguration: ObjectMapperConfig, forKey: "USEAST1_MAPPER")
        print("[HK] DynamoDB successfully initialized.")
    }
    
    
    
    
    /// This object mapper will help us read from, and write-to, the database.
    /// We have to get it in a non-standard way (see initializeDynamo) because it is in a different region
    /// Compared to the Cognito User pool of our default AWS configuration.
    ///
    /// - Returns: <#return value description#>
    func getDynamoObjectMapper() -> AWSDynamoDBObjectMapper {
        return AWSDynamoDBObjectMapper(forKey: "USEAST1_MAPPER")
    }
    
    
    
    /// When user decides to 'add a child' to the game, we use this function
    /// toa dd the prepopulated DDBTableRow to DynamoDB.
    /// - Parameter row: The completed DDBTableRow object containing user data.
    func AddUserToDynamo(row: DDBTableRow, completion: @escaping ((Bool) -> ())){
        
        print("[HK] Attempting to save entry to DynamoDB with email and name: \(row.email) , \(row.name)")

        getDynamoObjectMapper().save(row, completionHandler: { (error: Error?) -> Void in
            
            guard error == nil else {
                print("[HK] Amazon DynamoDB Save Error: \(error)")
                completion(false)
                return
            }
            
            print("[HK] Saved an entry to DynamoDB.")
            completion(true)
        })
    }
    
   

    
    /// This function attempts to log in the user. The callback returns true if the login
    /// was successful, and false otherwise. If true, the second callback variable
    /// contains the authentication token from the Identity Pool. After successfully
    /// calling login, you must call fullyAuthenticateWithToken to finalize this process.
    ///
    /// - Parameters:
    ///   - email: The email address of the user, with no post-processing
    ///   - password: The password that the user has filled out.
    ///   - completion: The callback for when login is complete.
    func login(email: String, password: String, completion: @escaping ((Bool, String?) -> ())) {
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = email
        let user = GlobalUserPool.getUser(email)
        
        user.getSession(email, password: password, validationData: [emailAttr!])
            .continueWith(block: {[weak self] (task) -> Any? in
                
                guard let AWSSession = task.result, task.error == nil else {
                    completion(false, task.error!.localizedDescription)
                    return nil
                }
                
                self?.UserEmail = email

                completion(true, AWSSession.idToken?.tokenString)
                return nil
            })
    }
    
    
    
    func signup(email: String, password: String, completition: @escaping ((Bool?) -> ())) {
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = email
        
        GlobalUserPool.signUp(email, password: password, userAttributes: [emailAttr!], validationData: nil)
            .continueWith(block: {[weak self] (task) -> Any? in
                
                guard task.error == nil else {
                    print("[HK] Failed to create a user account: \(task.error)")
                    completition(false)
                    return nil
                }
                
                print("[HK] Successfully created a user account")
                completition(true)
                return nil
            })
        //user = GlobalUserPool.getUser(email),
    }
    
    
    
    
    /// Instead of logging in with a username-password, this function will
    /// try to restore the login from a previous session. As before, once restored,
    /// you must call  fullyAuthenticateWithToken to finish the authentication process.
    ///
    /// - Parameter sessionCompletion: <#sessionCompletion description#>
    func restoreSession(sessionCompletion: @escaping ((Bool, String?) -> ())) {
        if let user = GlobalUserPool.currentUser() {
            // Try to restore prev. session
            user.getSession().continueWith(block: { [weak self] (task) in
                guard let session = task.result, task.error == nil else {
                    print("[HK] RestoreSession returning false (1).")
                    sessionCompletion(false, "")
                    return nil
                }
            
                // Save the access token for authentication of other AWS services.
                self!.accessToken = session.accessToken?.tokenString
                print("[HK] RestoreSession returned with access token: \(self!.accessToken)")

                GameEngineObject.getUserEmail(completion: { (Success, Email) in
                    sessionCompletion(Success, Email)
                })
                
                return nil
            })
        } else {
            print("[HK] RestoreSession returning false (2).")
            sessionCompletion(false, "")
        }
    }
    
    
    
    /// Performs the final step of the sign-in process: taking the token Then initializes Dynamo.
    /// obtained from the Cognito User Pool, and using it to authenticate our access to other AWS services.
    /// Finally, initializes DynamoDB.
    ///
    /// - Parameter sessionCompletion: True if this was successful, and false if otherwise.
    func fullyAuthenticateWithToken(sessionCompletion: @escaping ((Bool) -> ())){
        // PACKAGE OUR TOKEN FROM IDENTITY POOL
        GlobalTokens             = [GlobalCognitoUserpoolProvider: GameEngineObject.accessToken!]
        GlobalIdentityProvider   = CustomIdentityProvider(tokens: GlobalTokens)
        
        // PASS THE TOKEN FROM USERPOOL TO AWS
        GlobalCredentialsProvider = AWSCognitoCredentialsProvider(regionType: GlobalRegionObject, identityPoolId: GlobalIdentityPoolID, identityProviderManager: GlobalIdentityProvider)
        
        let configuration = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: GlobalCredentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        GlobalCredentialsProvider.getIdentityId().continueWith(block:{ (task) in
            guard task.error == nil else {
                print("[HK] fullyAuthenticateWithToken returning false: \(task.error)")
                print(task.error)
                sessionCompletion(false)
                return nil
            }
            print("[HK] fullyAuthenticateWithToken returning true...")
            // Initialize dynamo now that we have access.
            self.initializeDynamo()
            sessionCompletion(true)
            return task
        })
    }
    
    
    /// Get the email of the currently signed in user.
    ///
    /// - Parameter completion: Callback with parameter #1 representing of the operation
    ///                         was successful, and parameter #2 being the email address.
    func getUserEmail(completion: @escaping ((Bool, String?) -> ())) {
        // Update UI seperatley.
        if let user = GlobalUserPool.currentUser() {
            user.getDetails().continueWith(block: { (task) in
                if task.error != nil {  // some sort of error
                    print("Error!")
                    completion(false, "")
                } else {
                    if let response = task.result as? AWSCognitoIdentityUserGetDetailsResponse {
                        for attribute in response.userAttributes! {
                            if attribute.name == "email" {
                                self.UserEmail = attribute.value
                                completion(true, self.UserEmail)
                            }
                        }
                    }
                }
                
                return nil
            })
        }
        
        return
    }
    
    
    func getDBFriendlyEmail(email: String) -> String {
        let emailArr = email.components(separatedBy: "@")
        var P1 = emailArr[0]
    
        P1 = P1.replacingOccurrences(of: ".", with: "")
        
        return (P1 + "@" + emailArr[1])
    }
    
    
    /// Pull user data associated with the given email address.
    /// Then, store it locally and notify the caller that it is ready.
    /// - Parameters:
    ///   - email: Email addres (raw) of the user in question.
    ///   - completion: Callback with boolean value representing if operation was successful.
    func downloadUserData(email:String, completion: @escaping ((Bool) -> ())){

        let FinalEmail = getDBFriendlyEmail(email: email)

        print("Downloading user data with email: \(FinalEmail)")
        let atVal = AWSDynamoDBAttributeValue()!
        atVal.s = FinalEmail
        
        let condition = AWSDynamoDBCondition()!
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        condition.attributeValueList = [atVal]
        
        let myDic: [String: AWSDynamoDBCondition] = ["email": condition]
        let query = AWSDynamoDBQueryInput()!
        
        query.tableName = "HeadsUpSurveys"
        query.keyConditions = myDic
  
        GameEngineObject.dynamoDBCustom?.query(query).continueWith(block: { (task) in
            guard task.error == nil else {
                print(task.error)
                completion(false)
                return nil
            }
            
            let results = task.result as AWSDynamoDBQueryOutput!
            self.UserDBResults = results!.items!
            
            // For each user (e.g. child)
            for item in self.UserDBResults!{
                var val = item["name"]
                //print("Printing item name: \(val?.s)")
            }
            
            completion(true)
            // Return success to listener.
            return nil
        })
    }
    
}

