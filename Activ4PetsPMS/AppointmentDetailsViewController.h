//
//  AppointmentDetailsViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 24/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appointmentDetailsModel.h"

@interface AppointmentDetailsViewController : UIViewController
@property(nonatomic,weak) IBOutlet UILabel *clinicName;
@property(nonatomic,weak) IBOutlet UILabel *vistType;
@property(nonatomic,weak) IBOutlet UILabel *dayTime;
@property(nonatomic,weak) IBOutlet UILabel *status;
@property(nonatomic,weak) IBOutlet UILabel *petName;
@property(nonatomic,weak) IBOutlet UILabel *petType;
@property(nonatomic,weak) IBOutlet UILabel *petParent;
@property(nonatomic,weak) IBOutlet UILabel *email;
@property(nonatomic,weak) IBOutlet UILabel *vetName;
@property(nonatomic,weak) IBOutlet UILabel *consultMode;
@property(nonatomic,weak) IBOutlet UITextView *query;
@property(nonatomic,strong) appointmentDetailsModel *appoint;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *topSpace;
@property(nonatomic,weak) IBOutlet UIView *onlineView;
@property(nonatomic,weak) IBOutlet UIView *cliniView;
@property(nonatomic,weak) IBOutlet UITextView *healthQuery;
@property(nonatomic,weak) IBOutlet UILabel *conclusion;
@property(nonatomic,weak) IBOutlet UILabel *concTitle;
@property(nonatomic,weak) IBOutlet UIView *downView;
@property(nonatomic,strong) NSString *statusStr;
@property(nonatomic,assign) BOOL isFromViewList;
@property(nonatomic,strong) NSDictionary *apptDetails;
@property(nonatomic,assign) BOOL isFromReminder;

@end
