//
//  vc_wifi_warn.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/11/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_wifi_warn: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ButtonClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_countdown")
        self.present(newViewController, animated: false, completion: nil)
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
