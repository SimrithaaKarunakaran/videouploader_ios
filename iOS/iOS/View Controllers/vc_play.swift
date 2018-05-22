//
//  vc_play.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/21/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_play: UIViewController {

    var seconds        = 90 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer          : Timer?
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    @IBOutlet weak var TextTime: UILabel!
    @IBOutlet weak var TextScore: UILabel!
    @IBOutlet weak var GameImageView: UIImageView!
    
    func runTimer() {
        if(isTimerRunning == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(vc_countdown.updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true;
        }
    }
    
    
    @objc func updateTimer() {
        
        // Decrement number of seconds left.
        seconds -= 1
        
        // Update the number of seconds remaining.
        TextTime.text = "\(seconds)";
        
        let EmojiObject = PromptManager.GetNextImage()
        
        let image       = UIImage(named:EmojiObject.FileName!)
    
        GameImageView.image = image
        print("Showing image with file name: \(EmojiObject.FileName!)")
        
        
        
        
        
        if(seconds == 0){
            //Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_play")
            self.present(newViewController, animated: false, completion: nil)
        } else {

        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        runTimer(); // Start the timer.
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PromptManager.LoadPromptsForGame(PromptArray: GameEngineObject.ArraySelected)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
}
