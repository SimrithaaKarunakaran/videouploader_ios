



import UIKit
import AWSDynamoDB

class vc_select_player: UIViewController {
    // Todo: move this to a seperate file eventually.
    final class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
        var tokens: [String : String]?
        
        init(tokens: [String : String]?) {
            self.tokens = tokens
        }
        
        func logins() -> AWSTask<NSDictionary> {
            let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
            return AWSTask(result: logins)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        We are signed in with Cognito on US_WEST_2.
        Unfortunately, our DynamoDBTable is on US_EAST_1. Therefore,
        we have to switch regions.
        */
        
        let aws_config  = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: GlobalCredentialsProvider)
        AWSDynamoDB.register(with: aws_config!, forKey: "USEAST1Dynamo");
        let dynamoDBCustom = AWSDynamoDB(forKey: "USEAST1Dynamo")
        
        let tableRow = DDBTableRow()!
        tableRow.email = "haik.kalantarian1@gmail.com"
        
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
            
            let data = myResults.description.data(using: String.Encoding.utf8)
            
            do {
                
                let JsonDict = try JSONSerialization.jsonObject(with: data!, options: [])
                // you can now use t with the right type
                if let dictFromJSON = JsonDict as? [String:AWSDynamoDBAttributeValue]{
                    // use dictFromJSON
                    print(dictFromJSON["name"]?.description())
                    print("Finished printing name")
                }
            } catch let error as NSError {
                print(error)
                print("Entered catch")
            }
            
            
            return nil
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
