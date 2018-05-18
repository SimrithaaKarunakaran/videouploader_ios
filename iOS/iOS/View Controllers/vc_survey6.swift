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
    }
    
    @IBAction func ButtonNext(_ sender: Any) {
    }
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
