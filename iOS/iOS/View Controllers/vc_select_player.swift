



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
        We are signed in with Cognito on US_WEST_2.  Unfortunately, our DynamoDBTable is on US_EAST_1.
        Therefore, we have to switch regions.
        */
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
