//
//  DayEventsViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 21/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayEventsViewController : UIViewController
@property(nonatomic,strong) NSString *selectedDate;
@property(nonatomic,weak) IBOutlet UITableView *detailsTable;
@property(nonatomic,strong) NSDate *str;
@end

