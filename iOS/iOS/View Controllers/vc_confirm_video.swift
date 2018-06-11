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
    
    
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    
    let transferUtility = AWSS3TransferUtility.default()
    
    
    
    
    
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
    /// (1) For each game session, upload files then delete them.
    /// (2) If game session folder is empty, delete it.
    func SearchThroughGameSessions(){

        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                
                for file in fileURLs{
                    
                    if(file.path.contains("LOCKED")){
                        print("[FILES] Found a locked directory to delete.")
                        DeleteFile(Path: file.path)
                    } else {
                        print("[FILES] Found a non-locked directory to possibly upload: \(file.lastPathComponent)")
                        /// We have found a directory. Lets figure out if its empty.
                        /// If so, we delete it. If not, we upload the contents.
                        
                        let VideoExists = fileManager.fileExists(atPath: file.appendingPathComponent("GuessWhat.mp4").path)
                        let FileExists  = fileManager.fileExists(atPath: file.appendingPathComponent("GuessWhat.txt").path)
                        
                        if(VideoExists){
                            // Upload the video file if it exists.
                            print("[FILES] Found a video within this directory to upload.")
                            UploadFile(ContentType: "video/mp4", FolderName: file.lastPathComponent, FilePathURL: file.appendingPathComponent("GuessWhat.mp4"))
                        }
                        if(FileExists){
                            // Upload the text file if it exists.
                            print("[FILES] Found a text file within this directory to upload.")
                            UploadFile(ContentType: "text/plain", FolderName: file.lastPathComponent, FilePathURL: file.appendingPathComponent("GuessWhat.txt"))
                        }
                        
                        if(!VideoExists && !FileExists) {
                            print("[FILES] Found this directory is empty: deleting.")
                            // Neither the file or the meta information exist. Lets just delete the entire directory.
                            DeleteFile(Path: file.path)
                        }
                    }
                }
            }
            catch {
                print("[FILES] Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
        }
    }

    
    func UploadFile(ContentType: String, FolderName: String, FilePathURL: URL){
    
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
               // print("Progress: \(progress.fractionCompleted)")
            })
        }
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("[FILES] Upload failed with error: \(error)")
                  //  self.statusLabel.text = "Failed"
                }
                else{
                    print("[FILES] Upload complete.")
                    // Now we delete the file locally so we don't upload again.
                    // Directory is deleted in a seperate step: for now we are just worried about the file.
                    self.DeleteFile(Path: FilePathURL.path)
                }
            })
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        
        
        print("[FILES] Attempting to upload file with URL: \(FilePathURL)")
        let FinalFileName = (GameEngineObject.CurrentUserObject?.email)! + "/" + FolderName + "/" + FilePathURL.lastPathComponent
        print("[FILES] New file name (key) will be: \(FinalFileName)")

        transferUtility.uploadFile(
            FilePathURL,
            bucket: AWSBucketName,
            key: FinalFileName,
            contentType: ContentType,
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("[FILES] Error: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        print("[FILES]  Failed to upload file.")
                    }
                }
                
                return nil;
        }
        
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
        SearchThroughGameSessions()
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
            print("[FILES] Possibly finished deleting file or directory at \(Path)")
        }
        catch let error as NSError {
            print("[FILES] Failed to delete file or directory. \(error)")
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
        SearchThroughGameSessions()
        
        // Redirect the user after two seconds.
        StartDelayTimer()
    }
}
