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

    
    @IBOutlet weak var LabelTimeLeft: UILabel!
    var seconds        = 3 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer          = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
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
            // Instead of time = 0, we write "go!"
            LabelTimeLeft.text = "Go!";
        } else if(seconds <= -1){
            // Cancel this timer
            timer.invalidate();
    
            // Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_pageviewctrl") as! UIPageViewController
            self.present(newViewController, animated: true, completion: nil)
        } else {
            // Update the number of seconds remaining.
            LabelTimeLeft.text = "\(seconds)";
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the timer.
        runTimer();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonClickStartPager(_ sender: UIButton) {
       // Navigate to View Pager.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)

        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_pageviewctrl") as! UIPageViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
   
    
    
}

