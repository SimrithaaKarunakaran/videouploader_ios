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
    
    let cognitoRegion           = AWSRegionType.USWest2
    
    let UserPoolID              = "us-west-2_bB7kdaf7g"
    let Region                  = "us-west-2"
    let IdentityPoolID          = "us-west-2:371ad080-60d9-4623-aefd-f50e3bbd0cb4"
    
    let AppClientID             = "4fr7e4oqt2e7apdvi4tibseu77";
    let AppClientSecret         = "141oakhoer4bbslv42ognobpmp5blce9sbcmqnroaqbrh9pn5m94";
    

    var aws_config  : AWSServiceConfiguration!
    var pool_config : AWSCognitoIdentityUserPoolConfiguration!
    var awsUserPool : AWSCognitoIdentityUserPool!

    
    @IBAction func ButtonLoginClick(_ sender: Any) {
        
        let Username = String(TextViewUsername.text!)
        let Password = String(TextViewPassword.text!)
        

        
        
        
        login(email: Username, password: Password) { (Success, Result) in
            let ResultUnwrapped = Result!

            print("[HK]: Login process complete: \(ResultUnwrapped)" + "(Done Printing)")
            
            if(Success){
                let COGNITO_USERPOOL_PROVIDER = "cognito-idp.\(self.Region).amazonaws.com/\(self.UserPoolID)"
                let tokens = [COGNITO_USERPOOL_PROVIDER: ResultUnwrapped]
                let customIdentityProvider = CustomIdentityProvider(tokens: tokens)
                
                let credentialsProvider = AWSCognitoCredentialsProvider(regionType: self.cognitoRegion,                                                                       identityPoolId: self.IdentityPoolID,identityProviderManager: customIdentityProvider)
                
                let configuration = AWSServiceConfiguration(region: self.cognitoRegion, credentialsProvider: credentialsProvider)
                AWSServiceManager.default().defaultServiceConfiguration = configuration
                
            }
            
            // Update UI seperatley.
            DispatchQueue.main.async { // Correct
                if(Success){
                    self.TextViewError.text = "Success!"
                } else {
                    if ResultUnwrapped.range(of:"error 20") != nil {
                        self.TextViewError.text="Incorrect password!"
                    } else if ResultUnwrapped.range(of:"error 34") != nil {
                        self.TextViewError.text="Username not found!"
                    } else  {
                        self.TextViewError.text = ResultUnwrapped
                    }
                }
            }
        }
      
        
        // Todo: move this to a seperate file eventually.
        final class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
            var tokens: [String : String]?
            
            init(tokens: [String : String]?) {
                self.tokens = tokens
            }
            
             // Each entry in logins represents a single login with an identity provider. The key is the domain of the login provider (e.g. 'graph.facebook.com')
             // and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
            func logins() -> AWSTask<NSDictionary> {
                let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
                return AWSTask(result: logins)
            }
        }
    
    }
    
    // Get a token, then use it for full authentication.
    func login(email: String, password: String, completion: @escaping ((Bool, String?) -> ())) {
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = email
        let user = awsUserPool.getUser(email)
        // Having a user created we can now login with this credentials
        
        user.getSession(email, password: password, validationData: [emailAttr!])
            .continueWith(block: {[weak self] (task) -> Any? in
                
                guard let AWSSession = task.result, task.error == nil else {
                    completion(false, task.error!.localizedDescription)
                    return nil
                }

                // We can use this token for CustomIdentityProvider
                // COGNITO_USERPOOL_PROVIDER = "cognito-idp.\(<COGNITO_REGION>).amazonaws.com/\(<COGNITO_USERPOOL_ID>)"
                // [COGNITO_USERPOOL_PROVIDER: session.idToken?.tokenString]
                completion(true, AWSSession.idToken?.tokenString)
                return nil
            })
    }
    
    
    func restoreSession(completion: @escaping ((String?) -> ())) {
        if let user = awsUserPool.currentUser() {
            // Try to restore prev. session
            user.getSession().continueWith(block: { [weak self] (task) in
                guard let session = task.result, task.error == nil else {
                    print("Restoration failed.")
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
        
        if let user = awsUserPool.currentUser() {
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
        
        
        aws_config = AWSServiceConfiguration(region: self.cognitoRegion, credentialsProvider: nil)
        
        pool_config = AWSCognitoIdentityUserPoolConfiguration(clientId: AppClientID, clientSecret: AppClientSecret, poolId: UserPoolID)
        
        AWSCognitoIdentityUserPool.register(with: aws_config, userPoolConfiguration: pool_config, forKey: "userpool")
        
        awsUserPool = AWSCognitoIdentityUserPool(forKey: "userpool")
        
        
        
        
        
        
        restoreSession(completion: { (Email) in
            let EmailUnwrapped = Email!
            print("[HK]: Restored user with email:")
            print(Email)
            print("Done restoring")
        })
    }
        
        
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


