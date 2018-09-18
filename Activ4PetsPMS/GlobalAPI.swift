//
//  File.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 07/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import Foundation

struct API
{
    //  Live server
    
    static let BaseUrl = "http://ftp.activ4pets.es:8290/api/"
    
    // qa server
    
// static let BaseUrl = "http://qapetspms.activdoctorsconsult.com:8082/api/"
    
    struct Login       
    {
        static let Login = String(format: "%@UserLoginNew/Get", BaseUrl)
        
        static let ForgotPassword = String(format: "%@UserSignUp/PostForgotPassword/Post", BaseUrl)
        
        static let SignUp = String(format: "%@UserSignUp/Get", BaseUrl)
        
        static let SignUpOtp = String(format: "%@UserSignUpOTP/Get", BaseUrl)
        
        static let CheckEmailPhone = String(format: "%@UserValidateEmailPhone/Get", BaseUrl)
        
        static let CheckPromoCode = String(format: "%@SignupPromocodeValidate/Get", BaseUrl)
        
        static let SignUpVerifyEmail = String(format: "%@UserSignUpVerifyByEmail/Get", BaseUrl)
        
        static let SignUpChangeEmail = String(format: "%@UserSignUpChangeEmail/Get", BaseUrl)
        
        static let SignUpResendLink = String(format: "%@UserSignUpResendEmail/Get", BaseUrl)
        
        static let VerifyMobileNumberUserID = String(format: "%@VerifyMobileNumberByUserId/Get", BaseUrl)
        
        static let VerifyEmailUserID = String(format: "%@VerifyEmailByUserId/Get", BaseUrl)
        
        static let VerifyChangeEmailUserID = String(format: "%@ChangeRequestEmail/Get", BaseUrl)
        
        static let VerifyChangeMobileUserID = String(format: "%@ChangeRequestPhone/Get", BaseUrl)
        
        static let ACCEPTABLE_CHARACTERS = "0123456789-."
        
        static let ZIPCODE_CHARACTERS = "0123456789"
        
        static let NavigationBackImage = "back_arrow.png"
        
        static let backImage = "back_arrow.png"
        
        static let TermsAndCond = "http://82.127.123.86:8082/TermsConditions/TermAndCondition.aspx"
        
        static let DeviceRegister = BaseUrl + "DeviceRegister/Post"
        
        static let AcceptTermsAndCond = String(format: "%@UserSignUp/GetTermsAndConditions/Get", BaseUrl)
        
        static let ChangeTempPass = BaseUrl + "UserSetting/ChangeTemporaryPassword/Get"
        
        static let GetVerifiedEmail = BaseUrl + "UserGetVerifiedEmail/Get"
        
    }
    struct MerkNotification
    {
        
        static let NotificationOpen = BASEURL + "MerckPushNotificationOpen/Get"
        
        static let NotificationClick = String(format: "%@MerckPushNotificationClick/Get", BaseUrl)
        
        static let GetCount = BASEURL + "GetMerckPopupCount/Get"
        
        static let OpenPopUP = String(format: "%@OpenMerckPopup//Get", BaseUrl)
        
        static let ClickPopUp = BASEURL + "ClickMerckPopup/Get"
        
        static let SubmitOnline = BASEURL + "MerckPopupLinkTrack/Get"
        
    }
    struct Owner
    {
        static let PetList = String(format: "%@PetList/Get", BaseUrl)
        
        static let MaxPetCount = String(format: "%@UserMaxPetCount/Get", BaseUrl)
        
        static let SharedPets = String(format: "%@UserSharePet/GetSharedPetsWithMe/Get", BaseUrl)
        
        static let SharePet = String(format: "%@UserSharePet/Post", BaseUrl)
        
        static let EditSharePet = String(format: "%@UserSharePet/PostEditSharedPet/Post", BaseUrl)
        
        static let DeleteSharePetWithMe = String(format: "%@UserSharePet/GetDelete", BaseUrl)
        
        static let PetsShared = String(format: "%@UserSharePet/GetSharedPets/Get", BaseUrl)
        
