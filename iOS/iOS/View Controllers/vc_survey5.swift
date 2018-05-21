//
//  vc_survey5.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/9/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey5: UIViewController {

    
    @IBOutlet weak var NA12: UISwitch!
    @IBOutlet weak var NA13: UISwitch!
    @IBOutlet weak var NA14: UISwitch!
    @IBOutlet weak var NA15: UISwitch!
    
    @IBOutlet weak var Q12: UISlider!
    @IBOutlet weak var Q13: UISlider!
    @IBOutlet weak var Q14: UISlider!
    @IBOutlet weak var Q15: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Q12.value = Float((GameEngineObject.NewEntry?.answers[11])!)
        Q13.value = Float((GameEngineObject.NewEntry?.answers[12])!)
        Q14.value = Float((GameEngineObject.NewEntry?.answers[13])!)
        Q15.value = Float((GameEngineObject.NewEntry?.answers[14])!)
        
        NA12.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[11] == 0) ? false : true
        NA13.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[12] == 0) ? false : true
        NA14.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[13] == 0) ? false : true
        NA15.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[14] == 0) ? false : true
    }

    @IBAction func BackClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey4")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func NextClick(_ sender: Any) {
        
        GameEngineObject.NewEntry?.answers[11]  = Int(round(Q12.value))
        GameEngineObject.NewEntry?.answers[12]  = Int(round(Q13.value))
        GameEngineObject.NewEntry?.answers[13]  = Int(round(Q14.value))
        GameEngineObject.NewEntry?.answers[14]  = Int(round(Q15.value))
        
        GameEngineObject.NewEntry?.notApplicableChecked[11]  = NA12.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[12]  = NA13.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[13]  = NA14.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[14]  = NA15.isOn ? 1 : 0
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey6")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
