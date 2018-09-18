
//
//  AppointmentDetailsViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 24/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "AppointmentDetailsViewController.h"
#import "dateFormatterModelClass.h"


@interface AppointmentDetailsViewController ()

@end

@implementation AppointmentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatterModelClass *dateFormatterClsObj = [[dateFormatterModelClass alloc] init];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (_isFromReminder==YES)
    {
        NSLog(@"%@",_apptDetails);
        if ([_apptDetails[@"IsClinicVisit"] intValue]==1)
        {
            self.title=@"Clinic Visit";
        }
        else{
            self.title=@"Online Consultation";
        }
        
        _clinicName.text=[NSString stringWithFormat:@"%@ %@ %@",_apptDetails[@"ClinicName"],_apptDetails[@"ClinicCity"],_apptDetails[@"Country"]];
        
        if ([_apptDetails[@"AppointmentType"] isEqualToString:@""])
        {
            _vistType.text=[NSString stringWithFormat:@"%@ Booked",self.title];
        }
        else{
            _vistType.text=[NSString stringWithFormat:@"%@ Booked for %@",self.title,_apptDetails[@"AppointmentType"]];
        }
        
        NSString *str=_apptDetails[@"AppointmentDate"];
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
        _dayTime.text=[NSString stringWithFormat:@"%@ %ld %@. %ld at %@ for %@ mins",dayName,(long)day,monthName,(long)year,_apptDetails[@"AppointmentTimeFrom"],_apptDetails[@"Minutes"]];
        
        
        _status.layer.cornerRadius=3;
        _status.clipsToBounds=YES;
        _status.text=_apptDetails[@"Status"];
        if ([_apptDetails[@"StatusId"] intValue]==1)
            _status.backgroundColor=[self colorFromHexString:@"#84ba06"];
        else if ([_apptDetails[@"StatusId"] intValue]==3)
            _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
        else if ([_apptDetails[@"StatusId"] intValue]==2)
            _status.backgroundColor=[self colorFromHexString:@"#d9534f"];
        else if ([_apptDetails[@"StatusId"] intValue]==4)
            _status.backgroundColor=[self colorFromHexString:@"#a94442"];
        
        if ([_apptDetails[@"IsClinicVisit"] intValue]==1)        {
            _onlineView.hidden=YES;
            _cliniView.hidden=YES;
        }
        else //([_appoint.typeOfVisit isEqualToString:@"Online Consultation"])
        {
            _onlineView.hidden=NO;
            //_healthQuery.text=_appoint.apptReason;
            if ([_status.text isEqualToString:@"Upcoming"] || [_status.text isEqualToString:@"Cancelled"])
            {
                _conclusion.hidden=YES;
                _concTitle.hidden=YES;
                _downView.hidden=YES;
            }
            else if ([_status.text isEqualToString:@"Finished"]){
                _conclusion.hidden=NO;
                _concTitle.hidden=NO;
                _downView.hidden=NO;
                // _conclusion.text=_appoint.conclusion;;
            }
            
            _cliniView.hidden=YES;
        }
        
        _petName.text=_apptDetails[@"PetName"];
        _petType.text=_apptDetails[@"PetType"];
        _petParent.text=_apptDetails[@"PetParent"];
        _email.text=_apptDetails[@"PetParentEmail"];
        _vetName.text=_apptDetails[@"VetName"];
        if ([_apptDetails[@"ConsultationMode"] isEqualToString:@""])
            _consultMode.text=@"";
        else if ([_apptDetails[@"ConsultationMode"] intValue]==1)
            _consultMode.text=@"Video";
        else if ([_apptDetails[@"ConsultationMode"] intValue]==2)
            _consultMode.text=@"Text Chat";
        
    }
    else
    {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",_appoint.typeOfVisit]];
        if ([_appoint.clinicLocation isEqualToString:@""]){
            _clinicName.text=[NSString stringWithFormat:@"%@ Booked",_appoint.typeOfVisit];}
        else{
            _clinicName.text=_appoint.clinicLocation;
        }
        
        if ([_appoint.apptType isEqualToString:@""])
        {
            _vistType.text=[NSString stringWithFormat:@"%@ Booked",_appoint.typeOfVisit];
        }
        else{
            _vistType.text=[NSString stringWithFormat:@"%@ Booked for %@",_appoint.typeOfVisit,_appoint.apptType];
        }
        
        NSLog(@"%@",_appoint.apptDate);
        NSString *str=_appoint.apptDate;
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
        _dayTime.text=[NSString stringWithFormat:@"%@ %ld %@. %ld at %@ for %@ mins",dayName,(long)day,monthName,(long)year,_appoint.timeFrom12hr,_appoint.mins];
        if (![_appoint.rescheduleDate isEqualToString:@""])
        {
            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"MM/dd/yyyy"];
            NSDate *reschDate=[formater dateFromString:_appoint.rescheduleDate];
            NSLog(@"%@",reschDate);
            NSString *date2=[formater stringFromDate:[NSDate date]];
            NSDate *presentDate=[formater dateFromString:date2];
            NSComparisonResult result1=[presentDate compare:reschDate];
            if (result1==NSOrderedSame || result1==NSOrderedAscending)
            {
                NSString *str=_appoint.rescheduleDate;
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
                _dayTime.text=[NSString stringWithFormat:@"%@ %ld %@. %ld at %@ for %@ mins",dayName,(long)day,monthName,(long)year,_appoint.timeFrom12hr,_appoint.mins];
            }
        }
        
        if (_isFromViewList==YES)
        {
            if ([_statusStr isEqualToString:@"Upcoming"]) {
                _status.text=NSLocalizedString(@"Upcoming", nil);
                _status.backgroundColor=[self colorFromHexString:@"#84ba06"];
            }
            else if ([_statusStr isEqualToString:@"Completed"])
            {
                _status.text=NSLocalizedString(@"Completed", nil);
                _status.backgroundColor=[self colorFromHexString:@"#0667b8"];
            }
            else if ([_statusStr isEqualToString:@"Cancelled"])
            {
                _status.text=NSLocalizedString(@"Cancelled", nil);
                _status.backgroundColor=[self colorFromHexString:@"#d9534f"];
            }
        }
        else
        {
            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"MM/dd/yyyy"];
            NSString *date2=[formater stringFromDate:[NSDate date]];
            NSDate *presentDate=[formater dateFromString:date2];
            NSLog(@"%@",presentDate);
            if ([_appoint.statusId intValue]==2 && [_appoint.status isEqualToString:@"Cancelled"])
            {
                _status.backgroundColor=[self colorFromHexString:@"#d9534f"];
                _status.text=_appoint.status;
            }
            else if ([_appoint.rescheduleDate isEqualToString:@""])
            {
                NSDate *eventDate=[formater dateFromString:_appoint.apptDate];
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
                    NSDate *eventDate=[formater dateFromString:_appoint.timeFrom12hr];
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
                NSDate *reschDate=[formater dateFromString:_appoint.rescheduleDate];
                NSLog(@"%@",reschDate);
                NSComparisonResult result1=[presentDate compare:reschDate];
                if (result1==NSOrderedSame || result1==NSOrderedAscending)
                {
                    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                    [formater setDateFormat:@"hh:mm aa"];
                    NSString *date=[formater stringFromDate:[NSDate date]];
                    NSDate *presentDate=[formater dateFromString:date];
                    NSLog(@"%@",presentDate);
                    NSDate *eventDate=[formater dateFromString:_appoint.timeFrom12hr];
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
            
        }
        _status.layer.cornerRadius=3;
        _status.clipsToBounds=YES;
        
        if ([_appoint.typeOfVisit isEqualToString:@"Clinic Visit"])
        {
            _onlineView.hidden=YES;
            _cliniView.hidden=YES;
        }
        else if([_appoint.typeOfVisit isEqualToString:@"Online Consultation"])
        {
            _onlineView.hidden=NO;
            _healthQuery.text=_appoint.apptReason;
            if ([_status.text isEqualToString:@"Upcoming"] || [_status.text isEqualToString:@"Cancelled"])
            {
                _conclusion.hidden=YES;
                _concTitle.hidden=YES;
                _downView.hidden=YES;
            }
            else if ([_status.text isEqualToString:@"Completed"]){
                _conclusion.hidden=NO;
                _concTitle.hidden=NO;
                _downView.hidden=NO;
                _conclusion.text=_appoint.conclusion;;
            }
            
            _cliniView.hidden=YES;
        }
        
        _petName.text=_appoint.petName;
        _petType.text=_appoint.species;
        _petParent.text=_appoint.ownerName;
        _email.text=_appoint.ownerEmail;
        _vetName.text=_appoint.vetName;
        if ([_appoint.consultModeId isEqualToString:@""])
            _consultMode.text=@"";
        else if ([_appoint.consultModeId intValue]==1)
            _consultMode.text=@"Video";
        else if ([_appoint.consultModeId intValue]==2)
            _consultMode.text=@"Text Chat";
        
    }
    // Do any additional setup after loading the view.
}
-(IBAction)viewPetDetails:(id)sender
{
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PHR" bundle:nil];
    //    IdCardViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"IdCard_Owner"];
    //    if (_isFromReminder==YES)
    //    {
    //        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"]];
    //        ivc.patientID = userId;
    //        ivc.ShareWithMe =@"False";
    //        ivc.petID=_apptDetails[@"PetId"];
    //
    //    }
    //    else
    //    {
    //        ivc.patientID = _appoint.userId;
    //        ivc.ShareWithMe =@"False";
    //        ivc.petID=_appoint.petId;
    //    }
    //
    //    [self.navigationController pushViewController:ivc animated:YES];
    
    
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"False" forKey:@"ShareWithMe"];
    [prefs setObject:@"False" forKey:@"SharedDetails"];
    
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
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelAppointment:(id)sender
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Cancel Appointment" message:@"Why you want to cancel ?\n Enetr your reason here" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter reason";
    }];
    UIAlertAction *submit=[UIAlertAction actionWithTitle:@"SUBMIT" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:submit];
    [alert addAction:cancel];
    //alert.view.backgroundColor=[UIColor redColor];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)rescheduleAppointment:(id)sender
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Request to Reschedule" message:@"Why you want to Reschedule ?\n Enetr your reason and suggest any other date & time" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter reason";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter date and time";
    }];
    UIAlertAction *submit=[UIAlertAction actionWithTitle:@"SUBMIT" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:submit];
    [alert addAction:cancel];
    //alert.title
    //alert.view.backgroundColor=[UIColor blueColor];
    [self presentViewController:alert animated:YES completion:nil];
    
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
