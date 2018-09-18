//
//  CkViewController.h
//  hanaDoc
//
//  Created by sudhakar reddy peddireddy on 04/08/16.
//  Copyright © 2016 noorisys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
@interface CkViewController : UIViewController<CKCalendarDelegate>

@property(nonatomic,weak) IBOutlet UIView *contentView;


@end
