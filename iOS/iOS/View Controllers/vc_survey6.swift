//
//  vc_survey6.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/9/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey6: UIViewController {

    
    @IBOutlet weak var NA16: UISwitch!
    @IBOutlet weak var NA17: UISwitch!
    @IBOutlet weak var NA18: UISwitch!
    
    @IBOutlet weak var Q16: UISlider!
    @IBOutlet weak var Q17: UISlider!
    @IBOutlet weak var Q18: UISlider!
    
    @IBAction func ButtonBack(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey5")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func ButtonNext(_ sender: Any) {
        
        GameEngineObject.CurrentUserObject?.answers[15]  = Int(round(Q16.value))
        GameEngineObject.CurrentUserObject?.answers[16]  = Int(round(Q17.value))
        GameEngineObject.CurrentUserObject?.answers[17]  = Int(round(Q18.value))
        
        GameEngineObject.CurrentUserObject?.notApplicableChecked[15]  = NA16.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[16]  = NA17.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[17]  = NA18.isOn ? 1 : 0
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SurveyThankYou")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Q16.value = Float((GameEngineObject.CurrentUserObject?.answers[15])!)
        Q17.value = Float((GameEngineObject.CurrentUserObject?.answers[16])!)
        Q18.value = Float((GameEngineObject.CurrentUserObject?.answers[17])!)
        
        NA16.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[15] == 0) ? false : true
        NA17.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[16] == 0) ? false : true
        NA18.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[17] == 0) ? false : true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
