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


var timer          = Timer()

class vc_launchscreen: UIViewController, UITextFieldDelegate {
    

    
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var SecondsTillTransition = 2;
    
    func runTimer() {
        if(isTimerRunning == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(vc_launchscreen.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true;
        }
    }
    
    
    @objc func updateTimer() {
        
        // Decrement number of seconds left.
        SecondsTillTransition -= 1
        
        if(SecondsTillTransition == 0){
            timer.invalidate();
            
            // Move to the next viewpager: the login screen.
            
            /*
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_login") as! UIViewController
            self.present(newViewController, animated: true, completion: nil)
            */
            
            print("[HK] Timer is up: transitioning.")
            if AWSSignInManager.sharedInstance().isLoggedIn {
                print("[HK] User is currently logged in.")

                // If we are logged in, lets go to "Select Deck" for now.
                let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck")
                self.present(newViewController, animated: true, completion: nil)
                
            } else {
                presentAuthUIViewController()

            }
        }
    }
    
    
    func presentAuthUIViewController() {

        print("\n[HK] Presenting AuthUIViewController.")

        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.logoImage = #imageLiteral(resourceName: "LogoTitle.png")
        config.backgroundColor = UIColor.blue
        config.font = UIFont (name: "Helvetica Neue", size: 18)
        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        
        AWSAuthUIViewController
            .presentViewController(with: self.navigationController!,
                                   configuration: config,
                                   completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                    if error != nil {
                                        print("Error occurred: \(String(describing: error))")
                                        print("\n[HK] Error.")
                                    } else {
                                        // sign in successful.
                                        print("\n[HK] Success.")
                                    }
            })
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

