//
//  Inbox.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 6/15/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class Inbox: NSObject {
    var from            : String = ""
    var to              : String = ""
    var timestamp       : Double = 0
    var message         : String = ""
    var conversationId  : String = ""
    var user            : User?
    
    init(from: String,
         to: String,
         timeStamp: Double,
         message: String,
         conId: String,
         user: User) {
        
        self.from = from
        self.to = to
        self.timestamp = timeStamp
        self.message = message
        self.conversationId = conId
        self.user = user
        
        super.init()
    }
}
