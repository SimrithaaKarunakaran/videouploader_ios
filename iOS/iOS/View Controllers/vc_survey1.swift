//
//  vc_survey1.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/8/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit



class vc_survey1: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{


    @IBOutlet weak var ButtonBack: UIButton!
    @IBOutlet weak var ButtonContinue: UIButton!
    
    let AutismDiagnosis = ["Select","Autism Spectrum Disorder (ASD)","Autism Disorder","Asperger Syndrome", "Pervasive Developmental Disorder - Not Otherwise Specified", "Rett's Disorder","Childhood Disintegrative Disorder",
    "No ASD Diagnosis", "No ASD Diagnosis, but Suspicious", "Social Communication (Pragmatic) Disorder"]
    
    let Genders = ["Select","Male", "Female", "Other"]
    
    let Countries = ["Select","United States",  "Canada",  "Afghanistan",  "Aland Islands",  "Albania",  "Algeria",  "American Samoa",  "Andorra",  "Angola",  "Anguilla",  "Antarctica",  "Antigua",  "Argentina",  "Armenia",  "Aruba",  "Australia",  "Austria",  "Azerbaijan",  "Bahamas",  "Bahrain",  "Bangladesh",  "Barbados",  "Barbuda",  "Belarus",  "Belgium",  "Belize",  "Benin",  "Bermuda",  "Bhutan",  "Bolivia",  "Bosnia",  "Botswana",  "Bouvet Island",  "Brazil",  "British Indian Ocean Trty.",  "Brunei Darussalam",  "Bulgaria",  "Burkina Faso",  "Burundi",  "Caicos Islands",  "Cambodia",  "Cameroon",  "Cape Verde",  "Cayman Islands",  "Central African Republic",  "Chad",  "Chile",  "China",  "Christmas Island",  "Cocos (Keeling) Islands",  "Colombia",  "Comoros",  "Congo",  "Congo, Democratic Republic of the",  "Cook Islands",  "Costa Rica",  "Cote d\'Ivoire",  "Croatia",  "Cuba",  "Cyprus",  "Czech Republic",  "Denmark",  "Djibouti",  "Dominica",  "Dominican Republic",  "Ecuador",  "Egypt",  "El Salvador",  "Equatorial Guinea",  "Eritrea",  "Estonia",  "Ethiopia",  "Falkland Islands (Malvinas)",  "Faroe Islands",  "Fiji",  "Finland",  "France",  "French Guiana",  "French Polynesia",  "French Southern Territories",  "Futuna Islands",  "Gabon",  "Gambia",  "Georgia",  "Germany",  "Ghana",  "Gibraltar",  "Greece",  "Greenland",  "Grenada",  "Guadeloupe",  "Guam",  "Guatemala",  "Guernsey",  "Guinea",  "Guinea-Bissau",  "Guyana",  "Haiti",  "Heard",  "Herzegovina",  "Holy See",  "Honduras",  "Hong Kong",  "Hungary",  "Iceland",  "India",  "Indonesia",  "Iran (Islamic Republic of)",  "Iraq",  "Ireland",  "Isle of Man",  "Israel",  "Italy",  "Jamaica",  "Jan Mayen Islands",  "Japan",  "Jersey",  "Jordan",  "Kazakhstan",  "Kenya",  "Kiribati",  "Korea",  "Korea (Democratic)",  "Kuwait",  "Kyrgyzstan",  "Lao",  "Latvia",  "Lebanon",  "Lesotho",  "Liberia",  "Libyan Arab Jamahiriya",  "Liechtenstein",  "Lithuania",  "Luxembourg",  "Macao",  "Macedonia",  "Madagascar",  "Malawi",  "Malaysia",  "Maldives",  "Mali",  "Malta",  "Marshall Islands",  "Martinique",  "Mauritania",  "Mauritius",  "Mayotte",  "McDonald Islands",  "Mexico",  "Micronesia",  "Miquelon",  "Moldova",  "Monaco",  "Mongolia",  "Montenegro",  "Montserrat",  "Morocco",  "Mozambique",  "Myanmar",  "Namibia",  "Nauru",  "Nepal",  "Netherlands",  "Netherlands Antilles",  "Nevis",  "New Caledonia",  "New Zealand",  "Nicaragua",  "Niger",  "Nigeria",  "Niue",  "Norfolk Island",  "Northern Mariana Islands",  "Norway",  "Oman",  "Pakistan",  "Palau",  "Palestinian Territory, Occupied",  "Panama",  "Papua New Guinea",  "Paraguay",  "Peru",  "Philippines",  "Pitcairn",  "Poland",  "Portugal",  "Principe",  "Puerto Rico",  "Qatar",  "Reunion",  "Romania",  "Russian Federation",  "Rwanda",  "Saint Barthelemy",  "Saint Helena",  "Saint Kitts",  "Saint Lucia",  "Saint Martin (French part)",  "Saint Pierre",  "Saint Vincent",  "Samoa",  "San Marino",  "Sao Tome",  "Saudi Arabia",  "Senegal",  "Serbia",  "Seychelles",  "Sierra Leone",  "Singapore",  "Slovakia",  "Slovenia",  "Solomon Islands",  "Somalia",  "South Africa",  "South Georgia",  "South Sandwich Islands",  "Spain",  "Sri Lanka",  "Sudan",  "Suriname",  "Svalbard",  "Swaziland",  "Sweden",  "Switzerland",  "Syrian Arab Republic",  "Taiwan",  "Tajikistan",  "Tanzania",  "Thailand",  "The Grenadines",  "Timor-Leste",  "Tobago",  "Togo",  "Tokelau",  "Tonga",  "Trinidad",  "Tunisia",  "Turkey",  "Turkmenistan",  "Turks Islands",  "Tuvalu",  "Uganda",  "Ukraine",  "United Arab Emirates",  "United Kingdom",  "Uruguay",  "US Minor Outlying Islands",  "Uzbekistan",  "Vanuatu",  "Vatican City State",  "Venezuela",  "Vietnam",  "Virgin Islands (British)",  "Virgin Islands (US)",  "Wallis",  "Western Sahara",  "Yemen",  "Zambia",  "Zimbabwe"]
    
