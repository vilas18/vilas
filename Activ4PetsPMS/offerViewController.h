//
//  offerViewController.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/12/16.
//  Copyright © 2016 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface offerViewController : UIViewController
{
    IBOutlet UIButton *clickToVwBtn;
    IBOutlet UITextView *offerDtlView;
    NSString *addUrl;
}

-(IBAction)clickToViewBtnPressed:(id)sender;


@end
