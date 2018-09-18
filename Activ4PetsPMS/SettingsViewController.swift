//
//  SettingsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
    @IBOutlet weak var settingsScroll:TPKeyboardAvoidingScrollView!
    @IBOutlet weak var  oldPasswordTxt:UITextField!
    @IBOutlet weak var  newPasswordTxt:UITextField!
    @IBOutlet weak var  confirmNewPasswordTxt:UITextField!
    @IBOutlet weak var  submitButton:UIButton!
    @IBOutlet weak var mandatoryLabel:UILabel!
    @IBOutlet weak var prfileSettingsSeg:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.oldPasswordTxt.isSecureTextEntry = true
        self.newPasswordTxt.isSecureTextEntry = true
        self.confirmNewPasswordTxt.isSecureTextEntry = true
        
        
        self.oldPasswordTxt?.layer.masksToBounds = true
        self.oldPasswordTxt?.layer.borderWidth = 2
        self.oldPasswordTxt?.layer.cornerRadius = 3.0
        self.oldPasswordTxt?.layer.borderColor = UIColor.clear.cgColor
        
        self.newPasswordTxt?.layer.masksToBounds = true
        self.newPasswordTxt?.layer.borderWidth = 2
        self.newPasswordTxt?.layer.cornerRadius = 3.0
        self.newPasswordTxt?.layer.borderColor = UIColor.clear.cgColor
        
        self.confirmNewPasswordTxt?.layer.masksToBounds = true
        self.confirmNewPasswordTxt?.layer.borderWidth = 2
        self.confirmNewPasswordTxt?.layer.cornerRadius = 3.0
        self.confirmNewPasswordTxt?.layer.borderColor = UIColor.clear.cgColor
        
        self.prfileSettingsSeg?.addTarget(self, action: #selector(self.selectProfileSettings), for: .valueChanged)
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        self.prfileSettingsSeg.selectedSegmentIndex = 2
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    @objc func selectProfileSettings (sender:UISegmentedControl)-> Void
    {
        if sender.selectedSegmentIndex==0
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is MyProfileViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if sender.selectedSegmentIndex==1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is MyPlanViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let plan: MyPlanViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPlan") as! MyPlanViewController
                    self.navigationController?.pushViewController(plan, animated: true)
                    break
                    
                }
            }
        }
        else if sender.selectedSegmentIndex==2
        {
            
        }
    }
    
    @IBAction func submitDetails(_ sender: UIButton)
    {
        
        self.oldPasswordTxt?.resignFirstResponder()
        self.newPasswordTxt?.resignFirstResponder()
        self.confirmNewPasswordTxt?.resignFirstResponder()
        self.doValidationForUpdateDetails()
    }
    
    func doValidationForUpdateDetails() -> Void
    {
        if  self.oldPasswordTxt?.text==nil && self.oldPasswordTxt?.text=="" && self.newPasswordTxt?.text==nil && self.newPasswordTxt?.text=="" && self.confirmNewPasswordTxt?.text==nil && self.confirmNewPasswordTxt?.text==""
        {
            self.oldPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.newPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        if self.oldPasswordTxt?.text == nil || self.oldPasswordTxt?.text == "" {
            self.oldPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        else
        {
            self.oldPasswordTxt?.layer.borderColor=UIColor.clear.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        if self.newPasswordTxt?.text == nil || self.newPasswordTxt?.text == ""  {
            self.newPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        else
        {
            self.newPasswordTxt?.layer.borderColor=UIColor.clear.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        if self.confirmNewPasswordTxt?.text == nil || self.confirmNewPasswordTxt?.text == "" {
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.red.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        else
        {
            self.confirmNewPasswordTxt?.layer.borderColor=UIColor.clear.cgColor
            self.mandatoryLabel?.isHidden=false
        }
        
        if !(self.oldPasswordTxt?.text==nil) && !(self.oldPasswordTxt?.text=="") && !(self.newPasswordTxt?.text==nil) && !(self.newPasswordTxt?.text=="") && !(self.confirmNewPasswordTxt?.text==nil) && !(self.confirmNewPasswordTxt?.text=="")
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
        else if !(self.doValidationForOldPassword())
        {
            return false
        }
        
        return true
        
    }
    func doValidationForOldPassword() -> Bool
    {
        let passwordString: String = (self.oldPasswordTxt?.text)!
        let passWordReg: String = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_!*-]).*$"
        let passWordTest = NSPredicate(format: "SELF MATCHES %@", passWordReg)
        if passWordTest.evaluate(with: passwordString) == false
        {
            self.oldPasswordTxt?.layer.borderColor = UIColor.red.cgColor
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
        var details = String(format : "UserId=%@&OldUserName=%@&NewUserName=%@&OldPassword=%@&NewPassword=%@&ConfirmPassword=%@", userId,"", "", self.oldPasswordTxt!.text!, self.newPasswordTxt!.text!, self.confirmNewPasswordTxt!.text! )
        details = details.trimmingCharacters(in: CharacterSet.whitespaces)
        details = details.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Owner.Settings, details)
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
                print(json ?? " ")
                if status == 1
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alertDel = UIAlertController(title: nil, message: "Details has been changed successfully.\n Please login again with the new details", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        let saved: SavedUserLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedLogin") as! SavedUserLoginViewController
                        self.navigationController?.setViewControllers([saved], animated: true)
                        for controller: UIViewController in self.navigationController?.viewControllers ?? []
                        {
                            if (controller is SavedUserLoginViewController)
                            {
                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        
                    })
                    
                    alertDel.addAction(ok)
                    self.present(alertDel, animated: true, completion: nil)
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
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
        if textField == oldPasswordTxt
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
