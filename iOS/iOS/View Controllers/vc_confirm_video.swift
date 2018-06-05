//
//  vc_confirm_video.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/22/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



class vc_confirm_video: UIViewController {

    var VideoSharedOnce = false
    
    var ConfirmSelectionTimer : Timer?
    
    @IBOutlet weak var ScreenText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func ShareVideoButton(_ sender: Any) {
        VideoSharedOnce = true
        SetupPlayback()
    }
    
    // Every second, this function is called. It just updates # of seconds remaining.
    // Also ends the game when time runs out.
    @objc func ChangeScreensCallback() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    
    // Make sure we restore the UI to portrait mode after the view disappears.
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    /// This function starts the main game clock timer: if it isn't started already.
    func StartDelayTimer() {
        ConfirmSelectionTimer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(self.ChangeScreensCallback)), userInfo: nil, repeats: false)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func SetupPlayback(){
        // Getting the shared instance of the audio session and setting audio to continue playback when the screen is locked.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("[PLAY] Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        print("[PLAY] Playing back video at URL: \(VideoFileURL)")
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: VideoFileURL)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ShareVideo(_ sender: Any) {
        // Do what needs to be done to share video.
        // Specifically, remove the "lock" from directory name
        
        // Update the UI
        ScreenText.text = "Your video will be shared!"
        
        // Redirect the user after two seconds.
        StartDelayTimer()
    }
    
    @IBAction func DeleteVideo(_ sender: Any) {
        // Do what needs to be done to delete the video.
        
        // Update the UI
        ScreenText.text = "Your video has been deleted!"
        
        // Redirect the user after two seconds.
        StartDelayTimer()
        
    }
}
