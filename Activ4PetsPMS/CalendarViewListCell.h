//
//  CalendarViewListCell.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 02/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewListCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *icon;
@property(nonatomic,weak) IBOutlet UILabel *detailsLabel1;
@property(nonatomic,weak) IBOutlet UILabel *detailsLabel2;
@property(nonatomic,weak) IBOutlet UILabel *detailsLabel3;
@property(nonatomic,weak) IBOutlet UILabel *outInfoLabel1;
@property(nonatomic,weak) IBOutlet UILabel *outInfoLabel2;
@property(nonatomic,weak) IBOutlet UILabel *outInfoLabel3;
@property(nonatomic,weak) IBOutlet UILabel *dateLabel;
@property(nonatomic,weak) IBOutlet UILabel *timeLabel;
@property(nonatomic,weak) IBOutlet UIButton *edit;
@property(nonatomic,weak) IBOutlet UIButton *del;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *tailSpace;//-62
@property(nonatomic,weak) IBOutlet UILabel *statusLabel;
@property(nonatomic,weak) IBOutlet UIView *topView;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *leadingSpace;//-17
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *width;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *tailingSpace;//164.6
@end
