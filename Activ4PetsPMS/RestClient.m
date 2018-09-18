//
//  RestClient.m
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 10/05/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "RestClient.h"
#define GetTypes @"http://qapetspms.activdoctorsconsult.com:8082/api/GetTypes/Get"

@implementation RestClient
+ (void)getList:(NSString *)type callBackHandler:(void(^)(NSArray *response, NSError *error))handler
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache"
                               };
    NSString *urlStr=[NSString stringWithFormat:@"%@?Type=%@",GetTypes,type];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                    {
                                        if (data!=nil)
                                        {
                                            NSError *err;
                                            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                            if ([dict[@"Status"] intValue]==1)
                                            {
                                                NSArray *list=dict[@"CommonList"];
                                                handler(list,err);
                                            }
                                        }
                                    }];
    [dataTask resume];
}
+ (void)upadteDetails:(NSString *)type :(NSString *)url callBackHandler:(void(^)(NSDictionary *response, NSError *error))handler
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache",
                               };
    NSString *urlStr=[NSString stringWithFormat:@"%@?%@",url,type];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                    {
                                        if (data!=nil)
                                        {
                                            NSError *err;
                                            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                            handler(dict,err);
                                        }
                                    }];
    [dataTask resume];
    
}
+ (void)upadteStaffDetails:(NSDictionary *)type :(NSString *)url callBackHandler:(void(^)(NSDictionary *response, NSError *error))handler
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache",
                               @"Content-Type": @"application/json"
                               };
    NSData *postData=[NSJSONSerialization dataWithJSONObject:type options:0 error:nil];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                    {
                                        if (data!=nil)
                                        {
                                            NSError *err;
                                            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                            handler(dict,err);
                                        }
                                    }];
    [dataTask resume];
    
}
@end
