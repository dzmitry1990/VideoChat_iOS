//
//  User.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 6/3/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class User: NSObject {
    var userID              : String
    var userAvatar          : String
    var firstName           : String
    var lastName            : String
    var email               : String
    var age                 : Int
    var snapChatId          : String
    var gender              : String
    
    var fullname: String {
        return firstName + " " + lastName
    }
    
    var sGender: String {
        if gender == Gender.female {
            return "girl"
        } else {
            return "boy"
        }
    }
    
    override init() {
        self.userID = ""
        self.userAvatar = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.age = 0
        self.snapChatId = ""
        self.gender = ""
    }
    
    init(userID: String,
         userAvatar: String,
         firstName: String,
         lastName: String,
         email: String,
         age: Int,
         gender: String,
         snapchat: String) {
        
        self.userID = userID
        self.userAvatar = userAvatar
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.age = age
        self.gender = gender
        self.snapChatId = snapchat
        
        super.init()
    }
}
