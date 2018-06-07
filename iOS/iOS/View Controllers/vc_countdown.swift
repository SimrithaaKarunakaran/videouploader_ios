//
//  vc_secondary.swift
//  iOS
//
//  Created by Haik Kalantarian on 4/25/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import os.log

class vc_countdown: UIViewController {

    
    var seconds        = 3 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer          : Timer?
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    @IBOutlet weak var TextTimeRemaining: UILabel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    //    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    
    func runTimer() {
        if(isTimerRunning == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(vc_countdown.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true;
        }
        
    }
    
    
     @objc func updateTimer() {
        
        // Decrement number of seconds left.
        seconds -= 1
        
        if(seconds == 0){
            
            // Play chime sound.
            AudioManagerObject.PlayChime()
            
            // Instead of time = 0, we write "go!"
            TextTimeRemaining.text = "Go!";
        } else if(seconds <= -1){
            // Cancel this timer
            timer?.invalidate();
    
             //Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "nav_main_game")
            self.present(newViewController, animated: false, completion: nil)
        } else {
            // Update the number of seconds remaining.
            TextTimeRemaining.text = "\(seconds)";
            
            // Play marimba sound.
            if(seconds > 0 && (seconds <= 4)){
                AudioManagerObject.PlayMarimba()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Start the timer.
        runTimer();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

