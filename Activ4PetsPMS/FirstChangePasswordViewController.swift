//
//  FirstChangePasswordViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class FirstChangePasswordViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var settingsScroll:TPKeyboardAvoidingScrollView!
    @IBOutlet weak var  newPasswordTxt:UITextField!
    @IBOutlet weak var  confirmNewPasswordTxt:UITextField!
    @IBOutlet weak var  submitButton:UIButton!
    @IBOutlet weak var mandatoryLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.newPasswordTxt?.layer.masksToBounds = true
        self.newPasswordTxt?.layer.borderWidth = 2
        self.newPasswordTxt?.layer.cornerRadius = 3.0
        self.newPasswordTxt?.layer.borderColor = UIColor.clear.cgColor
        
        self.confirmNewPasswordTxt?.layer.masksToBounds = true
        self.confirmNewPasswordTxt?.layer.borderWidth = 2
        self.confirmNewPasswordTxt?.layer.cornerRadius = 3.0
        self.confirmNewPasswordTxt?.layer.borderColor = UIColor.clear.cgColor
        self.newPasswordTxt.isSecureTextEntry = true
        self.confirmNewPasswordTxt.isSecureTextEntry = true
        
        self.title = "FIRST CHANGE PASSWORD"
        let leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: nil, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
    }
    
    @IBAction func submitDetails(_ sender: UIButton)
    {
        self.newPasswordTxt?.resignFirstResponder()
        self.confirmNewPasswordTxt?.resignFirstResponder()
        self.doValidationForUpdateDetails()
    }
    
    func doValidationForUpdateDetails() -> Void
    {
        if  self.newPasswordTxt?.text==nil && self.newPasswordTxt?.text=="" && self.confirmNewPasswordTxt?.text==nil && self.confirmNewPasswordTxt?.text==""
        {
            self.newPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        
        if self.newPasswordTxt?.text==nil || self.newPasswordTxt?.text==""  {
            self.newPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        else
        {
            self.newPasswordTxt?.layer.borderColor=UIColor.clear.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        if self.confirmNewPasswordTxt?.text==nil || self.confirmNewPasswordTxt?.text=="" {
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        else
        {
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.clear.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        
        if !(self.newPasswordTxt?.text==nil) && !(self.newPasswordTxt?.text=="") && !(self.confirmNewPasswordTxt?.text==nil) && !(self.confirmNewPasswordTxt?.text=="")
        {
            self.mandatoryLabel?.isHidden=true
            let check:Bool = self.doValidationForTextFileds()
            if check==true
            {
                if CheckNetwork.isExistenceNetwork()
                {
                    MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
                    self.webServiceToUpdateDetails()
                }
            }
        }
    }
    func doValidationForTextFileds() -> Bool
    {
        let passwordString: String = (self.newPasswordTxt?.text)!
        let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
        let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
        if passWordTest.evaluate(with: passwordString) == false
        {
            self.newPasswordTxt?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if !(self.doValidationForStringsMatch())
        {
            return false
        }
        
        return true
        
    }
    func doValidationForStringsMatch() -> Bool
    {
        let pass=self.newPasswordTxt?.text!
        let con = self.confirmNewPasswordTxt?.text!
        if pass==con
        {
            return true
        }
        else{
            self.newPasswordTxt?.layer.borderColor=UIColor.red.cgColor;
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.red.cgColor;
            return false
        }
    }
    func webServiceToUpdateDetails() -> Void {
        
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var details = String(format : "UserId=%@&NewPassword=%@", userId,self.newPasswordTxt!.text!)
        details = details.trimmingCharacters(in: CharacterSet.whitespaces)
        details = details.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Login.ChangeTempPass, details)
        var request = URLRequest(url: URL(string: urlStr)!)
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        print(json ?? " ")
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: "Password Change Alert !", message: "Your password has been updated successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                
                                let terms = UserDefaults.standard.bool(forKey: "Conditions")
                                if terms == true
                                {
                                    let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                                    self.navigationController?.pushViewController(MyPets, animated: true)
                                }
                                else
                                {
                                    let termsCond: TermsAndConditionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TandC") as! TermsAndConditionsViewController
                                    self.navigationController?.pushViewController(termsCond, animated: true)
                                }
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
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField==self.newPasswordTxt || textField==self.confirmNewPasswordTxt
        {
            let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
            let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
            if passWordTest.evaluate(with: textField.text) != true
            {
                textField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        }
        if textField==self.confirmNewPasswordTxt
        {
            let pass=self.newPasswordTxt?.text!
            let con = self.confirmNewPasswordTxt?.text!
            if pass==con
            {
                textField.layer.borderColor = UIColor.clear.cgColor
            }
            else{
                textField.layer.borderColor = UIColor.red.cgColor
            }
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
