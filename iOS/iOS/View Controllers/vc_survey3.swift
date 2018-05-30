//
//  vc_survey3.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/9/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        A4.value = Float((GameEngineObject.CurrentUserObject?.answers[3])!)
        A5.value = Float((GameEngineObject.CurrentUserObject?.answers[4])!)
        A6.value = Float((GameEngineObject.CurrentUserObject?.answers[5])!)
        A7.value = Float((GameEngineObject.CurrentUserObject?.answers[6])!)

        NA4.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[3] == 0) ? false : true
        NA5.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[4] == 0) ? false : true
        NA6.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[5] == 0) ? false : true
        NA7.isOn = (GameEngineObject.CurrentUserObject?.notApplicableChecked[6] == 0) ? false : true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var NA4: UISwitch!
    @IBOutlet weak var NA5: UISwitch!
    @IBOutlet weak var NA6: UISwitch!
    @IBOutlet weak var NA7: UISwitch!
    
    @IBOutlet weak var A4: UISlider!
    @IBOutlet weak var A5: UISlider!
    @IBOutlet weak var A6: UISlider!
    @IBOutlet weak var A7: UISlider!

    
    @IBAction func BackButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey2")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func NextButtonClick(_ sender: Any) {
        
        GameEngineObject.CurrentUserObject?.answers[3] = Int(round(A4.value))
        GameEngineObject.CurrentUserObject?.answers[4] = Int(round(A5.value))
        GameEngineObject.CurrentUserObject?.answers[5] = Int(round(A6.value))
        GameEngineObject.CurrentUserObject?.answers[6] = Int(round(A7.value))

        GameEngineObject.CurrentUserObject?.notApplicableChecked[3] = NA4.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[4] = NA5.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[5] = NA6.isOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.notApplicableChecked[6] = NA6.isOn ? 1 : 0

        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey4")
        self.present(newViewController, animated: false, completion: nil)
    }
}
