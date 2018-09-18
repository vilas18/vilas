//
//  EditEventViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 06/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appointmentDetailsModel.h"

@interface EditEventViewController : UIViewController

@property(nonatomic,weak) IBOutlet UITextField *selectDate;
@property(nonatomic,weak) IBOutlet UITextField *selectTime;
@property(nonatomic,weak) IBOutlet UITextField *reason;
@property(nonatomic,weak) IBOutlet UITextField *veterinarian;
@property(nonatomic,weak) IBOutlet UITextField *comment;

@property(nonatomic,weak) IBOutlet UIView *contentView;

@property(nonatomic,weak) IBOutlet UILabel *starLabel1;
@property(nonatomic,weak) IBOutlet UILabel *starLabel2;
@property(nonatomic,weak) IBOutlet UILabel *starLabel3;

@property(nonatomic,weak) IBOutlet UIDatePicker *pickerDate;
@property(nonatomic,weak) IBOutlet UIDatePicker *pickerTime;

@property(nonatomic,weak) IBOutlet UIView *dateView;
@property(nonatomic,weak) IBOutlet UIView *timeView;

@property(nonatomic,strong)appointmentDetailsModel *eventModelObj;

@end

