//
//  offerViewController.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/12/16.
//  Copyright © 2016 Activ Doctors Online. All rights reserved.
//

#import "offerViewController.h"

@interface offerViewController ()

@end

@implementation offerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClk:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    NSString *dtlOfferStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationMsg"]];
    NSLog(@"dtlOfferStr:%@",dtlOfferStr);
    [offerDtlView setText:dtlOfferStr];
    
    //URL to redirect to offer we are receiving in app delegate in did receive notification method under segue id 13 condition
    addUrl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"advertisingUrl"]];
    NSLog(@"addUrl:%@",addUrl);
    
    //Make Click to View Button rounded with border and border color
    clickToVwBtn.layer.cornerRadius = 15.0;
    clickToVwBtn.clipsToBounds = YES;
    [[clickToVwBtn layer] setBorderWidth:1.0f];
    [[clickToVwBtn layer] setBorderColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1].CGColor];
}

#pragma mark -
#pragma mark Click To View button Pressed Action Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(IBAction)clickToViewBtnPressed:(id)sender
{
    
    NSString *urlStr=[NSString stringWithFormat: @"%@", addUrl];
    NSLog(@"urlStr : %@",urlStr);
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:urlStr];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        //if ([[UIApplication sharedApplication] canOpenURL: URL]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open iOS 10 %@: %d",urlStr,success);
           }];
    }
    else
    {
        BOOL success = [application openURL:URL];
        NSLog(@"Open old way %@: %d",urlStr,success);
    }
}

#pragma mark -
#pragma mark Back Button Pressed Action Method
-(void)leftClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark -
 #pragma mark Click to View buttong flash on/off methods
 - (void)flashOff:(UIView *)v
 {
 [UIView animateWithDuration:.05 delay:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
 v.alpha = .01;  //don't animate alpha to 0, otherwise you won't be able to interact with it
 } completion:^(BOOL finished) {
 [self flashOn:v];
 }];
 }
 
 - (void)flashOn:(UIView *)v
 {
 [UIView animateWithDuration:.05 delay:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
 v.alpha = 1;
 } completion:^(BOOL finished) {
 [self flashOff:v];
 }];
 }
 */

//#pragma mark -
//#pragma mark Validate URL
//- (BOOL) validateUrl: (NSString *) candidate {
//    NSString *urlRegEx =
//    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:candidate];
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
