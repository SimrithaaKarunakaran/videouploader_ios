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

        // Do any additional setup after loading the view.
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func NextButtonClick(_ sender: Any) {
    }
    @IBAction func BackButtonClick(_ sender: Any) {
    }
}