        static let SharedPending = String(format: "%@UserMyContact/GetPendingContact/Get", BaseUrl)
        
        // static let MyContacts = String(format: "%@UserMyContact/GetMyContact/Get", BaseUrl)
        
        static let EmergencyContacts = String(format: "%@UserEmergencyContactList/Get", BaseUrl)
        
        static let MyProfile = String(format: "%@UserAccountDetails/Get", BaseUrl)
        
        static let EditMyProfile = String(format: "%@UserAccountEdit/Post", BaseUrl)
        
        static let MyPlan = String(format: "%@UserMyPlanDetails/Get", BaseUrl)
        
        static let RenewPlanDetails = String(format: "%@RenewPlanBillingMobile/Get", BaseUrl)
        
        static let RenewPlanUpdate = String(format: "%@RenewPlanBillingMobile/Post", BaseUrl)
        
        static let Settings = String(format: "%@UserChangeUserNamePassword/Get", BaseUrl)
        
        static let NewNotifications = String(format: "%@UserNotification/Get", BaseUrl)
        
        static let NewNotificationsCount = String(format: "%@NotificationCount/GetNotificationCount/Get", BaseUrl)
        
        static let OldNotifications = String(format: "%@NotificationHistory/Get", BaseUrl)
        
        static let NotificationOpen = String(format: "%@NotificationOpen/Get", BaseUrl)
        
        static let AcceptContact = String(format: "%@UserMyContact/PostAcceptAddContact/Post", BaseUrl)
        
        static let DeclineContact = String(format: "%@UserMyContact/PostDeclineAddContact/Post", BaseUrl)
      
        static let GetSharedPetAccept = String(format: "%@SharePetInfoNotificationAccept/Get", BaseUrl)
        
        static let AllNotifications = String(format: "%@NotificationHistory/UserNotifications/Get", BaseUrl)
        
        static let help = String(format: "%@UserHelpQuerySendEmail/Get", BaseUrl)
        
    }
    struct MyContacts
    {
        static let ContactList = String(format: "%@UserMyContact/GetMyContact/Get", BaseUrl)
        
        static let AddContact = String(format: "%@UserMyContact/PostAddContact/Post", BaseUrl)
        
        static let SearchContact = String(format: "%@UserMyContact/GetUserForFriends/Get", BaseUrl)
        
        static let DelContact = String(format: "%@UserMyContact/GetDelete", BaseUrl)
        
        static let UnfollowedContacts = String(format: "%@UserMyContact/GetUnFollowContacts/Get", BaseUrl)
        
    }
    struct Reminders
    {
        static let ReminderList = String(format: "%@UserReminderList/Get", BaseUrl)
        
        static let ReminderAdd = String(format: "%@UserReminderAdd/Get", BaseUrl)
        
        static let ReminderEdit = String(format: "%@UserReminderUpdate/Get", BaseUrl)
        
        static let ReminderDelete = String(format: "%@UserReminderDelete/Get", BaseUrl)
    }
    
    struct Online
    {
        
        // E-Consultation
        
        static let ECList = String(format: "%@UserEconsultationList/Get", BaseUrl)
        
        static let ECAdd = String(format: "%@UserEconsultationAdd/Get", BaseUrl)
        
        static let ECDelete = String(format: "%@UserEconsultationDelete/Get", BaseUrl)
        
        static let ECUpdate = String(format: "%@UserEconsultationUpdate/Get", BaseUrl)
        
        // SMO
        
        static let SMOList = String(format: "%@UserSMOList/Get", BaseUrl)
        
        static let SMOAdd = String(format: "%@UserSMOAdd/Post", BaseUrl)
        
        static let SMODelete = String(format: "%@UserSMODelete/Get", BaseUrl)
        
        static let GetPrice = String(format: "%@A4PServices/Get", BaseUrl)
        
        static let GetReport = String(format: "%@DownloadSMOReportPDF/Get", BaseUrl)
        
        
    }
    struct Payment
    {
        static let DoPayment = String(format: "%@USAuthorizePayment/Get", BaseUrl)
    }
    struct Invite
    {
        static let UserInvite = String(format: "%@UserInvite/Get", BaseUrl)
        
