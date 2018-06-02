//
//  vc_play.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/21/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import CoreMotion

// Create a nonsense default URL. When view loads, this URL will be overridden, pointing to the new directory we have
// created in which the files (meta and video) will be stored.
var LockedGameDirectory = URL(string: "google.com")!
// Likewise, create a dummy URL to the text file (meta information) that will be written to throughout the game.
var TextFileURL         = URL(string: "google.com")!


class vc_play: UIViewController {

    // Number of seconds left in the game.
    var GameClockSeconds        = 90 //This variable will hold a starting value of seconds. It could be any amount above 0.
    
    // Update the game clock.
    var timerGameClock     : Timer?

    
    //This will be used to make sure only one timer is created at a time.
    var isTimerRunningMain = false
    
    // We can stop tilt detection using this (pause temporarily after tilt reported)
    // Tilt detection is disabled by default and gets enabled at time=4 seconds.
    var TiltDetectionEnabled = false
    var TimeSinceLastWordLoaded = 0
    var NumberOfCorrectAnswers = 0
    
    // Manager for getting gyroscope data.
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var TextTime: UILabel!
    @IBOutlet weak var TextScore: UILabel!
    @IBOutlet weak var GameImageView: UIImageView!
    
    /// This function starts the main game clock timer: if it isn't started already.
    func StartGameClock() {
        if(isTimerRunningMain == false){
            timerGameClock = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateGameClockCallback)), userInfo: nil, repeats: true)
            isTimerRunningMain = true;
        }
    }

    
    

    
    // Every second, this function is called. It just updates # of seconds remaining.
    // Also ends the game when time runs out.
    @objc func updateGameClockCallback() {
        
        // Decrement number of seconds left.
        GameClockSeconds -= 1
        TimeSinceLastWordLoaded = TimeSinceLastWordLoaded + 1
        
        
        
        // We only allow detecting tilt if:
        // (a) Game has been started for four seconds
        // (b) At least three seconds have elapsed since last word loaded.
        if((TimeSinceLastWordLoaded > 3) && (GameClockSeconds > 0)) {
            if((90 - GameClockSeconds) >= 4) {
                TiltDetectionEnabled = true
            } else {
                // No tilt allowed in the first four seconds.
                TiltDetectionEnabled = false
            }
        }
        
        
        
        // Update the number of seconds remaining.
        TextTime.text = "\(GameClockSeconds)";
        
        //updateGameImage()
        
        if(GameClockSeconds == 0){
            //Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_confirm_video")
            self.present(newViewController, animated: false, completion: nil)
        }
        
        if(GameClockSeconds < 0){
            // No more timer callbacks.
            timerGameClock?.invalidate()
            // No more gyroscope updates.
            motionManager.stopGyroUpdates()
        }
    }

    /// Update the game image shown to the player based on the prompts they have selected.
    /// Also, write to the associated log file.
    func updateGameImage(){
        let EmojiObject = PromptManager.GetNextImage()
        let image       = UIImage(named:EmojiObject.FileName!)
        
        // Reset this
        TimeSinceLastWordLoaded = 0
        
        GameImageView.image = image
        print("[PLAY] Showing image with file name: \(EmojiObject.FileName!)")
        
        // Now, we write to the ol' text file.
        let SecondsSinceGameStart = String(90 - GameClockSeconds)
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
        StartGameClock();
        
        // Set a default image to show the user.
        updateGameImage()
        
        // Thie unix time (MS) that will be used to identify this game session.
        let TimeStamp = Int(NSDate().timeIntervalSince1970)
        print("[PLAY] Got the timestamp associated with this session: \(TimeStamp)")
        
        // Create the directory that will be used to "house" the video and text file of meta information to upload.
        // We append ".LOCKED" to the end of it indicating it is being written to. The .LOCKED will be removed after game session.
        let LockedDirectoryName = String(TimeStamp) + ".LOCKED"
        LockedGameDirectory = CreateLockedGameDirectory(FOLDER_NAME: LockedDirectoryName)
        print("[PLAY] Creating directory with name: \(LockedDirectoryName)")
        print("[PLAY] Received path with URL: \(LockedGameDirectory)")
        
        // Now that we have created the folder, lets create a text file inside the folder.
        // This will contain information about who the user was, and what prompts were shown at what times.
        createMetaTextFile()
        

        // Update every 225 MS: equivalent to SENSOR_DELAY_NORMAL on Android platforms.
        motionManager.gyroUpdateInterval = 0.225
        // Now, let's enable the Gyroscope.
        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] (data: CMDeviceMotion?, error: Error?) in
            // Gyroscope callback: check for tilt on a sample-by-sample basis.
            if let Rotation = data?.rotationRate{
                self?.processGyroSample(x: Rotation.x, y: Rotation.y, z: Rotation.z)
            }
        }
        
    }
    
    
    // Given a sample from the gyroscope, lets determine (a) if there is a tilt, and (b) if so, is it in the forward or backward direction.
    func processGyroSample(x: Double, y: Double, z: Double){
            // We want to detect forward tilts, not "jiggles". Its complicated.
            let TILT_THRESHOLD   = 1.45; // Increase this number to decrease tilt sensitivity.
            let JIGGLE_THRESHOLD = 0.8; // Increase this number if non-tilt vibrations are being detected as tilts.

            // In this case, there is no tilt. Otherwise, we will detect what kind of tilt.
            if((abs(x) > JIGGLE_THRESHOLD) || (abs(z) > JIGGLE_THRESHOLD) || (abs(y) < TILT_THRESHOLD)){
                return; // No tilt detected.
            }
            
            if(!TiltDetectionEnabled){
                return;
            }
            
            // Now if we made it so far, we know tilt has happened. Lets find out which way, based on
            // the orientation of the phone. But first, disable tilt detection until next time.
            TiltDetectionEnabled = false
        
            var ScreenFlipped = true
        
            switch UIDevice.current.orientation{
                case .landscapeLeft:
                    ScreenFlipped = true
                case .landscapeRight:
                    ScreenFlipped = false
                default:
                    ScreenFlipped = true
            }
        
            var TiltForward = false
        
            // Send a notification to the listener.
            if(y >= TILT_THRESHOLD && !ScreenFlipped){
                TiltForward = true
            } else if(y <= -TILT_THRESHOLD && ScreenFlipped) {
                TiltForward = true
            }
        
        if(TiltForward){
            print("[PLAY] Forward tilt detected.")
            // Update game UI and also write to the log file.
            increaseNumberOfCorrectAnswers();
            writeToTextFile(Text: "Correct");
            //PlaySound(GetSoundChime());
        } else {
            print("[PLAY] Backward tilt detected.")
            writeToTextFile(Text: "Skipped");
            //PlaySound(GetSoundChord());
        }
        
        // Regardless of which direction the tilt is, we need a new prompt.
        updateGameImage()
    }
    
    
    func increaseNumberOfCorrectAnswers(){
        NumberOfCorrectAnswers = NumberOfCorrectAnswers + 1
        TextScore.text = String(NumberOfCorrectAnswers)
    }
    
    // Write a line to our meta-information file.
    // Specifically we will write the time and prompt everytime the prompt changes.
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
    
    
    
    // This function creates the game meta-information text-file within the appropriate directory.
    // Also populates the top of the file with user-specific information. Remaining information written
    // On an ad-hoc basis during the game session.
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
