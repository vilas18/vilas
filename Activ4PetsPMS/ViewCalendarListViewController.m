//
//  ViewCalendarListViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 31/05/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "ViewCalendarListViewController.h"
#import "CalendarViewListCell.h"
#import "responseParser.h"
#import "EditEventViewController.h"
#import "EventDetailsViewController.h"
#import "AppointmentDetailsViewController.h"

@interface ViewCalendarListViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) NSArray *apptList;
@property(nonatomic,strong) NSArray *eventList;
@property(nonatomic,strong) NSMutableArray *clinicList;
@property(nonatomic,strong) NSMutableArray *onlineList;
@property(nonatomic,strong) NSMutableArray *clinicPastList;
@property(nonatomic,strong) NSMutableArray *clinicUpcomingList;
@property(nonatomic,strong) NSMutableArray *clinicCancelledList;
@property(nonatomic,strong) NSMutableArray *onlinePastList;
@property(nonatomic,strong) NSMutableArray *onlineUpcomingList;
@property(nonatomic,strong) NSMutableArray *onlineCancelledList;
@property(nonatomic,strong) NSMutableArray *eventsUpList;
@property(nonatomic,strong) NSMutableArray *dateRangeEventUpList;
@property(nonatomic,strong) NSMutableArray *dateRangeEventList;
@property(nonatomic,assign) BOOL isFilter;
@property(nonatomic,strong) NSString *fromDate;
@property(nonatomic,strong) NSString *toDate;
@property(nonatomic,assign) BOOL isRange;
@end

