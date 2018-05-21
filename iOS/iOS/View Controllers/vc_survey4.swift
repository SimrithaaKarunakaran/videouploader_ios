//
//  vc_survey4.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/9/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey4: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Q8.value = Float((GameEngineObject.NewEntry?.answers[7])!)
        Q9.value = Float((GameEngineObject.NewEntry?.answers[8])!)
        Q10.value = Float((GameEngineObject.NewEntry?.answers[9])!)
        Q11.value = Float((GameEngineObject.NewEntry?.answers[10])!)
        
        SW8.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[7] == 0) ? false : true
        SW9.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[8] == 0) ? false : true
        SW10.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[9] == 0) ? false : true
        SW11.isOn = (GameEngineObject.NewEntry?.notApplicableChecked[10] == 0) ? false : true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var SW8: UISwitch!
    @IBOutlet weak var SW9: UISwitch!
    @IBOutlet weak var SW10: UISwitch!
    @IBOutlet weak var SW11: UISwitch!
    
    @IBOutlet weak var Q8: UISlider!
    @IBOutlet weak var Q9: UISlider!
    @IBOutlet weak var Q10: UISlider!
    @IBOutlet weak var Q11: UISlider!

    
    
    @IBAction func NextButtonClick(_ sender: Any) {
        
        GameEngineObject.NewEntry?.answers[7]  = Int(round(Q8.value))
        GameEngineObject.NewEntry?.answers[8]  = Int(round(Q9.value))
        GameEngineObject.NewEntry?.answers[9]  = Int(round(Q10.value))
        GameEngineObject.NewEntry?.answers[10]  = Int(round(Q11.value))
        
        GameEngineObject.NewEntry?.notApplicableChecked[7]  = SW8.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[8]  = SW9.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[9]  = SW10.isOn ? 1 : 0
        GameEngineObject.NewEntry?.notApplicableChecked[10]  = SW11.isOn ? 1 : 0
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey5")
        self.present(newViewController, animated: false, completion: nil)
    }
    @IBAction func BackButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey3")
        self.present(newViewController, animated: false, completion: nil)
    }
}
