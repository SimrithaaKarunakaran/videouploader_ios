//
//  AppDelegate.swift
//  iOS
//
//  Created by Haik Kalantarian on 3/12/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import AWSCore
import AWSCore
import AWSCognitoIdentityProvider
import AWSUserPoolsSignIn
import AVFoundation
import AWSS3



// Global variables for managing AWS Dynamo/Cognito
let GlobalUserPoolID              = "us-west-2_bB7kdaf7g"
let GlobalRegion                  = "us-west-2"
let GlobalIdentityPoolID          = "us-west-2:371ad080-60d9-4623-aefd-f50e3bbd0cb4"
let GlobalAppClientID             = "6arguf9m5ecvbgulsei89ketnm";
let GlobalAppClientSecret         = "178ml88t93a5cvjndco5ao7asu7r2omcl4lbopsee96s40kticis";
let GlobalCognitoUserpoolProvider = "cognito-idp.us-west-2.amazonaws.com/us-west-2_bB7kdaf7g"

var AWSBucketName                 = "headsup-du1r3b78fy"

var GlobalRegionObject        = AWSRegionType.USWest2
var GlobalUserPool            : AWSCognitoIdentityUserPool!
var GlobalPoolConfig          : AWSCognitoIdentityUserPoolConfiguration!
var GlobalAWSConfig           : AWSServiceConfiguration!
var GlobalTokens              : [String: String]!
var GlobalIdentityProvider    : CustomIdentityProvider!
var GlobalCredentialsProvider : AWSCognitoCredentialsProvider!

// Manage game session information.
var GameEngineObject : GameEngine!

// Manage audio throughout the app
var AudioManagerObject : AudioManager!





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Manage screen orientation
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.isStatusBarHidden = true
        
        // Initialize object that manages game state.
        GameEngineObject = GameEngine()
        
        // This is necessary to setup audio playback later in the app.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        
        // Initialize object that manages audio state.
        AudioManagerObject = AudioManager()
        print("[AUDIO] Finished initializing audio manager.")

        return true
        
    }
    
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        /*
         Store the completion handler.
         */
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    
    /*
    Add code to create an instance of AWSMobileClient in the application:open url function of your AppDelegate.swift, to resume a previously signed-in authenticated session.
    */

    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
}

// Todo: move this to a seperate file eventually.
final class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
    var tokens: [String : String]?
    
    init(tokens: [String : String]?) {
        self.tokens = tokens
    }
    
    // Each entry in logins represents a single login with an identity provider. The key is the domain of the login provider (e.g. 'graph.facebook.com')
    // and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
    func logins() -> AWSTask<NSDictionary> {
        let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
        return AWSTask(result: logins)
    }
}

