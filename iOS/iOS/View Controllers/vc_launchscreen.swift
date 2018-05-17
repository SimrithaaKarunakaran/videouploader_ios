//
//  ViewController.swift
//  iOS
//
//  Created by Haik Kalantarian on 3/12/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import os.log
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import AWSUserPoolsSignIn

import AWSCore
import AWSCognitoIdentityProvider

var timer          = Timer()

class vc_launchscreen: UIViewController, UITextFieldDelegate {
    

    
    var isTimerRunning        = false //This will be used to make sure only one timer is created at a time.
    var SecondsTillTransition = 1;
    
    /// Start a timer that will show the user our game logo for three seconds before transitioning away.
    func runTimer() {
        if(isTimerRunning == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(vc_launchscreen.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true;
        }
    }
    
    /// Timer callback.
    @objc func updateTimer() {
        
        // Decrement number of seconds left.
        SecondsTillTransition -= 1
        
        if(SecondsTillTransition == 0){
            // Cancel the timer, since now its "up"- we have shown the logo long enough.
            timer.invalidate();
           
            //First, lets check if the user is already signed in from a previous session.
            GameEngineObject.restoreSession(sessionCompletion: { (Success, Email) in
                if(Success){
                    // It seems we have a token from a previous login. Lets try to authenticate with this token.
                    // If it succeeds, we may be able to skip the login process.
                    GameEngineObject.fullyAuthenticateWithToken(sessionCompletion: { (Success) in
                        if(Success){
                            // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                            // Download all user data associated with this account, and redirect when we're done.
                            GameEngineObject.downloadUserData(email: GameEngineObject.UserEmail!, completion: { (Success) in
                                if(Success){
                                    DispatchQueue.main.async { // Correct
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                                        self.present(newViewController, animated: true, completion: nil)
                                    }
                                } else {
                                    // The login token is still bad: so we redirect to login screen.
                                    self.RedirectToLoginScreenMainThread()
                                }
                            })
                        } else {
                            // Failed to fully authenticate with the token. This means the token has probably expired.
                            // Lets redirect them to signon-screen.
                            self.RedirectToLoginScreenMainThread()
                        }
                    })
                    
                } else {
                    // Failed to restore the user? Take them to the login screen
                    // That way, they can login the "normal" way.
                    self.RedirectToLoginScreenMainThread()

                }
            }); // End RestoreSession
            
            print("[HK] Timer is up: transitioning.")
        }
    }
    
    /// This function is called whenever one of our asynchronous callbacks indicate
    /// That the user's session cannot be restored: lets redirect them to the login screen.
    func RedirectToLoginScreenMainThread(){
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_login")
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("[HK] viewDidLoad callback.")
        // Start the timer.
        runTimer();
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}