@implementation ViewCalendarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [_clinic setSelected:YES];
    [_upComing setSelected:YES];
    [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
    [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_upComing setTintColor:[UIColor clearColor]];
    [_eventsUp setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
    [_eventsUp setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_eventsUp setTintColor:[UIColor clearColor]];
    [_eventsUp setSelected:YES];
    _clinicView.hidden=NO;
    [_online setSelected:NO];
    [_events setSelected:NO];
    _topSpace.constant=0;
    _searchView.hidden=YES;
    [_listTv reloadData];
    _clearButton.hidden=YES;
    NSArray *list=[NSArray arrayWithObjects:_upComing,_past,_eventsUp,nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        for ( UIButton *btn in list)
        {
            UIView *side=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width-1, 0, 1, btn.frame.size.height)];
            side.clipsToBounds=YES;
            side.backgroundColor=[UIColor lightGrayColor];
            [btn addSubview:side];
            btn.clipsToBounds=YES;
        }
    });
    [_dateRangeView setHidden:YES];
    [_fromTo setUserInteractionEnabled:NO];
    _dateRange.returnKeyType= UIReturnKeyDone;
    _isFilter=NO;
    _isRange=NO;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
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
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(IBAction)selectVisitType:(UIButton *)sender
{
    if (sender.tag==1)
    {
        _isFilter=NO;
        _dateRangeView.hidden=YES;
        [_clinic setSelected:YES];
        [_online setSelected:NO];
        [_events setSelected:NO];
        _onlineConsult.textColor=[UIColor darkGrayColor];
        _clinicVist.textColor=[UIColor whiteColor];
        _myEvents.textColor=[UIColor darkGrayColor];
        [_upComing setSelected:YES];
        [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
        [_past setBackgroundColor:[UIColor clearColor]];
        [_cancelled setBackgroundColor:[UIColor clearColor]];
        [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_past setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_cancelled setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_past setSelected:NO];
        [_cancelled setSelected:NO];
        [_upComing setTintColor:[UIColor clearColor]];
        _clinicView.hidden=NO;
        _onlineView.hidden=YES;
        _eventsView.hidden=YES;
        _topSpace.constant=0;
        _searchView.hidden=YES;
        _upComing.hidden=NO;
        _past.hidden=NO;
        _cancelled.hidden=NO;
        _eventsUp.hidden=YES;
        _eventsAll.hidden=YES;
        if ([_upComing isSelected]==YES)// Upcoming
        {
            [_upComing setSelected:YES];
            [_past setSelected:NO];
            [_cancelled setSelected:NO];
            [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_upComing setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            
            _clinicUpcomingList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _clinicList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.apptDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedAscending)
                    [list addObject:model];
                else if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                }
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            [list addObject:model];
                    }
                    
                }
                
            }
            _clinicUpcomingList=[self sortArray:list];
        }
        [_listTv reloadData];
        _leadingSpace.constant=0;
    }
    else if (sender.tag==2)
    {
        _isFilter=NO;
        _dateRangeView.hidden=YES;
        [_clinic setSelected:NO];
        [_online setSelected:YES];
        [_events setSelected:NO];
        _clinicVist.textColor=[UIColor darkGrayColor];
        _onlineConsult.textColor=[UIColor whiteColor];
        _myEvents.textColor=[UIColor darkGrayColor];
        [_upComing setSelected:YES];
        [_past setSelected:NO];
        [_cancelled setSelected:NO];
        [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
        [_upComing setTintColor:[UIColor clearColor]];
        [_past setBackgroundColor:[UIColor clearColor]];
        [_cancelled setBackgroundColor:[UIColor clearColor]];
        [_upComing setTintColor:[UIColor clearColor]];
        [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_past setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_cancelled setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        _clinicView.hidden=YES;
        _onlineView.hidden=NO;
        _eventsView.hidden=YES;
        _topSpace.constant=0;
        _searchView.hidden=YES;
        _upComing.hidden=NO;
        _past.hidden=NO;
        _cancelled.hidden=NO;
        _eventsUp.hidden=YES;
        _eventsAll.hidden=YES;
        if ([_upComing isSelected]==YES)// Upcoming
        {
            [_upComing setSelected:YES];
            [_past setSelected:NO];
            [_cancelled setSelected:NO];
            [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_upComing setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            _onlineUpcomingList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _onlineList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.apptDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedAscending)
                    [list addObject:model];
                else if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                }
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            [list addObject:model];
                    }
                }
            }
        }
        [_listTv reloadData];
        _leadingSpace.constant=0;
    }
    else if (sender.tag==3)
    {
        _isFilter=NO;
        _isRange=NO;
        [_clinic setSelected:NO];
        [_online setSelected:NO];
        [_events setSelected:YES];
        [_eventsAll setSelected:NO];
        [_eventsUp setSelected:YES];
        [_eventsAll setBackgroundColor:[UIColor clearColor]];
        [_eventsUp setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
        [_eventsAll setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateSelected];
        [_eventsUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eventsUp setTintColor:[UIColor clearColor]];
        _onlineConsult.textColor=[UIColor darkGrayColor];
        _myEvents.textColor=[UIColor whiteColor];
        _clinicVist.textColor=[UIColor darkGrayColor];
        _leadingSpace.constant=-80;
        _clinicView.hidden=YES;
        _onlineView.hidden=YES;
        _eventsView.hidden=NO;
        _upComing.hidden=YES;
        _past.hidden=YES;
        _cancelled.hidden=YES;
        _eventsUp.hidden=NO;
        _eventsAll.hidden=NO;
        _searchView.hidden=NO;
        _topSpace.constant=50;
        _dateRange.text=@"";
        _fromDate=nil;
        _toDate=nil;
        [_listTv reloadData];
    }
    [_listTv reloadData];
}
-(IBAction)selectAppointmentStatus:(UIButton *)sender
{
    _clinicUpcomingList=nil;
    _clinicCancelledList=nil;
    _clinicPastList=nil;
    _onlineUpcomingList=nil;
    _onlinePastList=nil;
    _onlineCancelledList=nil;
    
    if ([_clinic isSelected]==YES)
    {
        _isFilter=YES;
        
        if (sender.tag==1)// Upcoming
        {
            [_upComing setSelected:YES];
            [_past setSelected:NO];
            [_cancelled setSelected:NO];
            [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_upComing setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            
            _clinicUpcomingList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _clinicList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.apptDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedAscending)
                    [list addObject:model];
                else if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                }
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            [list addObject:model];
                    }
                }
            }
            _clinicUpcomingList=[self sortArray:list];
        }
        else if (sender.tag==2)// Completed
        {
            [_upComing setSelected:NO];
            [_past setSelected:YES];
            [_cancelled setSelected:NO];
            [_past setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_past setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_past setTintColor:[UIColor clearColor]];
            [_upComing setBackgroundColor:[UIColor whiteColor]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            [_upComing setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            _clinicPastList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _clinicList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                if ([model.rescheduleDate isEqualToString:@""] && !([model.statusId intValue]==4))
                {
                    
                    NSDate *eventDate=[formater dateFromString:model.apptDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedDescending && ! ([model.statusId intValue]==2))
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedDescending)
                        {
                            [list addObject:model];
                        }
                        
                    }
                }
            }
            for (appointmentDetailsModel *model in _clinicList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDate *reschDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@", reschDate);
                    NSComparisonResult result1=[presentDate compare:reschDate];
                    if (result1==NSOrderedAscending) {
                        
                    }
                    else if (result1==NSOrderedDescending || result1==NSOrderedSame)
                        [list addObject:model];
                }
            }
            _clinicPastList=[self sortArray:list];
        }
        else if (sender.tag==3)// Cancelled
        {
            [_upComing setSelected:NO];
            [_past setSelected:NO];
            [_cancelled setSelected:YES];
            [_cancelled setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_cancelled setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_upComing setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            _clinicCancelledList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _clinicList)
            {
                if ([model.status isEqualToString:@"Cancelled"] && [model.statusId isEqualToString:@"2"])
                {
                    [list addObject:model];
                    NSLog(@"%@",model.status);
                }
            }
            for (appointmentDetailsModel *model in _clinicList)
            {
                if ([model.status isEqualToString:@"Resceduled"] && [model.statusId isEqualToString:@"4"])
                {
                    if ([model.rescheduleDate isEqualToString:@""])
                    {
                        [list addObject:model];
                        NSLog(@"%@",model.status);
                    }
                }
            }
            _clinicCancelledList=[self sortArray:list];
        }
        [_listTv reloadData];
    }
    else if ([_online isSelected]==YES)
    {
        _isFilter=YES;
        if (sender.tag==1)// Upcoming
        {
            [_upComing setSelected:YES];
            [_past setSelected:NO];
            [_cancelled setSelected:NO];
            [_upComing setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_upComing setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            _onlineUpcomingList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _onlineList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.apptDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedAscending)
                    [list addObject:model];
                else if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                }
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            [list addObject:model];
                    }
                }
            }
            _onlineUpcomingList=[self sortArray:list];
        }
        else if (sender.tag==2)// Completed
        {
            [_upComing setSelected:NO];
            [_past setSelected:YES];
            [_cancelled setSelected:NO];
            [_past setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_past setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_past setTintColor:[UIColor clearColor]];
            [_upComing setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setBackgroundColor:[UIColor whiteColor]];
            [_cancelled setBackgroundColor:[UIColor whiteColor]];
            _onlinePastList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _onlineList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                if (!([model.rescheduleDate isEqualToString:@""] && [model.statusId intValue]==4))
                {
                    NSDate *eventDate=[formater dateFromString:model.apptDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedDescending && ! ([model.statusId intValue]==2))
                        [list addObject:model];
                    else if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedDescending)
                        {
                            [list addObject:model];
                        }
                        
                    }
                }
            }
            for (appointmentDetailsModel *model in _onlineList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDate *reschDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@", reschDate);
                    NSComparisonResult result1=[presentDate compare:reschDate];
                    if (result1==NSOrderedDescending || result1==NSOrderedSame)
                        [list addObject:model];
                }
            }
            _onlinePastList=[self sortArray:list];
        }
        else if (sender.tag==3)// Cancelled
        {
            [_upComing setSelected:NO];
            [_past setSelected:NO];
            [_cancelled setSelected:YES];
            [_cancelled setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_cancelled setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_cancelled setTintColor:[UIColor clearColor]];
            [_past setBackgroundColor:[UIColor whiteColor]];
            [_upComing setBackgroundColor:[UIColor whiteColor]];
            [_past setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_upComing setTintColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            _onlineCancelledList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _onlineList)
            {
                if ([model.status isEqualToString:@"Cancelled"] && [model.statusId isEqualToString:@"2"])
                {
                    [list addObject:model];
                    NSLog(@"%@",model.status);
                }
            }
            for (appointmentDetailsModel *model in _onlineList)
            {
                if ([model.status isEqualToString:@"Resceduled"] && [model.statusId isEqualToString:@"4"])
                {
                    if ([model.rescheduleDate isEqualToString:@""])
                    {
                        [list addObject:model];
                        NSLog(@"%@",model.status);
                    }
                }
            }
            _onlineCancelledList=[self sortArray:list];
        }
        [_listTv reloadData];
    }
    [_listTv reloadData];
}

