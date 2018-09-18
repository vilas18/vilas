//
//  CreateAppointmentViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 25/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "CreateAppointmentViewController.h"
#import "dateFormatterModelClass.h"
#import "CkViewController.h"

//#define _AddEvent @"http://dpetspms.activdoctorsconsult.com:8092/api/OwnerAddEvent/Get"
#define _AddEvent @"http://qapetspms.activdoctorsconsult.com:8082/api/OwnerAddEvent/Get"

@interface CreateAppointmentViewController ()<UITextFieldDelegate>

@end

@implementation CreateAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    _pickerDate.minimumDate=[NSDate date];
    // Do any additional setup after loading the view.
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
    // dateFormatterModelClass *dateFormatterClsObj = [[dateFormatterModelClass alloc] init];
    if (sender.tag==1)
    {
        if (_dateView.hidden==YES)
            _dateView.hidden=NO;
        else
        {
            _dateView.hidden=YES;
            NSDateFormatter *formater=[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"MM/dd/yyyy"];
            _selectDate.text=[formater stringFromDate:_pickerDate.date];
            [_selectDate resignFirstResponder];
        }
        
    }
    else if (sender.tag==2)
    {
        if (_timeView.hidden==YES)
            _timeView.hidden=NO;
        else
        {
            _selectTime.text=[self setDate];
            _timeView.hidden=YES;
            [_selectTime resignFirstResponder];
        }
    }
}
-(NSString *)setDate
{
    NSDateFormatter *formator=[[NSDateFormatter alloc]init];
    [formator setDateFormat:@"hh:mm aa"];
    NSString *selTime=[formator stringFromDate:_pickerTime.date];
    return selTime;
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
    if ([_selectDate.text isEqualToString:@""] )
    {
        _starLabel1.hidden=NO;
        //_starLabel2.hidden=YES;
        //_starLabel3.hidden=YES;
        // [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        _starLabel1.hidden=YES;
        // _starLabel2.hidden=YES;
        // _starLabel3.hidden=YES;
    }
    if ([_selectTime.text isEqualToString:@""])
    {
        _starLabel2.hidden=NO;
        // _starLabel1.hidden=YES;
        // _starLabel3.hidden=YES;
        // [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        _starLabel2.hidden=YES;
        // _starLabel1.hidden=YES;
        // _starLabel3.hidden=YES;
    }
    if ([_reason.text isEqualToString:@""])
    {
        _starLabel3.hidden=NO;
        // _starLabel1.hidden=YES;
        // _starLabel2.hidden=YES;
        // [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        _starLabel3.hidden=YES;
        //_starLabel1.hidden=YES;
        //_starLabel2.hidden=YES;
        
    }
    if(!([_selectDate.text isEqualToString:@""]) && !([_selectTime.text isEqualToString:@""]) && !([_reason.text isEqualToString:@""]))
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
    
    NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    
    NSString *str=[NSString stringWithFormat:@"UserId=%@&selectedDate=%@&Time=%@&Reason=%@&Vet=%@&Comment=%@&SendNofication=false",userId,_selectDate.text,_selectTime.text,_reason.text,_veterinarian.text,_comment.text];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@?%@",_AddEvent,str];
    
    NSLog(@"urlStr of add event : %@",urlStr);
    
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
                                                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Event has been created successfully" preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                                                        
                                                        for (UIViewController *controller in self.navigationController.viewControllers)
                                                        {
                                                            if ([controller isKindOfClass:[CkViewController class]]) {
                                                                
                                                                [self.navigationController popToViewController:controller
                                                                                                      animated:YES];
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
                                                
                                            }
                                            NSLog(@"error :%@",error);
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
