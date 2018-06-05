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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.


        if(VideoSharedOnce == false){
            SetupPlayback()
            VideoSharedOnce = true
        }
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
    }
    
    @IBAction func DeleteVideo(_ sender: Any) {
    
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
