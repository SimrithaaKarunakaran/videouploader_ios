//
//  vc_survey1.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/8/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import UIKit


class vc_survey1: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    let AutismDiagnosis = ["Autism Spectrum Disorder (ASD)","Autism Disorder","Asperger Syndrome", "Pervasive Developmental Disorder - Not Otherwise Specified", "Rett's Disorder","Childhood Disintegrative Disorder",
    "No ASD Diagnosis", "No ASD Diagnosis, but Suspicious", "Social Communication (Pragmatic) Disorder"]
    
    let Genders = ["Male", "Female", "Other"]
    
    let Countries = [ "United States",  "Canada",  "Afghanistan",  "Aland Islands",  "Albania",  "Algeria",  "American Samoa",  "Andorra",  "Angola",  "Anguilla",  "Antarctica",  "Antigua",  "Argentina",  "Armenia",  "Aruba",  "Australia",  "Austria",  "Azerbaijan",  "Bahamas",  "Bahrain",  "Bangladesh",  "Barbados",  "Barbuda",  "Belarus",  "Belgium",  "Belize",  "Benin",  "Bermuda",  "Bhutan",  "Bolivia",  "Bosnia",  "Botswana",  "Bouvet Island",  "Brazil",  "British Indian Ocean Trty.",  "Brunei Darussalam",  "Bulgaria",  "Burkina Faso",  "Burundi",  "Caicos Islands",  "Cambodia",  "Cameroon",  "Cape Verde",  "Cayman Islands",  "Central African Republic",  "Chad",  "Chile",  "China",  "Christmas Island",  "Cocos (Keeling) Islands",  "Colombia",  "Comoros",  "Congo",  "Congo, Democratic Republic of the",  "Cook Islands",  "Costa Rica",  "Cote d\'Ivoire",  "Croatia",  "Cuba",  "Cyprus",  "Czech Republic",  "Denmark",  "Djibouti",  "Dominica",  "Dominican Republic",  "Ecuador",  "Egypt",  "El Salvador",  "Equatorial Guinea",  "Eritrea",  "Estonia",  "Ethiopia",  "Falkland Islands (Malvinas)",  "Faroe Islands",  "Fiji",  "Finland",  "France",  "French Guiana",  "French Polynesia",  "French Southern Territories",  "Futuna Islands",  "Gabon",  "Gambia",  "Georgia",  "Germany",  "Ghana",  "Gibraltar",  "Greece",  "Greenland",  "Grenada",  "Guadeloupe",  "Guam",  "Guatemala",  "Guernsey",  "Guinea",  "Guinea-Bissau",  "Guyana",  "Haiti",  "Heard",  "Herzegovina",  "Holy See",  "Honduras",  "Hong Kong",  "Hungary",  "Iceland",  "India",  "Indonesia",  "Iran (Islamic Republic of)",  "Iraq",  "Ireland",  "Isle of Man",  "Israel",  "Italy",  "Jamaica",  "Jan Mayen Islands",  "Japan",  "Jersey",  "Jordan",  "Kazakhstan",  "Kenya",  "Kiribati",  "Korea",  "Korea (Democratic)",  "Kuwait",  "Kyrgyzstan",  "Lao",  "Latvia",  "Lebanon",  "Lesotho",  "Liberia",  "Libyan Arab Jamahiriya",  "Liechtenstein",  "Lithuania",  "Luxembourg",  "Macao",  "Macedonia",  "Madagascar",  "Malawi",  "Malaysia",  "Maldives",  "Mali",  "Malta",  "Marshall Islands",  "Martinique",  "Mauritania",  "Mauritius",  "Mayotte",  "McDonald Islands",  "Mexico",  "Micronesia",  "Miquelon",  "Moldova",  "Monaco",  "Mongolia",  "Montenegro",  "Montserrat",  "Morocco",  "Mozambique",  "Myanmar",  "Namibia",  "Nauru",  "Nepal",  "Netherlands",  "Netherlands Antilles",  "Nevis",  "New Caledonia",  "New Zealand",  "Nicaragua",  "Niger",  "Nigeria",  "Niue",  "Norfolk Island",  "Northern Mariana Islands",  "Norway",  "Oman",  "Pakistan",  "Palau",  "Palestinian Territory, Occupied",  "Panama",  "Papua New Guinea",  "Paraguay",  "Peru",  "Philippines",  "Pitcairn",  "Poland",  "Portugal",  "Principe",  "Puerto Rico",  "Qatar",  "Reunion",  "Romania",  "Russian Federation",  "Rwanda",  "Saint Barthelemy",  "Saint Helena",  "Saint Kitts",  "Saint Lucia",  "Saint Martin (French part)",  "Saint Pierre",  "Saint Vincent",  "Samoa",  "San Marino",  "Sao Tome",  "Saudi Arabia",  "Senegal",  "Serbia",  "Seychelles",  "Sierra Leone",  "Singapore",  "Slovakia",  "Slovenia",  "Solomon Islands",  "Somalia",  "South Africa",  "South Georgia",  "South Sandwich Islands",  "Spain",  "Sri Lanka",  "Sudan",  "Suriname",  "Svalbard",  "Swaziland",  "Sweden",  "Switzerland",  "Syrian Arab Republic",  "Taiwan",  "Tajikistan",  "Tanzania",  "Thailand",  "The Grenadines",  "Timor-Leste",  "Tobago",  "Togo",  "Tokelau",  "Tonga",  "Trinidad",  "Tunisia",  "Turkey",  "Turkmenistan",  "Turks Islands",  "Tuvalu",  "Uganda",  "Ukraine",  "United Arab Emirates",  "United Kingdom",  "Uruguay",  "US Minor Outlying Islands",  "Uzbekistan",  "Vanuatu",  "Vatican City State",  "Venezuela",  "Vietnam",  "Virgin Islands (British)",  "Virgin Islands (US)",  "Wallis",  "Western Sahara",  "Yemen",  "Zambia",  "Zimbabwe"]
    
    let States = ["Alabama",  "Alaska",  "Arizona",  "Arkansas",  "California",  "Colorado",  "Connecticut",  "Delaware",  "District of Columbia",  "Florida",  "Georgia",  "Hawaii",  "Idaho",  "Illinois",  "Indiana",  "Iowa",  "Kansas",  "Kentucky",  "Louisiana",  "Maine",  "Maryland",  "Massachusetts",  "Michigan",  "Minnesota",  "Mississippi",  "Missouri",  "Montana",  "Nebraska",  "Nevada",  "New Hampshire",  "New Jersey",  "New Mexico",  "New York",  "North Carolina",  "North Dakota",  "Ohio",  "Oklahoma",  "Oregon",  "Pennsylvania",  "Rhode Island",  "South Carolina",  "South Dakota",  "Tennessee",  "Texas",  "Utah",  "Vermont",  "Virginia",  "Washington",  "West Virginia",  "Wisconsin",  "Wyoming"]

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
    
    
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return States.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return States[row]

        
    }
    
    // When user actually selects a field
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textState.text = States[row]
        textState.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        PickerViewStates.delegate = self
        PickerViewStates.dataSource = self
        
        
        textState.inputView = PickerViewStates
        //textState.textAlignment = .center
        textState.placeholder = "Select State"
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
