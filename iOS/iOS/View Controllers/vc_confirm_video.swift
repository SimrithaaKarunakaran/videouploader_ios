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
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player_nav")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    
    
    /// This function starts the main game clock timer: if it isn't started already.
    func StartDelayTimer() {
        ConfirmSelectionTimer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(self.ChangeScreensCallback)), userInfo: nil, repeats: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
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
        
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Do what needs to be done to share video: remove the "lock" from directory name
        let fileManager = FileManager.default
        let OldDirectoryPath = LockedGameDirectory.path
        let NewDirectoryPath = OldDirectoryPath.replacingOccurrences(of: ".LOCKED", with: "")
        
        print("[REVIEW] Old directory: \(OldDirectoryPath)")
        print("[REVIEW] New directory: \(NewDirectoryPath)")
        
        
        do {
            try fileManager.moveItem(atPath: OldDirectoryPath, toPath: NewDirectoryPath)
            print("[REVIEW] Possibly finished renaming directory.")
        }
        catch let error as NSError {
            print("[REVIEW] Failed to rename directory: \(error)")
        }
        
        // Update the UI
        ScreenText.text = "Your video will be shared!"
        
        // Redirect the user after two seconds.
        StartDelayTimer()
    }
    
    @IBAction func DeleteVideo(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Do what needs to be done to delete the video.
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: LockedGameDirectory.path)
            print("[REVIEW] Possibly finished deleting directory.")
        }
        catch let error as NSError {
            print("[REVIEW] Failed to delete directory: \(error)")
        }
        
        // Update the UI
        ScreenText.text = "Your video has been deleted!"
        
        // Redirect the user after two seconds.
        StartDelayTimer()
        
    }
}
