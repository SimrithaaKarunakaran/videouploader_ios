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

    @IBOutlet weak var TextLoginTitle: UILabel!
    @IBOutlet weak var LoadingProgress: UIActivityIndicatorView!
    
    @IBAction func ActionTrigger(_ sender: UITextView) {
        sender.resignFirstResponder()
    }
    
    @IBAction func ButtonLoginClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        let LastUsername = String(TextViewUsername.text!)
        let LastPassword = String(TextViewPassword.text!)
        
        HandleLoginClick(Username: LastUsername, Password: LastPassword)
    }
    
    
    func HandleLoginClick(Username: String, Password: String){

        
        ButtonLogin.resignFirstResponder()
        
        self.LoadingProgress.startAnimating()
        
        
        GameEngineObject?.login(email: Username, password: Password) { (Success, Result) in
            GameEngineObject?.accessToken     = Result!
            
            if(Success){
                
                GameEngineObject.fullyAuthenticateWithToken(sessionCompletion: { (Success) in
                    // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                    print("[HK] Fully authenticated.")
                    
                    GameEngineObject.downloadUserData(email: GameEngineObject.UserEmail!, completion: { (Success) in
                        print("[HK] DownloadUserData callback: \(Success)")
                        
                        DispatchQueue.main.async { // Correct
                            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player_nav")
                            self.present(newViewController, animated: false, completion: nil)
                        }
                    })
                })
                
            }
            else {
                
                // Update UI separately..
                DispatchQueue.main.async { // Correct
                    if(!Success){
                        
                        self.LoadingProgress.stopAnimating()
                        
                        if GameEngineObject?.accessToken?.range(of:"error 20") != nil {
                            self.TextViewError.text="Incorrect password!"
                        } else if GameEngineObject?.accessToken?.range(of:"error 34") != nil {
                            self.TextViewError.text="Username not found!"
                        } else  {
                            self.TextViewError.text = "Invalid credentials!"
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Restore to portrait mode in case the user arrived here from in-game session.
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    @objc func TextSignUpClickHandler(sender:UITapGestureRecognizer) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Direct user to screen where they can create an account.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_create_account")
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func AutoLoginClickHandler(sender:UITapGestureRecognizer) {
        HandleLoginClick(Username: "demo@gmail.com", Password: "Cureaut1sm!")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the "loading" animation not show up initially.
        LoadingProgress.hidesWhenStopped = true
        
        // Setup the onclick handler when user presses the "Don't Have An Account" link
        let tap = UITapGestureRecognizer(target: self, action: #selector(vc_login.TextSignUpClickHandler))
        TextSignUpLink.isUserInteractionEnabled = true
        TextSignUpLink.addGestureRecognizer(tap)
        
        // Quick trick to auto-login: tap the "Log In" title.
        let autolog = UITapGestureRecognizer(target: self, action: #selector(vc_login.AutoLoginClickHandler))
        TextLoginTitle.isUserInteractionEnabled = true
        TextLoginTitle.addGestureRecognizer(autolog)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


