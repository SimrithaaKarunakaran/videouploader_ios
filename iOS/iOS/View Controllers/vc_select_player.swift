//
//  vc_select_player.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/14/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import AWSDynamoDB






class vc_select_player: UIViewController {

    var tableRow:DDBTableRow?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("[HK] Entered player selection screen.")
   
        
        tableRow = DDBTableRow()
        tableRow?.email = "haik.kalantarian1@gmail.com"
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        //tableRow?.UserId --> (tableRow?.UserId)!
        dynamoDBObjectMapper .load(DDBTableRow.self, hashKey: (tableRow?.email), rangeKey: nil).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as NSError? {
                print("[HK][Dynamo] Error: \(error)")
            } else if let tableRow = task.result as? DDBTableRow {
                
                print("[HK][Dynamo] Success getting table row.")
                /*
                self.hashKeyTextField.text = tableRow.UserId
                self.rangeKeyTextField.text = tableRow.GameTitle
                self.attribute1TextField.text = tableRow.TopScore?.stringValue
                self.attribute2TextField.text = tableRow.Wins?.stringValue
                self.attribute3TextField.text = tableRow.Losses?.stringValue*/
            }
            
            return nil
        })
        
        
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
