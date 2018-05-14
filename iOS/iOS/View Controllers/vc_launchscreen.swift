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
    
    func runTimer() {
        if(isTimerRunning == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(vc_launchscreen.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true;
        }
    }
    
    
    final class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
        var tokens: [String : String]?
        
        init(tokens: [String : String]?) {
            self.tokens = tokens
        }
        
        func logins() -> AWSTask<NSDictionary> {
            let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
            return AWSTask(result: logins)
        }
    }
    
    
    @objc func updateTimer() {
        
        // Decrement number of seconds left.
        SecondsTillTransition -= 1
        
        if(SecondsTillTransition == 0){
            timer.invalidate();
           
            print("[HK] Timer is up: transitioning.")

            // If we are logged in, lets go to "Select Deck" for now.
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

