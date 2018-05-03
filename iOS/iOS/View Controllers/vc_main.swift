//
//  ViewController.swift
//  iOS
//
//  Created by Haik Kalantarian on 3/12/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import os.log


class vc_main: UIViewController, UITextFieldDelegate {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("[HK] viewDidLoad callback.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func ButtonClickNext(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToSecond", sender: self)
    }
    
    @IBAction func ButtonClickNextStoryboard(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "story_pageview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "story_one_viewcontroller") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    
}

