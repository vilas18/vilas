//
//  responseParser.m
//  Activ4Pets
//
//  Created by Activ Doctors Online on 20/04/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#import "responseParser.h"
#import "dateFormatterModelClass.h"

@implementation responseParser

+(NSMutableArray *)appointmentList:(NSArray *)list
{
    NSMutableArray *apptList=[[NSMutableArray alloc]init];
    NSMutableArray *filtered=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in list)
    {
        NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
        for (NSString * key in [dict allKeys])
        {
            if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
            else
                [prunedDictionary setObject:@"" forKey:key];
        }
        [filtered addObject:prunedDictionary];
    }
    NSLog(@"%@",filtered);
    
    for (NSDictionary *dict in filtered)
    {
        appointmentDetailsModel *model=[[appointmentDetailsModel alloc]init];
        
        // appointment
        model.userId=dict[@"UserId"];
        model.apptId=dict[@"AppId"];
        model.apptDate=dict[@"AppointmentDate"];
        model.timeFrom=dict[@"AppointmentTimeFrom"];
        model.timeTo=dict[@"AppointmentTimeTo"];
        model.rescheduleDate=dict[@"AppointmentRescheduleDate"];
        model.mins=dict[@"Minutes"];
        model.status=dict[@"Status"];
        model.statusId=dict[@"StatusId"];
        model.petName=dict[@"PetName"];
        model.petId=dict[@"PetId"];
        model.species=dict[@"Species"];
        model.ownerName=dict[@"OwnerName"];
        model.ownerEmail=dict[@"OwnerEmail"];
        model.vetName=dict[@"VetName"];
        model.apptType=dict[@"AppointmentType"];
        model.typeOfVisit=dict[@"TypeOfVisit"];
        model.typeOfVisitId=dict[@"TypeOfVisitId"];
        model.clinicLocation=dict[@"Location"];
        model.apptReason=dict[@"AppReason"];
        model.consultMode=dict[@"ConsultationModeName"];
        model.consultModeId=dict[@"ConsultationModeId"];
        model.timeFrom12hr=dict[@"AppTimeFrom12hr"];
        model.timeTo12hr=dict[@"AppTimeTo12hr"];
        model.conclusion=dict[@"Conclusion"];
        
        //Event
        
        model.eventId=dict[@"CalenderId"];
        model.date=dict[@"Date"];
        model.time=dict[@"Time"];
        model.physician=dict[@"Physician"];
        model.comment=dict[@"Comment"];
        model.reason=dict[@"Reason"];
        model.time12hr=dict[@"Time12hr"];
        
        
        [apptList addObject:model];
    }
    return apptList;
}


@end
