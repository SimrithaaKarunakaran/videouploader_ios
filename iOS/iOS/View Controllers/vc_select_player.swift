//
//  vc_select_player.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/14/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit
import AWSDynamoDB



let IdentityPoolID          = "us-west-2:371ad080-60d9-4623-aefd-f50e3bbd0cb4"



class vc_select_player: UIViewController {

    // Todo: move this to a seperate file eventually.
    final class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
        var tokens: [String : String]?
        
        init(tokens: [String : String]?) {
            self.tokens = tokens
        }
        
        // Each entry in logins represents a single login with an identity provider. The key is the domain of the login provider (e.g. 'graph.facebook.com')
        // and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
        func logins() -> AWSTask<NSDictionary> {
            let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
            return AWSTask(result: logins)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        let COGNITO_USERPOOL_PROVIDER = "cognito-idp.us-west-2.amazonaws.com/us-west-2_bB7kdaf7g"
        
        let tokens                    = [COGNITO_USERPOOL_PROVIDER: UserToken]
        let customIdentityProvider = CustomIdentityProvider(tokens: tokens)
        var credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USWest2, identityPoolId: IdentityPoolID, identityProviderManager: customIdentityProvider)
    
        let aws_config  = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSDynamoDB.register(with: aws_config!, forKey: "USEAST1Dynamo");
        let dynamoDBCustom = AWSDynamoDB(forKey: "USEAST1Dynamo")
        

        
        
        
        let tableRow = DDBTableRow()!
        tableRow.email = "haik.kalantarian1@gmail.com"

        let dynamoDB    = AWSDynamoDB.default()
        
        let atVal = AWSDynamoDBAttributeValue()!
        atVal.s = "haikkalantarian1@gmail.com"
        
        let condition = AWSDynamoDBCondition()!
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        condition.attributeValueList = [atVal]
        
        let myDic: [String: AWSDynamoDBCondition] = ["email": condition]
        let query = AWSDynamoDBQueryInput()!
        
        query.tableName = "HeadsUpSurveys"
        query.keyConditions = myDic
        
        
        dynamoDBCustom.query(query).continueWith(block: { (task) in
            guard task.error == nil else {
                print(task.error)
                return nil
            }
            
            let results = task.result as AWSDynamoDBQueryOutput!
            
            let myResults = results!.items!
            print("[HK] Query callback.")
            print("object: \(myResults.description)")
            //https://stackoverflow.com/questions/26958637/best-way-to-make-amazon-aws-dynamodb-queries-using-swift
            return nil
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
