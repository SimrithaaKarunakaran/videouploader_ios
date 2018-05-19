//
//  vc_consent_3.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/7/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit

class vc_consent_3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConsentClickBack(_ sender: Any) {
        GameEngineObject.NewEntry?.consentView = 0

        self.CreatePlayerProfileAndRedirect()
    }
    
    @IBAction func ConsentClickNext(_ sender: Any) {
        GameEngineObject.NewEntry?.consentView = 1

        self.CreatePlayerProfileAndRedirect()
    }
    
    
    
    func CreatePlayerProfileAndRedirect(){
        GameEngineObject.AddUserToDynamo(row: GameEngineObject.NewEntry!) { (Success) in
            print("[HK] Finished adding a user to DynamoDB.")
            // After we added the player, lets re-download all user players associated with our account.
            // Then, we can redirect the user to the screen where they can select it...
            GameEngineObject.downloadUserData(email: GameEngineObject.UserEmail!, completion: { (Success) in
                DispatchQueue.main.async { // Correct
                    print("[HK] Finished downloading user data.")
                    let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                    self.present(newViewController, animated: true, completion: nil)
                }
                
            })
        }
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
