//
//  ScheduleVetOnCallViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 19/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit
extension Date
{
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
}
class ScheduleVetOnCallViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var petimage : UIImageView!
    @IBOutlet weak var petname : UILabel!
    @IBOutlet weak var pettype : UILabel!
    @IBOutlet weak var apptime : UILabel!
    @IBOutlet weak var appdate : UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var detailsView: UIView!
    var textFld: UITextField?
    @IBOutlet weak var passcode1: UITextField!
    @IBOutlet weak var passcode2: UITextField!
    @IBOutlet weak var passcode3: UITextField!
    @IBOutlet weak var passcode4: UITextField!
    @IBOutlet weak var passcode5: UITextField!
    @IBOutlet weak var passcode6: UITextField!
    @IBOutlet weak var mobileNo: UITextField!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var editMobile: UIButton!
    @IBOutlet weak var confirmPay: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var isOTP: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.otpView.isHidden = true
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.verifyBtn.isUserInteractionEnabled = true
        self.resendBtn.isUserInteractionEnabled = true
        self.editMobile.isUserInteractionEnabled = true
        self.confirmPay.isUserInteractionEnabled = true
        self.petimage?.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "TalkToVetPetImage")!, defaultImage: "petImage-default.png")
        self.petname?.text = UserDefaults.standard.string(forKey: "TalkToVetPetName")
        self.pettype?.text = UserDefaults.standard.string(forKey: "TalkToVetPetType")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: UserDefaults.standard.string(forKey: "TalkToVetSelectedDate")!)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter1.string(from: date!)//"Sunday"
        let month = date?.monthAsString()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date!)
        let day = calendar.component(.day, from: date!)
        self.appdate?.text = String(format: "%@, %d %@, %d",dayInWeek,day, month!,year)
        self.apptime?.text = UserDefaults.standard.string(forKey: "TalkToVetSelectedTime")
        UserDefaults.standard.set(self.appdate.text, forKey: "VetScheduledDate")
        UserDefaults.standard.set(self.apptime.text, forKey: "VetScheduledTime")
        UserDefaults.standard.synchronize()
        let str: String = UserDefaults.standard.string(forKey: "TalkToVetPrice")!
        self.priceLabel.text = String(format: "You will be charged $%@ for this session.",str)
        
        self.detailsView.layer.masksToBounds = true
        self.detailsView.layer.borderWidth = 2
        self.detailsView.layer.cornerRadius = 10
        self.detailsView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Do any additional setup after loading the view.
    }
    @IBAction func confirmToPay(_ sender: UIButton)
    {
        if self.mobileNo.text == nil || self.mobileNo.text! == "" || (mobileNo.text?.count)! < 14
        {
            let alertDel = UIAlertController(title: nil, message: "Please enter your mobile number to verify"  , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else
        {
            UserDefaults.standard.set(mobileNo.text, forKey: "TalkToVetMobile")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "Payment", sender: nil)
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func editDetails(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("", comment: "")
            self.webServiceToGetOTP()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToGetOTP()
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
        var strNum = self.mobileNo.text?.replacingOccurrences(of: "(", with: "")
        strNum = strNum?.replacingOccurrences(of: ") ", with: "")
        strNum = strNum?.replacingOccurrences(of: "-", with: "")
        
        let urlString = String(format : "%@?MobileNumber=%@", API.VetOnCall.MobileNoVerify, strNum!)
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
                MBProgressHUD.hide(for: self.view, animated: true)
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
                            let str: String = json?["Message"] as! String
                            let alertDel = UIAlertController(title: nil, message: String(format: "Verification code has been sent to %@ %@ successfully",countryCode,self.mobileNo.text! )  , preferredStyle: .alert)
                            self.textLbl.text = "Please enter the 6 digit verification code received on " + countryCode + self.mobileNo.text!
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                UserDefaults.standard.set(str, forKey: "OTP")
                                UserDefaults.standard.synchronize()
                                self.isOTP = true
                                self.confirmPay.isUserInteractionEnabled = false
                                self.otpView.isHidden = false
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
    @IBAction func editMobileNumber(_ sender: UIButton)
    {
        self.passcode1.resignFirstResponder()
        self.otpView.isHidden = true
        self.mobileNo.resignFirstResponder()
        self.isOTP = false
    }
    @IBAction func verifyVerificationCode()
    {
        let enteredOtp: String = self.passcode1.text! + self.passcode2.text! + self.passcode3.text! + self.passcode4.text! + self.passcode5.text! + self.passcode6.text!
        let sentOtp = UserDefaults.standard.object(forKey: "OTP") as? String
        if enteredOtp == sentOtp
        {
            let alertDel = UIAlertController(title: nil, message: "Mobile Number has been verified successfully" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.verifyBtn.isUserInteractionEnabled = false
                self.resendBtn.isUserInteractionEnabled = false
                self.editMobile.isUserInteractionEnabled = false
                self.confirmPay.isUserInteractionEnabled = true
                
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
                self.passcode1.becomeFirstResponder()
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
        self.passcode1.resignFirstResponder()
        self.checkInternetConnection()
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == passcode1 || textField == passcode2 || textField == passcode3 || textField == passcode4 || textField == passcode5 || textField == passcode6 || textField == self.mobileNo
        {
            textField.keyboardType = .numberPad
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donewithNumberPad))
            done.tag = textField.tag
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelNumberPad))
            cancel.tag = textField.tag
            numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
            self.textFld = textField
            numberToolbar.sizeToFit()
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
        if textField == mobileNo
        {
            let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
            let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
            if numberTest.evaluate(with: textField.text) == false
            {
                textField.layer.borderColor = UIColor.red.cgColor
                let alertDel = UIAlertController(title: nil, message: "Please enter valid mobile number to verify"  , preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
            }
            else
            {
                textField.layer.borderColor = UIColor.clear.cgColor
                if textFld?.text?.count == 14
                {
                    self.checkInternetConnection()
                }
                print("Nmber is correct...")
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if self.isOTP
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
        else if textField == mobileNo
        {
            self.textFld = mobileNo
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
            if str!.count == 1
            {
                self.mobileNo?.text =  "(" + (self.mobileNo?.text)!
            }
        }
        else if str!.count == 5
        {
            self.mobileNo?.text = (self.mobileNo?.text!)! + ") "
        }
        else if str!.count == 10
        {
            self.mobileNo?.text = (self.mobileNo?.text!)! + "-"
        }
        else if str!.count > 14
        {
            return false
        }
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
