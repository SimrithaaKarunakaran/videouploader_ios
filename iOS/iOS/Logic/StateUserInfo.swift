//
//  StateUserInfo.swift
//  iOS
//
//  Created by Haik Kalantarian on 3/15/18.
//  Copyright © 2018 Haik Kalantarian. All rights reserved.
//

import Foundation


/*
 Here is the global variable.
 This can be accessed from anywhere.
 */

let UserInfo = VideoModeHK()

/*
 Here we are defining the class
 */

struct Resolution {
    var width = 0
    var height = 0
}
class VideoModeHK {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 2.0
    var name: String?
}
