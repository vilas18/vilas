//
//  ViewCalendarListViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 31/05/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"
@interface ViewCalendarListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) IBOutlet UITableView *listTv;
@property(nonatomic,weak) IBOutlet UILabel *clinicVist;
@property(nonatomic,weak) IBOutlet UILabel *onlineConsult;
@property(nonatomic,weak) IBOutlet UILabel *myEvents;
@property(nonatomic,weak) IBOutlet UIButton *clinic;
@property(nonatomic,weak) IBOutlet UIButton *online;
@property(nonatomic,weak) IBOutlet UIButton *events;
@property(nonatomic,weak) IBOutlet UIButton *upComing;
@property(nonatomic,weak) IBOutlet UIButton *past;
@property(nonatomic,weak) IBOutlet UIButton *cancelled;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *leadingSpace;
@property(nonatomic,weak) IBOutlet UIButton *eventsUp;
@property(nonatomic,weak) IBOutlet UIButton *eventsAll;
@property(nonatomic,weak) IBOutlet UITextField *dateRange;
@property(nonatomic,weak) IBOutlet UIButton *search;
@property(nonatomic,weak) IBOutlet UIView *clinicView;
@property(nonatomic,weak) IBOutlet UIView *onlineView;
@property(nonatomic,weak) IBOutlet UIView *eventsView;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *topSpace;
@property(nonatomic,weak) IBOutlet UIView *searchView;
@property(nonatomic,weak) IBOutlet UIView *dateRangeView;
@property(nonatomic,weak) IBOutlet UIButton *fromTo;
@property(nonatomic,weak) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,weak) IBOutlet UIButton *nextDone;
@property(nonatomic,weak) IBOutlet UIButton *clearButton;
@end
