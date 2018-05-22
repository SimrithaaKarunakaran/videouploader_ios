 import Foundation
 
 class PromptManager: NSObject {
    
    // Create a singleton instance
    static let sharedInstance: PromptManager = { return PromptManager() }()
    
    static var JobsPrompts   = [EmojiEntry]()
    static var EmojiPrompts  = [EmojiEntry]()
    static var FacesPrompts  = [EmojiEntry]()
    static var AnimalPrompts = [EmojiEntry]()
    static var SportsPrompts = [EmojiEntry]()

    // A set of all remaining prompts that have not yet been shown.
    var PromptsNotShownAlready : [EmojiEntry]


    override init() {
        
        
        print("[HK] PromptManager init called.")
        PromptsNotShownAlready = [EmojiEntry]()

        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e1_scientist"  , iCodeName: "E_SCIENTIST"  , iCaption: "Scientist"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e2_firefighter", iCodeName: "E_FIREFIGHTER", iCaption: "Firefighter"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e3_doctor"     , iCodeName: "E_DOCTOR"     , iCaption: "Doctor"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e5_astronaut"  , iCodeName: "E_ASTRONAUT"  , iCaption: "Astronaut"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e6_chef"       , iCodeName: "E_CHEF"       , iCaption: "Chef"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e7_teacher"    , iCodeName: "E_TEACHER"    , iCaption: "Teacher"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e8_artist"     , iCodeName: "E_ARTIST"     , iCaption: "Artist"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e9_dentist"    , iCodeName: "E_DENTIST"    , iCaption: "Dentist"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e10_pilot"     , iCodeName: "E_PILOT"      , iCaption: "Pilot"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e11_actor"     , iCodeName: "E_ACTOR"      , iCaption: "Actor"))
        PromptManager.JobsPrompts.append(EmojiEntry(iPath: "e12_musician"  , iCodeName: "E_MUSICIAN"   , iCaption: "Musician"))

        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a1_smile", iCodeName: "A_Smile", iCaption: "Smile"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a2_grin", iCodeName: "A_Grin", iCaption: "Smile"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a3_hug", iCodeName: "A_Hug", iCaption: "Hug"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a4_think", iCodeName: "A_Think", iCaption: "Think"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a5_love", iCodeName: "A_Love", iCaption: "Love"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a6_angry", iCodeName: "A_Angry", iCaption: "Angry"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a7_sick", iCodeName: "A_Sick", iCaption: "Sick"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a8_surprise", iCodeName: "A_Surprise", iCaption: "Surprised"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a9_cry", iCodeName: "A_Cry", iCaption: "Crying"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a10_sleepy", iCodeName: "A_Sleepy", iCaption: "Sleepy"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a11_annoyed", iCodeName: "A_Annoyed", iCaption: "Annoyed"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a12_sad", iCodeName:  "A_Sad", iCaption: "Sad"))
        PromptManager.EmojiPrompts.append(EmojiEntry(iPath: "a13_confused", iCodeName: "A_Confused", iCaption: "Confused"))

        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_angry", iCodeName: "F_ANGRY", iCaption: "Angry"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_angry2", iCodeName: "F_ANGRY2", iCaption: "Angry"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_angry3", iCodeName: "F_ANGRY3", iCaption: "Angry"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_disgust", iCodeName: "F_DISGUST", iCaption: "Yuck"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_disgust2", iCodeName: "F_DISGUST2", iCaption: "Yuck"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_disgust3", iCodeName: "F_DISGUST3", iCaption: "Yuck"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_disgust4", iCodeName: "F_DISGUST4", iCaption: "Yuck"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_happy2", iCodeName: "F_HAPPY2", iCaption: "Happy"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_happy3", iCodeName: "F_HAPPY3", iCaption: "Happy"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_neutral", iCodeName: "F_NEUTRAL", iCaption: "Calm"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_neutral2", iCodeName: "F_NEUTRAL2", iCaption: "Calm"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_sad", iCodeName: "F_SAD", iCaption: "Sad"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_sad2", iCodeName: "F_SAD2", iCaption: "Sad"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_scared", iCodeName: "F_SCARED", iCaption: "Scared"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_scared2", iCodeName: "F_SCARED2", iCaption: "Scared"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_surprised", iCodeName: "F_SURPRISED", iCaption: "Surprised"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_surprised2", iCodeName: "F_SURPRISED2", iCaption: "Surprised"))
        PromptManager.FacesPrompts.append(EmojiEntry(iPath: "f_surprised3", iCodeName: "F_SURPRISED3", iCaption: "Surprised"))
        
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c1_dog", iCodeName: "C_Dog", iCaption: "Dog"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c2_duck", iCodeName: "C_Duck", iCaption: "Duck"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c3_horse", iCodeName: "C_Horse", iCaption: "Horse"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c4_pig", iCodeName: "C_Pig", iCaption: "Pig"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c5_goat", iCodeName: "C_Goat", iCaption: "Goat"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c6_cat", iCodeName: "C_Cat", iCaption: "Cat"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c7_cow", iCodeName: "C_Cow", iCaption: "Cow"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c8_chicken", iCodeName: "C_Chicken", iCaption: "Chicken"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c9_sheep", iCodeName: "C_Sheep", iCaption: "Sheep"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c10_pig", iCodeName: "C_pig", iCaption: "Pig"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c11_lion", iCodeName: "C_lion", iCaption: "Lion"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c12_elephant", iCodeName: "C_elephant", iCaption: "Elephant"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c13_frog", iCodeName: "C_frog", iCaption: "Frog"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c14_bee", iCodeName: "C_bee", iCaption: "Bee"))
        PromptManager.AnimalPrompts.append(EmojiEntry(iPath: "c15_monkey", iCodeName: "C_monkey", iCaption: "Monkey"))
        
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d1_basketball", iCodeName: "D_BASKETBALL", iCaption: "Basketball"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d2_soccer", iCodeName: "D_SOCCER", iCaption: "Soccer"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d3_baseball", iCodeName: "D_BASEBALL", iCaption: "Baseball"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d4_football", iCodeName: "D_FOOTBALL", iCaption: "Football"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d5_hockey", iCodeName: "D_HOCKEY", iCaption: "Hockey"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d6_wrestling", iCodeName: "D_WRESTLING", iCaption: "Wrestling"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d7_tennis", iCodeName: "D_TENNIS", iCaption: "Tennis"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d8_biking", iCodeName: "D_BIKING", iCaption: "Biking"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d9_skiing", iCodeName: "D_SKIING", iCaption: "Skiing"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d10_skateboard", iCodeName: "D_SKATEBOARD", iCaption: "Skateboarding"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d11_running", iCodeName: "D_RUNNING", iCaption: "Running"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d12_weights", iCodeName: "D_WEIGHTS", iCaption: "Weightlifting"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d13_volleyball", iCodeName: "D_VOLLEYBALL", iCaption: "Volleyball"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d14_ping", iCodeName: "D_PINGPONG", iCaption: "Ping Pong"))
        PromptManager.SportsPrompts.append(EmojiEntry(iPath: "d15_archer", iCodeName: "D_ARCHERY", iCaption: "Archery"))
      
        super.init()
    }
    
    static func GetNextImage() -> EmojiEntry{
        
        if(self.sharedInstance.PromptsNotShownAlready.count <= 0){
            print("[HK] We are out of prompts! Lets load some more.")
            LoadPromptsForGame(PromptArray: GameEngineObject.ArraySelected)
        }
        
        // Generate a random number to select an image that has not been shown to the user yet.
        let rdx = Int(arc4random_uniform((UInt32)(self.sharedInstance.PromptsNotShownAlready.count)))
        
        print("[HK] The size of PromptsNotAlreadyShown is: \(self.sharedInstance.PromptsNotShownAlready.count)")
        print("[HK] The index we are retrieving is: \(rdx)")

        // Get a handle to the emoji we will return to the user.
        let tempHandle = self.sharedInstance.PromptsNotShownAlready[rdx]
        // Remove the emoji since it was already shown to the user.
        self.sharedInstance.PromptsNotShownAlready.remove(at: rdx)
        // Return the image to the user.
        return tempHandle
    }
    
    
    //["Emoji", "Animals", "Faces", "Sports", "Jobs", "All Decks"]
    static func LoadPromptsForGame(PromptArray: [Bool] ) {
        
        self.sharedInstance.PromptsNotShownAlready.removeAll()
        print("[HK] Entered LoadPromptsForGame.")

        // Emoji
        if(PromptArray[0] || PromptArray[5]){
            self.sharedInstance.PromptsNotShownAlready.append(contentsOf: PromptManager.EmojiPrompts)
            print("[HK] Importing emoji.")
        }
        // Animals
        if(PromptArray[1] || PromptArray[5]){
            self.sharedInstance.PromptsNotShownAlready.append(contentsOf: PromptManager.AnimalPrompts)
            print("[HK] Importing animals with count: \(PromptManager.AnimalPrompts.count)")
        }
        // Faces
        if(PromptArray[2] || PromptArray[5]){
            self.sharedInstance.PromptsNotShownAlready.append(contentsOf: PromptManager.FacesPrompts)
            print("[HK] Importing faces.")
        }
        // Sports
        if(PromptArray[3] || PromptArray[5]){
            self.sharedInstance.PromptsNotShownAlready.append(contentsOf: PromptManager.SportsPrompts)
            print("[HK] Importing sports with count: \(PromptManager.SportsPrompts.count)")
        }
        // Jobs
        if(PromptArray[4] || PromptArray[5]){
            self.sharedInstance.PromptsNotShownAlready.append(contentsOf: PromptManager.JobsPrompts)
            print("[HK] Importing jobs.")
        }
    }
 }
 

