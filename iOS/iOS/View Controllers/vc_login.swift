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

    
    @IBAction func ActionTrigger(_ sender: UITextView) {
        sender.resignFirstResponder()
    }
    
    @IBAction func ButtonLoginClick(_ sender: Any) {
        
        
        
        let LastUsername = String(TextViewUsername.text!)
        let LastPassword = String(TextViewPassword.text!)
      
        GameEngineObject?.login(email: LastUsername, password: LastPassword) { (Success, Result) in
            GameEngineObject?.accessToken     = Result!

            if(Success){
                
                GameEngineObject.fullyAuthenticateWithToken(sessionCompletion: { (Success) in
                    // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                    print("[HK] Fully authenticated.")
                    
                    GameEngineObject.downloadUserData(email: GameEngineObject.UserEmail!, completion: { (Success) in
                        print("[HK] DownloadUserData callback: \(Success)")
                        
                        DispatchQueue.main.async { // Correct
                            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                            self.present(newViewController, animated: false, completion: nil)
                        }
                    })
                })
                
            }
            else {
                // Update UI separately..
                DispatchQueue.main.async { // Correct
                    if(!Success){
                        if GameEngineObject?.accessToken?.range(of:"error 20") != nil {
                            self.TextViewError.text="Incorrect password!"
                        } else if GameEngineObject?.accessToken?.range(of:"error 34") != nil {
                            self.TextViewError.text="Username not found!"
                        } else  {
                            self.TextViewError.text = GameEngineObject.accessToken
                        }
                    }
                }
            }
        }
    }
    

    @objc func TextSignUpClickHandler(sender:UITapGestureRecognizer) {
        // Direct user to screen where they can create an account.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_create_account")
        self.present(newViewController, animated: false, completion: nil)
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


