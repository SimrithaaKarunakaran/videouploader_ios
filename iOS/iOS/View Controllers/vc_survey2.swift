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
    
    @IBOutlet weak var NA3: UISwitch!
    @IBOutlet weak var NA2: UISwitch!
    
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
    @IBAction func BackButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_request_survey")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func NextButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey3")
        self.present(newViewController, animated: true, completion: nil)
    }
}
