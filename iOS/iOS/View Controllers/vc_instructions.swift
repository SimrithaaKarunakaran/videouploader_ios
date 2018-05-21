//
//  vc_instructions.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/21/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import SystemConfiguration

class vc_instructions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }


    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
       // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ButtonClick(_ sender: Any) {
        
        print("[HK] Button click callback.")
        
        // Lets check if the user is connected to WiFi. If not, we direct them to a screen where they must acknowledge
        // the bandwidth implciations. Otherwise, we redirect them to the "countdown" screen that initiates the game.
        if(!isConnectedToWiFi()){
            
            print("[HK] No WiFi connection detected.")
            // No wifi connection- warn them.
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_wifi_warn")
            self.present(newViewController, animated: false, completion: nil)
        } else {
            print("[HK] WiFi connection detected.")
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_countdown")
            self.present(newViewController, animated: false, completion: nil)
        }
    }
    
    
    
    func isConnectedToWiFi() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
         //Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
        
        // Working for Cellular and WIFI
       // let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
       // let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
       // let ret = (isReachable && !needsConnection)
        
        
    }
    
 

}
