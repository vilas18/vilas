//
//  EventDetailsViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 06/06/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EditEventViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editEvent:)];
    
    [self.navigationItem setRightBarButtonItem:edit];
    
    _date.text=_model.date;
    _time.text=_model.time12hr;
    _physician.text=_model.physician;
    _reason.text=_model.reason;
    _comment.text=_model.comment;
}
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editEvent:(id)sender
{
    [self performSegueWithIdentifier:@"editEvent" sender:_model];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditEventViewController *edit=segue.destinationViewController;
    edit.eventModelObj=sender;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
