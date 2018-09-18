//
//  appointmentDetailscell.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 20/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appointmentDetailscell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *timeLabel;
@property(nonatomic,weak) IBOutlet UIView *firstView;
@property(nonatomic,weak) IBOutlet UIView *secondView;
@property(nonatomic,weak) IBOutlet UILabel *firstLabel;
@property(nonatomic,weak) IBOutlet UIView *thirdView;
@property(nonatomic,weak) IBOutlet UILabel *secLabel;
@property(nonatomic,weak) IBOutlet UILabel *thirdLabel;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *tailingSpace;//168
@property(nonatomic,weak) IBOutlet UIView *fourthView;
@property(nonatomic,weak) IBOutlet UILabel *fourthLabel;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *tailingSpace1;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *leadingSpace;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *leadingSpace1;
@property(nonatomic,weak) IBOutlet UIButton *edit;
@property(nonatomic,weak) IBOutlet UIButton *del;
//@property(nonatomic,weak) IBOutlet NSLayoutConstraint *width1;
//@property(nonatomic,weak) IBOutlet NSLayoutConstraint *width2;
//@property(nonatomic,weak) IBOutlet NSLayoutConstraint *width3;
//@property(nonatomic,weak) IBOutlet NSLayoutConstraint *width4;

@end
