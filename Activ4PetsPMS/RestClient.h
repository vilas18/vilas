//
//  RestClient.h
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 10/05/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestClient : NSObject
+ (void)getList:(NSString *)type callBackHandler:(void(^)(NSArray *response, NSError *error))handler;
+ (void)upadteDetails:(NSString *)type :(NSString *)url callBackHandler:(void(^)(NSDictionary *response, NSError *error))handler;
+ (void)upadteStaffDetails:(NSDictionary *)type :(NSString *)url callBackHandler:(void(^)(NSDictionary *response, NSError *error))handler;
@end
