



import UIKit
import AWSDynamoDB



/// The user selects which child is about to play, on this screen.
class vc_select_player: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var UITableViewInstance : UITableView!
    @IBOutlet weak var AddPlayerText       : UILabel!
    @IBOutlet weak var AddPlayerImage      : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableViewInstance.delegate   = self
        UITableViewInstance.dataSource = self

        // Setup the onclick handler when user presses the "Add A Player" link.
        let tap = UITapGestureRecognizer(target: self, action: #selector(vc_select_player.AddNewPlayerClickHandler))
        
        AddPlayerText.isUserInteractionEnabled = true
        AddPlayerText.addGestureRecognizer(tap)
        AddPlayerImage.isUserInteractionEnabled = true
        AddPlayerImage.addGestureRecognizer(tap)
        
        
        UITableViewInstance.tableFooterView = UIView(frame: .zero)

    }
    
    @objc func AddNewPlayerClickHandler(sender:UITapGestureRecognizer) {
        // Direct user to screen where they can add a new player.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey1")
        self.present(newViewController, animated: true, completion: nil)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameEngineObject.UserDBResults!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Save which child was selected.
        GameEngineObject.SelectedChildIndex = indexPath[1]
        var RelevantUser = GameEngineObject.UserDBResults![indexPath[1]]

        let SurveyCompleted2 = Int((RelevantUser["childSurveyCompleted"]?.n!)!)!


        print("Printing out childSurveyCompleted: \(SurveyCompleted2)")

        if(SurveyCompleted2 == 0){
            print("[HK] Survey not completed.")
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_request_survey")
            self.present(newViewController, animated: false, completion: nil)
        } else {
            // The survey has been completed.
            print("[HK] Survey was completed.")
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_deck")
            self.present(newViewController, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        let idx  = indexPath[1]
        var RelevantUser = GameEngineObject.UserDBResults![idx]
        
        cell.textLabel!.text = RelevantUser["name"]?.s
        cell.textLabel!.font = cell.textLabel!.font.withSize(24)

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
