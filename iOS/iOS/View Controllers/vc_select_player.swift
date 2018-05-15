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


    override func viewDidLoad() {
        super.viewDidLoad()
   
        let tableRow = DDBTableRow()!
        tableRow.email = "haik.kalantarian1@gmail.com"
        
        let dynamoDB    = AWSDynamoDB.default()
        
        let aws_config  = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: nil)
        AWSDynamoDB.register(with: aws_config!, forKey: "USEAST1Dynamo");
        let dynamoDBCustom = AWSDynamoDB(forKey: "USEAST1Dynamo")
        

        
        /*
       Start query
       */
        let atVal = AWSDynamoDBAttributeValue()!
        atVal.s = "haik.kalantarian1@gmail.com"
        let condition = AWSDynamoDBCondition()!
        
        
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        condition.attributeValueList = [atVal]
        
        let myDic: [String: AWSDynamoDBCondition] = ["email": condition]
        let query = AWSDynamoDBQueryInput()!
        
        query.indexName = "email"
        query.tableName = "HeadsUpSurveys"
        query.keyConditions = myDic
        

        
        
        dynamoDB.query(query).continueWith(block: { (task) in
            guard task.error == nil else {
                print(task.error)
                return nil
            }
            
            let results = task.result!
            
            let myResults = results.items
            print("[HK] Query callback.")
            //print("object: \(myResults.name)")
            //https://stackoverflow.com/questions/26958637/best-way-to-make-amazon-aws-dynamodb-queries-using-swift
            return nil
        })
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
