//
//  EditProfileViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,  UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var model: MyProfileModel?
    
    var filterArr = [Any]()
    var listArr = [Any]()
    var dropDownType: String = ""
    var detailsDict = [String: Any]()
    var isSearchable: String = "false"
    var textFld: UITextField?
    var isImageSelected: Bool = false
    
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView?
    @IBOutlet weak var fstNameTxtfld: UITextField!
    @IBOutlet weak var lstNameTxtfld: UITextField!
    @IBOutlet weak var dobTxtfld: UITextField!
    @IBOutlet weak var genderTxtfld: UITextField!
    @IBOutlet weak var emailTxtfld: UITextField!
    @IBOutlet weak var timeZoneTxtfld: UITextField!
    @IBOutlet weak var address1Txtfld: UITextField!
    @IBOutlet weak var address2Txtfld: UITextField!
    @IBOutlet weak var cityTxtfld: UITextField!
    @IBOutlet weak var countryTxtfld: UITextField!
    @IBOutlet weak var stateTxtfld: UITextField!
    @IBOutlet weak var zipcodeTxtfld: UITextField!
    @IBOutlet weak var primaryTxtfld: UITextField!
    @IBOutlet weak var secondTxtfld: UITextField!
    @IBOutlet weak var clientAccountId: UITextField!
    @IBOutlet weak var midNameTxtFld: UITextField!
    @IBOutlet weak var isAppearIn: UISwitch!
    @IBOutlet weak var profilePic: UIImageView!
    var listTv: UIPickerView!
    var datePicker = UIDatePicker()
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var passcode1: UITextField!
    @IBOutlet weak var passcode2: UITextField!
    @IBOutlet weak var passcode3: UITextField!
    @IBOutlet weak var passcode4: UITextField!
    @IBOutlet weak var passcode5: UITextField!
    @IBOutlet weak var passcode6: UITextField!
    @IBOutlet weak var textLbl: UILabel!
    
    var isChangeEmail: Bool = false
    var isChangePhone: Bool = false
    var stateId: String = ""
    var stateCountryID: String = ""
    var countryId: String = ""
    var timeZoneId: String = ""
    var genderId: String = ""
    var imgPkrCon: UIImagePickerController?
    var base64ImgString: String = ""
    @IBOutlet weak var mandatoryLbl: UILabel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.popUpView.isHidden = true
        print("result", self.detailsDict)
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width: 0, height: 220))
        self.listTv.delegate = self
        self.listTv.dataSource = self
        self.mandatoryLbl?.isHidden = true
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapG)
        self.zipcodeTxtfld?.keyboardType = .numberPad
        self.genderTxtfld?.isUserInteractionEnabled = true
        self.timeZoneTxtfld?.isUserInteractionEnabled = true
        self.dobTxtfld?.isUserInteractionEnabled = true
        self.countryTxtfld?.isUserInteractionEnabled = true
        self.stateTxtfld?.isUserInteractionEnabled = true
        self.scroll?.contentSize = CGSize(width: 320, height: 1400)
        
        self.fstNameTxtfld?.layer.masksToBounds = true
        self.fstNameTxtfld?.layer.borderWidth = 2
        self.fstNameTxtfld?.layer.cornerRadius = 3.0
        self.fstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.lstNameTxtfld?.layer.masksToBounds = true
        self.lstNameTxtfld?.layer.borderWidth = 2
        self.lstNameTxtfld?.layer.cornerRadius = 3.0
        self.lstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.emailTxtfld?.layer.masksToBounds = true
        self.emailTxtfld?.layer.borderWidth = 2
        self.emailTxtfld?.layer.cornerRadius = 3.0
        self.emailTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.timeZoneTxtfld?.layer.masksToBounds = true
        self.timeZoneTxtfld?.layer.borderWidth = 2
        self.timeZoneTxtfld?.layer.cornerRadius = 3.0
        self.timeZoneTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.timeZoneTxtfld?.font = UIFont.systemFont(ofSize: 11.0)
        self.timeZoneTxtfld?.adjustsFontSizeToFitWidth = true
        
        self.zipcodeTxtfld?.layer.masksToBounds = true
        self.zipcodeTxtfld?.layer.borderWidth = 2
        self.zipcodeTxtfld?.layer.cornerRadius = 3.0
        self.zipcodeTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        primaryTxtfld?.layer.masksToBounds = true
        primaryTxtfld?.layer.borderWidth = 2
        primaryTxtfld?.layer.cornerRadius = 3.0
        primaryTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        secondTxtfld?.layer.masksToBounds = true
        secondTxtfld?.layer.borderWidth = 2
        secondTxtfld?.layer.cornerRadius = 3.0
        secondTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.fstNameTxtfld?.text = self.model?.firstName
        self.lstNameTxtfld?.text = self.model?.lastName
        self.midNameTxtFld?.text = self.model?.middleName
        self.dobTxtfld?.text = self.model?.birthDate
        let df = DateFormatter()
        df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
        if dobTxtfld?.text != nil && dobTxtfld?.text != ""
        {
            self.datePicker.date = df.date(from: self.dobTxtfld.text!)!
        }
        self.genderTxtfld?.text = self.model?.gender
        let type = (Int)((self.model?.genderId!)!)
        if type == 2
        {
            self.genderTxtfld?.text = "Male"
        }
        else if type == 1
        {
            self.genderTxtfld?.text = "Female"
        }
        
        if self.model?.isSearchable == true
        {
            self.isAppearIn?.isOn = true
            self.isSearchable = "true"
        }
        else
        {
            self.isAppearIn?.isOn = false
            self.isSearchable = "false"
        }
        self.emailTxtfld?.text = self.model?.email
        self.timeZoneTxtfld?.text = self.model?.timeZone
        self.clientAccountId?.text = self.model?.clientId
        self.address1Txtfld?.text = self.model?.address1
        self.address2Txtfld?.text = self.model?.address2
        self.cityTxtfld?.text = self.model?.city
        self.countryTxtfld?.text = self.model?.country
        self.stateTxtfld?.text = self.model?.state
        self.zipcodeTxtfld?.text = self.model?.zip
        self.fstNameTxtfld?.text = self.model?.firstName
        if self.model?.primary?.count == 10 && self.model?.primary != nil && self.model?.primary != ""
        {
            self.primaryTxtfld?.text = self.arrangeUSFormat(strPhone: (self.model?.primary)!)
        }
        else{
            self.primaryTxtfld?.text = self.model?.primary
        }
        if self.model?.secondary?.count == 10 && self.model?.secondary != nil && self.model?.secondary != ""
        {
            self.secondTxtfld?.text = self.arrangeUSFormat(strPhone: (self.model?.secondary)!)
        }
        else
        {
            self.secondTxtfld?.text = self.model?.secondary
        }
        self.timeZoneId = (self.model?.timeZoneId)!
        self.genderId = (self.model?.genderId)!
        self.countryId = (self.model?.countryId)!
        self.stateId = (self.model?.stateId)!
        
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.masksToBounds = true
        self.profilePic.layer.cornerRadius = 30.0
        
        self.profilePic.imageFromServerURL(urlString: (self.model?.profilePic)!,defaultImage: "ic_user_prof")
        let image: UIImage = self.squareImage(with: self.profilePic.image!, scaledTo: CGSize(width: 120, height: 120))
        let imageData: Data? = UIImagePNGRepresentation(image)
        self.base64ImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
        self.isAppearIn?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        
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
            
            var str1: String = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&process=%@&verifyThrough=%@", (self.primaryTxtfld?.text)!, countryCode, "", "", "","verify","phone")
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
                                self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + (self.primaryTxtfld?.text!)!
                                let alertDel = UIAlertController(title: nil, message: String(format: "Verification code has been sent to %@ %@ successfully",countryCode,(self.primaryTxtfld?.text!)! )  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    UserDefaults.standard.set(str, forKey: "OTP")
                                    UserDefaults.standard.synchronize()
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
            var strNum = self.primaryTxtfld.text?.replacingOccurrences(of: "(", with: "")
            strNum = strNum?.replacingOccurrences(of: ") ", with: "")
            strNum = strNum?.replacingOccurrences(of: "-", with: "")
            if self.isChangePhone
            {
                urlStr = String(format : "userId=%@&changePhone=%@",userId,strNum!)
                urlString = API.Login.VerifyChangeMobileUserID
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
                                    self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        self.passcode1.text = ""
        self.passcode2.text = ""
        self.passcode3.text = ""
        self.passcode4.text = ""
        self.passcode5.text = ""
        self.passcode6.text = ""
        self.popUpView.isHidden = true
        
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
                urlString = String(format : "userId=%@&firstName=%@&lastName=%@&changeEmail=%@",userId,(self.fstNameTxtfld?.text)!, (self.lstNameTxtfld?.text)!, (self.emailTxtfld?.text)!)
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
                                
                                let alertDel = UIAlertController(title: nil, message: "We have sent a verification link to " + (self.emailTxtfld?.text!)! +  "\n Please click on the link to verify your email." , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                                })
                                let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.webServiceToGetVerificationLink()
                                })
                                let change = UIAlertAction(title: "Change Email", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                })
                                alertDel.addAction(change)
                                alertDel.addAction(resend)
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
    @objc func isSwitchOn(sender: UISwitch) -> Void
    {
        if (self.isAppearIn?.isOn)!
        {
            self.isSearchable = "true"
        }
        else
        {
            self.isSearchable = "false"
        }
    }
    func formatNumbers(_ str: String) -> NSString
    {
        var strs: String = str
        strs.insert("(", at: strs.startIndex)
        strs.insert(")", at: strs.index(strs.startIndex, offsetBy: 4))
        return (strs as NSString).replacingCharacters(in: NSMakeRange(5, 1), with: " ") as NSString
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        fstNameTxtfld?.resignFirstResponder()
        lstNameTxtfld?.resignFirstResponder()
        dobTxtfld?.resignFirstResponder()
        genderTxtfld?.resignFirstResponder()
        emailTxtfld?.resignFirstResponder()
        address1Txtfld?.resignFirstResponder()
        address2Txtfld?.resignFirstResponder()
        cityTxtfld?.resignFirstResponder()
        timeZoneTxtfld?.resignFirstResponder()
        zipcodeTxtfld?.resignFirstResponder()
        primaryTxtfld?.resignFirstResponder()
        secondTxtfld?.resignFirstResponder()
        self.midNameTxtFld?.resignFirstResponder()
        self.clientAccountId?.resignFirstResponder()
        countryTxtfld?.resignFirstResponder()
        timeZoneTxtfld?.resignFirstResponder()
        self.textFld?.resignFirstResponder()
    }
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            
            RestClient.getList(dropDownType, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = [Any]()
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    print(detailsArr)
                    for dict in detailsArr
                    {
                        if (self.dropDownType == "TimeZone") {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "Gender") {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "Country") {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "State") {
                            let model = CommonResponseModel()
                            if self.countryId != "" && self.countryId == dict["ConversationId"] as! String? {
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                model.paramSubID = dict["ConversationId"] as! String?
                                self.listArr.append(model)
                            }
                        }
                    }
                    self.listTv?.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    
    @IBAction func upload(_ up: UIButton)
    {
        self.imgPkrCon = UIImagePickerController()
        self.imgPkrCon?.delegate = self
        imgPkrCon?.allowsEditing = true
        let alertControl = UIAlertController(title: "Upload Photo", message: "Choose to upload from", preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .photoLibrary
            self.present(self.imgPkrCon!, animated: true, completion: nil)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .camera
            self.present(self.imgPkrCon!, animated: true, completion: nil)
        })
        let Cancel = UIAlertAction(title: "Cancel ", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.dismiss(animated: true, completion: nil)
        })
        alertControl.addAction(galary)
        alertControl.addAction(camera)
        alertControl.addAction(Cancel)
        alertControl.popoverPresentationController?.sourceView = self.view
        alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        navigationController?.present(alertControl, animated: true, completion: nil)
    }
    // MARK: -
    // MARK: UIImagePickerController Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String: Any]?) {
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        self.isImageSelected = true
        self.profilePic.image = info["UIImagePickerControllerEditedImage"] as? UIImage
        let newImage: UIImage = squareImage(with: self.profilePic.image!, scaledTo: CGSize(width: CGFloat(120), height: CGFloat(120)))
        let imageData: Data = UIImagePNGRepresentation(newImage)!
        self.base64ImgString = (imageData.base64EncodedString(options: .endLineWithLineFeed))
        print("Upadated Image base64 string for Pet Image:\(base64ImgString)")
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Scale Image Function
    
    func squareImage(with image: UIImage, scaledTo newSize: CGSize) -> UIImage
    {
        var ratio: Double
        var delta: Double
        var offset: CGPoint
        //make a new square size, that is the resized imaged width
        let sz = CGSize(width: CGFloat(newSize.width), height: CGFloat(newSize.width))
        //figure out if the picture is landscape or portrait, then
        //calculate scale factor and offset
        if image.size.width > image.size.height {
            ratio = (Double)(newSize.width / image.size.width)
            delta = (Double)(CGFloat(ratio) * image.size.width - CGFloat(ratio) * image.size.height)
            offset = CGPoint(x: CGFloat(delta / 2), y: CGFloat(0))
        }
        else {
            ratio = (Double)(newSize.width / image.size.height)
            delta = (Double)(CGFloat(ratio) * image.size.height - CGFloat(ratio) * image.size.width)
            offset = CGPoint(x: CGFloat(0), y: CGFloat(delta / 2))
        }
        //make the final clipping rect based on the calculated values
        let clipRect = CGRect(x: CGFloat(-offset.x), y: CGFloat(-offset.y), width: CGFloat((CGFloat(ratio) * image.size.width) + CGFloat(delta)), height: CGFloat((CGFloat(ratio) * image.size.height) + CGFloat(delta)))
        //start a new context, with scale factor 0.0 so retina displays get
        //high quality image
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        }
        else {
            UIGraphicsBeginImageContext(sz)
        }
        UIRectClip(clipRect)
        image.draw(in: clipRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.genderTxtfld || textField == self.timeZoneTxtfld || textField == self.countryTxtfld || textField == self.stateTxtfld
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == passcode1 || textField == passcode2 || textField == passcode3 || textField == passcode4 || textField == passcode5 || textField == passcode6 || textField == zipcodeTxtfld
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
        else if textField == self.dobTxtfld
        {
            self.datePicker.maximumDate = Date()
            self.datePicker.datePickerMode = UIDatePickerMode.date
            
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donedatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            self.dobTxtfld.inputAccessoryView = toolbar
            self.dobTxtfld.inputView = datePicker
        }
        else if textField == self.timeZoneTxtfld
        {
            self.textFld = textField
            dropDownType = "TimeZone"
            self.listArr = []
            self.listTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = listTv
        }
        else if textField == self.genderTxtfld
        {
            self.textFld = textField
            dropDownType = "Gender"
            self.listArr = []
            self.listTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = listTv
        }
        else if textField == self.countryTxtfld
        {
            self.textFld = textField
            dropDownType = "Country"
            self.listArr = []
            self.listTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = listTv
        }
        else if textField == self.stateTxtfld
        {
            self.textFld = textField
            dropDownType = "State"
            self.listArr = []
            self.listTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = listTv
        }
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.dobTxtfld.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.dobTxtfld.resignFirstResponder()
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem)
    {
        self.textFld?.resignFirstResponder()
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem)
    {
        self.textFld?.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == emailTxtfld
        {
            if textField.text?.count == 0
            {
                print("email is correct...")
            }
            else
            {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                if emailTest.evaluate(with: emailTxtfld?.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else
                {
                    textField.layer.borderColor = UIColor.clear.cgColor
                    if self.emailTxtfld?.text == self.model?.email
                    {
                        self.isChangeEmail = false
                        
                    }
                    else
                    {
                        self.isChangeEmail = true
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.textFld = emailTxtfld
                        self.webServiceToCheckEmailPhone()
                    }
                    
                    print("email is correct...")
                }
            }
        }
        else if textField == primaryTxtfld
        {
            if textField.text?.count == 0
            {
                print("Nmber is correct...")
            }
            else
            {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false
                {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else
                {
                    textField.layer.borderColor = UIColor.clear.cgColor
                    if self.primaryTxtfld?.text == self.model?.primary
                    {
                        self.isChangePhone = false
                    }
                    else
                    {
                        self.isChangePhone = true
                        self.textFld = primaryTxtfld
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.webServiceToCheckEmailPhone()
                    }
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == secondTxtfld
        {
            if textField.text?.count == 0
            {
                print("Nmber is correct...")
            }
            else
            {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor.clear.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == zipcodeTxtfld
        {
            if textField.text?.count == 0
            {
                print("Nmber is correct...")
            }
            else if (textField.text?.count)! < 5
            {
                zipcodeTxtfld?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid zipcode ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else
            {
                zipcodeTxtfld?.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
    }
    func webServiceToCheckEmailPhone()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            var str: String = ""
            if self.isChangeEmail
            {
                str = String(format: "emailId=%@&phoneNumber=%@",(self.emailTxtfld?.text!)!, "")
            }
            else if self.isChangePhone
            {
                str = String(format: "emailId=%@&phoneNumber=%@","", (self.primaryTxtfld?.text)!)
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
                                if self.isChangeEmail && self.textFld == self.emailTxtfld
                                {
                                    self.webServiceToGetVerificationLink()
                                    
                                }
                                else if self.isChangePhone && self.textFld == self.primaryTxtfld
                                {
                                    self.webServiceToGetOTP()
                                }
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: json?["Message"] as? String  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
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
        if textField == primaryTxtfld || textField == secondTxtfld
        {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if textField == primaryTxtfld
            {
                self.textFld = primaryTxtfld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == secondTxtfld
            {
                self.textFld = secondTxtfld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else
            {
                return true
            }
        }
        if textField == zipcodeTxtfld
        {
            let currentString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 5
            {
                return false
            }
        }
        if textField == primaryTxtfld || textField == secondTxtfld
        {
            let cs = NSCharacterSet(charactersIn: API.Login.ACCEPTABLE_CHARACTERS).inverted;
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
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
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                self.textFld?.text = "("
            }
            
        }else if str!.count == 5{
            
            self.textFld?.text = (self.textFld?.text!)! + ") "
            
        }else if str!.count == 10{
            
            self.textFld?.text = (self.textFld?.text!)! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        return true
    }
    
    func doValidationsForTextFields() -> Bool
    {
        let contactNumberString: String = primaryTxtfld!.text!
        let secNumString: String = secondTxtfld!.text!
        let emailString: String = emailTxtfld!.text!
        let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
        if primaryTxtfld?.text?.count == 0 && secondTxtfld?.text?.count == 0 {
            return true
        }
        else if (primaryTxtfld?.text?.count)! > 0 && (numberTest.evaluate(with: contactNumberString) != true) {
            
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct primary phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            primaryTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (secondTxtfld?.text?.count)! > 0 && (numberTest.evaluate(with: secNumString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct secondary phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            secondTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (emailTxtfld?.text?.count)! > 0 && (emailTest.evaluate(with: emailString) != true)
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter a valid email", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            emailTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else
        {
            return true
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.listArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row] as? CommonResponseModel
        return model?.paramName
        
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
            if (dropDownType == "TimeZone")
            {
                timeZoneTxtfld?.text = model?.paramName
                timeZoneId = (model?.paramID)!
            }
            else if (dropDownType == "Gender")
            {
                genderTxtfld?.text = model?.paramName
                genderId = (model?.paramID)!
            }
            else if (dropDownType == "Country")
            {
                countryTxtfld?.text = model?.paramName
                countryId = (model?.paramID)!
                stateTxtfld.text = ""
                stateId = ""
                
            }
            else if (dropDownType == "State")
            {
                stateTxtfld?.text = model?.paramName
                stateId = (model?.paramID)!
                stateCountryID = (model?.paramSubID)!
            }
            self.textFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.textFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.textFld?.resignFirstResponder()
    }
    
    
    @IBAction func submitDetails(_ sender: Any)
    {
        fstNameTxtfld?.resignFirstResponder()
        lstNameTxtfld?.resignFirstResponder()
        dobTxtfld?.resignFirstResponder()
        genderTxtfld?.resignFirstResponder()
        emailTxtfld?.resignFirstResponder()
        address1Txtfld?.resignFirstResponder()
        address2Txtfld?.resignFirstResponder()
        cityTxtfld?.resignFirstResponder()
        timeZoneTxtfld?.resignFirstResponder()
        zipcodeTxtfld?.resignFirstResponder()
        primaryTxtfld?.resignFirstResponder()
        secondTxtfld?.resignFirstResponder()
        clientAccountId?.resignFirstResponder()
        midNameTxtFld?.resignFirstResponder()
        countryTxtfld?.resignFirstResponder()
        timeZoneTxtfld?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    func doValidationsForUpdateDetails()
    {
        if self.fstNameTxtfld?.text == nil && self.lstNameTxtfld?.text == nil && self.emailTxtfld?.text == nil &&  self.timeZoneTxtfld?.text == nil  && self.primaryTxtfld.text == nil && (self.fstNameTxtfld?.text == "") && (self.lstNameTxtfld?.text == "") && (self.emailTxtfld?.text == "") && (self.timeZoneTxtfld?.text == "") && (self.primaryTxtfld.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.fstNameTxtfld?.layer.borderColor = UIColor.red.cgColor
            self.lstNameTxtfld?.layer.borderColor = UIColor.red.cgColor
            self.emailTxtfld?.layer.borderColor = UIColor.red.cgColor
            self.timeZoneTxtfld?.layer.borderColor = UIColor.red.cgColor
        }
        if fstNameTxtfld?.text == nil || fstNameTxtfld?.text == "" {
            fstNameTxtfld?.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl?.isHidden = false
        }
        else {
            fstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl?.isHidden = false
        }
        if lstNameTxtfld?.text == nil || lstNameTxtfld?.text == "" {
            lstNameTxtfld?.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl?.isHidden = false
        }
        else {
            lstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl?.isHidden = false
        }
        if emailTxtfld?.text == nil || emailTxtfld?.text == "" {
            emailTxtfld?.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl?.isHidden = false
        }
        else {
            emailTxtfld?.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl?.isHidden = false
        }
        if timeZoneTxtfld?.text == nil || timeZoneTxtfld?.text == "" {
            timeZoneTxtfld?.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl?.isHidden = false
        }
        else {
            timeZoneTxtfld?.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl?.isHidden = false
        }
        if primaryTxtfld?.text == nil || primaryTxtfld?.text == "" {
            primaryTxtfld?.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl?.isHidden = false
        }
        else {
            primaryTxtfld?.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl?.isHidden = false
        }
        
        if (self.fstNameTxtfld?.text != nil) && (self.lstNameTxtfld?.text != nil) && (self.emailTxtfld?.text != nil) && (self.timeZoneTxtfld?.text != nil) && self.primaryTxtfld.text != nil && !(self.fstNameTxtfld?.text == "") && !(self.lstNameTxtfld?.text == "") && !(self.emailTxtfld?.text == "") && !(self.timeZoneTxtfld?.text == "") && !(self.primaryTxtfld.text == "")
        {
            self.mandatoryLbl?.isHidden = true
            if doValidationsForTextFields() {
                checkInternetConnection()
            }
        }
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpadte()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToUpadte()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "content-type": "application/json"
            ]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var emailStr: String = ""
            if self.isChangeEmail && self.model?.emailVerified == true
            {
                emailStr = (self.model?.email)!
            }
            else
            {
                emailStr = self.emailTxtfld.text!
            }
            var dict = [String: Any]()
            dict["UserId"] = userId
            dict["ShelterOwnerId"] = (self.clientAccountId?.text)!
            dict["FirstName"] = (self.fstNameTxtfld?.text)!
            dict["LastName"] = (self.lstNameTxtfld?.text)!
            dict["MiddleName"] = (self.midNameTxtFld?.text)!
            dict["BirthDate"] = (self.dobTxtfld?.text)!
            dict["GenderId"] = self.genderId
            dict["Email"] = emailStr
            dict["TimeZoneId"] = self.timeZoneId
            dict["ClientAccountId"] = (self.clientAccountId?.text)!
            dict["Address1"] = (self.address1Txtfld?.text)!
            dict["Address2"] = (self.address2Txtfld?.text)!
            dict["City"] = (self.cityTxtfld?.text)!
            dict["CountryId"] = self.countryId
            dict["StateId"] = self.stateId
            dict["Zip"] = (self.zipcodeTxtfld?.text)!
            dict["PrimaryPhone"] = (self.primaryTxtfld?.text)!
            dict["SecondaryPhone"] = (self.secondTxtfld?.text)!
            dict["CreationDate"] = self.model?.createDate
            dict["IsNonSearchable"] = self.isSearchable
            if self.isImageSelected == false
            {
                dict["ProfilePicName"] = ""
                dict["ProfilePicBase64string"] = ""
            }
            else{
                dict["ProfilePicName"] = "ProfilePic.png"
                dict["ProfilePicBase64string"] = self.base64ImgString
            }
            
            let objDict = dict as NSDictionary
            print(dict)
            let requestUrl = URL(string: API.Owner.EditMyProfile) //else { return }
            var request = URLRequest(url:requestUrl!)
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: objDict, options: .prettyPrinted)
                
            }
            catch
            {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
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
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "Profile has been updated successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.navigationController?.popViewController(animated: true)
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
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
