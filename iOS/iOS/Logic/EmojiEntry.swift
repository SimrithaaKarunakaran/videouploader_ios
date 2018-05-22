//
//  EmojiEntry.swift
//  iOS
//
//  Created by Haik Kalantarian on 5/22/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import Foundation

public class EmojiEntry : NSObject {
    // What the file name is.
    var FileName : String?
    // What is shown under the image.
    var Caption : String?
    // What identifies it in meta information.
    var CodeName: String?
    
    init(iPath : String,iCodeName: String, iCaption : String){
        FileName = iPath
        Caption  = iCaption
        CodeName = iCodeName
    }
}
