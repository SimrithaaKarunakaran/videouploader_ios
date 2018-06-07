//
//  vc_thank_player.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/18/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_thank_player: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var RelevantUser = GameEngineObject.UserDBResults![GameEngineObject.SelectedChildIndex!]

        
        GameEngineObject.CurrentUserObject?.childSurveyCompleted = 1
        
        // We are going to save user data to Dynamo.
        // But first, lets fill out all information that WASNT populated in the "extra" survey.
        // This is stuff that is there already that we don't want to override.
        GameEngineObject.CurrentUserObject?.hispanic        = NSNumber(value:(Int((RelevantUser["hispanic"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.african         = NSNumber(value:(Int((RelevantUser["african" ]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.eastAsian       = NSNumber(value:(Int((RelevantUser["eastAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.arab            = NSNumber(value:(Int((RelevantUser["arab"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.nativeAmerican  = NSNumber(value:(Int((RelevantUser["nativeAmerican"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.pacificIslander = NSNumber(value:(Int((RelevantUser["pacificIslander"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.southeastAsian  = NSNumber(value:(Int((RelevantUser["southeastAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.southAsian      = NSNumber(value:(Int((RelevantUser["southAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.caucasian       = NSNumber(value:(Int((RelevantUser["caucasian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.unknown         = NSNumber(value:(Int((RelevantUser["unknown"]?.n!)!)!))

        GameEngineObject.CurrentUserObject?.consentPlay     = NSNumber(value:(Int((RelevantUser["consentPlay"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.consentView     = NSNumber(value:(Int((RelevantUser["consentView"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.consentShare    = NSNumber(value:(Int((RelevantUser["consentShare"]?.n!)!)!))
        
        GameEngineObject.CurrentUserObject?.email = (RelevantUser["email"]?.s!)!
        GameEngineObject.CurrentUserObject?.name = (RelevantUser["name"]?.s!)!
        GameEngineObject.CurrentUserObject?.gender = (RelevantUser["gender"]?.s!)!
        GameEngineObject.CurrentUserObject?.dOB = (RelevantUser["dOB"]?.s!)!
        GameEngineObject.CurrentUserObject?.country = (RelevantUser["country"]?.s!)!
        GameEngineObject.CurrentUserObject?.city = (RelevantUser["city"]?.s!)!
        GameEngineObject.CurrentUserObject?.state = (RelevantUser["state"]?.s!)!
        GameEngineObject.CurrentUserObject?.zIP = (RelevantUser["zIP"]?.s!)!
        GameEngineObject.CurrentUserObject?.autismDiagnosis = (RelevantUser["autismDiagnosis"]?.s!)!
        GameEngineObject.CurrentUserObject?.otherDiagnoses = (RelevantUser["otherDiagnoses"]?.s!)!

        GameEngineObject.AddUserToDynamo(row: GameEngineObject.CurrentUserObject!) { (Success) in
            if(Success){
                print("[HK] Success adding the user.")
            } else {
                print("[HK] failed to add the user.")
            }
        }

        
        // Update local record
        
        RelevantUser["childSurveyCompleted"]?.n = "1"
        
            
        // Do any additional setup after loading the view.
    }

    @IBAction func ClickNext(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
