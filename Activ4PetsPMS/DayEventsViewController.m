//
//  DayEventsViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 21/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "DayEventsViewController.h"
#import "CheckNetwork.h"
#import "responseParser.h"
#import "appointmentDetailscell.h"
#import "dateFormatterModelClass.h"
#import "appointmentDetailsModel.h"
#import "AppointmentDetailsViewController.h"
#import "EventDetailsViewController.h"


@interface DayEventsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSArray *eventList;
@property(nonatomic,strong) NSArray *eventListModels;
@property(nonatomic,strong) NSArray *timeList;
// 168

@end

@implementation DayEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatterModelClass *dateFormatterClsObj = [[dateFormatterModelClass alloc] init];
    _timeList=[NSArray arrayWithObjects:@"12 AM",@"1 AM",@"2 AM",@"3 AM",@"4 AM",@"5 AM",@"6 AM",@"7 AM",@"8 AM",@"9 AM",@"10 AM",@"11 AM",@"12 PM",@"1 PM",@"2 PM",@"3 PM",@"4 PM",@"5 PM",@"6 PM",@"7 PM",@"8 PM",@"9 PM",@"10 PM",@"11 PM", nil];
    NSString  *str1=[dateFormatterClsObj convertTheDateToCorrespondingDomain:_str];
    NSDate *date=[dateFormatterClsObj convertTheStringToCorrespondingDomain:str1];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    _selectedDate=[df stringFromDate:_str];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comp=[calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDate:date];
    NSInteger year=[comp year];
    NSInteger day=[comp day];
    NSInteger weekday=[comp weekday];
    NSInteger month=[comp month];
    NSString *monthName=[[calendar shortMonthSymbols] objectAtIndex:month-1];
    NSString *dayName=[[calendar shortWeekdaySymbols] objectAtIndex:weekday-1];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@, %@ %ld %ld",dayName,monthName,(long)day,(long)year]];
    

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
        
        [self getDayEventsList:_selectedDate];
        [_detailsTable reloadData];
    }
    else
    {
        NSLog(@"No internet connection");
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
#pragma mark -
#pragma mark - TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timeList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    appointmentDetailscell *cell = [tableView dequeueReusableCellWithIdentifier:@"appoint" forIndexPath:indexPath];
    cell.timeLabel.text=[_timeList objectAtIndex:indexPath.row];
    cell.firstView.hidden=YES;
    cell.secondView.hidden=YES;
    cell.thirdView.hidden=YES;
    cell.fourthView.hidden=YES;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
    UITapGestureRecognizer *eventGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectEventDetails:)];
    
    for (appointmentDetailsModel *model in _eventListModels)
    {
        if (indexPath.row==0)
        {
            if ([model.timeFrom isEqualToString:@"00:00"] || [model.time isEqualToString:@"00:00"])
            {
                if ([model.timeFrom isEqualToString:@"00:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"00:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"00:00"] && [model.time isEqualToString:@"00:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];

                }
            }
            else if ([model.timeFrom isEqualToString:@"00:30"]|| [model.time isEqualToString:@"00:30"])
            {
                if ([model.timeFrom isEqualToString:@"00:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"00:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"00:30"] && [model.time isEqualToString:@"00:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }

            }
        }
        else if (indexPath.row==1)
        {
            if ([model.timeFrom isEqualToString:@"01:00"]|| [model.time isEqualToString:@"01:00"])
            {
                if ([model.timeFrom isEqualToString:@"01:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"01:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"01:00"] && [model.time isEqualToString:@"01:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
            }
            else if ([model.timeFrom isEqualToString:@"01:30"]|| [model.time isEqualToString:@"01:30"])
            {
                if ([model.timeFrom isEqualToString:@"01:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"01:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"01:30"] && [model.time12hr isEqualToString:@"01:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                

            }
        }
        else if (indexPath.row==2)
        {
            if ([model.timeFrom isEqualToString:@"02:00"]|| [model.time isEqualToString:@"02:00"])
            {
                if ([model.timeFrom isEqualToString:@"02:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"02:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"02:00"] && [model.time isEqualToString:@"02:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"02:30"]|| [model.time isEqualToString:@"02:30"])
            {
                if ([model.timeFrom isEqualToString:@"02:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"02:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"02:30"] && [model.time isEqualToString:@"02:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==3)
        {
            if ([model.timeFrom isEqualToString:@"03:00"]|| [model.time isEqualToString:@"03:00"])
            {
                if ([model.timeFrom isEqualToString:@"03:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"03:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"03:00"] && [model.time isEqualToString:@"03:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"03:30"]|| [model.time isEqualToString:@"03:30"])
            {
                if ([model.timeFrom isEqualToString:@"03:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"03:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"03:30"] && [model.time isEqualToString:@"03:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==4)
        {
            if ([model.timeFrom isEqualToString:@"04:00"]|| [model.time isEqualToString:@"04:00"])
            {
                if ([model.timeFrom isEqualToString:@"04:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"04:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"04:00"] && [model.time isEqualToString:@"04:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
            }
            else if ([model.timeFrom isEqualToString:@"04:30"]|| [model.time isEqualToString:@"04:30"])
            {
                if ([model.timeFrom isEqualToString:@"04:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"04:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"04:30"] && [model.time isEqualToString:@"04:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                

            }
        }
        else if (indexPath.row==5)
        {
            if ([model.timeFrom isEqualToString:@"05:00"]|| [model.time isEqualToString:@"05:00"])
            {
                if ([model.timeFrom isEqualToString:@"05:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"05:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                   cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"05:00"] && [model.time isEqualToString:@"05:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"05:30"]|| [model.time isEqualToString:@"05:30"])
            {
                if ([model.timeFrom isEqualToString:@"05:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"05:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"05:30"] && [model.time isEqualToString:@"05:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
            }
        }
        else if (indexPath.row==6)
        {
            if ([model.timeFrom isEqualToString:@"06:00"]|| [model.time isEqualToString:@"06:00"])
            {
                if ([model.timeFrom isEqualToString:@"06:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"06:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"06:00"] && [model.time isEqualToString:@"06:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"06:30"]|| [model.time isEqualToString:@"06:30"])
            {
                if ([model.timeFrom isEqualToString:@"06:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"06:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"06:30"] && [model.time isEqualToString:@"06:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                
            }
        }
        else if (indexPath.row==7)
        {
            if ([model.timeFrom isEqualToString:@"07:00"]|| [model.time isEqualToString:@"07:00"])
            {
                if ([model.timeFrom isEqualToString:@"07:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"07:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"07:00"] && [model.time isEqualToString:@"07:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }

            }
            else if ([model.timeFrom isEqualToString:@"07:30"]|| [model.time isEqualToString:@"07:30"])
            {
                if ([model.timeFrom isEqualToString:@"07:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"07:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"07:30"] && [model.time isEqualToString:@"07:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                
            }
        }
        else if (indexPath.row==8)
        {
            if ([model.timeFrom isEqualToString:@"08:00"]|| [model.time isEqualToString:@"08:00"])
            {
                if ([model.timeFrom isEqualToString:@"08:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"08:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"08:00"] && [model.time isEqualToString:@"08:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
            }
            else if ([model.timeFrom isEqualToString:@"08:30"]|| [model.time isEqualToString:@"08:30"])
            {
                if ([model.timeFrom isEqualToString:@"08:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"08:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)", model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"08:30"] && [model.time isEqualToString:@"08:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                
            }
        }
        else if (indexPath.row==9)
        {
            if ([model.timeFrom isEqualToString:@"09:00"]|| [model.time isEqualToString:@"09:00"])
            {
                if ([model.timeFrom isEqualToString:@"09:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                 if ([model.time isEqualToString:@"09:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                if ([model.timeFrom isEqualToString:@"09:00"] && [model.time isEqualToString:@"09:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"09:30"]|| [model.time isEqualToString:@"09:30"])
            {
                if ([model.timeFrom isEqualToString:@"09:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                if ([model.time isEqualToString:@"09:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                if ([model.timeFrom isEqualToString:@"09:30"] && [model.time isEqualToString:@"09:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==10)
        {
            if ([model.timeFrom isEqualToString:@"10:00"]|| [model.time isEqualToString:@"10:00"])
            {
                if ([model.timeFrom isEqualToString:@"10:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"10:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"10:00"] && [model.time isEqualToString:@"10:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"10:30"]|| [model.time isEqualToString:@"10:30"])
            {
                if ([model.timeFrom isEqualToString:@"10:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"10:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"10:30"] && [model.time isEqualToString:@"10:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==11)
        {
            if ([model.timeFrom isEqualToString:@"11:00"]|| [model.time isEqualToString:@"11:00"])
            {
                if ([model.timeFrom isEqualToString:@"11:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"11:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"11:00"] && [model.time isEqualToString:@"11:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"11:30"]|| [model.time isEqualToString:@"11:30"])
            {
                if ([model.timeFrom isEqualToString:@"11:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"11:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"11:30"] && [model.time isEqualToString:@"11:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==12)
        {
            if ([model.timeFrom isEqualToString:@"12:00"]|| [model.time isEqualToString:@"12:00"])
            {
                if ([model.timeFrom isEqualToString:@"12:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"12:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                   cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"12:00"] && [model.time isEqualToString:@"12:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"12:30"]|| [model.time isEqualToString:@"12:30"])
            {
                if ([model.timeFrom isEqualToString:@"12:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"12:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"12:30"] && [model.time isEqualToString:@"12:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==13)
        {
            if ([model.timeFrom isEqualToString:@"13:00"]|| [model.time isEqualToString:@"13:00"])
            {
                if ([model.timeFrom isEqualToString:@"13:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"13:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"13:00"] && [model.time isEqualToString:@"13:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"13:30"]|| [model.time isEqualToString:@"13:30"])
            {
                if ([model.timeFrom isEqualToString:@"13:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"13:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"13:30"] && [model.time isEqualToString:@"13:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==14)
        {
            if ([model.timeFrom isEqualToString:@"14:00"]|| [model.time isEqualToString:@"14:00"])
            {
                if ([model.timeFrom isEqualToString:@"14:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"14:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"14:00"] && [model.time isEqualToString:@"14:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"14:30"]|| [model.time isEqualToString:@"14:30"])
            {
                if ([model.timeFrom isEqualToString:@"14:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"14:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"14:30"] && [model.time isEqualToString:@"14:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==15)
        {
            if ([model.timeFrom isEqualToString:@"15:00"]|| [model.time isEqualToString:@"15:00"])
            {
                if ([model.timeFrom isEqualToString:@"15:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"15:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"15:00"] && [model.time isEqualToString:@"15:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"15:30"]|| [model.time isEqualToString:@"15:30"])
            {
                if ([model.timeFrom isEqualToString:@"15:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"15:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"15:30"] && [model.time isEqualToString:@"15:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==16)
        {
            if ([model.timeFrom isEqualToString:@"16:00"]|| [model.time isEqualToString:@"16:00"])
            {
                if ([model.timeFrom isEqualToString:@"16:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"16:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"16:00"] && [model.time isEqualToString:@"16:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"16:30"]|| [model.time isEqualToString:@"16:30"])
            {
                if ([model.timeFrom isEqualToString:@"16:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"16:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"16:30"] && [model.time isEqualToString:@"16:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
            }
        }
        else if (indexPath.row==17)
        {
            if ([model.timeFrom isEqualToString:@"17:00"]|| [model.time isEqualToString:@"17:00"])
            {
                if ([model.timeFrom isEqualToString:@"17:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"17:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];                }
                else if ([model.timeFrom isEqualToString:@"17:00"] && [model.time isEqualToString:@"17:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"17:30"]|| [model.time isEqualToString:@"17:30"])
            {
                if ([model.timeFrom isEqualToString:@"17:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"17:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"17:30"] && [model.time isEqualToString:@"17:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                
            }
        }
        else if (indexPath.row==18)
        {
            if ([model.timeFrom isEqualToString:@"18:00"]|| [model.time isEqualToString:@"18:00"])
            {
                if ([model.timeFrom isEqualToString:@"18:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"18:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"18:00"] && [model.time isEqualToString:@"18:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"18:30"]|| [model.time isEqualToString:@"18:30"])
            {
                if ([model.timeFrom isEqualToString:@"18:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"18:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"18:30"] && [model.time isEqualToString:@"18:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==19)
        {
            if ([model.timeFrom isEqualToString:@"19:00"]|| [model.time isEqualToString:@"19:00"])
            {
                if ([model.timeFrom isEqualToString:@"19:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"19:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"19:00"] && [model.time isEqualToString:@"19:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }

            }
            else if ([model.timeFrom isEqualToString:@"19:30"]|| [model.time isEqualToString:@"19:30"])
            {
                if ([model.timeFrom isEqualToString:@"19:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"19:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"19:30"] && [model.time isEqualToString:@"19:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                

            }
        }
        else if (indexPath.row==20)
        {
            if ([model.timeFrom isEqualToString:@"20:00"]|| [model.time isEqualToString:@"20:00"])
            {
                if ([model.timeFrom isEqualToString:@"20:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"20:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"20:00"] && [model.time isEqualToString:@"20:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }

            }
            else if ([model.timeFrom isEqualToString:@"20:30"]|| [model.time isEqualToString:@"20:30"])
            {
                if ([model.timeFrom isEqualToString:@"20:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"20:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"20:30"] && [model.time isEqualToString:@"20:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                
            }
        }
        else if (indexPath.row==21)
        {
            if ([model.timeFrom isEqualToString:@"21:00"]|| [model.time isEqualToString:@"21:00"])
            {
                if ([model.timeFrom isEqualToString:@"21:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"21:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"21:00"] && [model.time isEqualToString:@"21:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }

            }
            else if ([model.timeFrom isEqualToString:@"21:30"]|| [model.time isEqualToString:@"21:30"])
            {
                if ([model.timeFrom isEqualToString:@"21:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"21:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"21:30"] && [model.time isEqualToString:@"21:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
                

            }
        }
        else if (indexPath.row==22)
        {
            if ([model.timeFrom isEqualToString:@"22:00"]|| [model.time isEqualToString:@"22:00"])
            {
                if ([model.timeFrom isEqualToString:@"22:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"22:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"22:00"] && [model.time isEqualToString:@"22:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                    
                }
            }
            else if ([model.timeFrom isEqualToString:@"22:30"]|| [model.time isEqualToString:@"22:30"])
            {
                if ([model.timeFrom isEqualToString:@"22:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"22:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"22:30"] && [model.time isEqualToString:@"22:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                
            }
        }
        else if (indexPath.row==23)
        {
            if ([model.timeFrom isEqualToString:@"23:00"]|| [model.time isEqualToString:@"23:00"])
            {
                if ([model.timeFrom isEqualToString:@"23:00"] && [model.time isEqualToString:@""])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:YES];
                    cell.tailingSpace.constant=8;
                    cell.firstView.tag=[model.apptId intValue];
                    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetails:)];
                    [cell.firstView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"23:00"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.firstView setHidden:YES];
                    [cell.thirdView setHidden:NO];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    cell.thirdView.tag=[model.eventId intValue];
                    cell.leadingSpace.constant=42;
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];                }
                else if ([model.timeFrom isEqualToString:@"23:00"] && [model.time isEqualToString:@"23:00"])
                {
                    [cell.firstView setHidden:NO];
                    [cell.thirdView setHidden:NO];
                    cell.tailingSpace.constant=168;
                    cell.leadingSpace.constant=202;
                    cell.firstView.tag=[model.apptId intValue];
                    cell.thirdView.tag=[model.eventId intValue];
                    [cell.firstView addGestureRecognizer:gesture];
                    [cell.thirdView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.firstView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.firstView.backgroundColor=[UIColor clearColor];
                    }
                    cell.firstLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.thirdLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr, model.physician];
                }

            }
            else if ([model.timeFrom isEqualToString:@"23:30"]|| [model.time isEqualToString:@"23:30"])
            {
                if ([model.timeFrom isEqualToString:@"23:30"] && [model.time isEqualToString:@""])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:YES];
                    cell.tailingSpace1.constant=8;
                    cell.secondView.tag=[model.apptId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                }
                else if ([model.time isEqualToString:@"23:30"] && [model.timeFrom isEqualToString:@""])
                {
                    [cell.secondView setHidden:YES];
                    [cell.fourthView setHidden:NO];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    cell.fourthView.tag=[model.eventId intValue];
                    cell.leadingSpace1.constant=42;
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                }
                else if ([model.timeFrom isEqualToString:@"23:30"] && [model.time isEqualToString:@"23:30"])
                {
                    [cell.secondView setHidden:NO];
                    [cell.fourthView setHidden:NO];
                    cell.tailingSpace1.constant=168;
                    cell.leadingSpace1.constant=202;
                    cell.secondView.tag=[model.apptId intValue];
                    cell.fourthView.tag=[model.eventId intValue];
                    [cell.secondView addGestureRecognizer:gesture];
                    [cell.fourthView addGestureRecognizer:eventGesture];
                    if ([model.typeOfVisitId intValue]==1 && [model.typeOfVisit isEqualToString:@"Clinic Visit"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#F4F586"];
                    }
                    else if ([model.typeOfVisitId intValue]==2 && [model.typeOfVisit isEqualToString:@"Online Consultation"])
                    {
                        cell.secondView.backgroundColor=[self colorFromHexString:@"#FFDAB4"];
                    }
                    else
                    {
                        cell.secondView.backgroundColor=[UIColor clearColor];
                    }
                    cell.secLabel.text=[NSString stringWithFormat:@"%@ (Pet Parent:%@)",model.timeFrom12hr,model.ownerName];
                    cell.fourthLabel.text=[NSString stringWithFormat:@"%@ (%@)",model.time12hr,model.physician];
                    
                }
            }
        }
    }
    return cell;
}
-(void)selectDetails:(UITapGestureRecognizer *)gesture
{
    UIView *view=(UIView *)gesture.view;
    NSLog(@"%ld",(long)view.tag);
    for (appointmentDetailsModel *model in _eventListModels)
    {
        if ([model.apptId intValue]==view.tag)
        {
            appointmentDetailsModel *selected=model;
            NSLog(@"%@",selected.apptId);
            NSLog(@"%@",selected.apptDate);
            [self performSegueWithIdentifier:@"appoint" sender:selected];
        }
    }
    
}
-(void)selectEventDetails:(UITapGestureRecognizer *)gesture
{
    UIView *view=(UIView *)gesture.view;
    NSLog(@"%ld",(long)view.tag);
    for (appointmentDetailsModel *model in _eventListModels)
    {
        if ([model.eventId intValue]==view.tag)
        {
            appointmentDetailsModel *selected=model;
            NSLog(@"%@",selected.apptId);
            NSLog(@"%@",selected.apptDate);
            [self performSegueWithIdentifier:@"event" sender:selected];
        }
    }
    
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)getDayEventsList:(NSString *)date
{
    NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    NSString *urlStr=[NSString stringWithFormat:@"%@?UserId=%@&DayDate=%@",CalenderEventList,userId,date];
    NSDictionary *headers = @{ @"x-appapikey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"e00b4833-7c48-6b20-4796-45d95fe154fe" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData* data, NSURLResponse* response, NSError *error)
    {
                                                    dispatch_async(dispatch_get_main_queue(), ^
        {
                                                    if (error)
                                                    {
                                                        NSLog(@"%@", error);
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                    else
                                                    {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSError *err;
                                                        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                                        NSLog(@"%@",dict);
                                                        if ([dict[@"Status"] intValue]==1)
                                                        {
                                                            self->_eventList=dict[@"CalenderEvList"];
                                                            NSLog(@"%@",self->_eventList);
                                                            if (self->_eventList.count>0)
                                                            {
                                                                self->_eventListModels=[responseParser appointmentList:_eventList];
                                                            }
                                                            [self->_detailsTable reloadData];
                                                           // [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        }
                                                        else
                                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    }
                                                    });
                                                }];
    [dataTask resume];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"appoint"])
    {
        AppointmentDetailsViewController *appoint=segue.destinationViewController;
        appoint.appoint=sender;
    }
    else if([segue.identifier isEqualToString:@"event"])
    {
        EventDetailsViewController *event=segue.destinationViewController;
        event.model=sender;
    }
}
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
