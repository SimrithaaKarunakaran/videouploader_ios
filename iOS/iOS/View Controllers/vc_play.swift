//
//  vc_play.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/21/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_play: UIViewController {

    var seconds        = 10 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer          : Timer?
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    

    
    // Create a nonsense default URL. When view loads, this URL will be overridden, pointing to the new directory we have
    // created in which the files (meta and video) will be stored.
    var LockedGameDirectory = URL(string: "google.com")!
    // Likewise, create a dummy URL to the text file (meta information) that will be written to throughout the game.
    var TextFileURL         = URL(string: "google.com")!
    
    
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
        
        //updateGameImage()
        
        if(seconds == 0){
            //Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_confirm_video")
            self.present(newViewController, animated: false, completion: nil)
        }
        
        if(seconds < 0){
            timer?.invalidate()
        }
    }
    
    
    
    

    
    /// Update the game image shown to the player based on the prompts they have selected.
    /// Also, write to the associated log file.
    func updateGameImage(){
        let EmojiObject = PromptManager.GetNextImage()
        let image       = UIImage(named:EmojiObject.FileName!)
        
        GameImageView.image = image
        print("[PLAY] Showing image with file name: \(EmojiObject.FileName!)")
        
        // Now, we write to the ol' text file.
        let SecondsSinceGameStart = String(90 - seconds)
        writeToTextFile(Text: SecondsSinceGameStart + ": " + EmojiObject.CodeName!)
        print("[PLAY] (Supposedly) finished writing to the text file.")
    }
    
  
    
    /// Create a directory associated with this game session, that will be a container
    // for the video to be uploaded, as well as the text file with the meta information.
    
    /// Create a directory associated with this game session, that will be a container
    /// for the video to be uploaded, as well as the text file with the meta information.
    ///
    /// - Parameter FOLDER_NAME: The name of the directory associated with this game session (timestamp)
    /// - Returns: The URL of the directory created: create the video and text file here.
    func CreateLockedGameDirectory(FOLDER_NAME: String) -> URL{
        
        var FilePathGameFolder = URL(string: "google.com")!
        
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            FilePathGameFolder =  tDocumentDirectory.appendingPathComponent("\(FOLDER_NAME)")
            if !fileManager.fileExists(atPath: FilePathGameFolder.path) {
                do {
                    try fileManager.createDirectory(atPath: FilePathGameFolder.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                    return FilePathGameFolder
                }
            }
            NSLog("Document directory is \(FilePathGameFolder)")
        }
    
        return FilePathGameFolder
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        // Start the game timer, counting down from 90 seconds.
        runTimer();
        
        // Set a default image to show the user.
        updateGameImage()
        
        // Thie unix time (MS) that will be used to identify this game session.
        let TimeStamp = Int(NSDate().timeIntervalSince1970)
        print("[PLAY] Got the timestamp associated with this session: \(TimeStamp)")
        
        // Create the directory that will be used to "house" the video and text file of meta information to upload.
        let LockedDirectoryName = String(TimeStamp) + ".LOCKED"
        LockedGameDirectory = CreateLockedGameDirectory(FOLDER_NAME: LockedDirectoryName)
        print("[PLAY] Creating directory with name: \(LockedDirectoryName)")
        print("[PLAY] Received path with URL: \(LockedGameDirectory)")
        
        // Now that we have created the folder, lets create a text file inside the folder.
        createMetaTextFile()
    }
    
    
    func writeToTextFile(Text: String){
        do {
            try Text.write(to: TextFileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("[PLAY] An unexpected error occurred when writing to the text file.")
            /* error handling here */
        }
        
        print("[PLAY] Wrote to text file: \(Text)")
    }
    
    func createMetaTextFile(){
        let file = "GuessWhat.txt" //this is the file. we will write to and read from it
        
        let CurrentUser = GameEngineObject.CurrentUserObject!
        
        let ConsentShare = String(Int(CurrentUser.consentShare))
        let ConsentView  = String(Int(CurrentUser.consentView))

        let L1 = "CONSENT_SHARE: "  + ConsentShare
        let L2 = "CONSENT_VIEW: "   + ConsentView
        let L3 = "Child Name: "     + CurrentUser.name
        let L4 = "Child DOB: "       + CurrentUser.dOB
        let L5 = "Child Gender: "    + CurrentUser.gender
        let L6 = "Child Diagnosis: " + CurrentUser.autismDiagnosis
        
        TextFileURL = LockedGameDirectory.appendingPathComponent(file)
        
        //writing
        do {
            try L1.write(to: TextFileURL, atomically: false, encoding: .utf8)
            try L2.write(to: TextFileURL, atomically: false, encoding: .utf8)
            try L3.write(to: TextFileURL, atomically: false, encoding: .utf8)
            try L4.write(to: TextFileURL, atomically: false, encoding: .utf8)
            try L5.write(to: TextFileURL, atomically: false, encoding: .utf8)
            try L6.write(to: TextFileURL, atomically: false, encoding: .utf8)
            print("[PLAY] Creating text file at URL: \(TextFileURL)")
            print("[PLAY] Child's name appended: \(CurrentUser.name)")
            print("[PLAY] Consent Share: \(ConsentShare)")
            print("[PLAY] Consent View: \(ConsentView)")
        }
        catch {
            print("[PLAY] An unexpected error occurred when writing to the text file.")
            /* error handling here */
        }
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
