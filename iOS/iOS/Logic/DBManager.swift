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


class DBManager {
    
    init() {
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
    
    
    func restoreSession(completion: @escaping ((String?) -> ())) {
        if let user = GlobalUserPool.currentUser() {
            // Try to restore prev. session
            user.getSession().continueWith(block: { [weak self] (task) in
                guard let session = task.result, task.error == nil else {
                    print("Restoration failed.")
                    completion("")
                    return nil
                }
                print("Restoration successful.")
                self!.getUserDetails()
                
                completion(user.username)
                return nil
            })
        } else {
            print("Restoration failed.")
            completion("")
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
    
    
    // Each entry in logins represents a single login with an identity provider. The key is the domain of the login provider (e.g. 'graph.facebook.com')
    // and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
 //   func logins() -> AWSTask<NSDictionary> {
 //       let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
  //      return AWSTask(result: logins)
 //   }
}

