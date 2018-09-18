//
//  MyProfileViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
import StoreKit
class MyProfileModel: NSObject
{
    var userId: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var birthDate: String?
    var gender: String?
    var genderId: String?
    var email: String
    var timeZone: String
    var timeZoneId: String
    var isSearchable: Bool?
    var address1: String?
    var address2: String?
    var city: String?
    var country: String?
    var countryId: String?
    var state: String?
    var stateId: String?
    var zip: String?
    var primary: String?
    var secondary: String?
    var createDate: String
    var clientId: String?
    var profilePic: String?
    var emailVerified: Bool?
    var mobileVerified: Bool?
    var changeEmail: String?
    
    init?(userId: String, firstName : String, middleName : String?, lastName : String, birthDate : String?, gender : String?, genderId : String?, email : String, timeZone : String, timeZoneId : String, isSearchable : Bool?, address1 : String?, address2 : String?, city: String?, country: String?, countryId: String?, state : String?, stateId : String?, zip : String?, primary : String?, secondary : String?, createDate : String, clientId: String?, profilePic: String?,emailVerified: Bool?, mobileVerified: Bool?, changeEmail: String? )
    {
        
        self.userId = userId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.birthDate = birthDate
        self.gender = gender
        self.genderId = genderId
        self.email = email
        self.timeZone = timeZone
        self.timeZoneId = timeZoneId
        self.isSearchable = isSearchable
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.country = country
        self.countryId = countryId
        self.state = state
        self.stateId = stateId
        self.zip = zip
        self.primary = primary
        self.secondary = secondary
        self.createDate = createDate
        self.clientId = clientId
        self.profilePic = profilePic
        self.emailVerified = emailVerified
        self.mobileVerified = mobileVerified
        self.changeEmail = changeEmail
        
    }
}

