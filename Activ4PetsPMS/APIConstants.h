//
//  APIConstants.h
//  Activ4Pets
//
//  Created by Activ Doctors Online on 20/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

#ifndef APIConstants_h
#define APIConstants_h
//Live url
//#define BASEURL  @"http://ftp.activ4pets.es:8290/api/"
//QA Url
#define BASEURL @"http://qapetspms.activdoctorsconsult.com:8082/api/"

#define EditEvent BASEURL @"OwnerEditEvent/Get/"

#define AddEvent BASEURL @"OwnerAddEvent/Get"

#define CalViewList BASEURL @"CalenderViewList/Get"

#define GetMonthlyAppointmentList BASEURL @"Appointment/Get"

#define CalenderEventList  BASEURL @"CalenderEventList/Get"

#define DeleteEvent BASEURL @"OwnerDeleteEvent/Get"

#define _NavigationBackImage @"logo_back.png"

#define GetCount  BASEURL @"GetMerckPopupCount/Get"

#define OpenPopUp BASEURL @"OpenMerckPopup/Get"

#define ClickPopUp BASEURL @"ClickMerckPopup/Get"

#define SubmitOnline BASEURL @"MerckPopupLinkTrack/Get"



#endif /* APIConstants_h */