        static let GetRefCode = String(format: "%@ReferAFriend/GetUserCode/Get", BaseUrl)
        
        static let GetSignature = String(format: "http://share.activ4pets.com/Reffer/GetSignature")
        
        static let GetReferrarCode = String(format: "http://share.activ4pets.com/Reffer/GetCode")
        
        static let GetReferrarDetails = String(format: "%@ReferAFriend/GetUserByReferalCode/Get", BaseUrl)
        
    }
    struct Pet
    {
        
        static let AddPet = String(format: "%@UserPetAdd/Get", BaseUrl)
        
        static let AddPetPhoto = String(format: "%@PetPhotoUpdate/Post", BaseUrl)
        
        static let AddPetCoverPhoto = String(format: "%@PetCoverPhotoUpdate/Post", BaseUrl)
        
        static let EditPet = String(format: "%@UserPetEdit/Get", BaseUrl)
        
        static let DeletePet = String(format: "%@UserPetDelete/Get", BaseUrl)
        
        static let VetList = String(format: "%@VetList/Get", BaseUrl)
        
        static let VetStaffList = String(format: "%@VetStaffList/Get", BaseUrl)
        
        static let PetAdoptionDetails = String(format: "%@UserPetAdoptionDetails/Get", BaseUrl)
        
        static let EditPetAdoption = String(format: "%@UserPetAdoptionEdit/Get", BaseUrl)
        
        static let PetInsuranceList = String(format: "%@UserPetInsurenceList/Get", BaseUrl)
        
        static let EditPetInsurance = String(format: "%@UserPetInsurenceEdit/Get", BaseUrl)
        
        static let AddPetInsurance = String(format: "%@UserPetInsurenceAdd/Get", BaseUrl)
        
        static let DeletePetInsurance = String(format: "%@UserPetInsurenceDelete/Get", BaseUrl)
        
        static let GetTimeSlot = String(format: "%@AppointmentTimeSlot/Get", BaseUrl)
        
        static let MedicalSummaryPdf = String(format: "%@UserGetMedicalSummeryPdf/Get", BaseUrl)
        
        static let MedicalRecordsCount = String(format: "%@GetPetHealthHistoryNumbers/Get", BaseUrl)
        
    }
    
    //Veterinarian List
    
    struct Vet
    {
        static let VetList = String(format: "%@UserVeterinarianList/Get", BaseUrl)
        
        static let VetDelete = String(format: "%@UserVeterinarianDelete/Get", BaseUrl)
        
        static let vetAdd = String(format: "%@UserVeterinarianAdd/Get", BaseUrl)
        
        static let vetEdit = String(format: "%@UserVeterinarianUpdate/Get", BaseUrl)
        
    }
    
    // Contact List
    
    struct Contact
    {
        static let ContactList = String(format: "%@UserContactList/Get", BaseUrl)
        
        static let ContactDelete = String(format: "%@UserContactDelete/Get", BaseUrl)
        
        static let ContactAdd = String(format: "%@UserContactAdd/Get", BaseUrl)
        
        static let ContactEdit = String(format: "%@UserContactUpdate/Get", BaseUrl)
    }
    
    // Gallery
    
    struct PhotoGallery
    {
        static let GalleryList = String(format: "%@UserPhotoGalleryList/Get", BaseUrl)
        
        static let PhotoAdd = String(format: "%@UserPhotoGalleryAdd/Post", BaseUrl)
        
        static let PhotoEdit = String(format: "%@UserPhotoGalleryUpdate/Post", BaseUrl)
        
        static let PhotoGalleryDelete = String(format: "%@UserPhotoGalleryDelete/Get", BaseUrl)
    }
    struct AlbumGallery
    {
        static let AlbumList = String(format: "%@AlbumGalleryList/Get", BaseUrl)
        
        static let UploadPhoto = String(format: "%@AlbumGalleryUpload/Post", BaseUrl)
        
