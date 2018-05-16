import AWSDynamoDB


class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    
    
    
    // Has the full survey information been filled out for this child?
    
    
    
    @objc var email                : String = "NA"
    @objc var name                 : String = "NA"
    @objc var gender               : String = "NA"
    @objc var dOB                  : String = "NA"
    @objc var country              : String = "NA"
    @objc var city                 : String = "NA"
    @objc var state                : String = "NA"
    @objc var zIP                  : String = "NA"
    @objc var autismDiagnosis      : String = "NA"
    @objc var otherDiagnoses       : String = "NA"
    

 
    @objc var answers              : NSArray = [0,0]
    @objc var notApplicableChecked : NSArray = [0,0]
 
    
    // Has the full survey information been filled out for this child?
    @objc var childSurveyCompleted : NSNumber = 0
    @objc var hispanic             : NSNumber = 0
    @objc var african              : NSNumber = 0
    @objc var eastAsian            : NSNumber = 0
    @objc var arab                 : NSNumber = 0
    @objc var nativeAmerican       : NSNumber = 0
    @objc var pacificIslander      : NSNumber = 0
    @objc var southeastAsian       : NSNumber = 0
    @objc var southAsian           : NSNumber = 0
    @objc var caucasian            : NSNumber = 0
    @objc var unknown              : NSNumber = 0
    
    @objc var consentPlay          : NSNumber = 0
    @objc var consentView          : NSNumber = 0
    @objc var consentShare         : NSNumber = 0
    

    
    
    
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
