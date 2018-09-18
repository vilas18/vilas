//
//  CKViewController.m
//  hanaDoc
//
//  Created by sudhakar reddy peddireddy on 04/08/16.
//  Copyright © 2016 noorisys. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "CkViewController.h"
#import "CheckNetwork.h"
#import "responseParser.h"
#import "appointmentDetailscell.h"
#import "DayEventsViewController.h"
#import "ViewCalendarListViewController.h"



@class DateButton;

@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CKDateItem *dateItem;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@interface CkViewController ()

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic,strong) UIDatePicker *picker;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic,strong) NSArray *apptList;
@property(nonatomic,strong) NSMutableArray *dateButtons;
@property(nonatomic,strong) DateButton *DateButton;
@property(nonatomic,strong) UIAlertController *alert;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,weak) IBOutlet UIView *offerView;
@property(nonatomic,weak) IBOutlet UIView *popUpView;
@property(nonatomic,assign) int senderId;
@property(nonatomic,weak) IBOutlet UIButton *step2;
@property(nonatomic,weak) IBOutlet UIButton *step3;
@property(nonatomic,weak) IBOutlet UILabel *step1Lbl;

@end

@implementation CkViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat originX=self.contentView.frame.origin.x;
    CGFloat originY=self.contentView.frame.origin.y-64;
    CGFloat width=self.contentView.frame.size.width;
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday frame:CGRectMake(originX,originY,width,self.contentView.frame.size.height)];
    self.calendar = calendar;
    calendar.delegate = self;
    self.senderId = 0;
    self.offerView.hidden = YES;
    calendar.cellWidth=_contentView.frame.size.width/7;
    _dateButtons=calendar.dateButtons;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    _date=[_dateFormatter stringFromDate:[NSDate date]];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: @"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleDone target:self action:@selector(rightClk:)];
    rightItem.tintColor = [UIColor whiteColor];
    [rightItem setTitle:@"View List"];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"01/01/1900"];
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"05/01/2013"],
                           [self.dateFormatter dateFromString:@"06/01/2013"],
                           [self.dateFormatter dateFromString:@"07/01/2013"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    calendar.backgroundColor=[UIColor darkGrayColor];
    [self.contentView addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    NSString *centreIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CenterID"]];
    NSString *userType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"]];
    
    NSLog(@"centreID:%@",centreIdStr);
    if ([centreIdStr isEqualToString:@"57"] && [userType isEqualToString:@"6"] )
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           CGRect frame=self.calendar.frame;
                           UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-40, frame.size.height+frame.origin.y+50, 40, 40)];
                           btn.clipsToBounds=YES;
                           [btn addTarget:self action:@selector(createAppointment:) forControlEvents:UIControlEventTouchUpInside];
                           [btn setImage:[UIImage imageNamed:@"add_blue.png"] forState:UIControlStateNormal];
                           btn.backgroundColor=[UIColor clearColor];
                           btn.userInteractionEnabled=YES;
                           [self.contentView addSubview:btn];
                       });
    }
    self.popUpView.clipsToBounds = YES;
    self.popUpView.layer.borderWidth = 2.0;
    self.popUpView.layer.borderColor = [[UIColor colorWithRed:92.0/255.0 green:59.0/255.0 blue:146.0/255.0 alpha:1] CGColor];
    BOOL isShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"PopUpCalendar"];
    NSAttributedString *step2Str = [[NSAttributedString alloc]initWithString:@" Download your rebate form here!"];
    NSAttributedString *step3Str = [[NSAttributedString alloc]initWithString:@"After purchasing Bravecto® mail in your rebate form and invoice, or submit them online here."];
    NSMutableAttributedString *text2 =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: step2Str];
    
    
    NSMutableAttributedString *text3 =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: step3Str];
    
    [text2 addAttribute:NSForegroundColorAttributeName
                  value:[UIColor redColor]
                  range:NSMakeRange(27, 4)];
    [text3 addAttribute:NSForegroundColorAttributeName
                  value:[UIColor redColor]
                  range:NSMakeRange(87, 4)];
    //[label setAttributedText: text];
    NSAttributedString *step1str = [[NSAttributedString alloc]initWithString:@"Visit your veterinarian to get more information about Bravecto®"];
    self.step1Lbl.attributedText = step1str;
    self.step1Lbl.numberOfLines = 6;
    self.step1Lbl.font = [UIFont systemFontOfSize:9.0];
    self.step1Lbl.textColor = [UIColor darkGrayColor];
    self.step1Lbl.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.step2.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.step2.titleLabel.numberOfLines = 4;
    self.step2.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.step2.titleLabel.textColor = [UIColor darkGrayColor];
    self.step2.titleLabel.font = [UIFont systemFontOfSize:9.0];
    [self.step2 setAttributedTitle:text2 forState:UIControlStateNormal];
    
    self.step3.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.step3.titleLabel.numberOfLines = 10;
    self.step3.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.step3.titleLabel.textColor = [UIColor darkGrayColor];
    self.step3.titleLabel.font = [UIFont systemFontOfSize:9.0];
    
    [self.step3 setAttributedTitle:text3 forState:UIControlStateNormal];
    if (isShown)
    {
        
    }
    else{
        //[self getPopupCount];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)getPopupCount
{
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
        
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSString *urlStr=[NSString stringWithFormat:@"%@?UserId=%@&PromocodeId=%d&PopupId=%d",GetCount,userId,12,1];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [request setAllHTTPHeaderFields:headers];
        NSURLSession *session=[NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (data!=nil)
                                                {
                                                    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                    int count = str.intValue;
                                                    if (count > 0)
                                                    {
                                                        self.offerView.hidden = YES;
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                    else
                                                    {
                                                        
                                                        [self callOpenPopupAPI];
                                                        self.offerView.hidden = NO;
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            });
                                        }];
        [dataTask resume];
    }
}
-(void)callOpenPopupAPI
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache"
                               };
    NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    NSString *date= [formater stringFromDate:[NSDate date]];
    NSString *str = [NSString stringWithFormat:@"UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",userId,12,1,"Open","IOS",date];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr=[NSString stringWithFormat:@"%@?%@",OpenPopUp,str];
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
                                                    self.senderId = [NSString stringWithFormat:@"%@", dict[@"Message"][@"Id"]].intValue;
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            }
                                            else
                                            {
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                            }
                                        });
                                    }];
    [dataTask resume];
}
-(IBAction)closePopup:(id)sender
{
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSString *date= [formater stringFromDate:[NSDate date]];
        NSString *str=[NSString stringWithFormat:@"Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,1,"Close","IOS",date];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *urlStr=[NSString stringWithFormat:@"%@?%@",ClickPopUp,str];
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
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        self.offerView.hidden = YES;
                                                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PopUpCalendar"];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                    }
                                                    else
                                                    {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            });
                                        }];
        [dataTask resume];
    }
    
}
-(void)callClickPopupAPI
{
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSString *date= [formater stringFromDate:[NSDate date]];
        NSString *str=[NSString stringWithFormat:@"Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,1,"Download","IOS",date];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *urlStr=[NSString stringWithFormat:@"%@?%@",ClickPopUp,str];
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
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        // self.offerView.hidden = YES;
                                                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"]])
                                                        {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"]];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            });
                                        }];
        [dataTask resume];
    }
}
-(IBAction)popupClick:(UIButton *)sender
{
    [self callClickPopupAPI];
    
}
-(IBAction)openClick:(UIButton *)sender
{
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSString *str=[NSString stringWithFormat:@"UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&UserAction=%s",userId,12,1,"IOS-App","ClickRewards"];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *urlStr=[NSString stringWithFormat:@"%@?%@",SubmitOnline,str];
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
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        //self.offerView.hidden = YES;
                                                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://rewards.mypet.com/#/"]])
                                                        {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://rewards.mypet.com/#/"]];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            });
                                        }];
        [dataTask resume];
    }
}
-(IBAction)callWebLink:(id)sender
{
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
        NSString *str=[NSString stringWithFormat:@"UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&UserAction=%s",userId,12,1,"IOS-App","ClickHome"];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *urlStr=[NSString stringWithFormat:@"%@?%@",SubmitOnline,str];
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
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        //self.offerView.hidden = YES;
                                                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://us.bravecto.com"]])
                                                        {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://us.bravecto.com"]];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                            });
                                        }];
        [dataTask resume];
    }
}
-(void)rightClk:(id)sender
{
    [self performSegueWithIdentifier:@"viewList" sender:nil];
}
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //    let storyboard = UIStoryboard(name: "appointment", bundle: nil)
    //    let calendar: CkViewController = storyboard.instantiateViewController(withIdentifier: "calendar") as! CkViewController
    //    navigationController?.pushViewController(calendar, animated: true)
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startAuthenticatingUser:_date];
}
-(void)createAppointment:(id)sender
{
    //    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    UIAlertAction *createAppt=[UIAlertAction actionWithTitle:@"Create Appointment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [self performSegueWithIdentifier:@"CreateAppt" sender:nil];
    //    }];
    //    UIAlertAction *createEvent=[UIAlertAction actionWithTitle:@"Create Event" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self performSegueWithIdentifier:@"addevent" sender:nil];
    //    }];
    //    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }];
    //
    //    [alert addAction:createAppt];
    //    [alert addAction:createEvent];
    //    [alert addAction:cancel];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)startAuthenticatingUser:(NSString *)date
{
    //first check internet connectivity
    
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:NSLocalizedString(@"Loading", nil)];
        
        [self getList:date];
    }
    else
    {
        NSLog(@"No internet connection");
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

-(void)getList:(NSString *)date
{
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache"
                               };
    NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    NSString *urlStr=[NSString stringWithFormat:@"%@?UserId=%@&CurrentDate=%@",GetMonthlyAppointmentList,userId,date];
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
                                                    self.apptList=dict[@"ApptList"];
                                                    NSLog(@"%@",self.apptList);
                                                    if (self.apptList.count>0)
                                                    {
                                                        [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
                                                        NSDate *dateUsed=[self.dateFormatter dateFromString:date];
                                                        [self addEvent:dateUsed];
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                    else
                                                    {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                }
                                            }
                                        });
                                    }];
    [dataTask resume];
}

