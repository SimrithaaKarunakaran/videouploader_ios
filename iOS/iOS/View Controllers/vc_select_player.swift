



import UIKit
import AWSDynamoDB



/// The user selects which child is about to play, on this screen.
class vc_select_player: UITableViewController {
    
    @IBOutlet weak var UITableViewInstance: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Iterate through each child associated with this account, and add to the table.
        for item in BackendManager.UserDBResults!{
            print("Printing item name: ")
            
            let val = item["name"]
            print(val?.s)
            
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
