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



class DBManager {
    
    // An instance of the dynamo DB that we can use for queries. Set to US EAST region as required.
    var dynamoDBCustom : AWSDynamoDB?
    
    var accessToken    : String?
    
    // The data structure that holds dictionaries of all entries associated with our email address.
    // This is an array of dictionaries.
    var UserDBResults  : [[String : AWSDynamoDBAttributeValue]]?
    
    var UserEmail      : String?
    

    init() {
        // Configuration (for Cognito)
        let GlobalAWSConfig  = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: nil)
        
        let GlobalPoolConfig = AWSCognitoIdentityUserPoolConfiguration(clientId: GlobalAppClientID, clientSecret: GlobalAppClientSecret, poolId: GlobalUserPoolID)
        
        AWSCognitoIdentityUserPool.register(with: GlobalAWSConfig, userPoolConfiguration: GlobalPoolConfig, forKey: GlobalUserPoolID)
        
        GlobalUserPool = AWSCognitoIdentityUserPool(forKey: GlobalUserPoolID)
    }
    
    
    // Call this function AFTER login is complete and we have a token.
    func initializeDynamo() {
        let aws_config  = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: GlobalCredentialsProvider)
        AWSDynamoDB.register(with: aws_config!, forKey: "USEAST1Dynamo");
        dynamoDBCustom = AWSDynamoDB(forKey: "USEAST1Dynamo")
    }
    
    
    // Get a token, then use it for full authentications
    

    
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
                    sessionCompletion(false, "")
                    return nil
                }
                
                // Save the access token for authentication of other AWS services.
                self!.accessToken = session.accessToken?.tokenString
            
                BackendManager.getUserEmail(completion: { (Success, Email) in
                    sessionCompletion(Success, Email)
                })
    
                return nil
            })
        } else {
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
        GlobalTokens             = [GlobalCognitoUserpoolProvider: BackendManager.accessToken!]
        GlobalIdentityProvider   = CustomIdentityProvider(tokens: GlobalTokens)
        
        // PASS THE TOKEN FROM USERPOOL TO AWS
        GlobalCredentialsProvider = AWSCognitoCredentialsProvider(regionType: GlobalRegionObject, identityPoolId: GlobalIdentityPoolID, identityProviderManager: GlobalIdentityProvider)
        
        let configuration = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: GlobalCredentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        GlobalCredentialsProvider.getIdentityId().continueWith(block:{ (task) in
            guard task.error == nil else {
                print(task.error)
                sessionCompletion(false)
                return nil
            }
           
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
    
    
    func downloadUserData(email:String, completion: @escaping ((Bool) -> ())){

        // Pre-process email: removing any dots (period) in the first half of the email before the "@".
        let emailArr = email.components(separatedBy: "@")
        
        var P1 = emailArr[0]
        var P2 = emailArr[1]
        
        P1 = P1.replacingOccurrences(of: ".", with: "")
        
        var FinalEmail = P1 + P2

        print("Downloading user data with Final Email: \(FinalEmail)")
        let atVal = AWSDynamoDBAttributeValue()!
        atVal.s = FinalEmail
        
        let condition = AWSDynamoDBCondition()!
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        condition.attributeValueList = [atVal]
        
        let myDic: [String: AWSDynamoDBCondition] = ["email": condition]
        let query = AWSDynamoDBQueryInput()!
        
        query.tableName = "HeadsUpSurveys"
        query.keyConditions = myDic
        
        print("Entered downloadUserData with email: \(email)")
        
        BackendManager.dynamoDBCustom?.query(query).continueWith(block: { (task) in
            guard task.error == nil else {
                print(task.error)
                completion(false)
                return nil
            }
            
            let results = task.result as AWSDynamoDBQueryOutput!
            self.UserDBResults = results!.items!
            
            print("Entered downloadUserData query callback.")
            
            // For each user (e.g. child)
            for item in self.UserDBResults!{
                print("Printing item name: ")
                
                var val = item["name"]
                print(val?.s)
            }
            
            completion(true)
            // Return success to listener.
            return nil
        })
    }
    
    
    

}

