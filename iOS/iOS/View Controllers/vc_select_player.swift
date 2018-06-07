



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

        // Update the title
        self.title = GameEngineObject.UserEmail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    @objc func AddNewPlayerClickHandler(sender:UITapGestureRecognizer) {
        // Direct user to screen where they can add a new player.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_survey", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_survey1")
        self.present(newViewController, animated: true, completion: nil)
        
        // Play marimba sound.
        AudioManagerObject.PlayClick()
    }
    

    @IBAction func QuitAppClick(_ sender: Any) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
    @IBAction func LogOutClick(_ sender: Any) {
        // Sign the user out of the userpool.
        GlobalUserPool.clearAll()
        
        //Move to the login viewpager.
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_login_nav")
        self.present(newViewController, animated: false, completion: nil)
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
        
        // Play marimba sound.
        AudioManagerObject.PlayClick()
        
        // Save which child was selected.
        GameEngineObject.SelectedChildIndex = indexPath[1]
        var RelevantUser = GameEngineObject.UserDBResults![indexPath[1]]
        
        // Transform the current user's dictionary (download from Dynamo) to an easily accessible data structure for use later in the app.
        GameEngineObject.CurrentUserObject?.hispanic        = NSNumber(value:(Int((RelevantUser["hispanic"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.african         = NSNumber(value:(Int((RelevantUser["african" ]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.eastAsian       = NSNumber(value:(Int((RelevantUser["eastAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.arab            = NSNumber(value:(Int((RelevantUser["arab"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.nativeAmerican  = NSNumber(value:(Int((RelevantUser["nativeAmerican"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.pacificIslander = NSNumber(value:(Int((RelevantUser["pacificIslander"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.southeastAsian  = NSNumber(value:(Int((RelevantUser["southeastAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.southAsian      = NSNumber(value:(Int((RelevantUser["southAsian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.caucasian       = NSNumber(value:(Int((RelevantUser["caucasian"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.unknown         = NSNumber(value:(Int((RelevantUser["unknown"]?.n!)!)!))
        
        GameEngineObject.CurrentUserObject?.consentPlay     = NSNumber(value:(Int((RelevantUser["consentPlay"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.consentView     = NSNumber(value:(Int((RelevantUser["consentView"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.consentShare    = NSNumber(value:(Int((RelevantUser["consentShare"]?.n!)!)!))
        GameEngineObject.CurrentUserObject?.email = (RelevantUser["email"]?.s!)!
        GameEngineObject.CurrentUserObject?.name = (RelevantUser["name"]?.s!)!
        GameEngineObject.CurrentUserObject?.gender = (RelevantUser["gender"]?.s!)!
        GameEngineObject.CurrentUserObject?.dOB = (RelevantUser["dOB"]?.s!)!
        GameEngineObject.CurrentUserObject?.country = (RelevantUser["country"]?.s!)!
        GameEngineObject.CurrentUserObject?.city = (RelevantUser["city"]?.s!)!
        GameEngineObject.CurrentUserObject?.state = (RelevantUser["state"]?.s!)!
        GameEngineObject.CurrentUserObject?.zIP = (RelevantUser["zIP"]?.s!)!
        GameEngineObject.CurrentUserObject?.autismDiagnosis = (RelevantUser["autismDiagnosis"]?.s!)!
        GameEngineObject.CurrentUserObject?.otherDiagnoses = (RelevantUser["otherDiagnoses"]?.s!)!
        
        
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
            let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
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
