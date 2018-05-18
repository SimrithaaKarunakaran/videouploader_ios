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

        // Do any additional setup after loading the view.
    }

    @IBAction func BackClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey4")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func NextClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey6")
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
