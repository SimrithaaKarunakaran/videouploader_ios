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
    
    @IBOutlet weak var ButtonLogin: UIButton!
    
    @IBOutlet weak var TextSignUpLink: UILabel!
    
    
    let cognitoRegion            = AWSRegionType.USWest2
    let cognitoIdentityPoolId    = "us-west-2_bB7kdaf7g";
    let AppClientID              = "6arguf9m5ecvbgulsei89ketnm";
    let AppClientSecret          = "178ml88t93a5cvjndco5ao7asu7r2omcl4lbopsee96s40kticis";
    

    var aws_config  : AWSServiceConfiguration!
    var pool_config : AWSCognitoIdentityUserPoolConfiguration!
    var awsUserPool : AWSCognitoIdentityUserPool!
    
    /// <#Description#>
    /// Windows, alt, slash
    /// - Parameter sender: <#sender description#>
    @IBAction func ButtonLoginClick(_ sender: Any) {
        os_log("[HK] Button click detected.")
        
        let Username = String(TextViewUsername.text!)
        let Password = String(TextViewPassword.text!)
        
        
        // Settings for UserPool (login)

        
        
        aws_config = AWSServiceConfiguration(region: cognitoRegion, credentialsProvider: nil)
        
        pool_config = AWSCognitoIdentityUserPoolConfiguration(clientId: AppClientID, clientSecret: AppClientSecret, poolId: cognitoIdentityPoolId)
        AWSCognitoIdentityUserPool.register(with: aws_config, userPoolConfiguration: pool_config, forKey: "userpool")
        
        awsUserPool = AWSCognitoIdentityUserPool(forKey: "userpool")
        
        login(email: Username, password: Password, completion:      { ( result) in
            print("[HK]: Login process complete: \(result)")
        })
        
  
        
        /*

        self.DownloadUserData(UserEmail:Username)
        
        
        // Move to the next viewpager: the pick-deck screen.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck") 
        self.present(newViewController, animated: true, completion: nil)*/
        
    }
    
    
    func login(email: String, password: String, completion: @escaping ((String?) -> ())) {
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = email
        let user = awsUserPool.getUser(email)
        // Having a user created we can now login with this credentials
        
        user.getSession(email, password: password, validationData: [emailAttr!])
            .continueWith(block: {[weak self] (task) -> Any? in
                
                guard let session = task.result, task.error == nil else {
                    print(task.error)
                    print("[HK] Login error.")
                    return nil
                }
                
                print("[HK] Login token.")
                print(session.idToken?.tokenString)
                // We can use this token for CustomIdentityProvider
                // COGNITO_USERPOOL_PROVIDER = "cognito-idp.\(<COGNITO_REGION>).amazonaws.com/\(<COGNITO_USERPOOL_ID>)"
                // [COGNITO_USERPOOL_PROVIDER: session.idToken?.tokenString]
                completion(session.idToken?.tokenString)
                return nil
            })
    }

    
    ///
    func DownloadUserData(UserEmail: String){

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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


