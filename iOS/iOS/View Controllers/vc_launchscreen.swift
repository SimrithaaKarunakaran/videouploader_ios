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
    

    
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var SecondsTillTransition = 2;
    
    
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
            timer.invalidate();
           
            //First, lets check if the user is already signed in from a previous session.
            BackendManager.restoreSession(sessionCompletion: { (Success, Email) in
                if(Success){
                    // Restored the user's session from last time?
                    // No reason to make them log in. Download full user data and proceed.

                    BackendManager.fullyAuthenticateWithToken(sessionCompletion: { (Success) in
                        // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                        print("[HK] Fully authenticated.")
                        
                        BackendManager.downloadUserData(email: BackendManager.UserEmail!, completion: { (Success) in
                            print("[HK] DownloadUserData callback: \(Success)")
                            
                            DispatchQueue.main.async { // Correct
                                let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        })
                    })
                    
                } else {
                    // Failed to restore the user? Take them to the login screen
                    // That way, they can login the "normal" way.
                    DispatchQueue.main.async {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_login")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                }
            }); // End RestoreSession
            
            print("[HK] Timer is up: transitioning.")
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    @IBAction func ButtonClickNext(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToSecond", sender: self)
    }
    
    @IBAction func ButtonClickNextStoryboard(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "story_pageview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "story_one_viewcontroller") as UIViewController
        present(vc, animated: true, completion: nil)
    }
 */
    
    
}

