//
//  MyPetsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
import StoreKit
let imageCache = NSCache<AnyObject, AnyObject>()
class MyPetsModel: NSObject
{
    var isActive : Bool?
    var canDelete : Bool?
    var SharePetInfoId : String?
    var PetPrefixId : String?
    var OwnerId : NSNumber?
    var PrefixOwnerId : String?
    var OwnerName : String?
    var OwnerInfoPath : String?
    var OwnerFirstName : String?
    var OwnerLastName : String?
    var PetVaccineName : String?
    var DueDate : String?
    var VaccinationId : String?
    
    var shareId: Bool?
    var shareMedi: Bool?
    var shareCont: Bool?
    var shareVets: Bool?
    var shareGall: Bool?
    var canModId: Bool?
    var canModMedi: Bool?
    var canModCont: Bool?
    var canModVet: Bool?
    var canModGall: Bool?
    
    var petId : NSNumber?
    var petName : String?
    var petType : String?
    var breed : String?
    var secBreed : String?
    var pedigree : String?
    var bloodType : String?
    var chipNo : String?
    var tattooNo : String?
    var genderId : NSNumber?
    var gender : String?
    var adoptDate : String?
    var dob : String?
    var pob : String?
    var country : String?
    var countryId : String?
    var state : String?
    var stateId : String?
    var zip : String?
    var hairType : String?
    var color : String?
    var secColor : String?
    var sterile : String?
    var imagePath : String?
    var coverImage : String?
    var petTypeId: NSNumber?
    var bloodTypeId: String?
    var hairTypeId: String?
    var colorId: String?
    var secColorId: String?
    var isInSmo: String?
    var tagNo: String?
    var tagType: String?
    var tagExp: String?
    var customPetType: String?
    var canAccessMedRec: Bool?
    var otherHairType: String?
    var otherColorType: String?
    var otherSecColorType: String?
    
    init?(IsActive: Bool?, canDelete: Bool?, SharePetInfoId : String?, PetPrefixId : String?, OwnerId : NSNumber?, PrefixOwnerId : String?, OwnerName : String?, OwnerInfoPath : String?, OwnerFirstName : String?, OwnerLastName : String?, PetVaccineName : String?, DueDate : String?, VaccinationId : String?, petId: NSNumber?, petName: String, petType : String, breed : String?, secBreed : String?, pedigree : String?, bloodType : String?, chipNo : String?, tattooNo : String?, genderId : NSNumber?, gender : String?, adoptDate : String?, dob : String?, pob : String?, country : String?, countryId : String?, state : String?, stateId : String?, zip : String?, hairType : String?, color : String?, sterile : String?, imagePath : String?, coverImage : String? ,petTypeId: NSNumber?, bloodTypeId: String?, hairTypeId: String?, colorId: String?, secColorId: String?, isInSmo: String?, tagNo: String?,tagType: String?,tagExp: String?, customPetType: String?, shareId: Bool?, shareMedi: Bool?, shareCont: Bool?, shareVets: Bool?, shareGall: Bool?, canModId: Bool?, canModMedi: Bool?, canModCont: Bool?, canModVet: Bool?, canModGall: Bool?, secColor : String?, canAccessMedRec: Bool?, otherHairType: String?, otherColorType: String?, otherSecColorType: String?)
    {
        
        self.isActive=IsActive
        self.canDelete=canDelete
        self.SharePetInfoId=SharePetInfoId
        self.PetPrefixId=PetPrefixId
        self.OwnerId=OwnerId
        self.PrefixOwnerId=PrefixOwnerId
        self.OwnerName=OwnerName
        self.OwnerInfoPath=OwnerInfoPath
        self.OwnerFirstName=OwnerFirstName
        self.OwnerLastName=OwnerLastName
        self.PetVaccineName=PetVaccineName
        self.DueDate=DueDate
        self.VaccinationId=VaccinationId
        
        self.petId=petId
        self.petName=petName
        self.petType=petType
        self.breed=breed
        self.secBreed=secBreed
        self.pedigree=pedigree
        self.bloodType=bloodType
        self.chipNo=chipNo
        self.tattooNo=tattooNo
        self.genderId=genderId
        self.gender=gender
        self.adoptDate=adoptDate
        self.dob=dob
        self.pob=pob
        self.country=country
        self.countryId=countryId
        self.state=state
        self.stateId=stateId
        self.zip=zip
        self.hairType=hairType
        self.color=color
        self.secColor = secColor
        self.sterile=sterile
        self.imagePath=imagePath
        self.coverImage=coverImage
        self.petTypeId = petTypeId
        self.bloodTypeId = bloodTypeId
        self.hairTypeId = hairTypeId
        self.colorId = colorId
        self.secColorId = secColorId
        self.isInSmo = isInSmo
        self.tagNo = tagNo
        self.tagType = tagType
        self.tagExp = tagExp
        self.customPetType = customPetType
        self.canAccessMedRec = canAccessMedRec
        self.otherHairType = otherHairType
        self.otherColorType = otherColorType
        self.otherSecColorType = otherSecColorType
        
        self.shareId = shareId
        self.shareMedi = shareMedi
        self.shareCont = shareCont
        self.shareVets = shareVets
        self.shareGall = shareGall
        self.canModId = canModId
        self.canModMedi = canModMedi
        self.canModCont = canModCont
        self.canModVet = canModVet
        self.canModGall = canModGall
        
    }
}

class MyPetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var mineShared: UISegmentedControl!
    var noDataLbl: UILabel?
    var patientID: String = ""
    var petListArray = [Any]()
    var petModelList = [MyPetsModel]()
    var prefs: UserDefaults?
    @IBOutlet weak var petListTbl: UITableView!
    @IBOutlet weak var splashScreen: UIImageView!
    @IBOutlet weak var enterBtn: UIButton!
    var selectedPet: MyPetsModel?
    var isFromNS : Bool = false
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var step2: UIButton!
    @IBOutlet weak var step3: UIButton!
    @IBOutlet weak var step1Lbl: UILabel!
    var senderId: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .done, target: self, action: nil)
        leftItem?.title = ""
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus.png"), style: .done, target: self, action: #selector(self.rightClk2))
        navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.font = UIFont.systemFont(ofSize: 17.0)
        noDataLbl?.numberOfLines = 1
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text =  "No pets found.\n Tap on '+' to add a Pet"
        noDataLbl?.textAlignment = .center
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.center = self.view.center
        self.mineShared.addTarget(self, action: #selector(self.showSharedPets), for: .valueChanged)
        self.splashScreen.isHidden = true
        self.enterBtn.isHidden = true
        self.offerView.isHidden = true
        let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
        if centerId as? Int == 57
        {
            if self.isFromNS == true
            {
                self.navigationController?.isNavigationBarHidden = true
                self.splashScreen.isHidden = false
                self.enterBtn.isHidden = false
            }
            else
            {
                self.navigationController?.isNavigationBarHidden = false
                self.splashScreen.isHidden = true
                self.enterBtn.isHidden = true
            }
        }
        else
        {
            if UserDefaults.standard.bool(forKey: "IsEmailVerified") == false && UserDefaults.standard.bool(forKey: "IsPhoneVerified") == false && UserDefaults.standard.string(forKey: "UserEmail") != "" && UserDefaults.standard.string(forKey: "UserEmail") != nil && UserDefaults.standard.string(forKey: "UserEmail")?.count != 0 && UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" && UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil && UserDefaults.standard.string(forKey: "UserPhoneNumber")?.count != 0
            {
                let alert = UIAlertController(title: "Verification!", message: "Your email and mobile number are not verified with Activ4Pets.\n Please verify them for further communications.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                    destViewController?.isFromVC = true
                    self.navigationController?.pushViewController(destViewController!, animated: true)
                    
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            else if UserDefaults.standard.bool(forKey: "IsEmailVerified") == false && UserDefaults.standard.string(forKey: "UserEmail") != "" && UserDefaults.standard.string(forKey: "UserEmail") != nil && UserDefaults.standard.string(forKey: "UserEmail")?.count != 0
            {
                let alert = UIAlertController(title: "Verification!", message: "Your email is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                    destViewController?.isFromVC = true
                    self.navigationController?.pushViewController(destViewController!, animated: true)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            else if UserDefaults.standard.bool(forKey: "IsPhoneVerified") == false && UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" && UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil && UserDefaults.standard.string(forKey: "UserPhoneNumber")?.count != 0
            {
                let alert = UIAlertController(title: "Verification!", message: "Your mobile number is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                    destViewController?.isFromVC = true
                    self.navigationController?.pushViewController(destViewController!, animated: true)
                })
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            else
            {
                let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as! Int
                if appOpenCount > 5
                {
                    
                    if #available(iOS 10.3, *)
                    {
                        SKStoreReviewController.requestReview()
                    }
                    else
                    {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        popUpView.clipsToBounds = true
        popUpView.layer.borderWidth = 2.0
        popUpView.layer.borderColor = UIColor(red: 92.0 / 255.0, green: 59.0 / 255.0, blue: 146.0 / 255.0, alpha: 1).cgColor
        let isShown: Bool = UserDefaults.standard.bool(forKey: "PopUpMyPets")
        let step2Str = NSAttributedString(string: " Download your rebate form here!")
        let step3Str = NSAttributedString(string: "After purchasing Bravecto® mail in your rebate form and invoice, or submit them online here.")
        let text2 = NSMutableAttributedString(attributedString: step2Str)
        let text3 = NSMutableAttributedString(attributedString: step3Str)
        text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 27, length: 4))
        text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 87, length: 4))
        let step1str = NSAttributedString(string: "Visit your veterinarian to get more information about Bravecto®")
        step1Lbl.attributedText = step1str
        step1Lbl.numberOfLines = 6
        step1Lbl.font = UIFont.systemFont(ofSize: 9.0)
        step1Lbl.textColor = UIColor.darkGray
        step1Lbl.lineBreakMode = .byTruncatingTail
        step2.titleLabel?.lineBreakMode = .byTruncatingTail
        step2.titleLabel?.numberOfLines = 4
        step2.titleLabel?.adjustsFontSizeToFitWidth = true
        step2.titleLabel?.textColor = UIColor.darkGray
        step2.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
        step2.setAttributedTitle(text2, for: .normal)
        step3.titleLabel?.lineBreakMode = .byTruncatingTail
        step3.titleLabel?.numberOfLines = 10
        step3.titleLabel?.adjustsFontSizeToFitWidth = true
        step3.titleLabel?.textColor = UIColor.darkGray
        step3.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
        step3.setAttributedTitle(text3, for: .normal)
        
        if isShown {
            
        }
        else {
            // getPopupCount()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mineShared.selectedSegmentIndex = 0
        checkInternetConnection()
    }
    @IBAction func hideSplash(_ sender: UIButton)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.splashScreen.isHidden = true
        self.enterBtn.isHidden = true
        if UserDefaults.standard.bool(forKey: "IsEmailVerified") == false && UserDefaults.standard.bool(forKey: "IsPhoneVerified") == false && UserDefaults.standard.string(forKey: "UserEmail") != "" && UserDefaults.standard.string(forKey: "UserEmail") != nil && UserDefaults.standard.string(forKey: "UserEmail")?.count != 0 && UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" && UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil && UserDefaults.standard.string(forKey: "UserPhoneNumber")?.count != 0
        {
            let alert = UIAlertController(title: "Alert!", message: "Your email and mobile number are not verified with Activ4Pets.\n Please verify them for further communications.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                destViewController?.isFromVC = true
                self.navigationController?.pushViewController(destViewController!, animated: true)
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        else if UserDefaults.standard.bool(forKey: "IsEmailVerified") == false && UserDefaults.standard.string(forKey: "UserEmail") != "" && UserDefaults.standard.string(forKey: "UserEmail") != nil && UserDefaults.standard.string(forKey: "UserEmail")?.count != 0
        {
            let alert = UIAlertController(title: "Alert!", message: "Your email is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                destViewController?.isFromVC = true
                self.navigationController?.pushViewController(destViewController!, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        else if UserDefaults.standard.bool(forKey: "IsPhoneVerified") == false && UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" && UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil && UserDefaults.standard.string(forKey: "UserPhoneNumber")?.count != 0
        {
            let alert = UIAlertController(title: "Alert!", message: "Your mobile number is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Verify", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let destViewController = storyboard13.instantiateViewController(withIdentifier: "myaccount") as? MyProfileViewController
                destViewController?.isFromVC = true
                self.navigationController?.pushViewController(destViewController!, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        else
        {
            let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as! Int
            //let isShownReview = UserDefaults.standard.bool(forKey: "ReviewShown")
            if appOpenCount > 5 //&& isShownReview == false
            {
                //                let alert = UIAlertController(title: "Rate Our App", message: "Please take a moment to rate our app if it's helping you and your furry friend.", preferredStyle: .alert)
                //                let rate = UIAlertAction(title: "Rate", style: .default, handler: {(action: UIAlertAction) -> Void in
                //                    UserDefaults.standard.set(true, forKey: "ReviewShown")
                //                    UserDefaults.standard.synchronize()
                //                    let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=954829197"
                //                    if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url)
                //                    {
                //                        if #available(iOS 10.0, *)
                //                        {
                //                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //                        }
                //                        else
                //                        {
                //                            UIApplication.shared.openURL(url)
                //                        }
                //                    }
                //                })
                //                let send = UIAlertAction(title: "Send Feedback", style: .default, handler: {(action: UIAlertAction) -> Void in
                //                    UserDefaults.standard.set(true, forKey: "ReviewShown")
                //                    UserDefaults.standard.synchronize()
                //                    let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=954829197"
                //                    if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url)
                //                    {
                //                        if #available(iOS 10.0, *) {
                //                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //                        } else {
                //                            UIApplication.shared.openURL(url)
                //                        }
                //                    }
                //                })
                //                let notnow = UIAlertAction(title: "Not Now", style: .default, handler: {(action: UIAlertAction) -> Void in
                //                    UserDefaults.standard.set(true, forKey: "ReviewShown")
                //                    UserDefaults.standard.synchronize()
                //                    let date = Date()
                //                    let df = DateFormatter()
                //                    df.dateFormat = "MM/dd/yyyy"
                //                    let dateStr = df.string(from: date)
                //                    UserDefaults.standard.set(dateStr, forKey: "ShownDate")
                //                    UserDefaults.standard.synchronize()
                //                })
                //                alert.addAction(rate)
                //                alert.addAction(send)
                //                alert.addAction(notnow)
                //                self.present(alert, animated: true, completion: nil)
                if #available(iOS 10.3, *)
                {
                    SKStoreReviewController.requestReview()
                }
                else
                {
                    // Fallback on earlier versions
                }
            }
        }
        
    }
    @objc func showSharedPets(_ sender: UISegmentedControl)
    {
        if  sender.selectedSegmentIndex == 0
        {
            print("Self")
        }
        else
        {
            self.performSegue(withIdentifier: "Shared", sender: nil)
        }
    }
    override func viewDidLayoutSubviews()
    {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.x != 0 {
            var offset: CGPoint = scrollView.contentOffset
            offset.x = 0
            scrollView.contentOffset = offset
        }
    }
    
    func leftClk(sender: AnyObject)
    {
        for controller: UIViewController in (self.navigationController?.viewControllers)!
        {
            if (controller is HomePageViewController)
            {
                _ = self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func getPopupCount()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d",userId,12,1)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.GetCount,str)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let str = String(data: data, encoding: .utf8),
                    let count: Int = Int(str)
                {
                    DispatchQueue.main.async
                        {
                            if count > 0
                            {
                                self.offerView.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else {
                                self.callOpenPopupAPI()
                                self.offerView.isHidden = false
                                self.noDataLbl?.isHidden = true
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callOpenPopupAPI()
    {
        let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date: String = formater.string(from: Date())
        var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",userId,12,1,"Open","IOS",date)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format: "%@?%@",API.MerkNotification.OpenPopUP,str)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let status = json?["Status"] as? Int
            {
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            let dict:[String: Any] = json?["Message"] as! [String : Any]
                            self.senderId = dict["Id"] as! Int
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    }
    @IBAction func closePopup(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%@&Platform=%@&ActionDate=%@",self.senderId,userId,12,1,"Close","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.offerView.isHidden = true
                                UserDefaults.standard.set(true, forKey: "PopUpMyPets")
                                UserDefaults.standard.synchronize()
                                if self.petModelList.count > 0 {
                                    self.noDataLbl?.isHidden = true
                                }
                                else {
                                    self.noDataLbl?.isHidden = false
                                }
                                
                            }
                            else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callClickPopupAPI()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,1,"Download","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"))!)
                                }
                                
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    @IBAction func popupClick(_ sender: UIButton)
    {
        callClickPopupAPI()
    }
    
    @IBAction func openClick(_ sender: UIButton)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,1,"IOS-App","ClickRewards")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                }
                                
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
        
    }
    
    @IBAction func callWebLink(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,1,"IOS-App","ClickHome")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://us.bravecto.com"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://us.bravecto.com"))!)
                                }
                                
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
        
    }
    
    // MARK: -
    // MARK: Logout pressed
    
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func rightClk2(sender: AnyObject)
    {
        self.performSegue(withIdentifier: "AddPet", sender: nil)
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.petModelList = []
            self.getMaxPetCountCount()
            
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getMaxPetCountCount()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.Owner.MaxPetCount, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let queryDic = json
            {
                DispatchQueue.main.async
                    {
                        let str: String = queryDic["Message"] as! String
                        
                        UserDefaults.standard.set(str, forKey: "MaxPetCount")
                        UserDefaults.standard.synchronize()
                        self.webServiceToGetpetList()
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    func webServiceToGetpetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?PatientId=%@", API.Owner.PetList, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let queryDic = json?["PetsList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            if self.senderId == 0
                            {
                                self.noDataLbl?.isHidden = false
                                self.petListTbl.reloadData()
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = true
                            }
                            UserDefaults.standard.set(true, forKey: "ZeroPetList")
                            UserDefaults.standard.synchronize()
                            let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
                            self.navigationItem.rightBarButtonItem = rightItem1
                            let rightItem2 = UIBarButtonItem(image: UIImage(named: "plus.png"), style: .done, target: self, action: #selector(self.rightClk2))
                            self.navigationItem.rightBarButtonItems = [rightItem1, rightItem2]
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            for item in queryDic
                            {
                                var prunedDictionary = [String: Any]()
                                for key: String in item.keys
                                {
                                    if !(item[key] is NSNull) {
                                        prunedDictionary[key] = item[key]
                                    }
                                    else
                                    {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                print(prunedDictionary)
                                filtered.append(prunedDictionary)
                            }
                            UserDefaults.standard.set(false, forKey: "ZeroPetList")
                            UserDefaults.standard.synchronize()
                            //  self.vetModelList = [VetModel]()
                            for item in filtered
                            {
                                let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : (item["PetType"] as? String)!, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["DateofBirth"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["ImagePath"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false,secColor : item["SecondaryColor"] as? String, canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                                
                                
                                self.petModelList.append(MyPets!)
                            }
                            
                            self.noDataLbl?.isHidden = true
                            let str: String = UserDefaults.standard.string(forKey: "MaxPetCount")!
                            if Int(str) == self.petModelList.count
                            {
                                var rightItem1: UIBarButtonItem?
                                rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
                                self.navigationItem.rightBarButtonItems = [rightItem1!]
                            }
                            else if self.petModelList.count > Int(str)!
                            {
                                var rightItem1: UIBarButtonItem?
                                rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
                                self.navigationItem.rightBarButtonItems = [rightItem1!]
                            }
                            else if self.petModelList.count < Int(str)!
                            {
                                let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
                                self.navigationItem.rightBarButtonItem = rightItem1
                                let rightItem2 = UIBarButtonItem(image: UIImage(named: "plus.png"), style: .done, target: self, action: #selector(self.rightClk2))
                                self.navigationItem.rightBarButtonItems = [rightItem1, rightItem2]
                            }
                            self.petListTbl.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return petModelList.count > 0 ? petModelList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPets", for: indexPath) as!  MyPetsTableViewCell
        cell.petImage.image = nil
        cell.petImage.layer.cornerRadius = 35
        cell.petImage.clipsToBounds = true
        let pets = self.petModelList[indexPath.row]
        if pets.petType == "Other"
        {
            cell.petType.text = pets.petType! + String(format: "(%@)", pets.customPetType!)
        }
        else
        {
            cell.petType.text = pets.petType
        }
        cell.petName.text = pets.petName
        cell.dob.text = pets.dob
        cell.gender.text = pets.gender
        cell.shareBtn.isHidden = false
        cell.shareBtn.tag = Int(truncating: pets.petId!)
        //print(pets.imagePath)
        cell.shareBtn.addTarget(self, action: #selector(self.viewMenuClk), for: .touchUpInside)
        //        var petImageString: String = (pets.imagePath)!
        //        petImageString = petImageString.trimmingCharacters(in: CharacterSet.whitespaces)
        //        petImageString = petImageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //        cell.petImage.sd_setImage(with: NSURL(string: petImageString)! as URL!, placeholderImage: UIImage(named: "petImage-default.png")!, options: SDWebImageOptions(rawValue: 1))
        cell.petImage.imageFromServerURL(urlString: (pets.imagePath)!, defaultImage: "petImage-default.png")
        
        //        let cacheKey = indexPath.row
        //        if(imageCache.object(forKey: cacheKey as AnyObject) != nil)
        //        {
        //            cell.petImage.image = imageCache.object(forKey: cacheKey as AnyObject) as? UIImage
        //        }
        //        else
        //        {
        //             DispatchQueue.global(qos: .background).async
        //                           {
        //                if let url = NSURL(string: (pets.imagePath)!) {
        //                    if let data = NSData(contentsOfURL: url as URL) {
        //                        let image: UIImage = UIImage(data: data)!
        //                        imageCache.setObject(image, forKey: cacheKey as AnyObject)
        //                        dispatch_async(dispatch_get_main_queue(), {
        //                            cell.petImage.image = image
        //                        })
        //                    }
        //                }
        //            }
        //        }
        
        //        var petImageUrl: String =  (pets.imagePath)!
        //        petImageUrl = petImageUrl.trimmingCharacters(in: CharacterSet.whitespaces)
        //        petImageUrl = petImageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //        if let url = NSURL(string: petImageUrl)
        //        {
        //            if let data = NSData(contentsOf: url as URL)
        //            {
        //                cell.petImage.image = UIImage(data: data as Data)
        //            }
        //            else
        //            {
        //                cell.petImage.image = UIImage(named: "petImage-default.png")
        //            }
        //        }
        //        else
        //        {
        //            cell.petImage.image = UIImage(named: "petImage-default.png")
        //        }
        return cell
        
    }
    @objc func viewMenuClk(sender: AnyObject)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.petListTbl)
        let indexPath = self.petListTbl.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            self.selectedPet = self.petModelList[(indexPath?.row)!]
            UserDefaults.standard.set(self.selectedPet?.petId, forKey: "SelectedPet")
            UserDefaults.standard.set(self.selectedPet?.petName, forKey: "SelectedPetName")
            UserDefaults.standard.set(self.selectedPet?.petId, forKey: "SelectedPet")
            UserDefaults.standard.set(self.selectedPet?.imagePath, forKey: "PetProfile")
            UserDefaults.standard.set(self.selectedPet?.bloodType, forKey: "PetBlood")
            UserDefaults.standard.set(self.selectedPet?.dob, forKey: "PetDob")
            UserDefaults.standard.set(self.selectedPet?.gender, forKey: "PetGender")
            UserDefaults.standard.set(self.selectedPet?.petName, forKey: "PetName")
            UserDefaults.standard.set(self.selectedPet?.petType, forKey: "PetType")
            UserDefaults.standard.set(self.selectedPet?.customPetType, forKey: "PetTypeOther")
            
            UserDefaults.standard.set(self.selectedPet?.isInSmo, forKey: "SMO")
            UserDefaults.standard.set(false, forKey: "SharedPet")
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.synchronize()
            print("\(String(describing:  self.selectedPet?.petId))")
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shared = UIAlertAction(title: "Share", style: .default, handler: {(action: UIAlertAction) -> Void in
            let shared: SharedPetsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SharedPets") as! SharedPetsListViewController
            self.navigationController?.pushViewController(shared, animated: true)
        })
        let medical = UIAlertAction(title: "Medical Summary", style: .default, handler: {(action: UIAlertAction) -> Void in
            print("\(String(describing: self.selectedPet?.petName))")
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            self.navigationController?.pushViewController(medical, animated: true)
            
        })
        let remove = UIAlertAction(title: "Remove", style: .default, handler: {(action: UIAlertAction) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
                self.callPetDeleteMethod()
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Vet Online", style: .cancel, handler: {(action: UIAlertAction) -> Void in
            let online: OnlineChoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "OnlineChoice") as! OnlineChoiceVC
            self.navigationController?.pushViewController(online, animated: true)
        })
        alert.addAction(shared)
        alert.addAction(medical)
        if self.selectedPet?.isInSmo == "1"
        {
            
        }
        else
        {
            alert.addAction(remove)
        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
    }
    func callPetDeleteMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?PetId=%@",API.Pet.DeletePet, (self.selectedPet?.petId)!)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Pet has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.checkInternetConnection()
                        })
                        
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            task.resume()
            
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let pet = petModelList[indexPath.row]
        UserDefaults.standard.set(pet.petId, forKey: "SelectedPet")
        UserDefaults.standard.set(pet.imagePath, forKey: "PetProfile")
        UserDefaults.standard.set(pet.bloodType, forKey: "PetBlood")
        UserDefaults.standard.set(pet.dob, forKey: "PetDob")
        UserDefaults.standard.set(pet.gender, forKey: "PetGender")
        UserDefaults.standard.set(pet.petName, forKey: "PetName")
        UserDefaults.standard.set(pet.petType, forKey: "PetType")
        UserDefaults.standard.set(pet.customPetType, forKey: "PetTypeOther")
        UserDefaults.standard.set(pet.isInSmo, forKey: "SMO")
        UserDefaults.standard.set(false, forKey: "SharedPet")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "petdetails", sender: pet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "petdetails")
        {
            let destination = segue.destination as! PetDetailsViewController
            destination.petInfo = sender as? MyPetsModel
        }
        else if(segue.identifier == "AddPet")
        {
            let add = segue.destination as! AddEditPetViewController
            add.isFromVC = false
        }
        else
        {
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webserviceToCallandStoreDropdowns()
    {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
