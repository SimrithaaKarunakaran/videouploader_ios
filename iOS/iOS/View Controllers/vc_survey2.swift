//
//  vc_survey2.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/9/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey2: UIViewController {
    
    @IBOutlet weak var Q1: UISlider!
    @IBOutlet weak var Q2: UISlider!
    @IBOutlet weak var Q3: UISlider!
    
    @IBOutlet weak var NA1: UISwitch!
    
    @IBOutlet weak var NA2: UISwitch!
    @IBOutlet weak var NA3: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        Q1.value = Float((GameEngineObject.CurrentUserObject?.answers[0])!)
        Q2.value = Float((GameEngineObject.CurrentUserObject?.answers[1])!)
        Q3.value = Float((GameEngineObject.CurrentUserObject?.answers[2])!)

        NA1.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[0] == 0) ? false : true
        NA2.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[1] == 0) ? false : true
        NA3.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[2] == 0) ? false : true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func BackButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_request_survey")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func NextButtonClick(_ sender: Any) {
        
        GameEngineObject.CurrentUserObject?.answers[0] = Int(round(Q1.value))
        GameEngineObject.CurrentUserObject?.answers[1] = Int(round(Q2.value))
        GameEngineObject.CurrentUserObject?.answers[2] = Int(round(Q3.value))
        
        GameEngineObject.CurrentUserObject?.notApplicableChecked[0] = NA1.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[1] = NA2.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[2] = NA3.isOn ? 1 : 0
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey3")
        self.present(newViewController, animated: false, completion: nil)
    }
}
