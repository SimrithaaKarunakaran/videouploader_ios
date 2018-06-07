//
//  vc_play.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/21/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import CoreMotion
import MobileCoreServices
import AVFoundation
import AVKit

// Create a nonsense default URL. When view loads, this will be overridden, pointing to new directory
// in which the files (meta and video) will be stored.
var LockedGameDirectory = URL(string: "google.com")!
// Likewise, create a dummy URL to the text file (meta information) that will be written to throughout the game.
var TextFileURL         = URL(string: "google.com")!
var VideoFileURL        = URL(string: "google.com")!





class vc_play: UIViewController, AVCaptureFileOutputRecordingDelegate {


    // Number of seconds left in the game.
    var GameClockSeconds        = 15 //This variable will hold a starting value of seconds. It could be any amount above 0.
    // Update the game clock.
    var timerGameClock     : Timer?
    
    //This will be used to make sure only one timer is created at a time.
    var isTimerRunningMain = false
    
    // We can stop tilt detection using this (pause temporarily after tilt reported)
    // Tilt detection is disabled by default and gets enabled at time=4 seconds.
    var TiltDetectionEnabled     = false
    var TimeSinceLastWordLoaded  = 0
    var NumberOfCorrectAnswers   = 0
    
    // Manager for getting gyroscope data.
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var TextTime: UILabel!
    @IBOutlet weak var TextScore: UILabel!
    @IBOutlet weak var GameImageView: UIImageView!
    @IBOutlet weak var UICameraPreview: UIView!
    
    
    // Camera related elements
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    
    
    
    
    
    /// This function starts the main game clock timer: if it isn't started already.
    func StartGameClock() {
        if(isTimerRunningMain == false){
            timerGameClock = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateGameClockCallback)), userInfo: nil, repeats: true)
            isTimerRunningMain = true;
        }
    }

    
    
    func setupSession() -> Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        
        // Setup Camera
        let camera = GetDefaultVideoDevice()
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("[PLAY] Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone!)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("[PLAY] Error setting device audio input: \(error)")
            return false
        }
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    
    func startPreview(){
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = UICameraPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        UICameraPreview.layer.addSublayer(previewLayer)
    }
    
    //MARK:- Camera Session
    func startSession() {
        if !captureSession.isRunning {
            
            self.captureSession.startRunning()
            
           // videoQueue().async {
           //     print("[PLAY] AVCaptureSession startRunning called.")
           //     self.captureSession.startRunning()
           // }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            print("[PLAY] AVCaptureSession stopRunning called.")
            self.captureSession.stopRunning()
        }
    }

    // Can't provide a meaningful comment because I copy-pasted this code from somewhere.
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }

    
    func GetDefaultVideoDevice() -> AVCaptureDevice {
        var defaultVideoDevice: AVCaptureDevice?
        
        if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        }
        else if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = dualCameraDevice
        }
        else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = backCameraDevice
        }
        
        return defaultVideoDevice!
    }
    
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            print("[ORIENTATION] Portrait detected.")
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            print("[ORIENTATION] Landscape right detected.")
            orientation = AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:
            print("[ORIENTATION] Portrait upside down detected.")
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            print("[ORIENTATION] Default case detected.")
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }

    
    
    
    func startRecording() {
        
        print("[PLAY] Entered startRecording")
        if movieOutput.isRecording == false {
            print("[PLAY] isRecording() was false. Setting up the recording.")

            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                print("[PLAY] Video orientation was supported.")
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                print("[PLAY] Video stabilization was supported.")
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                    print("[PLAY] Smooth auto-focus is supported. Why do I care though?")
                } catch {
                    print("[PLAY] Error setting configuration: \(error)")
                }
            }
            
            VideoFileURL = LockedGameDirectory.appendingPathComponent("GuessWhat.mp4")
            print("[PLAY] Started recording video to URL: \(VideoFileURL)")
            movieOutput.startRecording(to: VideoFileURL, recordingDelegate: self)
            print("[PLAY] Finished startRecording.")
        }
        else {
            print("[PLAY] isRecording() was not false. Calling stopRecording.")
            stopRecording()
        }
        
    }
    
    func stopRecording() {
        print("PLAY] Stop recording has been called.")
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            print("[PLAY] Stopped recording.")
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("[PLAY] didStartRecordingToOutputFileAt callback occurred.")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if (error != nil) {
            print("[PLAY] Error recording movie: \(error!.localizedDescription)")
        } else {
            _ = VideoFileURL as URL
        }
    }
    
    

    @IBAction func QuitClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Stop the current game.
        StopGame()
        
        // Delete all files we have created: they won't be synced.
        DeleteGameFiles()
        
        //Move to the next viewpager.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    // Let's delete the video we are recording, and delete the text file as well.
    func DeleteGameFiles(){
        // Delete residual files.
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: LockedGameDirectory.path)
            print("[REVIEW] Possibly finished deleting directory.")
        }
        catch let error as NSError {
            print("[REVIEW] Failed to delete directory: \(error)")
        }
    }
    
    
    @IBAction func LogOutClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // Stop the current game.
        StopGame()
        
        // Delete all files we have created: they won't be synced.
        DeleteGameFiles()
        
        // Sign the user out of the userpool.
        GlobalUserPool.clearAll()
        
        //Move to the login viewpager.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_login")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    
    
    func StopGame(){
        // Stop recording video
        stopRecording()
        // No more gyroscope
        motionManager.stopGyroUpdates()
        // No more motion updates in general.
        motionManager.stopDeviceMotionUpdates()
        
        timerGameClock?.invalidate()
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
        
        if(GameClockSeconds <= 3 && GameClockSeconds >= 1){
            AudioManagerObject.PlayMarimba()
        }
        
        if(GameClockSeconds == 0){
            print("[PLAY] Game clock expired.")

            // All the book-keeping to end a game.
            StopGame()

            //Move to the next viewpager.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_confirm_video")
            self.present(newViewController, animated: false, completion: nil)
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

        
        // Start the video recording process.
        if(setupSession()){
            startPreview()
            startSession()
            startRecording()
        }
    }
    
    
    // Given a sample from the gyroscope, lets determine (a) if there is a tilt, and (b) if so, is it in the forward or backward direction.
    func processGyroSample(x: Double, y: Double, z: Double){
            // We want to detect forward tilts, not "jiggles". Its complicated.
            let TILT_THRESHOLD   = 3.0; // Increase this number to decrease tilt sensitivity.
            let JIGGLE_THRESHOLD = 0.8; // Increase this number if non-tilt vibrations are being detected as tilts.

            // In this case, there is no tilt. Otherwise, we will detect what kind of tilt.
            if((abs(x) > JIGGLE_THRESHOLD) || (abs(z) > JIGGLE_THRESHOLD) || (abs(y) < TILT_THRESHOLD)){
                return; // No tilt detected.
            }
            
            if(!TiltDetectionEnabled){
                print("[PLAY] Detected tilt was \(abs(y))")
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
            // Play marimba sound.
            AudioManagerObject.PlayChime()
        } else {
            print("[PLAY] Backward tilt detected.")
            writeToTextFile(Text: "Skipped");
            // Play marimba sound.
            AudioManagerObject.PlayMarimba()
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
        }
        
        print("[PLAY] Wrote to text file: \(Text)")
    }
    
    
    
    // This function creates the game meta-information text-file within the appropriate directory.
    // Also populates the top of the file with user-specific information. Remaining information written
    // On an ad-hoc basis during the game session.
    func createMetaTextFile(){
        let file = "GuessWhat.txt" //this is the file. we will write to and read from it
        
        let CurrentUser = GameEngineObject.CurrentUserObject!
        
        
        let ConsentShare = String(describing: CurrentUser.consentShare)
        let ConsentView  = String(describing: CurrentUser.consentView)

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
        }
        catch {
            print("[PLAY] An unexpected error occurred when writing to the text file.")
            /* error handling here */
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("[Play] Recording done!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PromptManager.LoadPromptsForGame(PromptArray: GameEngineObject.ArraySelected)
        
        // Thie unix time (MS) that will be used to identify this game session.
        let TimeStamp = Int(NSDate().timeIntervalSince1970)
        print("[PLAY] Got the timestamp associated with this session: \(TimeStamp)")
        
        // Create the directory that will be used to "house" the video and text file of meta information to upload.
        // We append ".LOCKED" to the end of it indicating it is being written to. The .LOCKED will be removed after game session.
        let LockedDirectoryName = String(TimeStamp) + ".LOCKED"
        LockedGameDirectory = CreateLockedGameDirectory(FOLDER_NAME: LockedDirectoryName)
        print("[PLAY] Creating directory with name: \(LockedDirectoryName)")
        
        // Now that we have created the folder, lets create a text file inside the folder.
        // This will contain information about who the user was, and what prompts were shown at what times.
        createMetaTextFile()
        
        // Start the game timer, counting down from 90 seconds.
        StartGameClock();
        
        // Set a default image to show the user.
        updateGameImage()
        
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
    
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
}


