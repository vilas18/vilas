//
//  NotificationsModel.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 08/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class NotificationsModel: NSObject
{
    var notifiDate: NSDate
    var month: String
    var year: String
    var monthlyList:[NotificationDetailsModel]
    
     init(notifiDate: NSDate, month: String, year: String, monthlyList:[NotificationDetailsModel])
     {
        self.notifiDate = notifiDate
        self.month = month
        self.year = year
        self.monthlyList = monthlyList
    }
}
