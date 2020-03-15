//
//  Message.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 6/2/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class Message: NSObject {
    var from            : String = ""
    var to              : String = ""
    var timeStamp       : Double = 0
    var message         : String = ""
    var messageId       : String = ""

    init(from: String,
         to: String,
         timeStamp: Double,
         message: String,
         messageId: String) {
        
        self.from = from
        self.to = to
        self.timeStamp = timeStamp
        self.message = message
        self.messageId = messageId
        
        super.init()
    }
}
