//
//  OTPVerificationViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 16/11/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class OTPVerificationViewController: UIViewController, UITextFieldDelegate
{
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
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
       
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
        self.textLbl.text = String(format: "Please enter the verification code sent to %@ %@",countryCode, UserDefaults.standard.string(forKey: "MobileNumber")!)
       
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // This allows numeric text only, but also backspace for deletes
        if (string.count ) > 0 && !Scanner(string: string).scanInt32(nil)
        {
            return false
        }
        let oldLength: Int = textField.text?.count ?? 0
        let replacementLength: Int = string.count 
        let rangeLength: Int = range.length
        let newLength: Int = oldLength - rangeLength + replacementLength
        // This 'tabs' to next field when entering digits
        if newLength == 1
        {
            if textField == passcode1
            {
                perform(#selector(self.setNextResponder), with: passcode2, afterDelay: 0.1)
            }
            else if textField == passcode2
            {
                perform(#selector(self.setNextResponder), with: passcode3, afterDelay: 0.1)
            }
            else if textField == passcode3
            {
                perform(#selector(self.setNextResponder), with: passcode4, afterDelay: 0.1)
            }
            else if textField == passcode4
            {
                perform(#selector(self.setNextResponder), with: passcode5, afterDelay: 0.1)
            }
            else if textField == passcode5
            {
                perform(#selector(self.setNextResponder), with: passcode6, afterDelay: 0.1)
            }
        }
        else if oldLength > 0 && newLength == 0
        {
            if textField == passcode6
            {
                perform(#selector(self.setNextResponder), with: passcode5, afterDelay: 0.1)
            }
            else if textField == passcode5
            {
                perform(#selector(self.setNextResponder), with: passcode4, afterDelay: 0.1)
            }
            else if textField == passcode4
            {
                perform(#selector(self.setNextResponder), with: passcode3, afterDelay: 0.1)
            }
            else if textField == passcode3
            {
                perform(#selector(self.setNextResponder), with: passcode2, afterDelay: 0.1)
            }
            else if textField == passcode2
            {
                perform(#selector(self.setNextResponder), with: passcode1, afterDelay: 0.1)
            }
        }
        return newLength <= 1
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @objc func setNextResponder(_ nextResponder: UITextField)
    {
        nextResponder.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passcode1.becomeFirstResponder()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == passcode1 || textField == passcode2 || textField == passcode3 || textField == passcode4 || textField == passcode5 || textField == passcode6
            
        {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donewithNumberPad))
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelNumberPad))
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
//    func textFieldDidChange(textField: UITextField)
//    {
//        let text = textField.text
//        
//        if text?.utf16.count==1
//        {
//            switch textField
//            {
//            case passcode1:
//                passcode2.becomeFirstResponder()
//            case passcode2:
//                passcode3.becomeFirstResponder()
//            case passcode3:
//                passcode4.becomeFirstResponder()
//            case passcode4:
//                passcode5.becomeFirstResponder()
//            case passcode5:
//                passcode6.becomeFirstResponder()
//            case passcode6:
//                passcode6.resignFirstResponder()
//            default:
//                break
//            }
//        }
//        else
//        {
//            
//        }
//    }
    
    @IBAction func verifyVerificationCode()
    {
        let enteredOtp: String = self.passcode1.text! + self.passcode2.text! + self.passcode3.text! + self.passcode4.text! + self.passcode5.text! + self.passcode6.text!
        let sentOtp = UserDefaults.standard.object(forKey: "OTP") as? String
        if enteredOtp == sentOtp
        {
            MBProgressHUD.hide(for: self.view, animated: true)
            let alertDel = UIAlertController(title: "Done !", message: "Thank you for subscription", preferredStyle: .alert)
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
            let alertDel = UIAlertController(title: "Error !", message: "Invalid code\n Please enter valid verification code"  , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
    }
    @IBAction func resendVerificationCode()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache","content-type": "application/json"]
            
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
            let prefs = UserDefaults.standard
            var str: String = String(format: "phoneNumber=%@&countryCode=%@&emailId=%@&firstName=%@&lastName=%@&verifyThrough=%@", prefs.string(forKey: "MobileNumber")!, countryCode, "", prefs.string(forKey: "SignUpFirstName")!, prefs.string(forKey: "SignUpLastName")!, "Phone")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Login.SignUpOtp, str)
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
                print("responseString = \(String(describing: responseString))")
                if let str = String(data: data, encoding: .utf8),
                    let count: Int = Int(str)
                {
                    DispatchQueue.main.async
                        {
                            if count > 0
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                UserDefaults.standard.set(count, forKey: "OTP")
                                UserDefaults.standard.synchronize()
                                
                                let alertDel = UIAlertController(title: nil, message: String(format: "Verification code has been sent to %@ %@",countryCode,prefs.string(forKey: "MobileNumber")!)  , preferredStyle: .alert)
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
