import AWSDynamoDB


class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    
    
    
    // Has the full survey information been filled out for this child?
    
    
    
    @objc var email                : String = "NA"
    @objc var name                 : String = "NA"
    @objc var Gender               : String = "NA"
    @objc var DOB                  : String = "NA"
    @objc var Country              : String = "NA"
    @objc var City                 : String = "NA"
    @objc var State                : String = "NA"
    @objc var ZIP                  : String = "NA"
    @objc var AutismDiagnosis      : String = "NA"
    @objc var OtherDiagnoses       : String = "NA"
    

 
    @objc var Answers              : NSArray = [0,0]
    @objc var NotApplicableChecked : NSArray = [0,0]
 
    
    // Has the full survey information been filled out for this child?
    @objc var ChildSurveyCompleted : NSNumber = 0
    @objc var Hispanic             : NSNumber = 0
    @objc var African              : NSNumber = 0
    @objc var EastAsian            : NSNumber = 0
    @objc var Arab                 : NSNumber = 0
    @objc var NativeAmerican       : NSNumber = 0
    @objc var PacificIslander      : NSNumber = 0
    @objc var SoutheastAsian       : NSNumber = 0
    @objc var SouthAsian           : NSNumber = 0
    @objc var Caucasian            : NSNumber = 0
    @objc var Unknown              : NSNumber = 0
    
    @objc var ConsentPlay          : NSNumber = 0
    @objc var ConsentView          : NSNumber = 0
    @objc var ConsentShare         : NSNumber = 0
    

    
    
    
    class func dynamoDBTableName() -> String {
        return "HeadsUpSurveys"
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