-(void)addEvent:(NSDate *)dateUsed
{
    for (int i=0; i<_apptList.count; i++)
    {
        NSDictionary *dict=[_apptList objectAtIndex:i];
        NSCalendar *current=[NSCalendar currentCalendar];
        NSDateComponents *comps=[current components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateUsed];
        [comps setDay:[dict[@"Days"] intValue]];
        NSDate *eventDate=[current dateFromComponents:comps];
        [self setEventForDate:eventDate isHoliday:NO withTitle:nil];
    }
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
//}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date
{
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date])
    {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)select
{
    NSLog(@"%@",select);
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    if ([date laterDate:self.minimumDate] == date)
    {
        self.calendar.backgroundColor = [UIColor lightGrayColor];
        return YES;
    }
    else
    {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}
- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date
{
    for (DateButton *dateButton in self.dateButtons)
    {
        for (UILabel *label in [dateButton subviews]) {
            if (label.backgroundColor==[UIColor greenColor]) {
                [label removeFromSuperview];
            }
        }
    }
    NSCalendar *current=[NSCalendar currentCalendar];
    NSDateComponents *comps=[current components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSDate *startDate=[current dateFromComponents:comps];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [self startAuthenticatingUser:[_dateFormatter stringFromDate:startDate]];
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame
{
    
}

-(void)setEventForDate:(NSDate *)rotadate isHoliday:(BOOL)holiday withTitle:(NSString *)title
{
    for (DateButton *dateButton in self.dateButtons)
    {
        if (dateButton.date )
        {
            if ([rotadate isEqualToDate:dateButton.date])
            {
                [dateButton addTarget:self action:@selector(showDayEventDetails:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
                
                eventTitle.userInteractionEnabled=NO;
                eventTitle.clipsToBounds=YES;
                eventTitle.layer.cornerRadius=5.0f;
                eventTitle.backgroundColor=[UIColor greenColor];
                [dateButton addSubview:eventTitle];
            }
        }
    }
}

-(void)showDayEventDetails:(DateButton *)details
{
    NSLog(@"%@",details.date);
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *date=[_dateFormatter stringFromDate:details.date];
    NSLog(@"%@ %@",details.date,date);
    [self performSegueWithIdentifier:@"events" sender:details.date];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"events"])
    {
        DayEventsViewController *events=segue.destinationViewController;
        events.str=sender;
    }
    else
    {
    }
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
