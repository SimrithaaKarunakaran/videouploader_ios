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

        
        GameEngineObject.NewEntry?.childSurveyCompleted = 1
        
        
        GameEngineObject.NewEntry?.hispanic        = NSNumber(value:(Int((RelevantUser["hispanic"]?.n!)!)!))
        GameEngineObject.NewEntry?.african         = NSNumber(value:(Int((RelevantUser["african" ]?.n!)!)!))
        GameEngineObject.NewEntry?.eastAsian       = NSNumber(value:(Int((RelevantUser["eastAsian"]?.n!)!)!))
        GameEngineObject.NewEntry?.arab            = NSNumber(value:(Int((RelevantUser["arab"]?.n!)!)!))
        GameEngineObject.NewEntry?.nativeAmerican  = NSNumber(value:(Int((RelevantUser["nativeAmerican"]?.n!)!)!))
        GameEngineObject.NewEntry?.pacificIslander = NSNumber(value:(Int((RelevantUser["pacificIslander"]?.n!)!)!))
        GameEngineObject.NewEntry?.southeastAsian  = NSNumber(value:(Int((RelevantUser["southeastAsian"]?.n!)!)!))
        GameEngineObject.NewEntry?.southAsian      = NSNumber(value:(Int((RelevantUser["southAsian"]?.n!)!)!))
        GameEngineObject.NewEntry?.caucasian       = NSNumber(value:(Int((RelevantUser["caucasian"]?.n!)!)!))
        GameEngineObject.NewEntry?.unknown         = NSNumber(value:(Int((RelevantUser["unknown"]?.n!)!)!))

        GameEngineObject.NewEntry?.consentPlay     = NSNumber(value:(Int((RelevantUser["consentPlay"]?.n!)!)!))
        GameEngineObject.NewEntry?.consentView     = NSNumber(value:(Int((RelevantUser["consentView"]?.n!)!)!))
        GameEngineObject.NewEntry?.consentShare    = NSNumber(value:(Int((RelevantUser["consentShare"]?.n!)!)!))
        
        GameEngineObject.NewEntry?.email = (RelevantUser["email"]?.s!)!
        GameEngineObject.NewEntry?.name = (RelevantUser["name"]?.s!)!
        GameEngineObject.NewEntry?.gender = (RelevantUser["gender"]?.s!)!
        GameEngineObject.NewEntry?.dOB = (RelevantUser["dOB"]?.s!)!
        GameEngineObject.NewEntry?.country = (RelevantUser["country"]?.s!)!
        GameEngineObject.NewEntry?.city = (RelevantUser["city"]?.s!)!
        GameEngineObject.NewEntry?.state = (RelevantUser["state"]?.s!)!
        GameEngineObject.NewEntry?.zIP = (RelevantUser["zIP"]?.s!)!
        GameEngineObject.NewEntry?.autismDiagnosis = (RelevantUser["autismDiagnosis"]?.s!)!
        GameEngineObject.NewEntry?.otherDiagnoses = (RelevantUser["otherDiagnoses"]?.s!)!

        GameEngineObject.AddUserToDynamo(row: GameEngineObject.NewEntry!) { (Success) in
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck")
        self.present(newViewController, animated: true, completion: nil)
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
