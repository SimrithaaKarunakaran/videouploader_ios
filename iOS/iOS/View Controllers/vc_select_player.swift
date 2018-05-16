



import UIKit
import AWSDynamoDB



/// The user selects which child is about to play, on this screen.
class vc_select_player: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var UITableViewInstance: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Iterate through each child associated with this account, and add to the table.
     
        
        /*for item in BackendManager.UserDBResults!{
            print("Printing item name: ")
            
            let val = item["name"]
            print(val?.s)
            
        } */
        
        
        UITableViewInstance.delegate = self
        UITableViewInstance.dataSource = self

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BackendManager.UserDBResults!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        var idx = indexPath[1]
        var RelevantUser = BackendManager.UserDBResults![idx]
        
        cell.textLabel!.text = RelevantUser["name"]?.s
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
