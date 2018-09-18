//
//  dateFormatterModelClass.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/04/16.
//  Copyright © 2016 Activ Doctors Online. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dateFormatterModelClass : UIViewController

-(NSString *)convertTheDateToCorrespondingDomain :(NSDate *)dateParameter;
-(NSDate *)convertTheStringToCorrespondingDomain :(NSString *)strDateParameter;

@end
