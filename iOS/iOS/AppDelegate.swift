//
//  AppDelegate.swift
//  iOS
//
//  Created by Haik Kalantarian on 3/12/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore
import AWSCore
import AWSCognitoIdentityProvider
import AWSUserPoolsSignIn



// Global variables for managing AWS Dynamo/Cognito
let GlobalUserPoolID              = "us-west-2_bB7kdaf7g"
let GlobalRegion                  = "us-west-2"
let GlobalIdentityPoolID          = "us-west-2:371ad080-60d9-4623-aefd-f50e3bbd0cb4"
let GlobalAppClientID             = "6arguf9m5ecvbgulsei89ketnm";
let GlobalAppClientSecret         = "178ml88t93a5cvjndco5ao7asu7r2omcl4lbopsee96s40kticis";
let GlobalCognitoUserpoolProvider = "cognito-idp.us-west-2.amazonaws.com/us-west-2_bB7kdaf7g"

var GlobalRegionObject        = AWSRegionType.USWest2
var GlobalUserPool            : AWSCognitoIdentityUserPool!
var GlobalPoolConfig          : AWSCognitoIdentityUserPoolConfiguration!
var GlobalAWSConfig           : AWSServiceConfiguration!
var GlobalUserToken           : String = ""
var GlobalTokens              = [GlobalCognitoUserpoolProvider: GlobalUserToken]
var GlobalIdentityProvider    : CustomIdentityProvider!
var GlobalCredentialsProvider : AWSCognitoCredentialsProvider!

/*
 User's state management.
 */

var UserEmailValidated : String?


// Check info.plist for details.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UIApplication.shared.isStatusBarHidden = true

        /*
        Configure AWS
        */
        let GlobalAWSConfig  = AWSServiceConfiguration(region: GlobalRegionObject, credentialsProvider: nil)
        
        let GlobalPoolConfig = AWSCognitoIdentityUserPoolConfiguration(clientId: GlobalAppClientID, clientSecret: GlobalAppClientSecret, poolId: GlobalUserPoolID)
        
        AWSCognitoIdentityUserPool.register(with: GlobalAWSConfig, userPoolConfiguration: GlobalPoolConfig, forKey: GlobalUserPoolID)
        
        GlobalUserPool = AWSCognitoIdentityUserPool(forKey: GlobalUserPoolID)
        
        return true
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