        static let AlbumAdd = String(format: "%@AlbumGalleryAdd/Post", BaseUrl)
        
        static let AlbumUpdate = String(format: "%@UserAlbumGalleryUpdate/Post", BaseUrl)
        
        static let AlbumDelete = String(format: "%@UserAlbumGalleryDelete/Get", BaseUrl)
        
        static let AlbumPhotoDelete = String(format: "%@UserAlbumPhotoDelete/Get", BaseUrl)
    }
    
    
    //Health History
    
    struct Condition
    {
        static let  ConditionList = String(format: "%@UserConditionList/Get", BaseUrl)
        
        static let  ConditionAdd = String(format: "%@UserConditionAdd/Get", BaseUrl)
        
        static let  ConditionEdit = String(format: "%@UserConditionUpdate/Get", BaseUrl)
        
        static let  ConditionDelete = String(format: "%@UserConditionDelete/Get", BaseUrl)
    }
    struct Surgery
    {
        static let  SurgeryList = String(format: "%@UserSurgeryList/Get", BaseUrl)
        
        static let  SurgeryAdd = String(format: "%@UserSurgeryAdd/Get", BaseUrl)
        
        static let  SurgeryEdit = String(format: "%@UserSurgeryEdit/Get", BaseUrl)
        
        static let  SurgeryDelete = String(format: "%@UserSurgeryDelete/Get", BaseUrl)
    }
    struct Medication
    {
        static let  MedicationList = String(format: "%@UserMedicationList/Get", BaseUrl)
        
        static let  MedicationAdd = String(format: "%@UserMedicationAdd/Get", BaseUrl)
        
        static let  MedicationEdit = String(format: "%@UserMedicationEdit/Get", BaseUrl)
        
        static let  MedicationDelete = String(format: "%@UserMedicationDelete/Get", BaseUrl)
    }
    
    struct Allergy
    {
        static let  AllergyList = String(format: "%@UserAllergyList/Get", BaseUrl)
        
        static let  AllergyAdd = String(format: "%@UserAllergyAdd/Get", BaseUrl)
        
        static let  AllergyEdit = String(format: "%@UserAllergyEdit/Get", BaseUrl)
        
        static let  AllergyDelete = String(format: "%@UserAllergyDelete/Get", BaseUrl)
    }
    
    struct Immunization
    {
        static let  ImmunizationList = String(format: "%@UserImmunizationList/Get", BaseUrl)
        
        static let  ImmunizationAdd = String(format: "%@UserImmunizationAdd/Get", BaseUrl)
        
        static let  ImmunizationEdit = String(format: "%@UserImmunizationEdit/Get", BaseUrl)
        
        static let  ImmunizationDelete = String(format: "%@UserImmunizationDelete/Get", BaseUrl)
        
    }
    
    struct FoodPlan
    {
        static let  FoodPlanList = String(format: "%@UserFoodPlanList/Get", BaseUrl)
        
        static let  FoodPlanAdd = String(format: "%@UserFoodPlanAdd/Get", BaseUrl)
        
        static let  FoodPlanEdit = String(format: "%@UserFoodPlanEdit/Get", BaseUrl)
        
        static let  FoodPlanDelete = String(format: "%@UserFoodPlanDelete/Get", BaseUrl)
    }
    
    struct Hospitalization
    {
        static let  HospitalizationList = String(format: "%@UserHospitalizationList/Get", BaseUrl)
        
        static let  HospitalizationAdd = String(format: "%@UserHospitalizationAdd/Get", BaseUrl)
        
        static let  HospitalizationEdit = String(format: "%@UserHospitalizationEdit/Get", BaseUrl)
        
        static let  HospitalizationDelete = String(format: "%@UserHospitalizationDelete/Get", BaseUrl)
        
    }
    
    struct Consultation
    {
        static let  ConsultationList =  String(format: "%@UserConsultationList/Get", BaseUrl)
        
        static let  ConsultationAdd = String(format: "%@UserConsultationAdd/Get", BaseUrl)
        
