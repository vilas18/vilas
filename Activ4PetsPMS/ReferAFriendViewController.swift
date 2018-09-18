//
//  ReferAFriendViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 23/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ReferAFriendViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mandatoryLbl: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        self.mandatoryLbl.isHidden = true
        firstName.layer.masksToBounds = true
        firstName.layer.borderWidth = 2
        firstName.layer.cornerRadius = 3.0
        firstName.layer.borderColor = UIColor.clear.cgColor
        
        lastName.layer.masksToBounds = true
        lastName.layer.borderWidth = 2
        lastName.layer.cornerRadius = 3.0
        lastName.layer.borderColor = UIColor.clear.cgColor
        
        email.layer.masksToBounds = true
        email.layer.borderWidth = 2
        email.layer.cornerRadius = 3.0
        email.layer.borderColor = UIColor.clear.cgColor
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == email
        {
            if textField.text?.count == 0
            {
                print("email is correct...")
            }
            else
            {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                if emailTest.evaluate(with: email?.text) == false
                {
                    textField.layer.borderColor = UIColor.red.cgColor
                    let alertDel = UIAlertController(title: nil, message: "Please enter a valid email" , preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        
                    })
                    
                    alertDel.addAction(ok)
                    self.present(alertDel, animated: true, completion: nil)
                }
                else
                {
                    textField.layer.borderColor = UIColor.clear.cgColor
                    print("email is correct...")
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func sendInvitation(_ sender: UIButton)
    {
        //        self.firstName.resignFirstResponder()
        //        self.lastName.resignFirstResponder()
        //        self.email.resignFirstResponder()
        //        self.doValidationForReferAFrnd()
        // InviteReferrals.launch("18346", email: "vilas18@gmail.com", mobile: "7892934467", name: "Vilas", subscriptionID: nil)
        
        
    }
    func doValidationForReferAFrnd()
    {
        if self.firstName.text == nil && self.firstName.text == "" && self.lastName.text == nil && self.lastName.text == "" && self.email.text == nil && self.email.text == ""
        {
            self.firstName.layer.borderColor = UIColor.red.cgColor
            self.lastName.layer.borderColor = UIColor.red.cgColor
            self.email.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.firstName.text == nil || self.firstName.text == ""
        {
            self.firstName.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.firstName.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.lastName.text == nil || self.lastName.text == ""
        {
            self.lastName.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.lastName.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.email.text == nil || self.email.text == ""
        {
            self.email.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.email.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        
        if !(self.firstName.text == nil) && !(self.firstName.text == "") && !(self.lastName.text == nil) && !(self.lastName.text == "") && !(self.email.text == nil) && !(self.email.text == "")
        {
            self.mandatoryLbl.isHidden = true
            if self.dovalidationForEmail()
            {
                self.checkInternetConnection()
            }
            
        }
    }
    func dovalidationForEmail() -> Bool
    {
        let emailString: String = email!.text!
        let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        if (email?.text?.count)! > 0 && (emailTest.evaluate(with: emailString) != true)
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter a valid email", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            email?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else
        {
            return true
        }
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToGetReferAFriend()
        }
        else
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToGetReferAFriend()
    {
        let headers = [
            "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
            "cache-control": "no-cache"
        ]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var urlString = String(format : "FirstName=%@&LastName=%@&Email=%@&SenderUserId=%@&Isvet=%@",self.firstName.text!,self.lastName.text!,self.email.text!,userId,"false")
        urlString = urlString.trimmingCharacters(in: CharacterSet.whitespaces)
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format: "%@?%@",API.Invite.UserInvite,urlString)
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
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
                            let alertDel = UIAlertController(title: nil, message: "Invitation has been sent successfully" , preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: nil, message: json?["Message"] as? String, preferredStyle: .alert)
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
