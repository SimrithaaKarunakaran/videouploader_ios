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
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        print("[HK] Button click callback.")
        // Lets check if the user is connected to WiFi. If not, we direct them to a screen where they must acknowledge
        // the bandwidth implciations. Otherwise, we redirect them to the "countdown" screen that initiates the game.
        
        NetworkManager.isReachableViaWiFi() { Result in
            if(Result){
                print("[HK] WiFi connection detected.")
                let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_countdown")
                self.present(newViewController, animated: false, completion: nil)
            } else {
                // No wifi connection- warn them.
                let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_wifi_warn")
                self.present(newViewController, animated: false, completion: nil)
            }
        }
    }
}
