//
//  ShowPopUpViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 03/11/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ShowPopUpViewController: UIViewController {
    
    @IBOutlet weak var bravecto: UIView!
    @IBOutlet weak var triheart: UIView!
    @IBOutlet weak var step12: UIButton!
    @IBOutlet weak var step13: UIButton!
    @IBOutlet weak var step22: UIButton!
    @IBOutlet weak var step23: UIButton!
    @IBOutlet weak var step1Lbl: UILabel!
    @IBOutlet weak var step2Lbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bravecto.isHidden = true
        triheart.isHidden = true
        let leftItem = UIBarButtonItem(image: UIImage(named: _NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        bravecto.clipsToBounds = true
        bravecto.layer.borderWidth = 2.0
        bravecto.layer.borderColor = UIColor(red: 92.0 / 255.0, green: 59.0 / 255.0, blue: 146.0 / 255.0, alpha: 1).cgColor
        let step1str = NSAttributedString(string: "Visit your veterinarian to get more information about Bravecto®")
        step1Lbl.attributedText = step1str
        step1Lbl.numberOfLines = 6
        step1Lbl.font = UIFont.systemFont(ofSize: 9.0)
        step1Lbl.textColor = UIColor.darkGray
        step1Lbl.lineBreakMode = .byTruncatingTail
        let step2str = NSAttributedString(string: "Visit your veterinarian to get more information about Tri-Heart® Plus")
        step2Lbl.attributedText = step2str
        step2Lbl.numberOfLines = 6
        step2Lbl.font = UIFont.systemFont(ofSize: 9.0)
        step2Lbl.textColor = UIColor.darkGray
        step2Lbl.lineBreakMode = .byTruncatingTail
        triheart.clipsToBounds = true
        triheart.layer.borderWidth = 2.0
        triheart.layer.borderColor = UIColor(red: 28.0 / 255.0, green: 150.0 / 255.0, blue: 109.0 / 255.0, alpha: 1).cgColor
        self.openNotificationAPI()
        let defaults: UserDefaults? = UserDefaults.standard
        let popupId = defaults?.object(forKey: "PopupId") as? String
        if (popupId == "1")
        {
            bravecto.isHidden = false
            triheart.isHidden = true
            let step2Str = NSAttributedString(string: "Download your rebate form here!")
            let step3Str = NSAttributedString(string: "After purchasing Bravecto® mail in your rebate form and invoice, or submit them online here.")
            let text2 = NSMutableAttributedString(attributedString: step2Str)
            text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 26, length: 4))
            let text3 = NSMutableAttributedString(attributedString: step3Str)
            text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 26, length: 4))
            text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 87, length: 4))
            step12.titleLabel?.lineBreakMode = .byTruncatingTail
            step12.titleLabel?.numberOfLines = 4
            step12.titleLabel?.adjustsFontSizeToFitWidth = true
            step12.titleLabel?.textColor = UIColor.darkGray
            step12.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step12.setAttributedTitle(text2, for: .normal)
            step13.titleLabel?.lineBreakMode = .byTruncatingTail
            step13.titleLabel?.numberOfLines = 10
            step13.titleLabel?.adjustsFontSizeToFitWidth = true
            step13.titleLabel?.textColor = UIColor.darkGray
            step13.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step13.setAttributedTitle(text3, for: .normal)
        }
        else if (popupId == "2") {
            bravecto.isHidden = true
            triheart.isHidden = false
            let step2Str = NSAttributedString(string: " Download your rebate form here!")
            let step3Str = NSAttributedString(string: "After purchasing Tri-Heart® Plus mail in your rebate form and invoice, or submit them online here.")
            let text2 = NSMutableAttributedString(attributedString: step2Str)
            let text3 = NSMutableAttributedString(attributedString: step3Str)
            text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 27, length: 4))
            text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 93, length: 4))
            step22.titleLabel?.lineBreakMode = .byTruncatingTail
            step22.titleLabel?.numberOfLines = 4
            step22.titleLabel?.adjustsFontSizeToFitWidth = true
            step22.titleLabel?.textColor = UIColor.darkGray
            step22.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step22.setAttributedTitle(text2, for: .normal)
            step23.titleLabel?.lineBreakMode = .byTruncatingTail
            step23.titleLabel?.numberOfLines = 10
            step23.titleLabel?.adjustsFontSizeToFitWidth = true
            step23.titleLabel?.textColor = UIColor.darkGray
            step23.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step23.setAttributedTitle(text3, for: .normal)
            
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    func openNotificationAPI()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let defaults: UserDefaults? = UserDefaults.standard
            let popupId = defaults?.object(forKey: "PopupId") as? String
            var promoCode = defaults?.object(forKey: "PromoCodeId") as? String
            let userId = defaults?.object(forKey: "NotificationUserId") as? String
            let notDay = defaults?.object(forKey: "NotifyDay") as? String
            if promoCode == ""
            {
                promoCode = "0"
            }
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "UserId=%@&PromocodeId=%@&PopupId=%@&DeviceType=%@&NotificationOpenDate=%@&NotificationDay=%@",userId!,promoCode!,popupId!,"IOS",date,notDay!)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format : "%@?%@", API.MerkNotification.NotificationOpen, str)
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
                            }
                            else{
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
    func clickNotificationAPI()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let defaults: UserDefaults? = UserDefaults.standard
            let popupId = defaults?.object(forKey: "PopupId") as? String
            var promoCode = defaults?.object(forKey: "PromoCodeId") as? String
            let userId = defaults?.object(forKey: "NotificationUserId") as? String
            let notDay = defaults?.object(forKey: "NotifyDay") as? String
            if promoCode == ""
            {
                promoCode = "0"
            }
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "UserId=%@&PromocodeId=%@&PopupId=%@&DeviceType=%@&LinkAccessedOnDate=%@&NotificationDay=%@",userId!,promoCode!,popupId!,"IOS",date,notDay!)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format : "%@?%@", API.MerkNotification.NotificationClick, str)
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
                                if (popupId == "1")
                                {
                                    if UIApplication.shared.canOpenURL((URL(string: "https://us.bravecto.com/pdfs/193090-0001-2017_AH_Bravecto_Rebate1-Loyalty_Reward_8.5x11_Lv1.00.pdf"))!) {
                                        UIApplication.shared.openURL((URL(string: "https://us.bravecto.com/pdfs/193090-0001-2017_AH_Bravecto_Rebate1-Loyalty_Reward_8.5x11_Lv1.00.pdf"))!)
                                    }
                                }
                                else if (popupId == "2")
                                {
                                    if UIApplication.shared.canOpenURL((URL(string: "https://www.triheartplus.com/savings-and-rewards"))!) {
                                        UIApplication.shared.openURL((URL(string: "https://www.triheartplus.com/savings-and-rewards"))!)
                                    }
                                }
                            }
                            else{
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
    @IBAction func popupUrlClick(_ sender: UIButton)
    {
        clickNotificationAPI()
    }
    
    @IBAction func openClick(_ sender: UIButton)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let popupId = UserDefaults.standard.object(forKey: "PopupId") as? String
            var promoCode = UserDefaults.standard.object(forKey: "PromoCodeId") as? String
            if promoCode == ""
            {
                promoCode = "0"
            }
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,promoCode!,popupId!,"IOS-Push","ClickRewards")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                }
                                
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
    
    @IBAction func webUrlClick(_ sender: UIButton)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let popupId = UserDefaults.standard.object(forKey: "PopupId") as? String
            var promoCode = UserDefaults.standard.object(forKey: "PromoCodeId") as? String
            if promoCode == ""
            {
                promoCode = "0"
            }
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,promoCode!,popupId!,"IOS-Push","ClickHome")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if sender.tag == 1 {
                                    if UIApplication.shared.canOpenURL((URL(string: "https://us.bravecto.com"))!) {
                                        UIApplication.shared.openURL((URL(string: "https://us.bravecto.com"))!)
                                    }
                                }
                                else
                                {
                                    if UIApplication.shared.canOpenURL((URL(string: "https://www.triheartplus.com"))!) {
                                        UIApplication.shared.openURL((URL(string: "https://www.triheartplus.com"))!)
                                    }
                                }
                                
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
