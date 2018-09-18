//
//  EditEventViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 06/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "EditEventViewController.h"
#import "dateFormatterModelClass.h"
#import "DayEventsViewController.h"
#import "ViewCalendarListViewController.h"

@interface EditEventViewController ()

@end

@implementation EditEventViewController

#define _EditEvent @"http://qapetspms.activdoctorsconsult.com:8082/api/OwnerEditEvent/Get/"

//#define _EditEvent @"http://qapetspms.activdoctorsconsult.com:8082/api/OwnerEditEvent/Get/"

@synthesize eventModelObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValues];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    _dateView.hidden=YES;
    _timeView.hidden=YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: @"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // Do any additional setup after loading the view.
}

-(void)setValues{
    _selectDate.text = eventModelObj.date;
    _selectTime.text = eventModelObj.time12hr;
    _reason.text = eventModelObj.reason;
    _veterinarian.text = eventModelObj.physician;
    _comment.text = eventModelObj.comment;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1 || textField.tag==2)
    {
        [textField setInputView:[UIView new]];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1)
        _dateView.hidden=NO;
    else if (textField.tag==2)
        _timeView.hidden=NO;
}

-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showPickerDateTime:(UIButton *)sender
{
    if (sender.tag==1)
    {
        if ([self.dateView isHidden]==YES)
        {
            self.dateView.hidden = NO;
            
            if(![self.selectDate.text isEqualToString:@""])
            {
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"MM/dd/yyyy"];
                self.pickerDate.date=[formater dateFromString:_selectDate.text];
            }
            
            [self.pickerDate addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        }
        else
        {
            self.dateView.hidden = YES;
            
            [self.pickerDate addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    else if (sender.tag==2)
    {
        if ([self.timeView isHidden])
        {
            self.timeView.hidden = NO;
            
            if(![self.selectTime.text isEqualToString:@""])
            {
                
                NSDateFormatter *formater=[[NSDateFormatter alloc]init];
                [formater setDateFormat:@"hh:mm aa"];
                self.pickerTime.date=[formater dateFromString:_selectTime.text];
            }
            
            [self.pickerTime addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
        }
        else
        {
            self.timeView.hidden = YES;
            
            [self.pickerTime addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
        }
    }
}

-(void)dateChange:(id)sender
{
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM/dd/yyyy"];
    _selectDate.text=[formater stringFromDate:_pickerDate.date];
}

-(void)dateChange1:(id)sender
{
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"hh:mm aa"];
    _selectTime.text=[formater stringFromDate:_pickerTime.date];
}

-(IBAction)submit:(id)sender
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Asterisk (*) labeled fields are mandatory" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [_selectTime resignFirstResponder];
    [_selectDate resignFirstResponder];
    [_reason resignFirstResponder];
    [_veterinarian resignFirstResponder];
    [_comment resignFirstResponder];
    if ([_selectDate.text isEqualToString:@""] && [_selectTime.text isEqualToString:@""] && [_reason.text isEqualToString:@""])
    {
        _starLabel1.hidden=NO;
        _starLabel2.hidden=NO;
        _starLabel3.hidden=NO;
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([_selectDate.text isEqualToString:@""])
    {
        _starLabel1.hidden=NO;
        _starLabel2.hidden=YES;
        _starLabel3.hidden=YES;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([_selectTime.text isEqualToString:@""])
    {
        _starLabel2.hidden=NO;
        _starLabel1.hidden=YES;
        _starLabel3.hidden=YES;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([_selectTime.text isEqualToString:@""])
    {
        _starLabel3.hidden=NO;
        _starLabel1.hidden=YES;
        _starLabel2.hidden=YES;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        _starLabel1.hidden=YES;
        _starLabel2.hidden=YES;
        _starLabel3.hidden=YES;
        [self startAuthenticatingUser];
    }
}

-(void)startAuthenticatingUser
{
    //first check internet connectivity
    
    if([CheckNetwork isExistenceNetwork])
    {
        NSLog(@"Internet connection");
        
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:NSLocalizedString(@"Loading", nil)];
        
        [self postDataToCreateAppoint];
    }
    else
    {
        NSLog(@"No internet connection");
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)postDataToCreateAppoint
{
    NSDictionary *headers = @{ @"X-AppApiKey": @"A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                               @"cache-control": @"no-cache"
                               };
    NSString *str=[NSString stringWithFormat:@"EventId=%@&selectedDate=%@&Time=%@&Reason=%@&Vet=%@&Comment=%@&SendNofication=%@",eventModelObj.eventId,_selectDate.text,_selectTime.text,_reason.text,_veterinarian.text,_comment.text,@"false"];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@?%@",_EditEvent,str];
    
    NSLog(@"Edit Event urlStr:%@",urlStr);
    
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
                                                    NSLog(@"%@",dict[@"Status"]);
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Event has been updated successfully" preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                        for (UIViewController *controller in self.navigationController.viewControllers)
                                                        {
                                                            if ([controller isKindOfClass:[DayEventsViewController class]]) {
                                                                
                                                                [self.navigationController popToViewController:controller
                                                                                                      animated:YES];
                                                                break;
                                                            }
                                                            else if([controller isKindOfClass:[ViewCalendarListViewController class]])
                                                            {
                                                                [self.navigationController popToViewController:controller animated:YES];
                                                                break;
                                                            }
                                                        }
                                                    }];
                                                    [alert addAction:ok];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                                }
                                                else
                                                {
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                }
                                                NSLog(@"Error in edit event API:%@",error);
                                            }
                                        });
                                    }];
    [dataTask resume];
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
