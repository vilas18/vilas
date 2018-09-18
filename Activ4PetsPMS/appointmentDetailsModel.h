//
//  appointmentDetailsModel.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 20/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appointmentDetailsModel : NSObject
//Appointment
@property(nonatomic, strong) NSString *apptId;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *petId;
@property(nonatomic, strong) NSString *apptDate;
@property(nonatomic, strong) NSString *timeFrom;
@property(nonatomic, strong) NSString *timeTo;
@property(nonatomic, strong) NSString *mins;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *statusId;
@property(nonatomic, strong) NSString *petName;
@property(nonatomic, strong) NSString *species;
@property(nonatomic, strong) NSString *ownerName;
@property(nonatomic, strong) NSString *ownerEmail;
@property(nonatomic, strong) NSString *vetName;
@property(nonatomic, strong) NSString *apptType;
@property(nonatomic, strong) NSString *typeOfVisit;
@property(nonatomic, strong) NSString *typeOfVisitId;
@property(nonatomic, strong) NSString *clinicLocation;
@property(nonatomic, strong) NSString *rescheduleDate;
@property(nonatomic, strong) NSString *apptReason;
@property(nonatomic, strong) NSString *consultMode;
@property(nonatomic, strong) NSString *consultModeId;
@property(nonatomic, strong) NSString *timeFrom12hr;
@property(nonatomic, strong) NSString *timeTo12hr;
@property(nonatomic, strong) NSString *conclusion;
@property(nonatomic, strong) NSDate *apptSortdate;

//Event
@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *physician;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSString *reason;
@property(nonatomic, strong) NSString *time12hr;
@property(nonatomic, strong) NSDate *eventSortDate;
@end