    let States = ["Select","Alabama",  "Alaska",  "Arizona",  "Arkansas",  "California",  "Colorado",  "Connecticut",  "Delaware",  "District of Columbia",  "Florida",  "Georgia",  "Hawaii",  "Idaho",  "Illinois",  "Indiana",  "Iowa",  "Kansas",  "Kentucky",  "Louisiana",  "Maine",  "Maryland",  "Massachusetts",  "Michigan",  "Minnesota",  "Mississippi",  "Missouri",  "Montana",  "Nebraska",  "Nevada",  "New Hampshire",  "New Jersey",  "New Mexico",  "New York",  "North Carolina",  "North Dakota",  "Ohio",  "Oklahoma",  "Oregon",  "Pennsylvania",  "Rhode Island",  "South Carolina",  "South Dakota",  "Tennessee",  "Texas",  "Utah",  "Vermont",  "Virginia",  "Washington",  "West Virginia",  "Wisconsin",  "Wyoming"]

    var PickerViewDiagnosis = UIPickerView()
    var PickerViewGenders   = UIPickerView()
    var PickerViewCountries = UIPickerView()
    var PickerViewStates    = UIPickerView()
    
    // Handles to ethnicity switches
    @IBOutlet weak var LatinoSwitch: UISwitch!
    @IBOutlet weak var AsianSwitch: UISwitch!
    @IBOutlet weak var NativeAmericanSwitch: UISwitch!
    @IBOutlet weak var SoutheastSwitch: UISwitch!
    @IBOutlet weak var WhiteSwitch: UISwitch!
    @IBOutlet weak var CaribbeanSwitch: UISwitch!
    @IBOutlet weak var ArabSwitch: UISwitch!
    @IBOutlet weak var PacificSwitch: UISwitch!
    @IBOutlet weak var SouthAsianSwitch: UISwitch!
    @IBOutlet weak var OtherSwitch: UISwitch!
    
    // Handles to text-based fields.
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textGender: UITextField!
    @IBOutlet weak var textDOB: UITextField!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textState: UITextField!
    @IBOutlet weak var textZIP: UITextField!
    @IBOutlet weak var textOtherDiagnosis: UITextField!
    @IBOutlet weak var textAutism: UITextField!
    @IBOutlet weak var textCity: UITextField!
    
    
    
