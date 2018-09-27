//
//  SignUpViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 06/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var firstNameTxtF: UITextField!
    @IBOutlet weak var lastNameTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var mobileNumberTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var confirmPasswordTxtF: UITextField!
    @IBOutlet weak var promoCodeTxtF: UITextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var mandatoryLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var passcode1: UITextField!
    @IBOutlet weak var passcode2: UITextField!
    @IBOutlet weak var passcode3: UITextField!
    @IBOutlet weak var passcode4: UITextField!
    @IBOutlet weak var passcode5: UITextField!
    @IBOutlet weak var passcode6: UITextField!
    @IBOutlet weak var resend: UIButton!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    var textFld: UITextField?
    @IBOutlet weak var chngEmailPhone: UIButton!
    var changePhone: Bool = false
    var otpEmailMobile: String = ""
    var listArr = [CommonResponseModel]()
    var gender: String = ""
    var genderId: String = ""
    var changeEmail: Bool = false
    var resendLink: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        
        self.mandatoryLbl.isHidden = true
        
        firstNameTxtF.layer.masksToBounds = true
        firstNameTxtF.layer.borderWidth = 2
        firstNameTxtF.layer.cornerRadius = 3.0
        firstNameTxtF.layer.borderColor = UIColor.clear.cgColor
        
        lastNameTxtF.layer.masksToBounds = true
        lastNameTxtF.layer.borderWidth = 2
        lastNameTxtF.layer.cornerRadius = 3.0
        lastNameTxtF.layer.borderColor = UIColor.clear.cgColor
        
        emailTxtF.layer.masksToBounds = true
        emailTxtF.layer.borderWidth = 2
        emailTxtF.layer.cornerRadius = 3.0
        emailTxtF.layer.borderColor = UIColor.clear.cgColor
        
        passwordTxtF.layer.masksToBounds = true
        passwordTxtF.layer.borderWidth = 2
        passwordTxtF.layer.cornerRadius = 3.0
        passwordTxtF.layer.borderColor = UIColor.clear.cgColor
        
        confirmPasswordTxtF.layer.masksToBounds = true
        confirmPasswordTxtF.layer.borderWidth = 2
        confirmPasswordTxtF.layer.cornerRadius = 3.0
        confirmPasswordTxtF.layer.borderColor = UIColor.clear.cgColor
        
        mobileNumberTxtF.layer.masksToBounds = true
        mobileNumberTxtF.layer.borderWidth = 2
        mobileNumberTxtF.layer.cornerRadius = 3.0
        mobileNumberTxtF.layer.borderColor = UIColor.clear.cgColor
        
        promoCodeTxtF.layer.masksToBounds = true
        promoCodeTxtF.layer.borderWidth = 2
        promoCodeTxtF.layer.cornerRadius = 3.0
        promoCodeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
        self.popUpView.isHidden = true
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightClk(_ sender: Any)
    {
        self.firstNameTxtF.resignFirstResponder()
        self.lastNameTxtF.resignFirstResponder()
        self.emailTxtF.resignFirstResponder()
        self.passwordTxtF.resignFirstResponder()
        
        self.doValidationForSignUp()
    }
    @IBAction func selectGender(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.male.isSelected = true
            self.female.isSelected = false
            self.male.setImage(UIImage(named: "Male-1"), for: .selected)
            self.female.setImage(UIImage(named: "Female"), for: .normal)
            self.gender = "Male"
            self.genderId = "2"
        }
        else
        {
            self.male.isSelected = false
            self.female.isSelected = true
            self.female.setImage(UIImage(named: "Female-1"), for: .selected)
            self.male.setImage(UIImage(named: "Male"), for: .normal)
            self.gender = "Female"
            self.genderId = "1"
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == passcode1 || textField == passcode2 || textField == passcode3 || textField == passcode4 || textField == passcode5 || textField == passcode6 || textField == self.mobileNumberTxtF
            
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
        if textField == emailTxtF
        {
            if textField.text != nil && textField.text != ""
            {
                textField.text = textField.text?.lowercased()
            }
            let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            if emailTest.evaluate(with: emailTxtF.text) == false
            {
                textField.layer.borderColor = UIColor.red.cgColor
            }
            else
            {
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == mobileNumberTxtF
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
                print("Nmber is correct...")
            }
        }
        else if textField == passwordTxtF
        {
            let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
            let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
            if passWordTest.evaluate(with: passwordTxtF.text) != true {
                
                textField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == confirmPasswordTxtF
        {
            let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
            let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
            if passWordTest.evaluate(with: confirmPasswordTxtF.text) != true {
                
                textField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
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
        else if textField == mobileNumberTxtF
        {
            self.textFld = mobileNumberTxtF
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        return true
    }
    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool
    {
        let shouldDelete = true
        if (textField.text?.count ?? 0) == 0 && (textField.text == "") {
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
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool
    {
        
        if string == ""
        {
            return true
        }
        else if str!.count < 3
        {
            
            if str!.count == 1{
                
                self.mobileNumberTxtF?.text =  "(" + (self.mobileNumberTxtF?.text)!
            }
            
        }
        else if str!.count == 5{
            
            self.mobileNumberTxtF?.text = (self.mobileNumberTxtF?.text!)! + ") "
            
        }
        else if str!.count == 10{
            
            self.mobileNumberTxtF?.text = (self.mobileNumberTxtF?.text!)! + "-"
            
        }
        else if str!.count > 14
        {
            return false
        }
        return true
    }
    func doValidationForStringMatch() -> Bool
    {
        if !(passwordTxtF.text == confirmPasswordTxtF.text)
        {
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: "Warning", message: "Passwords doesn't match", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
            return false
        }
        else
        {
            return true
        }
    }
    func doValidationsForTextFields() -> Bool
    {
        let emailString: String = emailTxtF.text!
        let passwordString: String = passwordTxtF.text!
        let numberString : String = mobileNumberTxtF.text!
        let conpasswordString: String = confirmPasswordTxtF.text!
        
        
        let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        
        let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
        let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
        
        let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
        if (emailTest.evaluate(with: emailString) != true)
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            emailTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: "Warning", message: "Enter correct email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
            
            return false
        }
        else if (numberTest.evaluate(with: numberString) != true)
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            mobileNumberTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: "Warning", message: "Enter correct mobile number", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertDel.addAction(ok)
            return false
        }
        else if passWordTest.evaluate(with: passwordString) == false
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: "Warning", message: "Password doesn't match with the requirement", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertDel.addAction(ok)
            return false
        }
        else if passWordTest.evaluate(with: conpasswordString) == false
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            confirmPasswordTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: "Warning", message: "Password doesn't match with the requirement", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertDel.addAction(ok)
            return false
        }
        else if !(self.doValidationForStringMatch())
        {
            return false
        }
        else if self.doValidationForStringMatch()
        {
            return true
        }
        
        
        return true
    }
    func doValidationForSignUp()
    {
        if firstNameTxtF.text == nil && lastNameTxtF.text == nil && emailTxtF.text == nil && mobileNumberTxtF.text == nil && passwordTxtF.text == nil && confirmPasswordTxtF.text == nil && promoCodeTxtF.text == nil && (firstNameTxtF.text == "") && (lastNameTxtF.text == "") && (emailTxtF.text == "") && (mobileNumberTxtF.text == "") && (self.passwordTxtF.text == "") && (self.confirmPasswordTxtF.text == "") && (promoCodeTxtF.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            firstNameTxtF.layer.borderColor = UIColor.red.cgColor
            lastNameTxtF.layer.borderColor = UIColor.red.cgColor
            emailTxtF.layer.borderColor = UIColor.red.cgColor
            mobileNumberTxtF.layer.borderColor = UIColor.red.cgColor
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTxtF.layer.borderColor = UIColor.red.cgColor
            promoCodeTxtF.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if firstNameTxtF.text == nil || (firstNameTxtF.text == "")
        {
            firstNameTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            firstNameTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if lastNameTxtF.text == nil || (lastNameTxtF.text == "")
        {
            lastNameTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            lastNameTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if emailTxtF.text == nil || (emailTxtF.text == "") {
            emailTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            emailTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if mobileNumberTxtF.text == nil || (mobileNumberTxtF.text == "") {
            mobileNumberTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            mobileNumberTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if passwordTxtF.text == nil || (passwordTxtF.text == "") {
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            passwordTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if confirmPasswordTxtF.text == nil || (confirmPasswordTxtF.text == "") {
            confirmPasswordTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            confirmPasswordTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if promoCodeTxtF.text == nil || (promoCodeTxtF.text == "")
        {
            promoCodeTxtF.layer.borderColor = UIColor.red.cgColor
            let alertDel = UIAlertController(title: nil, message: "If you don't have any promocode,\n Please contact Activ4Pets to get your promocode."  , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
            mandatoryLbl.isHidden = false
        }
        else
        {
            promoCodeTxtF.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if !(firstNameTxtF.text == nil) && !(lastNameTxtF.text == nil) && !(emailTxtF.text == nil)  && !(mobileNumberTxtF.text == nil) && !(passwordTxtF.text == nil) && !(confirmPasswordTxtF.text == nil) && !(promoCodeTxtF.text == nil) && !(firstNameTxtF.text == "") && !(lastNameTxtF.text == "") && !(emailTxtF.text == "") && !(mobileNumberTxtF.text == "") && !(passwordTxtF.text == "") && !(confirmPasswordTxtF.text == "") && !(promoCodeTxtF.text == "")
        {
            mandatoryLbl.isHidden = true
            if doValidationsForTextFields()
            {
                self.webServiceToCheckEmailPhone()
            }
        }
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("", comment: "")
            self.webServiceToSignUp()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToCheckPromoCode()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
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
            var str: String = String(format: "promocode=%@", self.promoCodeTxtF.text!)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Login.CheckPromoCode, str)
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
                            if status == 1 && (json?["Message"] as? String) == "Valid"
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "Do you want to verify Email or Mobile?"  , preferredStyle: .alert)
                                let email = UIAlertAction(title: "Email", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.otpEmailMobile = "Email"
                                    self.webServiceToGetVerificationLink()
                                })
                                let mobile = UIAlertAction(title: "Mobile", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.otpEmailMobile = "Mobile"
                                    self.webServiceToGetOTP()
                                    
                                    self.chngEmailPhone.setTitle("Change Mobile", for: .normal)
                                    self.chngEmailPhone.setTitle("Change mobile", for: .selected)
                                })
                                alertDel.addAction(email)
                                alertDel.addAction(mobile)
                                self.present(alertDel, animated: true, completion: nil)
                            }
                            else if status == 0 && (json?["Message"] as? String) == "Invalid"
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "Please sign up on web application with this promocode."  , preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                })
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "Invalid promocode.\n If you don't have any valid promocode, Please contact Activ4Pets to get your promocode." , preferredStyle: .alert)
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
    func webServiceToSignUp()
    {
        let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        var checkedStr: String = ""
        if self.otpEmailMobile == "Email"
        {
            checkedStr = "email"
        }
        else if self.otpEmailMobile == "Mobile"
        {
            checkedStr = "phone"
        }
        let refCode = UserDefaults.standard.string(forKey: "UserReferrarCode")
        var deviceStr: String = ""
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
        if deviceToken?.count != 0 && deviceToken != nil && deviceToken != ""
        {
            deviceStr = deviceToken!
        }
        else
        {
            deviceStr = ""
        }
        var str: String = String(format: "firstName=%@&lastName=%@&emailId=%@&phoneNumber=%@&genderId=%@&password=%@&promocode=%@&VerifiedBy=%@&ReferralCode=%@&DeviceId=%@&DeviceType=%@",self.firstNameTxtF.text!,self.lastNameTxtF.text!,self.emailTxtF.text!, self.mobileNumberTxtF.text!, self.genderId, self.passwordTxtF.text!, self.promoCodeTxtF.text!,checkedStr,refCode!,deviceStr,"ios")
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr: String = String(format: "%@?%@",API.Login.SignUp, str)
        let requestUrl = URL(string: urlStr)
        var request = URLRequest(url:requestUrl!)
        request.httpMethod = "GET"
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
                        if status > 0
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: "Done !", message: "Thank you for subscription.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                for controller: UIViewController in self.navigationController?.viewControllers ?? []
                                {
                                    if (controller is LoginViewController)
                                    {
                                        _ = self.navigationController?.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            })
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: nil, message: json?["StatusMsg"] as? String, preferredStyle: .alert)
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
    func webServiceToGetVerificationLink()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            var str1: String = ""
            var urlStr: String = ""
            if self.changeEmail
            {
                str1 = String(format: "userId=%@&firstName=%@&lastName=%@&emailId=%@&promocode=%@",UserDefaults.standard.value(forKey: "SignUpUserId") as! CVarArg,self.firstNameTxtF.text!,self.lastNameTxtF.text!,self.emailTxtF.text!, self.promoCodeTxtF.text!)
                urlStr = API.Login.SignUpChangeEmail
            }
            else if self.resendLink
            {
                str1 = String(format: "userId=%@&firstName=%@&lastName=%@&emailId=%@&promocode=%@",UserDefaults.standard.value(forKey: "SignUpUserId") as! CVarArg,self.firstNameTxtF.text!,self.lastNameTxtF.text!,self.emailTxtF.text!, self.promoCodeTxtF.text!)
                urlStr = API.Login.SignUpResendLink
            }
            else
            {
                let refCode = UserDefaults.standard.string(forKey: "UserReferrarCode")
                var deviceStr: String = ""
                let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
                if deviceToken?.count != 0 && deviceToken != nil && deviceToken != ""
                {
                    deviceStr = deviceToken!
                }
                else
                {
                    deviceStr = ""
                }
                str1 = String(format: "firstName=%@&lastName=%@&emailId=%@&phoneNumber=%@&genderId=%@&password=%@&promocode=%@&ReferralCode=%@&DeviceId=%@&DeviceType=%@",self.firstNameTxtF.text!,self.lastNameTxtF.text!,self.emailTxtF.text!, self.mobileNumberTxtF.text!, self.genderId, self.passwordTxtF.text!, self.promoCodeTxtF.text!,refCode!,deviceStr,"ios")
                urlStr = API.Login.SignUpVerifyEmail
            }
            var strNum = self.mobileNumberTxtF.text?.replacingOccurrences(of: "(", with: "")
            strNum = strNum?.replacingOccurrences(of: ") ", with: "")
            strNum = strNum?.replacingOccurrences(of: "-", with: "")
            str1 = str1.trimmingCharacters(in: CharacterSet.whitespaces)
            str1 = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", urlStr, str1)
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
                            if status > 0
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                UserDefaults.standard.set(status, forKey: "SignUpUserId")
                                UserDefaults.standard.synchronize()
                                let alertDel = UIAlertController(title: nil, message: "We have sent an activation link to " + self.emailTxtF.text! +  "\n Please click on the link to activate your account."  , preferredStyle: .alert)
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
                                let change = UIAlertAction(title: "Change Email", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    self.changeEmail = true
                                    self.emailTxtF.isUserInteractionEnabled = true
                                    self.firstNameTxtF.isUserInteractionEnabled = false
                                    self.lastNameTxtF.isUserInteractionEnabled = false
                                    self.mobileNumberTxtF.isUserInteractionEnabled = false
                                    self.passwordTxtF.isUserInteractionEnabled = false
                                    self.confirmPasswordTxtF.isUserInteractionEnabled = false
                                    self.promoCodeTxtF.isUserInteractionEnabled = false
                                    
                                })
                                let resend = UIAlertAction(title: "Resend", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.resendLink = true
                                    self.webServiceToGetVerificationLink()
                                })
                                
                                alertDel.addAction(change)
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
            var strNum = self.mobileNumberTxtF.text?.replacingOccurrences(of: "(", with: "")
            strNum = strNum?.replacingOccurrences(of: ") ", with: "")
            strNum = strNum?.replacingOccurrences(of: "-", with: "")
            var str1: String = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&process=%@&verifyThrough=%@", strNum!, countryCode, "", "", "","signup","phone" )
            
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
                                let alertDel = UIAlertController(title: nil, message: String(format: "Verification code has been sent to %@ %@ successfully",countryCode,self.mobileNumberTxtF.text! )  , preferredStyle: .alert)
                                self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + self.mobileNumberTxtF.text!
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
            var message: String = ""
            if self.otpEmailMobile == "Email"
            {
                message = "Email has been verified successfully"
            }
            else if self.otpEmailMobile == "Mobile"
            {
                message = "Mobile has been verified successfully"
            }
            let alertDel = UIAlertController(title: nil, message: message , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                self.popUpView.isHidden = true
                self.checkInternetConnection()
                
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
            
        }
        else
        {
            self.passcode1.text = ""
            self.passcode2.text = ""
            self.passcode3.text = ""
            self.passcode4.text = ""
            self.passcode5.text = ""
            self.passcode6.text = ""
            let alertDel = UIAlertController(title: "Sorry", message: "Invalid code\n Please enter valid verification code"  , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
    }
    @IBAction func changeEmailPhone()
    {
        self.popUpView.isHidden = true
        if self.otpEmailMobile == "Mobile"
        {
            self.changePhone = true
            self.emailTxtF.isUserInteractionEnabled = false
            self.firstNameTxtF.isUserInteractionEnabled = false
            self.lastNameTxtF.isUserInteractionEnabled = false
            self.mobileNumberTxtF.isUserInteractionEnabled = true
            self.passwordTxtF.isUserInteractionEnabled = false
            self.confirmPasswordTxtF.isUserInteractionEnabled = false
            self.promoCodeTxtF.isUserInteractionEnabled = false
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
    
    func webServiceToCheckEmailPhone()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            var str: String = String(format: "emailId=%@&phoneNumber=%@",self.emailTxtF.text!, self.mobileNumberTxtF.text!)
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
                                if self.changeEmail
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.webServiceToGetVerificationLink()
                                }
                                else if self.changePhone
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.webServiceToGetOTP()
                                }
                                else
                                {
                                    self.webServiceToCheckPromoCode()
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
    func webServiceToChangeEmail()
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
