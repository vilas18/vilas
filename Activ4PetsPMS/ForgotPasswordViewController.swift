//
//  ForgotPasswordViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var isPhone: Bool = false
    var isEmail: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: nil, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        
        prepareUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.userName.text = "Forgot Password ?"
        self.userNameTxt.text = ""
        self.userNameTxt.isSecureTextEntry = false
    }
    func prepareUI()
    {
        loginView.layer.masksToBounds = true
        loginView.clipsToBounds = false
        loginView.layer.cornerRadius = 5.0
        
        userNameTxt.layer.masksToBounds = true
        userNameTxt.layer.cornerRadius = 3.0
        userNameTxt.font = UIFont(name: "OpenSans", size: 12.0)
        loginBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 16)
        
        userNameTxt.resignFirstResponder()
    }
    @IBAction func backToLoginClk(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginClk(_ sender: Any)
    {
        print("Login Button Click....")
        
        userNameTxt.resignFirstResponder()
        doValidationForEmptyField()
    }
    func doValidationForEmptyField()
    {
        if userNameTxt.text == nil || (userNameTxt.text == "")
        {
            let alert = UIAlertController(title: "Warning", message: "Please enter your email", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            userNameTxt.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true) 
        }
        else
        {
            self.doValidationForEmailAddress()
        }
    }
    
    func doValidationForEmailAddress()
    {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        if emailTest.evaluate(with: userNameTxt.text) == false
        {
            let alert = UIAlertController(title: nil, message: "Please Enter Valid Email Address.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else
        {
            self.startAuthenticatingUser()
        }
    }
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("", comment: "")
            webserviceToAuthenticateUser()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webserviceToAuthenticateUser()
    {
        let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        let urlStr = String(format : "%@?email=%@", API.Login.ForgotPassword, self.userNameTxt.text!)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
        request.httpMethod = "POST"
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
                let status = json?["status"] as? Int
            {
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: nil, message: "Password has been sent to your email successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: nil, message: json?["msg"] as? String, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == userNameTxt
        {
            if textField.text != nil && textField.text != ""
            {
                let str = textField.text
                if let num = Int(str!)
                {
                    self.isPhone = true
                    self.isEmail = false
                }
                else
                {
                    let word = self.userNameTxt.text
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
        if textField == userNameTxt
        {
            if textField.text?.count == 0
            {
                print("email is correct...")
            }
            else if self.isEmail
            {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                if emailTest.evaluate(with: userNameTxt.text) == false
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
                // let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$" "^[0-9]{10}|\\d{3}[-. ]\\d{3}[-. ]\\d{4}"
                let numberReg: String = "^[0-9]{10}|\\d{3}[-. ]\\d{3}[-. ]\\d{4}"
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == userNameTxt
        {
            let count: Int = (self.userNameTxt.text?.count)!
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
                    let word = self.userNameTxt.text
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
            if self.isPhone
            {
                if str.count > 10
                {
                    return false
                }
                else{
                    return true
                }
            }
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