        static let  ConsultationEdit = String(format: "%@UserConsultationEdit/Get", BaseUrl)
        
        static let  ConsultationDelete = String(format: "%@UserConsultationDelete/Get", BaseUrl)
    }
    
    //Health Tracker
    
    struct Vitals
    {
        static let  VitalsList = String(format: "%@UserVitalList/Get", BaseUrl)
        
        static let  VitalsAdd = String(format: "%@UserVitalAdd/Get", BaseUrl)
        
        static let  VitalsEdit = String(format: "%@UserVitalUpdate/Get", BaseUrl)
        
        static let  VitalsDelete = String(format: "%@UserVitalDelete/Get", BaseUrl)
        
    }
    struct CBG
    {
        static let  CBGList = String(format: "%@UserCBGList/Get", BaseUrl)
        
        static let  CBGAdd = String(format: "%@UserCBGAdd/Get", BaseUrl)
        
        static let  CBGEdit = String(format: "%@UserCBGUpdate/Get", BaseUrl)
        
        static let  CBGDelete = String(format: "%@UserCBGDelete/Get", BaseUrl)
    }
    
    struct Hemoglobin
    {
        static let  HemoglobinList = String(format: "%@UserHemoglobinList/Get", BaseUrl)
        
        static let  HemoglobinAdd = String(format: "%@UserHemoglobinAdd/Get", BaseUrl)
        
        static let  HemoglobinEdit = String(format: "%@UserHemoglobinUpdate/Get", BaseUrl)
        
        static let  HemoglobinDelete = String(format: "%@UserHemoglobinDelete/Get", BaseUrl)
    }
    
    struct Hemogram
    {
        static let  HemogramList = String(format: "%@UserHemogramList/Get", BaseUrl)
        
        static let  HemogramAdd = String(format: "%@UserHemogramAdd/Get", BaseUrl)
        
        static let  HemogramEdit = String(format: "%@UserHemogramUpdate/Get", BaseUrl)
        
        static let  HemogramDelete = String(format: "%@UserHemogramDelete/Get", BaseUrl)
    }
    
    struct SerumElectrolytes
    {
        static let  SerumElectrolyteList = String(format: "%@UserSerumElectrolyteList/Get", BaseUrl)
        
        static let  SerumElectrolyteAdd = String(format: "%@UserSerumElectrolyteAdd/Get", BaseUrl)
        
        static let  SerumElectrolyteEdit = String(format: "%@UserSerumElectrolyteUpdate/Get", BaseUrl)
        
        static let  SerumElectrolyteDelete = String(format: "%@UserSerumElectrolyteDelete/Get", BaseUrl)
    }
    
    //Dcouments
    
    struct Document
    {
        static let  DocumentList = String(format: "%@UserDocumentList/Get", BaseUrl)
        
        static let  DocumentAdd = String(format: "%@UserDocumentAdd/Post", BaseUrl) 
        
        static let  DocumentEdit = String(format: "%@UserDocumentUpdate/Get", BaseUrl)
        
        static let  DocumentDelete = String(format: "%@UserDocumentDelete/Get", BaseUrl)
    }
    struct VetOnCall
    {
        static let  TimeSlotList = String(format: "%@TalkToVet/GetSelectDateTimeSlot/Get", BaseUrl)
        
        static let  MobileNoVerify = String(format: "%@TalkToVet/SendOTP/Get", BaseUrl)
        
        static let  GetOrderId = String(format: "%@TalkToVet/CreateNewTransaction/Post", BaseUrl)
        
        static let  VetOnCall = String(format: "%@TalkToVet/VetToCall/Post", BaseUrl)
        
        static let  VetOnCallList = String(format: "%@TalkToVet/Get", BaseUrl)
        
        static let  PostRedemptionLog = String(format: "%@ReferAndEarn/PostRedemptionLog/Post", BaseUrl)
        
    }
    
    struct PetCare
    {
        static let  petArticles = String(format: "%@PetCare/GetAllArticles", BaseUrl)
        
    }
    
}
