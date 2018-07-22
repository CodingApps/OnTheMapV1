//
//  UserInfo.swift
//  OnTheMapV1-TestA
//
//  Created by Rick Mc on 7/14/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import Foundation

var userInformation = studentInformation(dictionary: [:])


class sharedData {
    
    static let sharedInstance = sharedData()
    var studentLocations = [studentInformation]()
    private init() {}
    
}

