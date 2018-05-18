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

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func BackButtonClick(_ sender: Any) {
    }
    
    @IBAction func NextButtonClick(_ sender: Any) {
    }
}
