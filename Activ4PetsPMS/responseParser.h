//
//  responseParser.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 20/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appointmentDetailsModel.h"
@interface responseParser : NSObject
+(NSMutableArray *)appointmentList:(NSArray *)list;

@end
