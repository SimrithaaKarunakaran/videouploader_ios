//
//  vc_create_account.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/7/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit



var Username  = ""
var Password  = ""

class vc_create_account: UIViewController {

    @IBOutlet weak var TextUsername: UITextField!
    @IBOutlet weak var TextPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Show a popup that indicates user has entered an invalid username or password.
    ///
    /// - Parameter error: The exact error message to display.
    func ShowError(error: String){
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func CreateAccountNextClick(_ sender: Any) {
        
        // Get text out of the text fields corresponding with username and password
        Username = TextUsername.text!
        Password = TextPassword.text!
        
        print("Username length: \(Username.count)")
        print("Password length: \(Password.count)")

        // First, lets determine if the username (email) is of reasonable length.
        if(Username.count < 4){
            ShowError(error: "Please enter a valid email address.")
            return;
        }
      
        // Next, determine if email address contains "@"
        if(Username.range(of:"@") == nil){
            ShowError(error: "Please enter a valid email address.")
            return;
        }
        
        // Lastly, determine if email address contains "."
        if(Username.range(of:".") == nil){
            ShowError(error: "Please enter a valid email address.")
            return;
        }
        
        // Lets determine if the password is sufficiently complex
        if(!checkTextSufficientComplexity(text: Password)){
            ShowError(error: "Password must be 8 digits, containing at least one capital letter, number, and symbol.")
            return;
        }
        
        GameEngineObject.signup(email: Username, password: Password) { (SuccessRegister) in
            
            if(SuccessRegister!){
                // Successfully created account. Now lets finish authentication and proceed.
                GameEngineObject?.login(email: Username, password: Password) { (Success, Result) in
                    GameEngineObject?.accessToken     = Result!
                    if(Success){
                        GameEngineObject.fullyAuthenticateWithToken(sessionCompletion: { (Success) in
                            // We've got a session and now we can access AWS service via default() e.g.: let cognito = AWSCognito.default()
                            print("[HK] Fully authenticated.")
                            GameEngineObject.downloadUserData(email: GameEngineObject.UserEmail!, completion: { (Success) in
                                print("[HK] DownloadUserData callback: \(Success)")
                                
                                DispatchQueue.main.async { // Correct
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "story_pageview", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player")
                                    self.present(newViewController, animated: true, completion: nil)
                                }
                            })
                        })
                    }
                }
            }
        }
    }
    
    
    
    /// This function will return true if the input is at least 8 characters,
    /// containing 1+ capital letters, numbers, and special characters.
    ///
    /// - Parameter text: The input string to parse.
    /// - Returns: Boolean value representing whether or not it is sufficiently complex.
    func checkTextSufficientComplexity(text : String) -> Bool{
        
        if(text.count < 8){
            return false;
        }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with:text)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with:text)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with:text)
        
        return capitalresult || numberresult || specialresult
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
