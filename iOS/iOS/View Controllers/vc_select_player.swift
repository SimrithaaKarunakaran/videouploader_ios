



import UIKit
import AWSDynamoDB



/// The user selects which child is about to play, on this screen.
class vc_select_player: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Iterate through each child associated with this account, and add to the table.
        for item in BackendManager.UserDBResults!{
            print("Printing item name: ")
            
            let val = item["name"]
            print(val?.s)
            
        }
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
