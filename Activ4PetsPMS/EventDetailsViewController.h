//
//  EventDetailsViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 06/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appointmentDetailsModel.h"
@interface EventDetailsViewController : UIViewController
@property(nonatomic,strong) appointmentDetailsModel *model;
@property(nonatomic,weak) IBOutlet UILabel *date;
@property(nonatomic,weak) IBOutlet UILabel *time;
@property(nonatomic,weak) IBOutlet UILabel *physician;
@property(nonatomic,weak) IBOutlet UILabel *reason;
@property(nonatomic,weak) IBOutlet UILabel *comment;


@end
