//
//  dateFormatterModelClass.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/04/16.
//  Copyright © 2016 Activ Doctors Online. All rights reserved.
//

#import "dateFormatterModelClass.h"

@interface dateFormatterModelClass ()

@end

@implementation dateFormatterModelClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSString *)convertTheDateToCorrespondingDomain :(NSDate *)dateParameter{
    
    NSLog(@"dateParameter:%@",dateParameter);
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedDomainStr = [userDefs objectForKey:@"LangCode"];
    
    [userDefs synchronize];

    NSLog(@"selectedDomainStr:%@",selectedDomainStr);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if ([selectedDomainStr isEqualToString:@"en-IN"] || [selectedDomainStr isEqualToString:@"en-US"])
    {
        [df setDateFormat:NSLocalizedString(@"MM/dd/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"en-FR"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"en-AU"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"es-ES"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[df stringFromDate:dateParameter]];
    
    NSLog(@"dateStr:%@",dateStr);
    
    return dateStr;
}

-(NSDate *)convertTheStringToCorrespondingDomain :(NSString *)strDateParameter
{
    NSLog(@"strDateParameter:%@",strDateParameter);
    
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedDomainStr = [userDefs objectForKey:@"LangCode"];
    
    [userDefs synchronize];
    
    NSLog(@"selectedDomainStr:%@",selectedDomainStr);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if ([selectedDomainStr isEqualToString:@"en-IN"] || [selectedDomainStr isEqualToString:@"en-US"])
    {
        [df setDateFormat:NSLocalizedString(@"MM/dd/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"en-FR"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"en-AU"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    else if ([selectedDomainStr isEqualToString:@"es-ES"])
    {
        [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
    }
    
    NSDate *dateObj = [df dateFromString:strDateParameter];
    
    NSLog(@"dateObj:%@",dateObj);
    
    if (!dateObj || dateObj == nil) {
        
        //NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        NSDate *dateObj1 = [NSDate date];
        
        if ([selectedDomainStr isEqualToString:@"en-IN"] || [selectedDomainStr isEqualToString:@"en-US"])
        {
            [df setDateFormat:NSLocalizedString(@"MM/dd/yyyy", nil)];
        }
        else if ([selectedDomainStr isEqualToString:@"en-FR"])
        {
            [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
        }
        else if ([selectedDomainStr isEqualToString:@"en-AU"])
        {
            [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
        }
        else if ([selectedDomainStr isEqualToString:@"es-ES"])
        {
            [df setDateFormat:NSLocalizedString(@"dd/MM/yyyy", nil)];
        }
        
        NSString *tempStrDate = [df stringFromDate:dateObj1];
        dateObj = [df dateFromString:tempStrDate];
    }
    
    return dateObj;
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
