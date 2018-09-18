//
//  ReminderModel.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 05/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ReminderModel: NSObject
{
    var id: String?
    var date: String?
    var time: String?
    var reason: String?
    var comments: String?
    var vet: String?
    var repeatInt: String?
    
    init(id: String?, date: String?, time: String?, reason: String?, comments: String?, vet: String?, repeatInt: String?)
    {
        self.id = id
        self.date = date
        self.time = time
        self.reason = reason
        self.comments = comments
        self.vet = vet
        self.repeatInt = repeatInt
    }
    
}
