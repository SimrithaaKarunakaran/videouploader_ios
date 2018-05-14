
import AWSDynamoDB


let AWSSampleDynamoDBTableName = "HeadsUpSurveys"


class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    
    
    
    var email       :String? = ""
    var ConsentPlay :Bool?   = false
    var ConsentView :Bool?   = false
    var ConsentShare:Bool?   = false
 
    var Answers : [Int]?
    var NotApplicableChecked : [Bool]?
    
    
    // Has the full survey information been filled out for this child?
    var ChildSurveyCompleted:Bool? = false;
    
    var name, Gender, DOB, Country, City, State, ZIP, AutismDiagnosis, OtherDiagnoses : String?
    var Hispanic, African, EastAsian, Arab, NativeAmerican, PacificIslander, SoutheastAsian,SouthAsian, Caucasian, Unknown : Bool?
    
    
    
    class func dynamoDBTableName() -> String {
        return AWSSampleDynamoDBTableName
    }
    
    class func hashKeyAttribute() -> String {
        return "email"
    }
    
    class func rangeKeyAttribute() -> String {
        return "name"
    }
    
    class func ignoreAttributes() -> [String] {
        return []
    }
}
