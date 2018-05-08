//
//  vc_survey1.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/8/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_survey1: UIViewController {

    @IBOutlet weak var LatinoSwitch: UISwitch!
    @IBOutlet weak var AsianSwitch: UISwitch!
    @IBOutlet weak var NativeAmericanSwitch: UISwitch!
    @IBOutlet weak var SoutheastSwitch: UISwitch!
    @IBOutlet weak var WhiteSwitch: UISwitch!
    @IBOutlet weak var CaribbeanSwitch: UISwitch!
    @IBOutlet weak var ArabSwitch: UISwitch!
    @IBOutlet weak var PacificSwitch: UISwitch!
    @IBOutlet weak var SouthAsianSwitch: UISwitch!
    @IBOutlet weak var OtherSwitch: UISwitch!
    
    
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textGender: UITextField!
    @IBOutlet weak var textDOB: UITextField!
    
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textState: UITextField!
    @IBOutlet weak var textZIP: UITextField!
    
    @IBOutlet weak var textOtherDiagnosis: UITextField!
    @IBOutlet weak var textAutism: UITextField!
    @IBOutlet weak var textCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
