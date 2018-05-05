//
//  vc_login.swift
//  iOS
//
//  Created by Haik Kalantarian on 4/30/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import os.log

class vc_login: UIViewController {
    
    @IBOutlet weak var TextViewUsername: UITextField!
    @IBOutlet weak var TextViewPassword: UITextField!
    
    @IBOutlet weak var ButtonLogin: UIButton!
    
    
    
    /// <#Description#>
    /// Windows, alt, slash
    /// - Parameter sender: <#sender description#>
    @IBAction func ButtonLoginClick(_ sender: Any) {
        os_log("[HK] Button click detected.")
        
        let Username = String(TextViewUsername.text!)
        let Password = String(TextViewPassword.text!)
        

        self.DownloadUserData(UserEmail:Username)
        
        
        // Move to the next viewpager: the pick-deck screen.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck") 
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    ///
    func DownloadUserData(UserEmail: String){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


