//
//  UpcomingAppointmentNotificationsViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 22/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "UpcomingAppointmentNotificationsViewController.h"
#import "responseParser.h"
#import "dateFormatterModelClass.h"

//#define CalViewList @"http://qapetspms.activdoctorsconsult.com:8082/api/CalenderViewList/Get"




@interface UpcomingAppointmentNotificationsViewController ()
@property(nonatomic,strong) NSArray *aptList;

@end

@implementation UpcomingAppointmentNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: @"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view.
}
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startAuthenticatingUser];
}
-(void)startAuthenticatingUser
{
    //first check internet connectivity
    
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:NSLocalizedString(@"Loading", nil)];
        
        [self getList];
    }
    else
    {
        NSLog(@"No internet connection");
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
-(void)getList
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache"
                               };
    NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    NSString *urlStr=[NSString stringWithFormat:@"%@?UserId=%@",CalViewList,userId];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setAllHTTPHeaderFields:headers];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (data!=nil)
                                            {
                                                NSError *err;
                                                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                                
                                                if ([dict[@"Status"] intValue]==1)
                                                {
                                                    NSArray *eveList=dict[@"appointmentlist"];
                                                    
                                                    NSLog(@"%@",eveList);
                                                    if (eveList.count>0)
                                                    {
                                                        NSArray *modelList=[responseParser appointmentList:eveList];
                                                        NSString *upcomingId=[[NSUserDefaults standardUserDefaults] objectForKey:@"upcomingId"];
                                                        for (appointmentDetailsModel *model in modelList)
                                                        {
                                                            if ([model.apptId isEqualToString:upcomingId]) {
                                                                self.upcomingModel=model;
                                                                [self displayDetails];
                                                            }
                                                        }
                                                    }
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            }
                                        });
                                    }];
    [dataTask resume];
}
-(void)displayDetails
{
    
    dateFormatterModelClass *dateFormatterClsObj = [[dateFormatterModelClass alloc] init];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",_upcomingModel.typeOfVisit]];
    if ([_upcomingModel.clinicLocation isEqualToString:@""]){
        _clinicName.text=[NSString stringWithFormat:@"%@ Booked",_upcomingModel.typeOfVisit];}
    else{
        _clinicName.text=_upcomingModel.clinicLocation;
    }
    
    if ([_upcomingModel.apptType isEqualToString:@""])
    {
        _vistType.text=[NSString stringWithFormat:@"%@ Booked",_upcomingModel.typeOfVisit];
    }
    else{
        _vistType.text=[NSString stringWithFormat:@"%@ Booked for %@",_upcomingModel.typeOfVisit,_upcomingModel.apptType];
    }
    
    NSLog(@"%@",_upcomingModel.apptDate);
    
    NSString *str=_upcomingModel.apptDate;
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate  *date1=[df dateFromString:str];
    NSString  *str1=[dateFormatterClsObj convertTheDateToCorrespondingDomain:date1];
    NSDate *date=[dateFormatterClsObj convertTheStringToCorrespondingDomain:str1];
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comp=[calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDate:date];
    NSInteger year=[comp year];
    NSInteger day=[comp day];
    NSInteger weekday=[comp weekday];
    NSInteger month=[comp month];
    NSString *monthName=[[calendar shortMonthSymbols] objectAtIndex:month-1];
    NSString *dayName=[[calendar weekdaySymbols] objectAtIndex:weekday-1];
    _dayTime.text=[NSString stringWithFormat:@"%@ %ld %@. %ld at %@ for %@ mins",dayName,(long)day,monthName,(long)year,_upcomingModel.timeFrom12hr,_upcomingModel.mins];
    if (![_upcomingModel.rescheduleDate isEqualToString:@""])
    {
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM/dd/yyyy"];
        NSDate *reschDate=[formater dateFromString:_upcomingModel.rescheduleDate];
        NSLog(@"%@",reschDate);
        NSString *date2=[formater stringFromDate:[NSDate date]];
        NSDate *presentDate=[formater dateFromString:date2];
        NSComparisonResult result1=[presentDate compare:reschDate];
        if (result1==NSOrderedSame || result1==NSOrderedAscending)
        {
            NSString *str=_upcomingModel.rescheduleDate;
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM/dd/yyyy"];
            NSDate  *date1=[df dateFromString:str];
            NSString  *str1=[dateFormatterClsObj convertTheDateToCorrespondingDomain:date1];
            NSDate *date=[dateFormatterClsObj convertTheStringToCorrespondingDomain:str1];
            
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSDateComponents *comp=[calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDate:date];
            NSInteger year=[comp year];
            NSInteger day=[comp day];
            NSInteger weekday=[comp weekday];
            NSInteger month=[comp month];
            NSString *monthName=[[calendar shortMonthSymbols] objectAtIndex:month-1];
            NSString *dayName=[[calendar weekdaySymbols] objectAtIndex:weekday-1];
            _dayTime.text=[NSString stringWithFormat:@"%@ %ld %@. %ld at %@ for %@ mins",dayName,(long)day,monthName,(long)year,_upcomingModel.timeFrom12hr,_upcomingModel.mins];
        }
    }
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM/dd/yyyy"];
    NSString *date2=[formater stringFromDate:[NSDate date]];
    NSDate *presentDate=[formater dateFromString:date2];
    NSLog(@"%@",presentDate);
    if ([_upcomingModel.statusId intValue]==2 && [_upcomingModel.status isEqualToString:@"Cancelled"])
    {
        _status.backgroundColor=[self colorFromHexString:@"#d9534f"];
        _status.text=_upcomingModel.status;
    }
    else if ([_upcomingModel.rescheduleDate isEqualToString:@""])
    {
        NSDate *eventDate=[formater dateFromString:_upcomingModel.apptDate];
        NSLog(@"%@",eventDate);
        NSComparisonResult result=[presentDate compare:eventDate];
        if ( result==NSOrderedAscending)
        {
            _status.text=NSLocalizedString(@"Upcoming", nil);
            _status.backgroundColor=[self colorFromHexString:@"#84ba06"];
        }
        else if ( result==NSOrderedSame)
        {
            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"hh:mm aa"];
            NSString *date=[formater stringFromDate:[NSDate date]];
            NSDate *presentDate=[formater dateFromString:date];
            NSLog(@"%@",presentDate);
            NSDate *eventDate=[formater dateFromString:_upcomingModel.timeFrom12hr];
            NSLog(@"%@",eventDate);
            NSComparisonResult result=[presentDate compare:eventDate];
            if (result==NSOrderedAscending)
            {
                _status.text=NSLocalizedString(@"Upcoming", nil);
                _status.backgroundColor=[self colorFromHexString:@"#84ba06"];
            }
            else
            {
                _status.text=NSLocalizedString(@"Completed", nil);
                _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
            }
        }
        else if (result==NSOrderedDescending)
        {
            _status.text=NSLocalizedString(@"Completed", nil);
            _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
            
        }
    }
    else
    {
        NSDate *reschDate=[formater dateFromString:_upcomingModel.rescheduleDate];
        NSLog(@"%@",reschDate);
        NSComparisonResult result1=[presentDate compare:reschDate];
        if (result1==NSOrderedSame || result1==NSOrderedAscending)
        {
            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"hh:mm aa"];
            NSString *date=[formater stringFromDate:[NSDate date]];
            NSDate *presentDate=[formater dateFromString:date];
            NSLog(@"%@",presentDate);
            NSDate *eventDate=[formater dateFromString:_upcomingModel.timeFrom12hr];
            NSLog(@"%@",eventDate);
            NSComparisonResult result=[presentDate compare:eventDate];
            if (result==NSOrderedAscending)
            {
                _status.text=NSLocalizedString(@"Upcoming", nil);
                _status.backgroundColor=[self colorFromHexString:@"#84ba06"];
            }
            else
            {
                _status.text=NSLocalizedString(@"Completed", nil);
                _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
            }
        }
        else if (result1==NSOrderedDescending)
        {
            _status.text=NSLocalizedString(@"Completed", nil);
            _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
            
        }
    }
    
    
    _status.layer.cornerRadius=3;
    _status.clipsToBounds=YES;
    
    //_status.text=NSLocalizedString(@"Upcoming", nil);
    //_status.backgroundColor=[self colorFromHexString:@"#84ba06"];
    
    if ([_upcomingModel.typeOfVisit isEqualToString:@"Clinic Visit"])
    {
        _onlineView.hidden=YES;
        _cliniView.hidden=YES;
    }
    else if([_upcomingModel.typeOfVisit isEqualToString:@"Online Consultation"])
    {
        _onlineView.hidden=NO;
        _healthQuery.text=_upcomingModel.apptReason;
        _conclusion.hidden=YES;
        _concTitle.hidden=YES;
        _downView.hidden=YES;
        _cliniView.hidden=YES;
    }
    _petName.text=_upcomingModel.petName;
    _petType.text=_upcomingModel.species;
    _petParent.text=_upcomingModel.ownerName;
    _email.text=_upcomingModel.ownerEmail;
    _vetName.text=_upcomingModel.vetName;
    if ([_upcomingModel.consultModeId isEqualToString:@""])
        _consultMode.text=@"";
    else if ([_upcomingModel.consultModeId intValue]==1)
        _consultMode.text=@"Video";
    else if ([_upcomingModel.consultModeId intValue]==2)
        _consultMode.text=@"Text Chat";
    
    
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
