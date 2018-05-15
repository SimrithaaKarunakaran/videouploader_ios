//
//  vc_login.swift
//  iOS
//
//  Created by Haik Kalantarian on 4/30/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import os.log
import AWSCore
import AWSCognitoIdentityProvider
import AWSUserPoolsSignIn



class vc_login: UIViewController {
    
    @IBOutlet weak var TextViewUsername: UITextField!
    @IBOutlet weak var TextViewPassword: UITextField!
    @IBOutlet weak var ButtonLogin:      UIButton!
    @IBOutlet weak var TextSignUpLink:   UILabel!
    @IBOutlet weak var TextViewError:    UILabel!

    @IBAction func ButtonLoginClick(_ sender: Any) {
        
        let LastUsername = String(TextViewUsername.text!)
        let LastPassword = String(TextViewPassword.text!)
        
       
        login(email: LastUsername, password: LastPassword) { (Success, Result) in
            GlobalUserToken     = Result!

            if(Success){
                // PACKAGE OUR TOKEN FROM IDENTITY POOL
                GlobalTokens             = [GlobalCognitoUserpoolProvider: GlobalUserToken]
                GlobalIdentityProvider   = CustomIdentityProvider(tokens: GlobalTokens)

                // PASS THE TOKEN FROM USERPOOL TO AWS
                GlobalCredentialsProvider = AWSCognitoCredentialsProvider(regionType: GlobalRegionObject, identityPoolId: GlobalIdentityPoolID, identityProviderManager: GlobalIdentityProvider)
                
                let configuration = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: GlobalCredentialsProvider)
                AWSServiceManager.default().defaultServiceConfiguration = configuration
              
                GlobalCredentialsProvider.getIdentityId().continueWith(block:{ (task) in
                    guard task.error == nil else {
                        print(task.error)
                        return nil
                    }
                    // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                    print("[HK] Fully authenticated.")
                    UserEmailValidated = LastUsername
                    return task
                })
            }
            
            // Update UI separately..
            DispatchQueue.main.async { // Correct
                if(Success){
                    //self.TextViewError.text = "Success!"
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                    self.present(newViewController, animated: true, completion: nil)
                    
                } else {
                    if GlobalUserToken.range(of:"error 20") != nil {
                        self.TextViewError.text="Incorrect password!"
                    } else if GlobalUserToken.range(of:"error 34") != nil {
                        self.TextViewError.text="Username not found!"
                    } else  {
                        self.TextViewError.text = GlobalUserToken
                    }
                }
            }
        }
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
    
    
    @objc func TextSignUpClickHandler(sender:UITapGestureRecognizer) {
        // Direct user to screen where they can create an account.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_create_account")
        self.present(newViewController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the onclick handler when user presses the "Don't Have An Account" link
        let tap = UITapGestureRecognizer(target: self, action: #selector(vc_login.TextSignUpClickHandler))
        TextSignUpLink.isUserInteractionEnabled = true
        TextSignUpLink.addGestureRecognizer(tap)

        /*
        restoreSession(completion: { (Email) in
            let EmailUnwrapped = Email!
            print("[HK]: Restored user with email:")
            print(Email)
        }) */
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