    @IBAction func ResignResponder(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    

    var LatinoSwitchOn         = false;
    var AsianSwitchOn          = false;
    var SoutheastSwitchOn      = false;
    var SouthAsianSwitchOn     = false;
    var NativeAmericanSwitchOn = false;
    var WhiteSwitchOn          = false;
    var CaribbeanSwitchOn      = false;
    var ArabSwitchOn           = false;
    var PacificSwitchOn        = false;
    var OtherSwitchOn          = false;
    
    var StringName    = "";
    var StringGender  = "";
    var StringDOB     = "";
    var StringCountry = "";
    var StringState   = "";
    var StringZIP     = "";
    var StringAutism  = "";
    var StringCity    = "";
    var StringOtherDiagnosis = "";
    
    
    
    
    func ShowError(error: String){
        let alert = UIAlertController(title: "Form Incomplete", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func ContinueClick(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        LatinoSwitchOn         = LatinoSwitch.isOn
        AsianSwitchOn          = AsianSwitch.isOn
        NativeAmericanSwitchOn = NativeAmericanSwitch.isOn
        SoutheastSwitchOn      = SoutheastSwitch.isOn
        WhiteSwitchOn          = WhiteSwitch.isOn
        CaribbeanSwitchOn      = CaribbeanSwitch.isOn
        ArabSwitchOn           = ArabSwitch.isOn
        PacificSwitchOn        = PacificSwitch.isOn
        SouthAsianSwitchOn     = SouthAsianSwitch.isOn
        OtherSwitchOn          = OtherSwitch.isOn
        
        // First, we validate the inputs.
        //if(!LatinoSwitch.isOn && !AsianSwitch.isOn && !NativeAmericanSwitch.isOn && !SoutheastSwitch.isOn
        //    && !WhiteSwitch.isOn && !CaribbeanSwitch.isOn && !ArabSwitch.isOn && !PacificSwitch.isOn && !SouthAsianSwitch.isOn && !OtherSwitch.isOn){
        //    ShowError(error: "Please select an ethnicity to proceed.")
        //    return;
        //}
        
        StringName    = textName.text!
        StringGender  = textGender.text!
        StringDOB     = textDOB.text!
        StringCountry = textCountry.text!
        StringState   = textState.text!
        StringZIP     = textZIP.text!
        StringAutism  = textAutism.text!
        StringCity    = textCity.text!
        StringOtherDiagnosis = textOtherDiagnosis.text!
    
        if(StringName.count < 3){
            ShowError(error: "Please enter your name to proceed.")
            return;
        }
        
        //if(StringZIP.count != 5){
        //    ShowError(error: "Please complete the ZIP field proceed.")
        //    return;
        //}
        
        if(StringGender.count < 4){
            ShowError(error: "Please enter your child's gender to proceed.")
            return;
        }
        
        if(StringDOB.count < 4){
            ShowError(error: "Please enter your child's DOB in MM/YY format to proceed.")
            return;
        }
        
        if(StringDOB.range(of:"/") == nil){
            ShowError(error: "Please include the DOB in format MM/YY")
            return;
        }
        
        //if(StringCountry.count < 4){
        //    ShowError(error: "Please complete the Country field to proceed.")
        //    return;
        //}
        
        //if(StringState.count < 2){
        //    ShowError(error: "Please complete the State field to proceed.")
        //    return;
        //}
        
        if(StringAutism.count < 4){
            ShowError(error: "Please enter your child's autism diagnosis to proceed.")
            return;
        }
        
        //if(StringCity.count < 4){
        //    ShowError(error: "Please complete the city field to proceed.")
        //    return;
        //}
        
        
        // We can't submit any empty fields so lets use some placeholders here.
        StringName    = (StringName.count == 0) ? "[Empty]" : StringName
        StringZIP     = (StringZIP.count == 0) ? "[Empty]" : StringZIP
        StringGender  = (StringGender.count == 0) ? "[Empty]" : StringGender
        StringDOB     = (StringDOB.count == 0) ? "[Empty]" : StringDOB
        StringCountry = (StringCountry.count == 0) ? "[Empty]" : StringCountry
        StringState   = (StringState.count == 0) ? "[Empty]" : StringState
        StringAutism  = (StringAutism.count == 0) ? "[Empty]" : StringAutism
        StringCity    = (StringCity.count == 0) ? "[Empty]" : StringCity
        StringOtherDiagnosis    = (StringOtherDiagnosis.count == 0) ? "[Empty]" : StringOtherDiagnosis

        /*
        Now that the user has made it this far, lets create a new record in the database.
        */
        
        GameEngineObject.CurrentUserObject = DDBTableRow()
        GameEngineObject.CurrentUserObject?.email   = GameEngineObject.getDBFriendlyEmail(email: GameEngineObject.UserEmail!)
        GameEngineObject.CurrentUserObject?.name    = StringName
        GameEngineObject.CurrentUserObject?.gender  = StringGender
        GameEngineObject.CurrentUserObject?.dOB     = StringDOB
        GameEngineObject.CurrentUserObject?.country = StringCountry
        GameEngineObject.CurrentUserObject?.city    = StringCity
        GameEngineObject.CurrentUserObject?.state   = StringState
        GameEngineObject.CurrentUserObject?.zIP     = StringZIP
        GameEngineObject.CurrentUserObject?.autismDiagnosis = StringAutism
        GameEngineObject.CurrentUserObject?.otherDiagnoses  = StringOtherDiagnosis
        

        GameEngineObject.CurrentUserObject?.childSurveyCompleted = 0
        
        GameEngineObject.CurrentUserObject?.consentPlay = 1
        GameEngineObject.CurrentUserObject?.consentView = 1
        GameEngineObject.CurrentUserObject?.consentShare = 1

        GameEngineObject.CurrentUserObject?.childSurveyCompleted = 0
        
        GameEngineObject.CurrentUserObject?.hispanic = LatinoSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.african   = CaribbeanSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.eastAsian = AsianSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.arab = ArabSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.nativeAmerican = NativeAmericanSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.pacificIslander = PacificSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.southeastAsian = SoutheastSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.southAsian = SouthAsianSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.caucasian = WhiteSwitchOn ? 1 : 0
        GameEngineObject.CurrentUserObject?.unknown = OtherSwitchOn ? 1 : 0
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_consent_1")
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func BackClickNew(_ sender: Any) {
        // Play click sound.
        AudioManagerObject.PlayClick()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "story_game", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "vc_select_player_nav")
        self.present(newViewController, animated: false, completion: nil)
    }
   
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if(pickerView == PickerViewStates){
            return States.count
        } else if(pickerView == PickerViewCountries){
            return Countries.count
        }
        else if(pickerView == PickerViewGenders){
            return Genders.count
        }
        else if(pickerView == PickerViewDiagnosis){
            return AutismDiagnosis.count
        }
        else{
            return States.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == PickerViewStates){
            return States[row]
        } else if(pickerView == PickerViewCountries){
            return Countries[row]
        }
        else if(pickerView == PickerViewGenders){
            return Genders[row]
        }
        else if(pickerView == PickerViewDiagnosis){
            return AutismDiagnosis[row]
        }
        else{
            return States[row]
        }
    }
    
    // When user actually selects a field
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == PickerViewStates){
            textState.text = States[row]
            textState.resignFirstResponder()
        } else if(pickerView == PickerViewCountries){
            textCountry.text = Countries[row]
            textCountry.resignFirstResponder()        }
        else if(pickerView == PickerViewGenders){
            textGender.text = Genders[row]
            textGender.resignFirstResponder()        }
        else if(pickerView == PickerViewDiagnosis){
            textAutism.text = AutismDiagnosis[row]
            textAutism.resignFirstResponder()
        }
        else{
            textState.text = States[row]
            textState.resignFirstResponder()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        PickerViewStates.delegate = self
        PickerViewStates.dataSource = self
        
        PickerViewCountries.delegate = self
        PickerViewCountries.dataSource = self
      
        PickerViewGenders.delegate = self
        PickerViewGenders.dataSource = self
        
        PickerViewDiagnosis.delegate = self
        PickerViewDiagnosis.dataSource = self
        
        textState.inputView = PickerViewStates
        textState.placeholder = "Select State"
        
        textCountry.inputView = PickerViewCountries
        textCountry.placeholder = "Select Country"
        
        textGender.inputView = PickerViewGenders
        textGender.placeholder = "Select Gender"
        
        textAutism.inputView = PickerViewDiagnosis
        textAutism.placeholder = "Select Diagnosis"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
