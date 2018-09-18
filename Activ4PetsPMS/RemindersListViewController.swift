//
//  RemindersListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 05/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class RemindersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var noDataLbl: UILabel?
    var remModelList = [ReminderModel]()
    @IBOutlet weak var RemList: UITableView!
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var step2: UIButton!
    @IBOutlet weak var step3: UIButton!
    @IBOutlet weak var step1Lbl: UILabel!
    var senderId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus.png"), style: .done, target: self, action: #selector(self.rightClk2))
        navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text =  "No reminders found.\n Tap on '+' to create a new Reminder"
        noDataLbl?.numberOfLines = 2
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.center = self.view.center
        popUpView.clipsToBounds = true
        popUpView.layer.borderWidth = 2.0
        popUpView.layer.borderColor = UIColor(red: 92.0 / 255.0, green: 59.0 / 255.0, blue: 146.0 / 255.0, alpha: 1).cgColor
        self.offerView.isHidden = true
        let isShown: Bool = UserDefaults.standard.bool(forKey: "PopUpAddRemi")
        let step2Str = NSAttributedString(string: " Download your rebate form here!")
        let step3Str = NSAttributedString(string: "After purchasing Bravecto® mail in your rebate form and invoice, or submit them online here.")
        let text2 = NSMutableAttributedString(attributedString: step2Str)
        let text3 = NSMutableAttributedString(attributedString: step3Str)
        text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 27, length: 4))
        text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 87, length: 4))
        let step1str = NSAttributedString(string: "Visit your veterinarian to get more information about Bravecto®")
        step1Lbl.attributedText = step1str
        step1Lbl.numberOfLines = 6
        step1Lbl.font = UIFont.systemFont(ofSize: 9.0)
        step1Lbl.textColor = UIColor.darkGray
        step1Lbl.lineBreakMode = .byTruncatingTail
        step2.titleLabel?.lineBreakMode = .byTruncatingTail
        step2.titleLabel?.numberOfLines = 4
        step2.titleLabel?.adjustsFontSizeToFitWidth = true
        step2.titleLabel?.textColor = UIColor.darkGray
        step2.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
        step2.setAttributedTitle(text2, for: .normal)
        step3.titleLabel?.lineBreakMode = .byTruncatingTail
        step3.titleLabel?.numberOfLines = 10
        step3.titleLabel?.adjustsFontSizeToFitWidth = true
        step3.titleLabel?.textColor = UIColor.darkGray
        step3.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
        step3.setAttributedTitle(text3, for: .normal)
        if isShown {
            
        }
        else {
            // getPopupCount()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkInternetConnection()
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func rightClk2(sender: AnyObject)
    {
        let add: AddEditReminderViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddReminder") as! AddEditReminderViewController
        add.isFromVC = false
        self.navigationController?.pushViewController(add, animated: true)
    }
    func getPopupCount()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d",userId,12,1)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.GetCount,str)
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
                if let str = String(data: data, encoding: .utf8),
                    let count: Int = Int(str)
                {
                    DispatchQueue.main.async
                        {
                            if count > 0
                            {
                                self.offerView.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else {
                                self.callOpenPopupAPI()
                                self.offerView.isHidden = false
                                self.noDataLbl?.isHidden = true
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callOpenPopupAPI()
    {
        let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date: String = formater.string(from: Date())
        var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",userId,12,1,"Open","IOS",date)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format: "%@?%@",API.MerkNotification.OpenPopUP,str)
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
                            let dict:[String: Any] = json?["Message"] as! [String : Any]
                            self.senderId = dict["Id"] as! Int
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    }
    @IBAction func closePopup(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,1,"Close","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                                self.offerView.isHidden = true
                                UserDefaults.standard.set(true, forKey: "PopUpMyPets")
                                UserDefaults.standard.synchronize()
                                if self.remModelList.count > 0 {
                                    self.noDataLbl?.isHidden = true
                                }
                                else {
                                    self.noDataLbl?.isHidden = false
                                }
                                
                            }
                            else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callClickPopupAPI()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,1,"Download","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                                self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://login.activ4pets.com/content/images/Merck/Bravecto_Loyalty_Rebate.pdf"))!)
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
    @IBAction func popupClick(_ sender: UIButton)
    {
        callClickPopupAPI()
    }
    
    @IBAction func openClick(_ sender: UIButton)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,1,"IOS-App","ClickRewards")
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
    
    @IBAction func callWebLink(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,1,"IOS-App","ClickHome")
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
                                if UIApplication.shared.canOpenURL((URL(string: "https://us.bravecto.com"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://us.bravecto.com"))!)
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
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.remModelList = []
            self.webServiceToGetRemList()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func webServiceToGetRemList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.Reminders.ReminderList, userId)
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
                let queryDic = json?["Reminders"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            self.RemList.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            for item in queryDic
                            {
                                var prunedDictionary = [String: Any]()
                                for key: String in item.keys
                                {
                                    if !(item[key] is NSNull) {
                                        prunedDictionary[key] = item[key]
                                    }
                                    else {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            //  self.vetModelList = [VetModel]()
                            for item in filtered
                            {
                                let str = item["Date"] as? String
                                if str != ""
                                {
                                    let arr:[String] = str!.components(separatedBy: " ")
                                    var str = arr[1] as? NSString
                                    str = str?.replacingCharacters(in: NSMakeRange(4,3), with:"") as NSString?
                                    let timeStr = String(format: "%@ %@", str!, arr[2])
                                    
                                    let Reminder = ReminderModel(id: item["Id"] as? String, date: arr[0], time: timeStr, reason: item["Reason"] as? String, comments: item["Comment"] as? String, vet: item["Physician"] as? String, repeatInt: item["Repeat"] as? String)
                                    
                                    
                                    self.remModelList.append(Reminder)
                                }
                                else
                                {
                                    let Reminder = ReminderModel(id: item["Id"] as? String, date: " ", time: " ", reason: item["Reason"] as? String, comments: item["Comment"] as? String, vet: item["Physician"] as? String, repeatInt: item["Repeat"] as? String)
                                    self.remModelList.append(Reminder)
                                }
                                
                                
                            }
                            for model in self.remModelList
                            {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                                let date = dateFormatter.date(from: model.date!)
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                model.date = dateFormatter.string(from: date!)
                            }
                            self.remModelList = self.remModelList.sorted(by: {$0.date?.compare($1.date!) == .orderedDescending})
                            self.RemList.reloadData()
                            self.noDataLbl?.isHidden = true
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return remModelList.count > 0 ? remModelList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let rem = self.remModelList[indexPath.row]
        // cell.type.text = NSLocalizedString("Species")
        cell.firstLabel.text = rem.reason
        cell.timeLabel.text = rem.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.remModelList[indexPath.row];
        self.performSegue(withIdentifier: "ShowReminder", sender: model)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let details = segue.destination as! ReminderDetailsViewController
        details.model = sender as? ReminderModel
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
