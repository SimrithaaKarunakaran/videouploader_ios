//
//  vc_consent_1.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/7/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_consent_1: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConsentClickContinue(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // This is found at the top of vc_consent_1 (outside class)
        GameEngineObject.CurrentUserObject?.consentPlay = 1
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_consent_2")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func ConsentClickBack(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        // User can't play without accepting the first agreement.
        ShowError(error: "You must accept the agreement to create an account.")
    }
    
    
    /// Show a popup that indicates user has entered an invalid username or password.
    ///
    /// - Parameter error: The exact error message to display.
    func ShowError(error: String){
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
