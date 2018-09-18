//
//  LoginViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
import CoreBluetooth
class LoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userNameTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var congratsView: UIView!
    
    @IBOutlet weak var passcode1: UITextField!
    @IBOutlet weak var passcode2: UITextField!
    @IBOutlet weak var passcode3: UITextField!
    @IBOutlet weak var passcode4: UITextField!
    @IBOutlet weak var passcode5: UITextField!
    @IBOutlet weak var passcode6: UITextField!
    @IBOutlet weak var resend: UIButton!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    
    var signature:String = ""
    var referrarCode:String = ""
    var textFld: UITextField?
    var isPhone: Bool = false
    var isEmail: Bool = false
    var userDefaults: UserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        let leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: nil, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        self.popUpView.isHidden = true
        self.congratsView.isHidden = true
        prepareUI()
        self.checkInternetConnection()
        
        // Do any additional setup after loading the view.
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.getValidSignatureOfTheUser()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getValidSignatureOfTheUser()
    {
        var str: String = String(format: "UserAgent=%@&IpAddress=%@",UserDefaults.standard.string(forKey: "UserAgent")!, UserDefaults.standard.string(forKey: "PublicIP")!)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format:"%@?%@",API.Invite.GetSignature,str)
        let request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
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
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let sign = json?["Signature"] as? String
            {
                DispatchQueue.main.async
                    {
                        if sign != nil && sign != ""
                        {
                            self.signature = (json!["Signature"] as? String)!
                            self.getReferralCodeFromSignature()
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
    func getReferralCodeFromSignature()
    {
        //var str: String = String(format: "Signature=%@",self.signature)
        var str: String = String(format: "Signature=%@","23.99.101.118-Unknown-Unknown-WinNT")
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format:"%@?%@",API.Invite.GetReferrarCode,str)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
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
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let refCode = json?["RfferalCode"] as? String
            {
                DispatchQueue.main.async
                    {
                        if refCode != nil && refCode != ""
                        {
                            self.referrarCode = (json!["RfferalCode"] as? String)!
                            UserDefaults.standard.set(self.referrarCode, forKey: "UserReferrarCode")
                            UserDefaults.standard.synchronize()
                            self.getReferralDetails()
                        }
                        else
                        {
                            UserDefaults.standard.set("", forKey: "UserReferrarCode")
                            UserDefaults.standard.synchronize()
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
    func getReferralDetails()
    {
        let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        let urlStr = String(format : "%@?ReferralCode=%@", API.Invite.GetReferrarDetails, self.referrarCode)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(json ?? [])
                            let refName: String = String(format:"%@ %@",(json!["FirstName"] as? String)!,(json!["LastName"] as? String)!)
                            let refUserId: NSNumber = (json!["UserId"] as? NSNumber)!
                            let refEmail: String = (json!["EmailId"] as? String)!
                            UserDefaults.standard.set(refName, forKey: "ReferrarName")
                            UserDefaults.standard.set(refUserId, forKey: "ReferralUserId")
                            UserDefaults.standard.set(refEmail, forKey: "ReferralEmail")
                            UserDefaults.standard.synchronize()
                            self.congratsView.isHidden = false
                        }
                        else
                        {
                            self.congratsView.isHidden = true
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
    @IBAction func closeCongratsView(_ sender: UIButton)
    {
        self.congratsView.isHidden = true
    }
    @IBAction func moveToSignUp(_ sender: UIButton)
    {
        self.congratsView.isHidden = true
        self.performSegue(withIdentifier: "ReferSignUp", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        checkForDeviceLanguage()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.userName.text = ""
    }
    func prepareUI()
    {
        loginView.layer.masksToBounds = true
        loginView.clipsToBounds = false
        loginView.layer.cornerRadius = 5.0
        userNameTxtF.layer.masksToBounds = true
        userNameTxtF.layer.cornerRadius = 3.0
        userNameTxtF.font = UIFont(name: "OpenSans", size: 12.0)
        passwordTxtF.layer.masksToBounds = true
        passwordTxtF.layer.cornerRadius = 3.0
        passwordTxtF.font = UIFont(name: "OpenSans", size: 12.0)
        loginBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 16)
        userNameTxtF.resignFirstResponder()
        passwordTxtF.resignFirstResponder()
    }
    @IBAction func forgotPasswordClk(_ sender: UIButton)
    {
        let forgot : ForgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    @IBAction func loginClk(_ sender: Any)
    {
        print("Login Button Click....")
        userNameTxtF.resignFirstResponder()
        passwordTxtF.resignFirstResponder()
        doValidationForEmptyField()
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
        if textField == userNameTxtF
        {
            if textField.text != nil && textField.text != ""
            {
                let str = textField.text
                if let num = Int(str!)
                {
                    self.isPhone = true
                    // self.userNameTxtF.text = self.arrangeUSFormat(strPhone: self.userNameTxtF.text!)
                    self.isEmail = false
                }
                else
                {
                    let word = self.userNameTxtF.text
                    let searchCharacter: Character = "@"
                    
                    if (word?.lowercased().characters.contains(searchCharacter))!
                    {
                        self.isEmail = true
                        self.isPhone = false
                    }
                    else{
                        self.isEmail = false
                        self.isPhone = false
                    }
                }
            }
        }
        if textField == userNameTxtF
        {
            if textField.text?.count == 0
            {
                print("email is correct...")
            }
            else if self.isEmail
            {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                if emailTest.evaluate(with: userNameTxtF.text) == false
                {
                    textField.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: "Warning", message: "Please enter valid email", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    present(alert, animated: true)
                }else
                {
                    textField.layer.borderColor = UIColor.clear.cgColor
                }
            }
            else if self.isPhone
            {
                // let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$" "^[0-9]{10}|\\d{3}[-. ]\\d{3}[-. ]\\d{4}" "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberReg: String =  "^[0-9]{10}|\\d{3}[-. ]\\d{3}[-. ]\\d{4}"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false
                {
                    textField.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: "Warning", message: "Please enter valid mobile number", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    present(alert, animated: true)
                }
                else
                {
                    textField.layer.borderColor = UIColor.clear.cgColor
                    print("Nmber is correct...")
                }
            }
        }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == userNameTxtF
        {
            let count: Int = (self.userNameTxtF.text?.count)!
            if count > 0
            {
                let str = textField.text
                if let num = Int(str!)
                {
                    self.isPhone = true
                    self.isEmail = false
                    
                }
                else
                {
                    let word = self.userNameTxtF.text
                    let searchCharacter: Character = "@"
                    
                    if (word?.lowercased().contains(searchCharacter))!
                    {
                        self.isEmail = true
                        self.isPhone = false
                    }
                    else
                    {
                        self.isEmail = false
                        self.isPhone = false
                    }
                }
            }
            
            if self.isPhone
            {
                if str.count > 10
                {
                    return false
                }
                else
                {
                    return true
                }
            }
        }
        if self.popUpView.isHidden == false
        {
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
        return true
    }
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool
    {
        
        if string == ""
        {
            
            return true
            
        }
        else if str!.count < 3
        {
            
            if str!.count == 1
            {
                self.userNameTxtF?.text =  "(" + (self.userNameTxtF?.text!)!
            }
            
        }
        else if str!.count == 5{
            
            self.userNameTxtF?.text = (self.userNameTxtF?.text!)! + ") "
            
        }
        else if str!.count == 10{
            
            self.userNameTxtF?.text = (self.userNameTxtF?.text!)! + "-"
            
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
    func doValidationForEmptyField()
    {
        if userNameTxtF.text == nil || passwordTxtF.text == nil || (userNameTxtF.text == "") || (passwordTxtF.text == "") {
            let alert = UIAlertController(title: "All fields required", message: "Please check that you have entered all fields", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            userNameTxtF.layer.borderColor = UIColor.red.cgColor
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true) 
        }
        else
        {
            let prefs = UserDefaults.standard
            prefs.set(self.userNameTxtF.text, forKey: "LoginUserName")
            prefs.set(false, forKey: "PopUpMyPets")
            prefs.set(false, forKey: "PopUpAddRemi")
            prefs.set(false, forKey: "PopUpPetVets")
            prefs.set(false, forKey: "PopUpPetId")
            prefs.set(false, forKey: "PopUpCalendar")
            prefs.synchronize()
            startAuthenticatingUser()
        }
    }
    
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Logging In", comment: "")
            UserDefaults.standard.set(false, forKey: "IsUserLoggedIn")
            UserDefaults.standard.synchronize()
            webserviceToAuthenticateUser()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webserviceToAuthenticateUser()
    {
        let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        // NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"]];
        var str = String(format : "UserName=%@&password=%@", self.userNameTxtF.text!, self.passwordTxtF.text!)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Login.Login, str)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
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
                DispatchQueue.main.async
                    {
                        let queryDic = json?["Login"] as! [String : Any]
                        if status == 0 && json?["Message"] as? String != nil && json?["Message"] as? String != "" && queryDic["UserId"] as? NSNumber != 0
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            UserDefaults.standard.set(queryDic["UserId"], forKey: "userID")
                            UserDefaults.standard.synchronize()
                            var message: String = ""
                            var alertOkTitle: String = ""
                            var alertCancelTitle: String = ""
                            if self.isEmail
                            {
                                message = "Your email is not verified with Activ4Pets."
                                alertOkTitle = "Verify your email now"
                                alertCancelTitle = "Login with your mobile number"
                            }
                            else if self.isPhone
                            {
                                message = "Your mobile number is not verified with Activ4Pets."
                                alertOkTitle = "Verify your mobile number now"
                                alertCancelTitle = "Login with your email"
                            }
                            let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: alertOkTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                if self.isEmail
                                {
                                    self.webServiceToGetVerificationLink()
                                }
                                else if self.isPhone
                                {
                                    self.webServiceToGetOTP()
                                }
                                
                            })
                            let cancel = UIAlertAction(title: alertCancelTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            alert.addAction(ok)
                            alert.addAction(cancel)
                            self.present(alert, animated: true)
                        }
                        else if status == 0 && queryDic["UserId"] as? NSNumber == 0
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: nil, message: json!["Message"] as? String, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            })
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        }
                        else if status == 1 && queryDic["UserId"] as? NSNumber != 0 && queryDic["UserType"] as? NSNumber == 6
                        {
                            var prunedDictionary = [String: Any]()
                            for key: String in (queryDic.keys)
                            {
                                if !(queryDic[key] is NSNull)
                                {
                                    prunedDictionary[key] = queryDic[key]
                                }
                                else {
                                    prunedDictionary[key] = ""
                                }
                            }
                            print(prunedDictionary)
                            UserDefaults.standard.set(false, forKey: "LoggedOut")
                            UserDefaults.standard.synchronize()
                            self.userDefaults = UserDefaults.standard
                            self.userDefaults?.set(true, forKey: "IsUserLoggedIn")
                            self.userDefaults?.set(prunedDictionary, forKey: "user")
                            self.userDefaults?.set(prunedDictionary["UserId"], forKey: "userID")
                            self.userDefaults?.set(prunedDictionary["UserType"], forKey: "userType")
                            self.userDefaults?.set(prunedDictionary["UserName"], forKey: "UserName")
                            self.userDefaults?.set(prunedDictionary["ProfilePicUrl"], forKey: "ProfilePicUrl")
                            self.userDefaults?.set(prunedDictionary["VerifyByPhone"], forKey: "IsPhoneVerified")
                            self.userDefaults?.set(prunedDictionary["VerifyByEmail"], forKey: "IsEmailVerified")
                            self.userDefaults?.set(prunedDictionary["UserEmail"], forKey: "UserEmail")
                            self.userDefaults?.set(prunedDictionary["UserPhoneNumber"], forKey: "UserPhoneNumber")
                            if prunedDictionary["CenterId"] as? String == ""
                            {
                                self.userDefaults?.set(0, forKey: "CenterID")
                            }
                            else
                            {
                                self.userDefaults?.set(prunedDictionary["CenterId"], forKey: "CenterID")
                            }
                            self.userDefaults?.set(prunedDictionary["CenterName"], forKey: "CenterName")
                            self.userDefaults?.set(prunedDictionary["IsAccountExpired"], forKey: "AccountExpired")
                            self.userDefaults?.set(prunedDictionary["IsPaymentDone"], forKey: "PaymentDone")
                            self.userDefaults?.set(prunedDictionary["GeneralConditions"], forKey: "Conditions")
                            self.userDefaults?.set(prunedDictionary["IsTemporalPasword"], forKey: "TempPassword")
                            
                            self.userDefaults?.synchronize()
                            if prunedDictionary["IsPaymentDone"] as! Bool == true && prunedDictionary["IsAccountExpired"] as! Bool == false
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.userDefaults?.set(true, forKey: "isUserLoggedIn")
                                self.userDefaults?.set(self.userNameTxtF.text, forKey: "SavedUserName")
                                self.userDefaults?.set(self.passwordTxtF.text, forKey: "SavedPassword")
                                self.userDefaults?.synchronize()
                                self.regisetrDeviceIDOnServer()
                                if prunedDictionary["IsTemporalPasword"] as! Bool == true
                                {
                                    let change: FirstChangePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! FirstChangePasswordViewController
                                    self.navigationController?.pushViewController(change, animated: true)
                                }
                                else if prunedDictionary["GeneralConditions"] as! Bool == true
                                {
                                    let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int ?? 0
                                    if  appOpenCount < 6
                                    {
                                        incrementAppOpenedCount()
                                    }
                                    let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                                    MyPets.isFromNS = true
                                    self.navigationController?.pushViewController(MyPets, animated: true)
                                }
                                else
                                {
                                    let termsCond: TermsAndConditionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TandC") as! TermsAndConditionsViewController
                                    self.navigationController?.pushViewController(termsCond, animated: true)
                                }
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.userDefaults?.set(true, forKey: "isUserLoggedIn")
                                self.userDefaults?.set(self.userNameTxtF.text, forKey: "SavedUserName")
                                self.userDefaults?.set(self.passwordTxtF.text, forKey: "SavedPassword")
                                self.userDefaults?.synchronize()
                                self.regisetrDeviceIDOnServer()
                                let alert = UIAlertController(title: nil, message: "Your account has been Expired. Please renew your plan in My Plan page.", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                                    let destViewController = storyboard13.instantiateViewController(withIdentifier: "MyPlan") as? MyPlanViewController
                                    destViewController?.isFromVC = true
                                    destViewController?.isFromAppDel = false
                                    self.navigationController?.pushViewController(destViewController!, animated: true)
                                })
                                alert.addAction(ok)
                                self.present(alert, animated: true)
                            }
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "Error!", message: "Invalid username or password\n Please enter valid username and password", preferredStyle: .alert)
                            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(OK)
                            self.present(alert, animated: true)
                        }
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error!", message: "Invalid username or password\n Please enter valid username and password", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true)
            }
            
        }
        task.resume()
    }
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day!
    }
    func regisetrDeviceIDOnServer()
    {
        let headers: [String : String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache","content-type": "application/json"]
        let userId = self.userDefaults?.string(forKey: "userID")
        var deviceStr: String = ""
        let deviceToken = self.userDefaults?.string(forKey: "deviceToken")
        if deviceToken?.count != 0 && deviceToken != nil && deviceToken != ""
        {
            deviceStr = deviceToken!
        }
        else
        {
            deviceStr = ""
        }
        let str: [String: String] = ["UserId": userId!,"AndroidRegId":"", "IOSRegId": deviceStr]
        //let str: [String: String] = ["UserId": userId!,"AndroidRegId":"", "IOSRegId": ""]
        let urlStr = API.Login.DeviceRegister
        guard let requestUrl = URL(string: urlStr) else { return }
        var request = URLRequest(url:requestUrl)
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
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
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                //MBProgressHUD.hide(for: self.view, animated: true)
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
                            //MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
                
            }
            else
            {
                //MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    func checkForDeviceLanguage()
    {
        userDefaults = UserDefaults.standard
        let preferredLang: String = NSLocale.preferredLanguages[0]
        print("Preferred lang is :\(preferredLang)")
        let localIdentifier = Locale.current.identifier //returns identifier of your telephones country/region settings
        let locale = NSLocale(localeIdentifier: localIdentifier)
        let countryCode: String? = locale.object(forKey: .countryCode) as? String
        let countryName: String? = locale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
        print("countryName \(String(describing: countryName))")
        
        if (preferredLang == "en-IN")
        {
            print("Language is English-India.....")
            self.userDefaults?.set("1", forKey: "LanguageCode")
            self.userDefaults?.set("en-IN", forKey: "LangCode")
        }
        else if (preferredLang == "en-US")
        {
            //English USA
            print("Language is English-US.....")
            self.userDefaults?.set("1", forKey: "LanguageCode")
            self.userDefaults?.set("en-US", forKey: "LangCode")
        }
        else if (preferredLang == "fr") {
            //French
            print("Language is FR.....")
            self.userDefaults?.set("2", forKey: "LanguageCode")
            self.userDefaults?.set("fr-Fr", forKey: "LangCode")
        }
        else if (preferredLang == "en-AU") {
            //Australian English.....
            print("Language is Australian English (en-AU).....")
            self.userDefaults?.set("5", forKey: "LanguageCode")
            self.userDefaults?.set("en-AU", forKey: "LangCode")
        }
        else if (preferredLang == "es-ES") {
            print("Language is Spanish.....")
            self.userDefaults?.set("4", forKey: "LanguageCode")
            self.userDefaults?.set("en-ES", forKey: "LangCode")
        }
        else
        {
            self.userDefaults?.set("1", forKey: "LanguageCode")
            self.userDefaults?.set("en-US", forKey: "LangCode")
        }
        userDefaults?.synchronize()
    }
    @IBAction func showPassword(_ sender: UIButton)
    {
        if sender.isSelected == true
        {
            sender.isSelected = false
            sender.setImage(UIImage(named: "view_pass"), for: .normal)
            self.passwordTxtF.isSecureTextEntry = true
        }
        else{
            sender.isSelected = true
            sender.setImage(UIImage(named: "Show password"), for: .selected)
            self.passwordTxtF.isSecureTextEntry = false
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
    func webServiceToGetOTP()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
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
            var str1: String = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&process=%@&verifyThrough=%@", self.userNameTxtF.text!, countryCode, "", "", "","verify","phone")
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
                                self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + self.userNameTxtF.text!
                                let alertDel = UIAlertController(title: nil, message: String(format: "Verification code has been sent to %@ %@ successfully",countryCode,self.userNameTxtF.text! )  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    UserDefaults.standard.set(str, forKey: "OTP")
                                    UserDefaults.standard.synchronize()
                                    self.popUpView.isHidden = false
                                    self.passcode1.becomeFirstResponder()
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
    @IBAction func verifyVerificationCode()
    {
        let enteredOtp: String = self.passcode1.text! + self.passcode2.text! + self.passcode3.text! + self.passcode4.text! + self.passcode5.text! + self.passcode6.text!
        let sentOtp = UserDefaults.standard.object(forKey: "OTP") as? String
        if enteredOtp == sentOtp
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlString = String(format : "%@?userId=%@", API.Login.VerifyMobileNumberUserID,userId)
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
                                let alertDel = UIAlertController(title: nil, message: "Your mobile number has been verified succesfully." , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    self.popUpView.isHidden = true
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
    func webServiceToGetVerificationLink()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlString = String(format : "%@?userId=%@", API.Login.VerifyEmailUserID, userId)
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
                                
                                let alertDel = UIAlertController(title: nil, message: "We have sent a verification link to " + self.userNameTxtF.text! +  "\n Please click on the link to verify your email." , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                    for controller: UIViewController in self.navigationController?.viewControllers ?? []
                                    {
                                        if (controller is LoginViewController)
                                        {
                                            _ = self.navigationController?.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
                                })
                                let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.webServiceToGetVerificationLink()
                                })
                                
                                alertDel.addAction(resend)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