extension UIImageView
{
    public func imageFromServerURL(urlString: String, defaultImage : String?)
    {
        if let di = defaultImage {
            self.image = UIImage(named: di)
        }
        
        URLSession.shared.dataTask(with: URL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if image != nil
                {
                    self.image = image
                }
                else
                {
                    self.image = UIImage(named: defaultImage!)
                }
                MBProgressHUD.hide(for: self, animated: true)
                
            })
            
        }).resume()
    }
}
class MyProfileViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var profileScroll:UIScrollView!
    @IBOutlet weak var userId:UILabel!
    @IBOutlet weak var dob:UILabel!
    @IBOutlet weak var gender:UILabel!
    @IBOutlet weak var email:UILabel!
    @IBOutlet weak var timeZone:UILabel!
    @IBOutlet weak var address1:UILabel!
    @IBOutlet weak var address2:UILabel!
    @IBOutlet weak var city:UILabel!
    @IBOutlet weak var country:UILabel!
    @IBOutlet weak var state:UILabel!
    @IBOutlet weak var zip:UILabel!
    @IBOutlet weak var primary:UILabel!
    @IBOutlet weak var second:UILabel!
    @IBOutlet weak var createDate:UILabel!
    @IBOutlet weak var clientAcId:UILabel!
    @IBOutlet weak var inSearch:UILabel!
    @IBOutlet weak var fullName:UILabel!
    @IBOutlet weak var profilePic:UIImageView!
    @IBOutlet weak var prfileSettingsSeg:UISegmentedControl!
    @IBOutlet weak var emailVerified: UIButton!
    @IBOutlet weak var mobileVerified: UIButton!
    @IBOutlet weak var verifyMobile: UIButton!
    @IBOutlet weak var verifyEmail: UIButton!
    @IBOutlet weak var emailRightSpace: NSLayoutConstraint!
    @IBOutlet weak var mobileRightSpace: NSLayoutConstraint!
    
    @IBOutlet weak var emailBotSpace: NSLayoutConstraint!
    @IBOutlet weak var mobileBotSpace: NSLayoutConstraint!
    
    @IBOutlet weak var changeEmailTopSpace: NSLayoutConstraint!//86
    @IBOutlet weak var changeEmailLbl:UILabel!
    @IBOutlet weak var changeEmail:UILabel!
    @IBOutlet weak var changeTxtLbl:UILabel!
    @IBOutlet weak var resendLink: UIButton!
    var isChangeEmail: Bool = false
    var model: MyProfileModel?
    var isFromVC: Bool = false
    
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var passcode1: UITextField!
    @IBOutlet weak var passcode2: UITextField!
    @IBOutlet weak var passcode3: UITextField!
    @IBOutlet weak var passcode4: UITextField!
    @IBOutlet weak var passcode5: UITextField!
    @IBOutlet weak var passcode6: UITextField!
    //    @IBOutlet weak var resend: UIButton!
    //    @IBOutlet weak var verify: UIButton!
    
    @IBOutlet weak var changeView: UIView!
    @IBOutlet weak var changeEmailMobileTxtField: UITextField!
    var changeViewEmail: Bool = false
    var changeViewMobile: Bool = false
    @IBOutlet weak var changeViewTxtLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    var textFld: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //                if #available(iOS 10.3, *) {
        //                    SKStoreReviewController.requestReview()
        //                } else {
        //                    // Fallback on earlier versions
        //                }
        self.popUpView.isHidden = true
        self.changeView.isHidden = true
        self.verifyMobile.isHidden = true
        self.verifyEmail.isHidden = true
        self.emailVerified.isHidden = true
        self.mobileVerified.isHidden = true
        self.emailRightSpace.constant = 10
        self.mobileRightSpace.constant = 10
        self.emailBotSpace.constant = 15
        self.mobileBotSpace.constant = 15
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        rightItem2 = UIBarButtonItem(image: UIImage(named: "ic_edit")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightClk2))
        navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        
        self.prfileSettingsSeg?.addTarget(self, action: #selector(self.selectProfileSettings), for: .valueChanged)
        if self.isFromVC == false
        {
            
        }
        self.changeEmailTopSpace.constant = -1
        self.changeTxtLbl.isHidden = true
        self.changeEmailLbl.isHidden = true
        self.changeEmail.isHidden = true
        self.resendLink.isHidden = true
        
        //        if UserDefaults.standard.bool(forKey: "IsEmailVerified") == false && UserDefaults.standard.string(forKey: "UserEmail") != "" && UserDefaults.standard.string(forKey: "UserEmail") != nil && UserDefaults.standard.string(forKey: "UserEmail")?.count != 0
        //        {
        //            self.verifyEmail.isHidden = false
        //            self.emailVerified.isHidden = true
        //            self.emailBotSpace.constant = 35
        //            self.emailRightSpace.constant = 10
        //        }
        //        else
        //        {
        //            self.verifyEmail.isHidden = true
        //            self.emailVerified.isHidden = false
        //            self.emailBotSpace.constant = 15
        //            self.emailRightSpace.constant = 35
        //        }
        //        if UserDefaults.standard.bool(forKey: "IsPhoneVerified") == false && UserDefaults.standard.string(forKey: "UserPhoneNumber") != "" && UserDefaults.standard.string(forKey: "UserPhoneNumber") != nil && UserDefaults.standard.string(forKey: "UserPhoneNumber")?.count != 0
        //        {
        //            self.verifyMobile.isHidden = false
        //            self.mobileVerified.isHidden = true
        //            self.mobileBotSpace.constant = 35
        //            self.mobileRightSpace.constant = 10
        //        }
        //        else
        //        {
        //            self.verifyMobile.isHidden = true
        //            self.mobileVerified.isHidden = false
        //            self.mobileBotSpace.constant = 15
        //            self.mobileRightSpace.constant = 35
        //        }
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func rightClk2(sender: AnyObject)
    {
        self.performSegue(withIdentifier: "EditProfile", sender: self.model)
    }
    @objc func selectProfileSettings (sender:UISegmentedControl)-> Void
    {
        if sender.selectedSegmentIndex==0
        {
            
        }
        else if sender.selectedSegmentIndex==1
        {
            self.performSegue(withIdentifier: "MyPlan", sender: nil)
        }
        else if sender.selectedSegmentIndex==2
        {
            self.performSegue(withIdentifier: "Settings", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.prfileSettingsSeg.selectedSegmentIndex = 0
        self.isChangeEmail = false
        self.startAuthenticatingUser()
    }
    func startAuthenticatingUser() -> Void
    {
        if CheckNetwork.isExistenceNetwork() {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.getDetails()
        }
        else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func getDetails() -> Void
    {
        
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@",API.Owner.MyProfile, userId)
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
                let queryDic = json?["myAccountDetails"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                print(queryDic)
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
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
                                    else {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                print(prunedDictionary)
                                filtered.append(prunedDictionary)
                            }
                            
                            for item in filtered
                            {
                                let profile = MyProfileModel(userId: item["UserId"] as! String, firstName : item["FirstName"] as! String, middleName : item["MiddleName"] as? String, lastName : item["LastName"] as! String, birthDate : item["BirthDate"] as? String, gender : item["GenderName"] as? String, genderId : item["GenderId"] as? String, email : item["Email"] as! String, timeZone : item["TimeZone"] as! String, timeZoneId : item["TimeZoneId"] as! String, isSearchable : item["IsNonSearchable"] as? Bool, address1 : item["Address1"] as? String, address2 : item["Address2"] as? String, city: item["City"] as? String, country: item["CountryName"] as? String, countryId: item["CountryId"] as? String, state : item["StateName"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, primary : item["PrimaryPhone"] as? String, secondary : item["SecondaryPhone"] as? String, createDate : item["CreationDate"] as! String, clientId: item["ShelterOwnerId"] as? String, profilePic: item["ProfilePicUrl"] as? String,emailVerified: item["VerifyByEmail"] as? Bool, mobileVerified: item["VerifyByPhone"] as? Bool, changeEmail: item["ChangeRequestEmail"] as? String)
                                self.model = profile
                            }
                            self.fullName.text = String(format: "%@ %@", (self.model?.firstName)!, (self.model?.lastName)!)
                            UserDefaults.standard.set(self.fullName.text, forKey: "UserName")
                            UserDefaults.standard.synchronize()
                            self.userId.text = "US" + (self.model?.userId)!
                            self.dob.text = self.model?.birthDate
                            if self.model?.genderId == "2"
                            {
                                self.gender.text = "Male"
                            }
                            else if self.model?.genderId == "1"
                            {
                                self.gender.text = "Female"
                            }
                            
                            self.email.text = self.model?.email
                            self.changeEmail.text = self.model?.changeEmail
                            if self.model?.emailVerified == true
                            {
                                UserDefaults.standard.set(true, forKey: "IsEmailVerified")
                                UserDefaults.standard.set(self.model?.email, forKey: "UserEmail")
                                UserDefaults.standard.synchronize()
                            }
                            if self.model?.mobileVerified == true
                            {
                                UserDefaults.standard.set(true, forKey: "IsEmailVerified")
                                UserDefaults.standard.synchronize()
                            }
                            if self.model?.isSearchable == true
                            {
                                self.inSearch.text = "YES"
                            }
                            else if self.model?.isSearchable == false
                            {
                                self.inSearch.text = "NO"
                            }
                            self.address1.text = self.model?.address1
                            self.address2.text = self.model?.address2
                            self.country.text = self.model?.country
                            self.state.text = self.model?.state
                            self.city.text = self.model?.city
                            self.zip.text = self.model?.zip
                            if self.model?.primary?.count == 10 && self.model?.primary != nil && self.model?.primary != ""
                            {
                                self.primary.text = self.arrangeUSFormat(strPhone: (self.model?.primary)!)
                                if self.model?.mobileVerified == true
                                {
                                    self.mobileRightSpace.constant = 35
                                    self.mobileBotSpace.constant = 15
                                    self.mobileVerified.isHidden = false
                                    self.verifyMobile.isHidden = true
                                }
                                else
                                {
                                    self.mobileRightSpace.constant = 10
                                    self.mobileBotSpace.constant = 35
                                    self.mobileVerified.isHidden = true
                                    self.verifyMobile.isHidden = false
                                    
                                }
                            }
                            else if self.model?.primary?.count == 14
                            {
                                self.primary.text = self.model?.primary
                                if self.model?.mobileVerified == true
                                {
                                    self.mobileRightSpace.constant = 35
                                    self.mobileBotSpace.constant = 15
                                    self.mobileVerified.isHidden = false
                                    self.verifyMobile.isHidden = true
                                }
                                else
                                {
                                    self.mobileRightSpace.constant = 10
                                    self.mobileBotSpace.constant = 35
                                    self.mobileVerified.isHidden = true
                                    self.verifyMobile.isHidden = false
                                }
                            }
                            if self.model?.secondary?.count == 10 && self.model?.secondary != nil && self.model?.secondary != ""
                            {
                                self.second.text = self.arrangeUSFormat(strPhone: (self.model?.secondary)!)
                            }
                            else{
                                self.second.text = self.model?.secondary
                            }
                            
                            self.createDate.text = self.model?.createDate
                            
                            self.clientAcId.text = self.model?.clientId
                            self.timeZone.text = self.model?.timeZone
                            if self.model?.email != "" && self.model?.email.count != 0 && self.model?.email != nil
                            {
                                if self.model?.emailVerified == true
                                {
                                    self.emailRightSpace.constant = 35
                                    self.emailBotSpace.constant = 15
                                    self.verifyEmail.isHidden = true
                                    self.emailVerified.isHidden = false
                                    
                                }
                                else
                                {
                                    self.emailRightSpace.constant = 10
                                    self.emailBotSpace.constant = 35
                                    self.verifyEmail.isHidden = false
                                    self.emailVerified.isHidden = true
                                }
                            }
                            if self.model?.changeEmail != nil && self.model?.changeEmail != ""
                            {
                                if self.model?.email == self.model?.changeEmail
                                {
                                    self.changeEmail.isHidden = true
                                    self.changeEmailLbl.isHidden = true
                                    self.changeTxtLbl.isHidden = true
                                    self.resendLink.isHidden = true
                                    self.changeEmailTopSpace.constant = -1
                                    
                                }
                                else
                                {
                                    self.changeEmail.isHidden = false
                                    self.changeEmailLbl.isHidden = false
                                    self.changeTxtLbl.isHidden = false
                                    self.resendLink.isHidden = false
                                    self.changeEmailTopSpace.constant = 86
                                }
                            }
                            else
                            {
                                self.changeEmail.isHidden = true
                                self.changeEmailLbl.isHidden = true
                                self.changeTxtLbl.isHidden = true
                                self.resendLink.isHidden = true
                                self.changeEmailTopSpace.constant = -1
                            }
                            //                    if self.model?.emailVerified == false && self.model?.mobileVerified == false && self.model?.primary?.count != 0 && self.model?.primary != nil && self.model?.primary != ""
                            //                    {
                            //                        let alert = UIAlertController(title: "Alert!", message: "Your email and mobile number are not verified with Activ4Pets.\n Please verify them for further communications.", preferredStyle: .alert)
                            //                        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                            //                            
                            //                        })
                            //                        alert.addAction(cancel)
                            //                        self.present(alert, animated: true)
                            //                    }
                            //                    else if self.model?.emailVerified == false
                            //                    {
                            //                        let alert = UIAlertController(title: "Alert!", message: "Your email is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
                            //                        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                            //                            
                            //                        })
                            //                        alert.addAction(cancel)
                            //                        self.present(alert, animated: true)
                            //                    }
                            //                    else if self.model?.mobileVerified == false && self.model?.primary?.count != 0 && self.model?.primary != nil && self.model?.primary != ""
                            //                    {
                            //                        let alert = UIAlertController(title: "Alert!", message: "Your mobile number is not verified with Activ4Pets.\n Please verify it for further communications.", preferredStyle: .alert)
                            //                        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                            //                            
                            //                        })
                            //                        alert.addAction(cancel)
                            //                        self.present(alert, animated: true)
                            //                    }
                            UserDefaults.standard.set((self.model?.profilePic)!, forKey: "ProfilePicUrl")
                            self.profilePic.imageFromServerURL(urlString: (self.model?.profilePic)!, defaultImage: "ic_user_prof")
                            //                    var petImageString: String = (self.model?.profilePic)!
                            //                        petImageString = petImageString.trimmingCharacters(in: CharacterSet.whitespaces)
                            //                        petImageString = petImageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                            //                        self.profilePic.sd_setImage(with: NSURL(string: petImageString)! as URL!, placeholderImage: UIImage(named: "profile-icon.png")!, options: SDWebImageOptions(rawValue: 1))
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
    func arrangeUSFormat(strPhone : String)-> String
    {
        var strUpdated = strPhone
        if strPhone.count == 10
        {
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
        }
        return strUpdated
    }
    @IBAction func verifyEmailAddress(_ sender: UIButton)
    {
        self.webServiceToGetVerificationLink()
    }
    @IBAction func verifyPhoneNumber(_ sender: UIButton)
    {
        self.webServiceToGetOTP()
    }
    @IBAction func resendEmailToUser(_ sender: UIButton)
    {
        self.isChangeEmail = true
        self.webServiceToGetVerificationLink()
    }
    func webServiceToGetOTP()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            
            let cultureName = UserDefaults.standard.object(forKey: "LangCode") as? String
            
            var countryCode: String = ""
            if cultureName == "en-US"
            {
                countryCode = "+1"
            }
            else if cultureName == "en-IN"
            {
                countryCode = "+91"
            }
            var str1: String = ""
            
            if self.changeViewMobile
            {
                str1 = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&process=%@&verifyThrough=%@", self.changeEmailMobileTxtField.text!, countryCode, "", "", "","verify","phone")
            }
            else
            {
                str1 = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&process=%@&verifyThrough=%@", (self.model?.primary)!, countryCode, "", "", "","verify","phone")
            }
            
            str1 = str1.trimmingCharacters(in: CharacterSet.whitespaces)
            str1 = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Login.SignUpOtp, str1)
            let requestUrl = URL(string: urlString)
            var request = URLRequest(url: requestUrl!)
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
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print(responseString ?? " ")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let str: String = json?["OTP"] as! String
                                var message: String = ""
                                if self.changeViewMobile
                                {
                                    self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + self.changeEmailMobileTxtField.text!
                                    message = String(format: "Verification code has been sent to %@ %@ successfully",countryCode,self.changeEmailMobileTxtField.text!)
                                }
                                else
                                {
                                    self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + self.primary.text!
                                    message = String(format: "Verification code has been sent to %@ %@ successfully",countryCode,self.primary.text!)
                                }
                                let alertDel = UIAlertController(title: nil, message: message  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    UserDefaults.standard.set(str, forKey: "OTP")
                                    UserDefaults.standard.synchronize()
                                    self.changeEmailMobileTxtField.text = ""
                                    self.popUpView.isHidden = false
                                    self.passcode1.becomeFirstResponder()
                                })
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
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
    @IBAction func verifyVerificationCode()
    {
        let enteredOtp: String = self.passcode1.text! + self.passcode2.text! + self.passcode3.text! + self.passcode4.text! + self.passcode5.text! + self.passcode6.text!
        let sentOtp = UserDefaults.standard.object(forKey: "OTP") as? String
        if enteredOtp == sentOtp
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var urlStr : String = ""
            var urlString: String = ""
            
            if self.changeViewMobile
            {
                var strNum = self.changeEmailMobileTxtField.text?.replacingOccurrences(of: "(", with: "")
                strNum = strNum?.replacingOccurrences(of: ") ", with: "")
                strNum = strNum?.replacingOccurrences(of: "-", with: "")
                urlStr = String(format : "userId=%@&changePhone=%@",userId,strNum!)
                urlString = API.Login.VerifyChangeMobileUserID
            }
            else
            {
                urlStr = String(format : "userId=%@",userId)
                urlString = API.Login.VerifyMobileNumberUserID
            }
            urlStr = urlStr.trimmingCharacters(in: CharacterSet.whitespaces)
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStringsent = String(format : "%@?%@", urlString, urlStr)
            let requestUrl = URL(string: urlStringsent)
            var request = URLRequest(url: requestUrl!)
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
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print(responseString ?? " ")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "Your mobile number has been verified succesfully." , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    self.popUpView.isHidden = true
                                    UserDefaults.standard.set(true, forKey: "IsPhoneVerified")
                                    UserDefaults.standard.synchronize()
                                    self.startAuthenticatingUser()
                                })
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
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
        else
        {
            self.passcode1.text = ""
            self.passcode2.text = ""
            self.passcode3.text = ""
            self.passcode4.text = ""
            self.passcode5.text = ""
            self.passcode6.text = ""
            let alertDel = UIAlertController(title: "Error!", message: "Invalid code\n Please enter valid verification code"  , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
    }
    @IBAction func resendVerificationCode()
    {
        self.passcode1.text = ""
        self.passcode2.text = ""
        self.passcode3.text = ""
        self.passcode4.text = ""
        self.passcode5.text = ""
        self.passcode6.text = ""
        
        self.webServiceToGetOTP()
    }
    @IBAction func changeMobileNumber()
    {
        self.popUpView.isHidden = true
        self.changeView.isHidden = false
        self.changeViewMobile = true
        self.changeViewEmail = false
        self.changeViewTxtLbl.text = "Change Mobile"
        self.changeEmailMobileTxtField.placeholder = "Mobile *"
        
    }
    @IBAction func cancelChangeMobileEmailView()
    {
        self.changeViewMobile = false
        self.changeViewEmail = false
        self.changeView.isHidden = true
        self.changeEmailMobileTxtField.resignFirstResponder()
    }
    @IBAction func changeViewChangeEmailPhone()
    {
        if self.changeEmailMobileTxtField.text == nil || self.changeEmailMobileTxtField.text == "" || self.changeEmailMobileTxtField.text?.count == 0
        {
            if self.changeViewMobile
            {
                let alertDel = UIAlertController(title: nil, message: "Mobile number is required", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
            }
            else if self.changeViewEmail
            {
                let alertDel = UIAlertController(title: nil, message: "Email is required", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
            }
        }
        else
        {
            if self.doValidationsForTextFields()
            {
                if self.changeViewMobile
                {
                    self.webServiceToCheckEmailPhone()
                    
                }
                else if self.changeViewEmail
                {
                    self.webServiceToCheckEmailPhone()
                }
            }
        }
    }
    func webServiceToGetVerificationLink()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var urlString : String = ""
            var urlStr: String = ""
            if self.isChangeEmail
            {
                urlString = String(format : "userId=%@&firstName=%@&lastName=%@&changeEmail=%@",userId,(self.model?.firstName)!, (self.model?.lastName)!, self.changeEmail.text!)
                urlStr = API.Login.VerifyChangeEmailUserID
            }
            else if self.changeViewEmail
            {
                urlString = String(format : "userId=%@&firstName=%@&lastName=%@&changeEmail=%@",userId,(self.model?.firstName)!, (self.model?.lastName)!, self.changeEmailMobileTxtField.text!)
                urlStr = API.Login.VerifyChangeEmailUserID
            }
            else
            {
                urlString = String(format : "userId=%@",userId)
                urlStr = API.Login.VerifyEmailUserID
            }
            
            urlString = urlString.trimmingCharacters(in: CharacterSet.whitespaces)
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let finalStr: String = String(format: "%@?%@", urlStr, urlString)
            let requestUrl = URL(string: finalStr)
            var request = URLRequest(url: requestUrl!)
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
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print(responseString ?? " ")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                if self.isChangeEmail
                                {
                                    let alertDel = UIAlertController(title: nil, message: "We have sent a verification link to " + self.changeEmail.text! +  "\n Please click on the link to verify your email." , preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                        self.startAuthenticatingUser()
                                    })
                                    let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        self.webServiceToGetVerificationLink()
                                    })
                                    
                                    
                                    alertDel.addAction(resend)
                                    alertDel.addAction(ok)
                                    
                                    self.present(alertDel, animated: true, completion: nil)
                                }
                                else  if self.changeViewEmail
                                {
                                    let alertDel = UIAlertController(title: nil, message: "We have sent a verification link to " + self.changeEmailMobileTxtField.text! +  "\n Please click on the link to verify your email." , preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                        
                                        self.startAuthenticatingUser()
                                    })
                                    let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        self.webServiceToGetVerificationLink()
                                    })
                                    
                                    
                                    alertDel.addAction(resend)
                                    alertDel.addAction(ok)
                                    
                                    self.present(alertDel, animated: true, completion: nil)
                                }
                                else
                                {
                                    let alertDel = UIAlertController(title: nil, message: "We have sent a verification link to " + (self.model?.email)! +  "\n Please click on the link to verify your email." , preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                    })
                                    let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        self.webServiceToGetVerificationLink()
                                    })
                                    let change = UIAlertAction(title: "Change Email", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        self.changeEmailInProfile()
                                    })
                                    
                                    alertDel.addAction(resend)
                                    alertDel.addAction(change)
                                    alertDel.addAction(ok)
                                    
                                    self.present(alertDel, animated: true, completion: nil)
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
    func changeEmailInProfile()
    {
        self.changeView.isHidden = false
        self.changeViewEmail = true
        self.changeViewMobile = false
        self.changeViewTxtLbl.text = "Change Email"
        self.changeEmailMobileTxtField.placeholder = "Email"
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == passcode1 || textField == passcode2 || textField == passcode3 || textField == passcode4 || textField == passcode5 || textField == passcode6
        {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donewithNumberPad))
            done.tag = textField.tag
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelNumberPad))
            cancel.tag = textField.tag
            numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
            numberToolbar.sizeToFit()
            self.textFld = textField
            textField.inputAccessoryView = numberToolbar
        }
        else if textField == self.changeEmailMobileTxtField
        {
            if self.changeViewMobile == true
            {
                let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
                numberToolbar.barStyle = .blackTranslucent
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donewithNumberPad))
                done.tag = textField.tag
                let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelNumberPad))
                cancel.tag = textField.tag
                numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
                numberToolbar.sizeToFit()
                self.textFld = textField
                textField.inputAccessoryView = numberToolbar
            }
        }
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem)
    {
        self.textFld?.resignFirstResponder()
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem)
    {
        self.textFld?.resignFirstResponder()
    }
    func webServiceToCheckEmailPhone()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            var str: String = ""
            if self.changeViewEmail
            {
                str = String(format: "emailId=%@&phoneNumber=%@",(self.changeEmailMobileTxtField?.text!)!, "")
            }
            else if self.changeViewMobile
            {
                str = String(format: "emailId=%@&phoneNumber=%@","", (self.changeEmailMobileTxtField?.text)!)
            }
            
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Login.CheckEmailPhone, str)
            let requestUrl = URL(string: urlString)
            var request = URLRequest(url: requestUrl!)
            request.allHTTPHeaderFields = headers
            request.httpMethod = "GET"
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
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                self.changeView.isHidden = true
                                if self.changeViewEmail
                                {
                                    self.webServiceToGetVerificationLink()
                                    
                                }
                                else if self.changeViewMobile
                                {
                                    self.webServiceToGetOTP()
                                }
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: json?["Message"] as? String  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.changeEmailMobileTxtField.text = nil
                                    //                                   self.changeViewMobile = false
                                    //                                    self.changeViewEmail = false
                                    
                                    
                                })
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
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
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == changeEmailMobileTxtField
        {
            if self.changeViewEmail
            {
                if textField.text?.count == 0
                {
                    print("email is correct...")
                }
                else
                {
                    let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                    if emailTest.evaluate(with: changeEmailMobileTxtField?.text) == false
                    {
                        textField.layer.borderColor = UIColor.red.cgColor
                    }
                    else
                    {
                        textField.layer.borderColor = UIColor.clear.cgColor
                        print("email is correct...")
                    }
                }
            }
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.changeEmailMobileTxtField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if self.popUpView.isHidden == false
        {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if (string.count ) > 0 && !Scanner(string: string).scanInt32(nil)
            {
                return false
            }
            if textField.text?.count == 0
            {
                perform(#selector(self.changeTextFieldFocus(toNextTextField:)), with: textField, afterDelay: 0.1)
            }
            let length: Int = (str.count )
            if length > 1 {
                return false
            }
        }
        if textField == self.changeEmailMobileTxtField
        {
            if self.changeViewMobile
            {
                let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                self.textFld = changeEmailMobileTxtField
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
        }
        return true
        
    }
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""
        {
            return true
        }
        else if str!.count < 3
        {
            if str!.count == 1
            {
                self.textFld?.text = "("
            }
        }
        else if str!.count == 5
        {
            self.textFld?.text = (self.textFld?.text!)! + ") "
        }
        else if str!.count == 10
        {
            self.textFld?.text = (self.textFld?.text!)! + "-"
        }
        else if str!.count > 14
        {
            return false
        }
        
        return true
    }
    
    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool
    {
        let shouldDelete = true
        if (textField.text?.count ?? 0) == 0 && (textField.text == "")
        {
            let tagValue: Int = textField.tag - 1
            let txtField = view.viewWithTag(tagValue) as? UITextField
            txtField?.becomeFirstResponder()
        }
        return shouldDelete
    }
    @objc func changeTextFieldFocus(toNextTextField textField: UITextField)
    {
        let tagValue: Int = textField.tag + 1
        let txtField = view.viewWithTag(tagValue) as? UITextField
        txtField?.becomeFirstResponder()
    }
    @objc func setNextResponder(_ nextResponder: UITextField)
    {
        nextResponder.becomeFirstResponder()
    }
    func doValidationsForTextFields() -> Bool
    {
        if self.changeViewMobile
        {
            let numberString : String = changeEmailMobileTxtField.text!
            let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
            let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
            if (numberTest.evaluate(with: numberString) != true)
            {
                navigationItem.rightBarButtonItem?.isEnabled = true
                changeEmailMobileTxtField.layer.borderColor = UIColor.red.cgColor
                let alertDel = UIAlertController(title: "Warning", message: "Enter correct mobile number", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                return false
            }
        }
        else if changeViewEmail
        {
            let emailString: String = changeEmailMobileTxtField.text!
            let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            if (emailTest.evaluate(with: emailString) != true)
            {
                navigationItem.rightBarButtonItem?.isEnabled = true
                changeEmailMobileTxtField.layer.borderColor = UIColor.red.cgColor
                let alertDel = UIAlertController(title: "Warning", message: "Enter correct email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "EditProfile"
        {
            let edit = segue.destination as! EditProfileViewController
            edit.model = sender as? MyProfileModel
            
        }
        else if segue.identifier == "MyPlan"
        {
            
        }
        else if segue.identifier == "Settings"
        {
            
        }
        
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
