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
    
    var accessToken     : String?
    
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
    
    
    // Get a token, then use it for full authentication.
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
                
                completion(true, AWSSession.idToken?.tokenString)
                return nil
            })
    }
    
    
    func restoreSession(completion: @escaping ((Bool, String?) -> ())) {
        if let user = GlobalUserPool.currentUser() {
            // Try to restore prev. session
            user.getSession().continueWith(block: { [weak self] (task) in
                guard let session = task.result, task.error == nil else {
                    print("Restoration failed.")
                    completion(false, "")
                    return nil
                }
                print("Restoration successful.")
                
                self!.accessToken = session.accessToken?.tokenString
                                
                self!.getUserDetails()
                
                completion(true, user.username)
                return nil
            })
        } else {
            print("Restoration failed.")
            completion(false, "")
        }
    }
    
    func getUserDetails() {
        // Update UI seperatley.
        if let user = GlobalUserPool.currentUser() {
            user.getDetails().continueWith(block: { (task) in
                if task.error != nil {  // some sort of error
                    print("Error!")
                } else {
                    if let response = task.result as? AWSCognitoIdentityUserGetDetailsResponse {
                        for attribute in response.userAttributes! {
                            if attribute.name == "email" {
                                print("Found email")
                                print(attribute.value)
                            }
                        }
                    }
                }
                
                return nil
            })
        }
        
        return
    }
    
    
    

}