-(IBAction)selectEventType:(UIButton *)sender
{
    _eventsUpList=nil;
    
    if ([_events isSelected]==YES)
    {
        if (sender.tag==1)
        {
            [_eventsAll setSelected:NO];
            [_eventsUp setSelected:YES];
            [_eventsUp setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_eventsUp setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_eventsUp setTintColor:[UIColor clearColor]];
            [_eventsAll setBackgroundColor:[UIColor whiteColor]];
            [_eventsAll setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_eventsAll setTintColor:[UIColor clearColor]];
            _isFilter=YES;
            _eventsUpList=[[NSMutableArray alloc]init];
            NSMutableArray *list=[[NSMutableArray alloc]init];
            for (appointmentDetailsModel *model in _eventList)
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.date];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedAscending)
                    [list addObject:model];
            }
            _eventsUpList=[self sortEventArray:list];
            if (_isRange==YES)
            {
                [self getDaterangeEvents];
            }
        }
        else if (sender.tag==2)
        {
            _isFilter=YES;
            [_eventsAll setSelected:YES];
            [_eventsUp setSelected:NO];
            [_eventsAll setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1]];
            [_eventsAll setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_eventsAll setTintColor:[UIColor clearColor]];
            [_eventsUp setBackgroundColor:[UIColor whiteColor]];
            [_eventsUp setTintColor:[UIColor clearColor]];
            [_eventsUp setTitleColor:[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
            if (_isRange==YES)
            {
                [self getDaterangeEvents];
            }
        }
        [_listTv reloadData];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_dateRange resignFirstResponder];
    return YES;
}
-(IBAction)selectRangeOfEvents:(UIButton *)sender
{
    _dateRange.text=@"";
    _isRange=NO;
    if (_dateRangeView.hidden==YES)
    {
        _dateRangeView.hidden=NO;
        [_nextDone setTitle:@"Next" forState:UIControlStateNormal];
        [_fromTo setTitle:@"From" forState:UIControlStateNormal];
    }
    else{
        _dateRangeView.hidden=YES;
    }
}
-(IBAction)selectDateRange:(UIButton *)sender
{
    _dateRangeEventList=nil;
    _dateRangeEventUpList=nil;
    _isRange=NO;
    if ([sender.currentTitle isEqualToString:@"Next"])
    {
        [_fromTo setTitle:@"From" forState:UIControlStateNormal];
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM/dd/yyyy"];
        _fromDate=[formater stringFromDate:_datePicker.date];
        [_fromTo setTitle:@"To" forState:UIControlStateNormal];
        [_nextDone setTitle:@"Done" forState:UIControlStateNormal];
        _datePicker.minimumDate=[formater dateFromString:_fromDate];
    }
    else if ([sender.currentTitle isEqualToString:@"Done"])
    {
        [_fromTo setTitle:@"To" forState:UIControlStateNormal];
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM/dd/yyyy"];
        _toDate=[formater stringFromDate:_datePicker.date];
        _dateRangeView.hidden=YES;
        _dateRange.text=[NSString stringWithFormat:@"%@ - %@", _fromDate,_toDate];
        [self getDaterangeEvents];
    }
}
-(void)getDaterangeEvents
{
    _isRange=YES;
    _dateRangeEventList=nil;
    _dateRangeEventUpList=nil;
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM/dd/yyyy"];
    NSDate *fromDate=[formater dateFromString:_fromDate];
    NSDateFormatter *formater1=[[NSDateFormatter alloc]init];
    [formater1 setDateFormat:@"MM/dd/yyyy"];
    NSDate *toDate=[formater1 dateFromString:_toDate];
    if ([_events isSelected]==YES)
    {
        if ([_eventsUp isSelected]==YES)
        {
            _dateRangeEventUpList=[[NSMutableArray alloc]init];
            if(_eventsUpList.count>0)
            {
                for (appointmentDetailsModel *model in _eventsUpList)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSDate *eventDate=[formater1 dateFromString:model.date];
                    BOOL range=[self date:eventDate isBetweenDate:fromDate andDate:toDate];
                    if (range==YES)
                    {
                        [_dateRangeEventUpList addObject:model];
                        NSLog(@"%@",model.date);
                    }
                }
                _clearButton.hidden=NO;
            }
        }
        else if ([_eventsAll isSelected]==YES)
        {
            _dateRangeEventList=[[NSMutableArray alloc]init];
            if(_eventList.count>0)
            {
                for (appointmentDetailsModel *model in _eventList)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSDate *eventDate=[formater1 dateFromString:model.date];
                    BOOL range=[self date:eventDate isBetweenDate:fromDate andDate:toDate];
                    if (range==YES)
                    {
                        [_dateRangeEventList addObject:model];
                        NSLog(@"%@",model.date);
                    }
                }
                _clearButton.hidden=NO;
            }
        }
        else{
            
        }
        [_listTv reloadData];
    }
}
-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}
-(IBAction)clearFilters:(id)sender
{
    _dateRange.text=@"";
    _fromDate=nil;
    _toDate=nil;
    _isRange=NO;
    [_listTv reloadData];
    _clearButton.hidden=YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=0;
    if (_isFilter==NO)
    {
        if ([_clinic isSelected]==YES && [_upComing isSelected]==YES)
            count=_clinicUpcomingList.count;
        else if ([_online isSelected]==YES && [_upComing isSelected]==YES)
            count=_onlineUpcomingList.count;
        else if (_isRange==NO)
        {
            if ([_events isSelected]==YES && [_eventsUp isSelected]==YES)
                count=_eventsUpList.count;
            else if ([_events isSelected]==YES && [_eventsAll isSelected]==YES)
                count=_eventList.count;
        }
        else if(_isRange==YES)
        {
            if([_eventsUp isSelected]==YES)
                count=_dateRangeEventUpList.count;
            else if ([_eventsAll isSelected]==YES)
                count=_dateRangeEventList.count;
        }
    }
    else if(_isFilter==YES)
    {
        if ([_clinic isSelected]==YES )
        {
            if([_upComing isSelected]==YES)
                count=_clinicUpcomingList.count;
            else if ([_past isSelected]==YES)
                count=_clinicPastList.count;
            else if ([_cancelled isSelected]==YES)
                count=_clinicCancelledList.count;
        }
        else if([_online isSelected]==YES)
        {
            if([_upComing isSelected]==YES)
                count=_onlineUpcomingList.count;
            else if ([_past isSelected]==YES)
                count=_onlinePastList.count;
            else if ([_cancelled isSelected]==YES)
                count=_onlineCancelledList.count;
        }
        else if ([_events isSelected]==YES)
        {
            if (_isRange==NO)
            {
                if([_eventsUp isSelected]==YES)
                    count=_eventsUpList.count;
                else if ([_eventsAll isSelected]==YES)
                    count=_eventList.count;
            }
            else if(_isRange==YES)
            {
                if([_eventsUp isSelected]==YES)
                    count=_dateRangeEventUpList.count;
                else if ([_eventsAll isSelected]==YES)
                    count=_dateRangeEventList.count;
            }
        }
    }
    return count;
}
-(UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewListCell *cell=(CalendarViewListCell *)[tableView dequeueReusableCellWithIdentifier:@"viewList" forIndexPath:indexPath];
    
    [cell reloadInputViews];
    
    cell.statusLabel.layer.cornerRadius=3;
    cell.statusLabel.clipsToBounds=YES;
    if (_isFilter==NO)
    {
        if ([_clinic isSelected]==YES && [_upComing isSelected]==YES)
        {
            
            appointmentDetailsModel *model=[_clinicUpcomingList objectAtIndex:indexPath.row];
            cell.detailsLabel1.text=@"Pet Name";
            cell.detailsLabel2.text=@"Vet Name";
            cell.detailsLabel3.text=@"Appointment Type";
            cell.outInfoLabel1.text=model.petName;
            cell.outInfoLabel2.text=model.vetName;
            cell.outInfoLabel3.text=model.apptType;
            
            cell.dateLabel.text=model.apptDate;
            
            if (![model.rescheduleDate isEqualToString:@""])
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        cell.dateLabel.text=model.rescheduleDate;
                }
                else if(result==NSOrderedAscending)
                    cell.dateLabel.text=model.rescheduleDate;
            }
            
            cell.timeLabel.text=model.timeFrom12hr;
            [cell.del setHidden:YES];
            [cell.edit setHidden:YES];
            cell.tailSpace.constant=-7;
            cell.width.constant=90;
            cell.leadingSpace.constant=-17;
            [cell.icon setImage:[UIImage imageNamed:@"clinicvisit_36"]];
            cell.tailingSpace.constant=100;
            [cell.statusLabel setHidden:NO];
            cell.statusLabel.text=NSLocalizedString(@"UPCOMING", nil);
            NSLog(@"%@",model.status);
            NSLog(@"%@",model.statusId);
            
            cell.statusLabel.backgroundColor=[self colorFromHexString:@"#84ba06"];;
            cell.statusLabel.textColor=[UIColor whiteColor];
        }
        else if ([_online isSelected]==YES && [_upComing isSelected]==YES)
        {
            appointmentDetailsModel *model=[_onlineUpcomingList objectAtIndex:indexPath.row];
            cell.detailsLabel1.text=@"Pet Name";
            cell.detailsLabel2.text=@"Vet Name";
            cell.detailsLabel3.text=@"Appointment Type";
            cell.outInfoLabel1.text=model.petName;
            cell.outInfoLabel2.text=model.vetName;
            cell.outInfoLabel3.text=model.apptType;
            
            cell.dateLabel.text=model.apptDate;
            if (![model.rescheduleDate isEqualToString:@""])
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                NSString *date=[formater stringFromDate:[NSDate date]];
                NSDate *presentDate=[formater dateFromString:date];
                NSLog(@"%@",presentDate);
                NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                NSLog(@"%@",eventDate);
                NSComparisonResult result=[presentDate compare:eventDate];
                if (result==NSOrderedSame)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedAscending)
                        cell.dateLabel.text=model.rescheduleDate;
                    else
                        cell.dateLabel.text=model.apptDate;
                }
                else if(result==NSOrderedAscending)
                    cell.dateLabel.text=model.rescheduleDate;
            }
            cell.timeLabel.text=model.timeFrom12hr;
            cell.tailSpace.constant=-7;
            cell.width.constant=90;
            cell.tailingSpace.constant=100;
            cell.leadingSpace.constant=-17;
            [cell.edit setHidden:YES];
            [cell.del setHidden:YES];
            [cell.icon setImage:[UIImage imageNamed:@"onlineconsult_36"]];
            NSLog(@"%@",model.status);
            NSLog(@"%@",model.statusId);
            [cell.statusLabel setHidden:NO];
            cell.statusLabel.text=NSLocalizedString(@"UPCOMING", nil);
            cell.statusLabel.backgroundColor=[self colorFromHexString:@"#84ba06"];;
            cell.statusLabel.textColor=[UIColor whiteColor];
        }
        else if (_isRange==NO)
        {
            if ([_events isSelected]==YES && [_eventsUp isSelected]==YES)
            {
                appointmentDetailsModel *model=[_eventsUpList objectAtIndex:indexPath.row];
                cell.detailsLabel1.text=@"Reason";
                cell.detailsLabel2.text=@"Veterinarian";
                cell.detailsLabel3.text=@"Comment";
                cell.tailingSpace.constant=8;
                cell.tailSpace.constant=-62;
                cell.width.constant=160;
                cell.leadingSpace.constant=-2;
                cell.outInfoLabel1.text=model.reason;
                cell.outInfoLabel2.text=model.physician;
                cell.outInfoLabel3.text=model.comment;
                cell.dateLabel.text=model.date;
                cell.timeLabel.text=model.time12hr;
                [cell.statusLabel setHidden:YES];
                [cell.icon setImage:[UIImage imageNamed:@"event_72.png"]];
                [cell.edit setHidden:NO];
                [cell.del setHidden:NO];
                [cell.edit setBackgroundImage:[UIImage imageNamed:@"edit_48.png"] forState:UIControlStateNormal];
                [cell.del setImage:[UIImage imageNamed:@"delete_48.png"] forState:UIControlStateNormal];
                [cell.edit addTarget:self action:@selector(editClk:) forControlEvents:UIControlEventTouchUpInside];
                [cell.del addTarget:self action:@selector(deleteClk:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([_events isSelected]==YES && [_eventsAll isSelected]==YES)
            {
                appointmentDetailsModel *model=[_eventList objectAtIndex:indexPath.row];
                cell.detailsLabel1.text=@"Reason";
                cell.detailsLabel2.text=@"Veterinarian";
                cell.detailsLabel3.text=@"Comment";
                cell.tailingSpace.constant=8;
                cell.tailSpace.constant=-62;
                cell.width.constant=160;
                cell.leadingSpace.constant=-2;
                cell.outInfoLabel1.text=model.reason;
                cell.outInfoLabel2.text=model.physician;
                cell.outInfoLabel3.text=model.comment;
                cell.dateLabel.text=model.date;
                cell.timeLabel.text=model.time12hr;
                [cell.statusLabel setHidden:YES];
                [cell.icon setImage:[UIImage imageNamed:@"event_72.png"]];
                [cell.edit setHidden:NO];
                [cell.del setHidden:NO];
                [cell.edit setBackgroundImage:[UIImage imageNamed:@"edit_48.png"] forState:UIControlStateNormal];
                [cell.del setImage:[UIImage imageNamed:@"delete_48.png"] forState:UIControlStateNormal];
                [cell.edit addTarget:self action:@selector(editClk:) forControlEvents:UIControlEventTouchUpInside];
                [cell.del addTarget:self action:@selector(deleteClk:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if (_isRange==YES)
        {
            if ([_events isSelected]==YES && [_eventsUp isSelected]==YES)
            {
                appointmentDetailsModel *model=[_dateRangeEventUpList objectAtIndex:indexPath.row];
                cell.detailsLabel1.text=@"Reason";
                cell.detailsLabel2.text=@"Veterinarian";
                cell.detailsLabel3.text=@"Comment";
                cell.tailingSpace.constant=8;
                cell.tailSpace.constant=-62;
                cell.width.constant=160;
                cell.leadingSpace.constant=-2;
                cell.outInfoLabel1.text=model.reason;
                cell.outInfoLabel2.text=model.physician;
                cell.outInfoLabel3.text=model.comment;
                cell.dateLabel.text=model.date;
                cell.timeLabel.text=model.time12hr;
                [cell.statusLabel setHidden:YES];
                [cell.icon setImage:[UIImage imageNamed:@"event_72.png"]];
                [cell.edit setHidden:NO];
                [cell.del setHidden:NO];
                [cell.edit setBackgroundImage:[UIImage imageNamed:@"edit_48.png"] forState:UIControlStateNormal];
                [cell.del setImage:[UIImage imageNamed:@"delete_48.png"] forState:UIControlStateNormal];
                [cell.edit addTarget:self action:@selector(editClk:) forControlEvents:UIControlEventTouchUpInside];
                [cell.del addTarget:self action:@selector(deleteClk:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([_events isSelected]==YES && [_eventsAll isSelected]==YES)
            {
                appointmentDetailsModel *model=[_dateRangeEventList objectAtIndex:indexPath.row];
                cell.detailsLabel1.text=@"Reason";
                cell.detailsLabel2.text=@"Veterinarian";
                cell.detailsLabel3.text=@"Comment";
                cell.tailingSpace.constant=8;
                cell.tailSpace.constant=-62;
                cell.width.constant=160;
                cell.leadingSpace.constant=-2;
                cell.outInfoLabel1.text=model.reason;
                cell.outInfoLabel2.text=model.physician;
                cell.outInfoLabel3.text=model.comment;
                cell.dateLabel.text=model.date;
                cell.timeLabel.text=model.time12hr;
                [cell.statusLabel setHidden:YES];
                [cell.icon setImage:[UIImage imageNamed:@"event_72.png"]];
                [cell.edit setHidden:NO];
                [cell.del setHidden:NO];
                [cell.edit setBackgroundImage:[UIImage imageNamed:@"edit_48.png"] forState:UIControlStateNormal];
                [cell.del setImage:[UIImage imageNamed:@"delete_48.png"] forState:UIControlStateNormal];
                [cell.edit addTarget:self action:@selector(editClk:) forControlEvents:UIControlEventTouchUpInside];
                [cell.del addTarget:self action:@selector(deleteClk:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    else if (_isFilter==YES)
    {
        if ([_clinic isSelected]==YES)
        {
            [cell.icon setImage:[UIImage imageNamed:@"clinicvisit_36.png"]];
            [cell.del setHidden:YES];
            [cell.edit setHidden:YES];
            if ([_upComing isSelected]==YES)
            {
                appointmentDetailsModel *model=[_clinicUpcomingList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                cell.dateLabel.text=model.apptDate;
                
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            cell.dateLabel.text=model.rescheduleDate;
                    }
                    else if(result==NSOrderedAscending)
                        cell.dateLabel.text=model.rescheduleDate;
                }
                cell.timeLabel.text=model.timeFrom12hr;
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17;
                cell.statusLabel.text=NSLocalizedString(@"UPCOMING", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                [cell.statusLabel setHidden:NO];
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#84ba06"];;
                cell.statusLabel.textColor=[UIColor whiteColor];
            }
            else if ([_past isSelected]==YES)
            {
                appointmentDetailsModel *model=[_clinicPastList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                if ([model.apptDate isEqualToString:@""])
                    cell.dateLabel.text=model.rescheduleDate;
                else
                    cell.dateLabel.text=model.apptDate;
                
                //NSString *timeStr = [NSString stringWithFormat:@"%@",model.timeFrom12hr];
                
                //NSLog(@"model.timeFrom12hr:%@",timeStr);
                
                //                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //                [dateFormatter setDateFormat:@"h:mm a"];
                //                NSDate *formattedDateString = [dateFormatter dateFromString:timeStr];
                //                
                //                NSLog(@"formattedDateString:%@",formattedDateString);
                
                cell.timeLabel.text=model.timeFrom12hr;//[NSString stringWithFormat:@"%@",formattedDateString];
                
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17;
                cell.statusLabel.text=NSLocalizedString(@"COMPLETED", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                [cell.statusLabel setHidden:NO];
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#0667b8"];
                cell.statusLabel.textColor=[UIColor whiteColor];
            }
            else if([_cancelled isSelected]==YES)
            {
                appointmentDetailsModel *model=[_clinicCancelledList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                cell.dateLabel.text=model.apptDate;
                cell.timeLabel.text=model.timeFrom12hr;
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17; [cell.statusLabel setHidden:NO];
                cell.statusLabel.text=NSLocalizedString(@"CANCELLED", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#d9534f"];
                cell.statusLabel.textColor=[UIColor whiteColor];
                
            }
        }
        else if ([_online isSelected]==YES)
        {
            [cell.del setHidden:YES];
            [cell.edit setHidden:YES];
            [cell.icon setImage:[UIImage imageNamed:@"onlineconsult_36.png"]];
            if ([_upComing isSelected]==YES)
            {
                appointmentDetailsModel *model=[_onlineUpcomingList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                cell.dateLabel.text=model.apptDate;
                if (![model.rescheduleDate isEqualToString:@""])
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"MM/dd/yyyy"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                    NSLog(@"%@",eventDate);
                    NSComparisonResult result=[presentDate compare:eventDate];
                    if (result==NSOrderedSame)
                    {
                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                        [formater setDateFormat:@"hh:mm aa"];
                        NSString *date=[formater stringFromDate:[NSDate date]];
                        NSDate *presentDate=[formater dateFromString:date];
                        NSLog(@"%@",presentDate);
                        NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                        NSLog(@"%@",eventDate);
                        NSComparisonResult result=[presentDate compare:eventDate];
                        if (result==NSOrderedAscending)
                            cell.dateLabel.text=model.rescheduleDate;
                        else
                            cell.dateLabel.text=model.apptDate;
                    }
                    else if(result==NSOrderedAscending)
                        cell.dateLabel.text=model.rescheduleDate;
                }
                cell.timeLabel.text=model.timeFrom12hr;
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17;
                [cell.statusLabel setHidden:NO];
                cell.statusLabel.text=NSLocalizedString(@"UPCOMING", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#84ba06"];;
                cell.statusLabel.textColor=[UIColor whiteColor];
            }
            else if ([_past isSelected]==YES)
            {
                appointmentDetailsModel *model=[_onlinePastList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                cell.dateLabel.text=model.apptDate;
                cell.timeLabel.text=model.timeFrom12hr;
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17;
                cell.statusLabel.text=NSLocalizedString(@"COMPLETED", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                [cell.statusLabel setHidden:NO];
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#0667b8"];
                cell.statusLabel.textColor=[UIColor whiteColor];
            }
            else if ([_cancelled isSelected]==YES)
            {
                appointmentDetailsModel *model=[_onlineCancelledList objectAtIndex:indexPath.row];
                cell.outInfoLabel1.text=model.petName;
                cell.outInfoLabel2.text=model.vetName;
                cell.outInfoLabel3.text=model.apptType;
                cell.dateLabel.text=model.apptDate;
                cell.timeLabel.text=model.timeFrom12hr;
                cell.statusLabel.backgroundColor=[UIColor greenColor];
                cell.statusLabel.textColor=[UIColor whiteColor];
                cell.detailsLabel1.text=@"Pet Name";
                cell.detailsLabel2.text=@"Vet Name";
                cell.detailsLabel3.text=@"Appointment Type";
                cell.tailSpace.constant=-7;
                cell.width.constant=90;
                cell.tailingSpace.constant=100;
                cell.leadingSpace.constant=-17;
                [cell.statusLabel setHidden:NO];
                cell.statusLabel.text=NSLocalizedString(@"CANCELLED", nil);
                NSLog(@"%@",model.status);
                NSLog(@"%@",model.statusId);
                cell.statusLabel.backgroundColor=[self colorFromHexString:@"#d9534f"];
                cell.statusLabel.textColor=[UIColor whiteColor];
            }
        }
        else if ([_events isSelected]==YES)
        {
            cell.tailingSpace.constant=8;
            [cell bringSubviewToFront:cell.topView];
            [cell.icon setImage:[UIImage imageNamed:@"event_72.png"]];
            [cell.edit setHidden:NO];
            [cell.del setHidden:NO];
            [cell.edit setBackgroundImage:[UIImage imageNamed:@"edit_48.png"] forState:UIControlStateNormal];
            [cell.del setImage:[UIImage imageNamed:@"delete_48.png"] forState:UIControlStateNormal];
            [cell.edit addTarget:self action:@selector(editClk:) forControlEvents:UIControlEventTouchUpInside];
            [cell.del addTarget:self action:@selector(deleteClk:) forControlEvents:UIControlEventTouchUpInside];
            if (_isRange==NO)
            {
                if([_eventsUp isSelected]==YES)
                {
                    appointmentDetailsModel *model=[_eventsUpList objectAtIndex:indexPath.row];
                    cell.detailsLabel1.text=@"Reason";
                    cell.detailsLabel2.text=@"Veterinarian";
                    cell.detailsLabel3.text=@"Comment";
                    cell.tailSpace.constant=-62;
                    cell.width.constant=160;
                    cell.leadingSpace.constant=-2;
                    cell.outInfoLabel1.text=model.reason;
                    cell.outInfoLabel2.text=model.physician;
                    cell.outInfoLabel3.text=model.comment;
                    cell.dateLabel.text=model.date;
                    cell.timeLabel.text=model.time12hr;
                    [cell.statusLabel setHidden:YES];
                    
                }
                else if ([_eventsAll isSelected]==YES)
                {
                    appointmentDetailsModel *model=[_eventList objectAtIndex:indexPath.row];
                    cell.detailsLabel1.text=@"Reason";
                    cell.detailsLabel2.text=@"Veterinarian";
                    cell.detailsLabel3.text=@"Comment";
                    cell.tailSpace.constant=-62;
                    cell.width.constant=160;
                    cell.leadingSpace.constant=-2;
                    cell.outInfoLabel1.text=model.reason;
                    cell.outInfoLabel2.text=model.physician;
                    cell.outInfoLabel3.text=model.comment;
                    cell.dateLabel.text=model.date;
                    cell.timeLabel.text=model.time12hr;
                    [cell.statusLabel setHidden:YES];
                }
            }
            else if (_isRange==YES)
            {
                if([_eventsUp isSelected]==YES)
                {
                    appointmentDetailsModel *model=[_dateRangeEventUpList objectAtIndex:indexPath.row];
                    cell.detailsLabel1.text=@"Reason";
                    cell.detailsLabel2.text=@"Veterinarian";
                    cell.detailsLabel3.text=@"Comment";
                    cell.tailSpace.constant=-62;
                    cell.width.constant=160;
                    cell.leadingSpace.constant=-2;
                    cell.outInfoLabel1.text=model.reason;
                    cell.outInfoLabel2.text=model.physician;
                    cell.outInfoLabel3.text=model.comment;
                    cell.dateLabel.text=model.date;
                    cell.timeLabel.text=model.time12hr;
                    [cell.statusLabel setHidden:YES];
                    
                }
                else if ([_eventsAll isSelected]==YES)
                {
                    appointmentDetailsModel *model=[_dateRangeEventList objectAtIndex:indexPath.row];
                    cell.detailsLabel1.text=@"Reason";
                    cell.detailsLabel2.text=@"Veterinarian";
                    cell.detailsLabel3.text=@"Comment";
                    cell.tailSpace.constant=-62;
                    cell.width.constant=160;
                    cell.leadingSpace.constant=-2;
                    cell.outInfoLabel1.text=model.reason;
                    cell.outInfoLabel2.text=model.physician;
                    cell.outInfoLabel3.text=model.comment;
                    cell.dateLabel.text=model.date;
                    cell.timeLabel.text=model.time12hr;
                    [cell.statusLabel setHidden:YES];
                }
            }
            
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appointmentDetailsModel *eventModelObject;
    if ([_events isSelected]==YES)
    {
        if (_isRange==NO)
        {
            if ([_eventsUp isSelected]==YES)
            {
                eventModelObject=[_eventsUpList objectAtIndex:indexPath.row];
                EventDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"eventdetails"];
                details.model=eventModelObject;
                [self.navigationController pushViewController:details animated:YES];
            }
            else if([_eventsAll isSelected]==YES)
            {
                eventModelObject =[_eventList objectAtIndex:indexPath.row];
                EventDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"eventdetails"];
                details.model=eventModelObject;
                [self.navigationController pushViewController:details animated:YES];
            }
            else
            {
                eventModelObject =[_eventList objectAtIndex:indexPath.row];
                EventDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"eventdetails"];
                details.model=eventModelObject;
                [self.navigationController pushViewController:details animated:YES];
            }
        }
        else if(_isRange==YES)
        {
            if ([_eventsUp isSelected]==YES)
            {
                eventModelObject=[_dateRangeEventUpList objectAtIndex:indexPath.row];
                EventDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"eventdetails"];
                details.model=eventModelObject;
                [self.navigationController pushViewController:details animated:YES];
            }
            else if([_eventsAll isSelected]==YES)
            {
                eventModelObject =[_dateRangeEventList objectAtIndex:indexPath.row];
                EventDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"eventdetails"];
                details.model=eventModelObject;
                [self.navigationController pushViewController:details animated:YES];
            }
            else{
            }
        }
    }
    else if([_clinic isSelected]==YES)
    {
        if ([_upComing isSelected]==YES){
            eventModelObject=[_clinicUpcomingList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Upcoming";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else if ([_past isSelected]==YES){
            eventModelObject=[_clinicPastList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Completed";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else if ([_cancelled isSelected]==YES){
            eventModelObject=[_clinicCancelledList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Cancelled";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else{
            eventModelObject=[_clinicList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            [self.navigationController pushViewController:details animated:YES];
        }
        
    }
    else if ([_online isSelected]==YES)
    {
        if ([_upComing isSelected]==YES){
            eventModelObject=[_onlineUpcomingList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Upcoming";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else if ([_past isSelected]==YES){
            eventModelObject=[_onlinePastList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Completed";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else if ([_cancelled isSelected]==YES){
            eventModelObject=[_onlineCancelledList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            details.statusStr=@"Cancelled";
            details.isFromViewList=YES;
            [self.navigationController pushViewController:details animated:YES];
        }
        else{
            eventModelObject=[_onlineList objectAtIndex:indexPath.row];
            AppointmentDetailsViewController *details=[self.storyboard instantiateViewControllerWithIdentifier:@"appointdetails"];
            details.appoint=eventModelObject;
            [self.navigationController pushViewController:details animated:YES];
        }
    }
}
-(void)editClk:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"appointment" bundle:nil];
    EditEventViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"EditEventViewController"];
    
    UIButton *btnObj = (UIButton *)sender;
    CGPoint center= btnObj.center;
    CGPoint rootViewPoint = [btnObj.superview convertPoint:center toView:self.listTv];
    NSIndexPath *indexPath = [self.listTv indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"indexPath on event list :%@",indexPath);
    appointmentDetailsModel *eventModelObject;
    if (_isRange==NO)
    {
        if ([_eventsUp isSelected]==YES)
        {
            eventModelObject=[_eventsUpList objectAtIndex:indexPath.row];
        }
        else{
            eventModelObject =[_eventList objectAtIndex:indexPath.row];
        }
    }
    else if (_isRange==YES)
    {
        if ([_eventsUp isSelected]==YES)
        {
            eventModelObject=[_dateRangeEventUpList objectAtIndex:indexPath.row];
        }
        else if([_eventsAll isSelected]==YES)
        {
            eventModelObject =[_dateRangeEventList objectAtIndex:indexPath.row];
        }
    }
    ivc.eventModelObj = eventModelObject;
    
    [self.navigationController pushViewController:ivc animated:YES];
}
-(void)deleteClk:(id)sender
{
    UIButton *btnObj = (UIButton *)sender;
    CGPoint center= btnObj.center;
    CGPoint rootViewPoint = [btnObj.superview convertPoint:center toView:self.listTv];
    NSIndexPath *indexPath = [self.listTv indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"indexPath on event list :%@",indexPath);
    appointmentDetailsModel *eventModelObject;
    if (_isRange==NO)
    {
        if ([_eventsUp isSelected]==YES)
        {
            eventModelObject=[_eventsUpList objectAtIndex:indexPath.row];
        }
        else{
            eventModelObject =[_eventList objectAtIndex:indexPath.row];
        }
    }
    else if (_isRange==YES)
    {
        if ([_eventsUp isSelected]==YES)
        {
            eventModelObject=[_dateRangeEventUpList objectAtIndex:indexPath.row];
        }
        else if([_eventsAll isSelected]==YES)
        {
            eventModelObject =[_dateRangeEventList objectAtIndex:indexPath.row];
        }
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure, You want to delete ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@"Deleting.."];
        [self callEventDelMethod:eventModelObject];
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)callEventDelMethod:(appointmentDetailsModel *)model
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable)
    {
        NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                                   @"cache-control": @"no-cache"
                                   };
        NSString *urlStr=[NSString stringWithFormat:@"%@?EventId=%@",DeleteEvent,model.eventId];
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
                                                        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Deleted Successfully" preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@"Loading"];
                                                            [self getList];
                                                        }];
                                                        
                                                        [alert addAction:ok];
                                                        [self presentViewController:alert animated:YES completion:nil];
                                                        
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
                                                    self.apptList=dict[@"appointmentlist"];
                                                    NSArray *eveList=dict[@"eventlist"];
                                                    NSLog(@"%@",eveList);
                                                    NSLog(@"%@",self.apptList);
                                                    if (self.apptList.count>0)
                                                    {
                                                        NSArray *modelList=[responseParser appointmentList:self.apptList];
                                                        self.clinicList=[[NSMutableArray alloc]init];
                                                        self.onlineList=[[NSMutableArray alloc]init];
                                                        for (appointmentDetailsModel *model in modelList)
                                                        {
                                                            if ([model.typeOfVisitId isEqualToString:@"1"] && [model.typeOfVisit isEqualToString:@"Clinic Visit"]) {
                                                                [self.clinicList addObject:model];
                                                            }
                                                            else if ([model.typeOfVisitId isEqualToString:@"2"] && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                                                            {
                                                                [self.onlineList addObject:model];
                                                            }
                                                        }
                                                        NSLog(@"%lu",(unsigned long)self.clinicList.count);
                                                        NSLog(@"%lu",(unsigned long)self.onlineList.count);
                                                        if ([self.upComing isSelected]==YES)
                                                        {
                                                            if ([self.clinic isSelected]==YES)
                                                            {
                                                                self.clinicUpcomingList=[[NSMutableArray alloc]init];
                                                                NSMutableArray *list=[[NSMutableArray alloc]init];
                                                                for (appointmentDetailsModel *model in self.clinicList)
                                                                {
                                                                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                                                                    [formater setDateFormat:@"MM/dd/yyyy"];
                                                                    NSString *date=[formater stringFromDate:[NSDate date]];
                                                                    NSDate *presentDate=[formater dateFromString:date];
                                                                    NSLog(@"%@",presentDate);
                                                                    if (![model.apptDate isEqualToString:@""]) {
                                                                        NSDate *eventDate=[formater dateFromString:model.apptDate];
                                                                        NSLog(@"%@",eventDate);
                                                                        NSComparisonResult result=[presentDate compare:eventDate];
                                                                        if (result==NSOrderedAscending)
                                                                            [list addObject:model];
                                                                        else if (result==NSOrderedSame)
                                                                        {
                                                                            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                                                                            [formater setDateFormat:@"hh:mm aa"];
                                                                            NSString *date=[formater stringFromDate:[NSDate date]];
                                                                            NSDate *presentDate=[formater dateFromString:date];
                                                                            NSLog(@"%@",presentDate);
                                                                            NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                                                                            NSLog(@"%@",eventDate);
                                                                            NSComparisonResult result=[presentDate compare:eventDate];
                                                                            if (result==NSOrderedAscending)
                                                                                [list addObject:model];
                                                                        }
                                                                    }
                                                                    if (![model.rescheduleDate isEqualToString:@""])
                                                                    {
                                                                        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                                                                        [formater setDateFormat:@"MM/dd/yyyy"];
                                                                        NSString *date=[formater stringFromDate:[NSDate date]];
                                                                        NSDate *presentDate=[formater dateFromString:date];
                                                                        NSLog(@"%@",presentDate);
                                                                        NSDate *eventDate=[formater dateFromString:model.rescheduleDate];
                                                                        NSLog(@"%@",eventDate);
                                                                        NSComparisonResult result=[presentDate compare:eventDate];
                                                                        if (result==NSOrderedAscending)
                                                                            [list addObject:model];
                                                                        else if (result==NSOrderedSame)
                                                                        {
                                                                            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                                                                            [formater setDateFormat:@"hh:mm aa"];
                                                                            NSString *date=[formater stringFromDate:[NSDate date]];
                                                                            NSDate *presentDate=[formater dateFromString:date];
                                                                            NSLog(@"%@",presentDate);
                                                                            NSDate *eventDate=[formater dateFromString:model.timeFrom12hr];
                                                                            NSLog(@"%@",eventDate);
                                                                            NSComparisonResult result=[presentDate compare:eventDate];
                                                                            if (result==NSOrderedAscending)
                                                                                [list addObject:model];
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                                self.clinicUpcomingList=[self sortArray:list];
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                                    if (eveList.count>0)
                                                    {
                                                        NSMutableArray *lists=[responseParser appointmentList:eveList];
                                                        self.eventList=[self sortEventArray:lists];
                                                        self.eventsUpList=nil;
                                                        if ([self.eventsUp isSelected]==YES)
                                                        {
                                                            self.eventsUpList=[[NSMutableArray alloc]init];
                                                            NSMutableArray *list=[[NSMutableArray alloc]init];
                                                            for (appointmentDetailsModel *model in self.eventList)
                                                            {
                                                                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                                                                [formater setDateFormat:@"MM/dd/yyyy"];
                                                                NSString *date=[formater stringFromDate:[NSDate date]];
                                                                NSDate *presentDate=[formater dateFromString:date];
                                                                NSLog(@"%@",presentDate);
                                                                NSDate *eventDate=[formater dateFromString:model.date];
                                                                NSLog(@"%@",eventDate);
                                                                NSComparisonResult result=[presentDate compare:eventDate];
                                                                if (result==NSOrderedAscending)
                                                                    [list addObject:model];
                                                            }
                                                            NSLog(@"%@",self.eventsUpList);
                                                            self.eventsUpList=[self sortEventArray:list];
                                                        }
                                                    }
                                                    [self.listTv reloadData];
                                                    
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

-(NSMutableArray *)sortArray:(NSMutableArray *)arr
{
    NSMutableArray *sortArray=[[NSMutableArray alloc]init];
    for (appointmentDetailsModel *model in arr)
    {
        NSString *date=model.apptDate;
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM/dd/yyyy"];
        model.apptSortdate=[formater dateFromString:date];
        [sortArray addObject:model];
    }
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"apptSortdate" ascending: NO];
    list =(NSMutableArray *) [sortArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    return list;
}
-(NSMutableArray *)sortEventArray:(NSMutableArray *)arr
{
    NSMutableArray *sortArray=[[NSMutableArray alloc]init];
    for (appointmentDetailsModel *model in arr)
    {
        NSString *date=model.date;
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM/dd/yyyy"];
        model.eventSortDate=[formater dateFromString:date];
        [sortArray addObject:model];
    }
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventSortDate" ascending: NO];
    list =(NSMutableArray *) [sortArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return list;
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
