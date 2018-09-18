//
//  NotificationDetailsModel.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 08/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class NotificationDetailsModel: NSObject
{
    var isSMOPaymentDone: Bool?
    var conversationId: String?
    var subject: String?
    var fromUserId: NSNumber?
    var illegalPostId: String?
    var messageDateText: String?
    var fromUserName: String?
    var messageTypeId: String?
    var typeOfNotification: String?
    var creationDate: String?
    var notificationDate: String?
    var petID: NSNumber?
    var shareCategoryTypeId: String?
    var isAccepted: Bool?
    var userMessage: String?
    var isClinicVisit: Bool?
    var isOnlineConsultation: Bool?
    var bookApptId: String?
    var isRead: Bool?
    
    init(isSMOPaymentDone: Bool?, conversationId: String?, subject: String?, fromUserId: NSNumber?, illegalPostId: String?, messageDateText: String?, fromUserName: String?, messageTypeId: String?, typeOfNotification: String?, creationDate: String?, notificationDate: String?, petID: NSNumber?,shareCategoryTypeId: String?, isAccepted: Bool?, userMessage: String?, isClinicVisit: Bool?, isOnlineConsultation: Bool?, bookApptId: String?,isRead: Bool? )
    {
        self.isSMOPaymentDone = isSMOPaymentDone
        self.conversationId = conversationId
        self.subject = subject
        self.fromUserId = fromUserId
        self.illegalPostId = illegalPostId
        self.messageDateText = messageDateText
        self.fromUserName = fromUserName
        self.messageTypeId = messageTypeId
        self.typeOfNotification = typeOfNotification
        self.creationDate = creationDate
        self.notificationDate = notificationDate
        self.petID = petID
        self.shareCategoryTypeId = shareCategoryTypeId
        self.isAccepted = isAccepted
        self.userMessage = userMessage
        self.isClinicVisit = isClinicVisit
        self.isOnlineConsultation = isOnlineConsultation
        self.bookApptId = bookApptId
        self.isRead = isRead
    }

//    "IsSMOPaymentDone": false,
//    "ConversationId": "4147",
//    "Subject": "fever",
//    "FromUserId": 0,
//    "IllegalPostId": 0,
//    "MessageDateText": null,
//    "FromUserName": "Amarnath",
//    "MessageTypeId": 0,
//    "TypeOfNotification": "reminder",
//    "CreationDate": null,
//    "NotificationDate": "2017-09-07T15:30:00",
//    "PetID": 0,
//    "ShareCategoryTypeId": 0,
//    "IsAccepted": false,
//    "UserMessage": null,
//    "IsClinicVisit": false,
//    "IsOnlineConsultation": false,
//    "BookApptId": 0
}
