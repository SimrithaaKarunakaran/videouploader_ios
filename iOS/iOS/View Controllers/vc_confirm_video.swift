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
import AWSS3



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
    
    // Move to a new screen when time is up.
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

    /// Search through files in local directory.
    /// (1) If file is locked, just delete it.
    /// (2) If file is not locked, upload it.
    func ProcessLocalFiles(){

        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                
                for file in fileURLs{
                    
                    if(file.path.contains("LOCKED")){
                        print("[FILES] Found a locked directory to delete.")
                        DeleteFile(Path: file.path)
                    } else {
                        print("[FILES] Found a non-locked directory to possibly upload.")
                        print(file.path)
                        UploadFile(FilePathURL: file)
                    }
                }
            }
            catch {
                print("[FILES] Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
        }
    }

    
    func UploadFile(FilePathURL: URL){
        let transferManager = AWSS3TransferManager.default()
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = AWSBucketName
        uploadRequest?.key = FilePathURL.lastPathComponent
        uploadRequest?.body = FilePathURL
        
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        print("[FILES] Error uploading (cancel or pause): \(String(describing: uploadRequest?.key)) Error: \(error)")
                        break
                    default:
                        print("[FILES] Error uploading (default): \(String(describing: uploadRequest?.key)) Error: \(error)")
                    }
                } else {
                    print("[FILES] Error uploading (generic): \(String(describing: uploadRequest?.key)) Error: \(error)")
                }
                return nil
            }
            
            let uploadOutput = task.result
            print("[FILES] Upload complete for: \(String(describing: uploadRequest?.key)) with result: \(String(describing:uploadOutput))")
            return nil
        })
    }
    
    
    @IBAction func ShareVideoClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Do what needs to be done to share video: remove the "lock" from directory name
        let fileManager = FileManager.default
        let OldDirectoryPath = LockedGameDirectory.path
        let NewDirectoryPath = OldDirectoryPath.replacingOccurrences(of: ".LOCKED", with: "")
        
        print("[FILES] Old directory: \(OldDirectoryPath)")
        print("[FILES] New directory: \(NewDirectoryPath)")
        
        do {
            try fileManager.moveItem(atPath: OldDirectoryPath, toPath: NewDirectoryPath)
            print("[FILES] Possibly finished renaming directory.")
        }
        catch let error as NSError {
            print("[FILES] Failed to rename directory: \(error)")
        }
        
        // Update the UI
        ScreenText.text = "Your video will be shared!"
        // Process local files (from this game session and others)
        ProcessLocalFiles()
        // Redirect the user after two seconds.
        StartDelayTimer()
    }
    
    
    
    /// Delete a file or directory at the given path.
    /// Necessary if user elects not to remove the text and video files.
    /// - Parameter Path: Path to the file or directory to delete.
    func DeleteFile(Path: String){
        // Do what needs to be done to delete the video.
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: Path)
            print("[FILES] Possibly finished deleting directory.")
        }
        catch let error as NSError {
            print("[FILES] Failed to delete directory: \(error)")
        }
    }
    
    @IBAction func DeleteVideoClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        //Delete the files associated with last game session.
        DeleteFile(Path: LockedGameDirectory.path)
        
        // Update the UI
        ScreenText.text = "Your video has been deleted!"
        
        // Process local files (from this game session and others)
        ProcessLocalFiles()
        
        // Redirect the user after two seconds.
        StartDelayTimer()
    }
}
