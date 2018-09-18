//
//  SavedUserLoginViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SavedUserLoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var userDefaults: UserDefaults?
    
    override func viewDidLoad() {
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
        checkForDeviceLanguage()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.userName.text = ""
        let prefs = UserDefaults.standard
        prefs.set(true, forKey: "IsUserLoggedIn")
        prefs.set(false, forKey: "PopUpMyPets")
        prefs.set(false, forKey: "PopUpAddRemi")
        prefs.set(false, forKey: "PopUpPetVets")
        prefs.set(false, forKey: "PopUpPetId")
        prefs.set(false, forKey: "PopUpCalendar")
        self.userName.text = prefs.string(forKey: "UserName")
        prefs.synchronize()
        print(prefs.string(forKey: "UserName"))
        self.profilePic.imageFromServerURL(urlString: prefs.string(forKey: "ProfilePicUrl")!,defaultImage: "ic_user_prof")
        //  self.profilePic.sd_setImage(with: NSURL(string: (prefs.value(forKey: "ProfilePicUrl"))! as? String ?? "") as URL?, placeholderImage: UIImage(named: "ic_user_prof")!, options: SDWebImageOptions(rawValue: 1))
    }
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day!
    }
    func prepareUI()
    {
        loginView.layer.masksToBounds = true
        loginView.clipsToBounds = false
        loginView.layer.cornerRadius = 5.0
        
        passwordTxtF.layer.masksToBounds = true
        passwordTxtF.layer.cornerRadius = 3.0
        passwordTxtF.font = UIFont(name: "OpenSans", size: 12.0)
        loginBtn.titleLabel?.font = UIFont(name: "OpenSans", size: 16)
        
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
        
        passwordTxtF.resignFirstResponder()
        doValidationForEmptyField()
    }
    func doValidationForEmptyField()
    {
        if passwordTxtF.text == nil || (passwordTxtF.text == "") {
            let alert = UIAlertController(title: "All fields required", message: "Please check that you have entered all fields", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            passwordTxtF.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true) 
        }
        else {
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
        // NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"]];
        let str1: String = UserDefaults.standard.string(forKey: "SavedUserName")!
        var str = String(format : "UserName=%@&password=%@", str1, self.passwordTxtF.text!)
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
                        }
                        else if status == 0 && queryDic["UserId"] as? NSNumber == 0
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "Invalid password", message: "Please enter correct password.", preferredStyle: .alert)
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
                            self.userDefaults = UserDefaults.standard
                            self.userDefaults?.set(true, forKey: "IsUserLoggedIn")
                            self.userDefaults?.set(prunedDictionary, forKey: "user")
                            self.userDefaults?.set(prunedDictionary["UserId"], forKey: "userID")
                            self.userDefaults?.set(prunedDictionary["UserType"], forKey: "userType")
                            self.userDefaults?.set(prunedDictionary["UserName"], forKey: "UserName")
                            self.userDefaults?.set(prunedDictionary["ProfilePicUrl"], forKey: "ProfilePicUrl")
                            self.userDefaults?.set(prunedDictionary["UserEmail"], forKey: "UserEmail")
                            self.userDefaults?.set(prunedDictionary["VerifyByPhone"], forKey: "IsPhoneVerified")
                            self.userDefaults?.set(prunedDictionary["VerifyByEmail"], forKey: "IsEmailVerified")
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
                                UserDefaults.standard.set(false, forKey: "LoggedOut")
                                UserDefaults.standard.synchronize()
                                self.userDefaults?.set(true, forKey: "isUserLoggedIn")
                                
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
                                    //                                    if UserDefaults.standard.bool(forKey: "ReviewShown") && UserDefaults.standard.value(forKey: "ShownDate") as? String == nil
                                    //                                    {
                                    //
                                    //                                    }
                                    //                                    else if UserDefaults.standard.value(forKey: "ShownDate") as? String != nil
                                    //                                    {
                                    //                                        let date = Date()
                                    //                                        let df = DateFormatter()
                                    //                                        df.dateFormat = "MM/dd/yyyy"
                                    //                                        let startDate = df.date(from: UserDefaults.standard.value(forKey: "ShownDate") as! String)
                                    //                                        let endDateStr = df.string(from: date)
                                    //                                        let enddate = df.date(from: endDateStr)
                                    //                                        let diff = self.daysBetweenDates(startDate: startDate!, endDate: enddate!)
                                    //                                        if diff > 28
                                    //                                        {
                                    //                                            UserDefaults.standard.set(6, forKey: "APP_OPENED_COUNT")
                                    //                                            UserDefaults.standard.set(false, forKey: "ReviewShown")
                                    //                                            UserDefaults.standard.synchronize()
                                    //                                        }
                                    //                                    }
                                    //
                                    let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int ?? 0
                                    if appOpenCount < 6
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
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: "Invalid username or password\n Please enter valid username and password", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true)
            }
        }
        
        task.resume()
        
    }
    func regisetrDeviceIDOnServer()
    {
        let headers: [String : String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","content-type": "application/json"]
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
        let urlStr =  API.Login.DeviceRegister
        guard let requestUrl = URL(string: urlStr) else { return }
        var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: str, options: [])
            
        } catch
        {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                // MBProgressHUD.hide(for: self.view, animated: true)
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
                        if status == 1
                        {
                            // MBProgressHUD.hide(for: self.view, animated: true)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
