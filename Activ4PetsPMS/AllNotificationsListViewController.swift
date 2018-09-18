//
//  NewNotificationsListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 19/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AllNotificationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var notifyModelList = [NotificationsModel]()
    var notifyDetailsModelList = [NotificationDetailsModel]()
    @IBOutlet weak var notifyListTv: UITableView!
    var addContact: Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        self.title = "Notifications"
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        
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
    func checkInternetConnection() {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.notifyModelList = []
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
        let urlStr = String(format : "%@?UserId=%@", API.Owner.AllNotifications, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let queryDic = json?["NotificationList"] as? [[String : Any]]
            {
                print(json ?? "")
                
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            for item1 in queryDic
                            {
                                let detailsList = item1["lstNotification"] as? [[String : Any]]
                                var filtered = [[String : Any]]()
                                for item in detailsList!
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
                                self.notifyDetailsModelList = []
                                for item in filtered
                                {
                                    let details = NotificationDetailsModel(isSMOPaymentDone: item["IsSMOPaymentDone"] as? Bool , conversationId: item["ConversationId"] as? String, subject: item["Subject"] as? String, fromUserId: item["FromUserId"] as? NSNumber, illegalPostId: item["IllegalPostId"] as? String, messageDateText: item["MessageDateText"] as? String, fromUserName: item["FromUserName"] as? String, messageTypeId: item["MessageTypeId"] as? String, typeOfNotification: item["TypeOfNotification"] as? String, creationDate: item["CreationDate"] as? String, notificationDate: item["NotificationDateStr"] as? String, petID: item["PetID"] as? NSNumber,shareCategoryTypeId: item["ShareCategoryTypeId"] as? String, isAccepted: item["IsAccepted"] as? Bool, userMessage: item["UserMessage"] as? String, isClinicVisit: item["IsClinicVisit"] as? Bool, isOnlineConsultation: item["IsOnlineConsultation"] as? Bool, bookApptId: item["BookApptId"] as? String, isRead: item["IsNotifRead"] as? Bool)
                                    
                                    self.notifyDetailsModelList.append(details)
                                }
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                                let date = dateFormatter.date(from: item1["NotificationDate"] as! String)
                                let model = NotificationsModel(notifiDate: date! as NSDate, month: item1["Month"] as! String, year: item1["Year"] as! String, monthlyList: self.notifyDetailsModelList)
                                
                                self.notifyModelList.append(model)
                                
                            }
                            self.notifyListTv.reloadData()
                            self.notifyModelList = self.notifyModelList.sorted(by: {$0.notifiDate.timeIntervalSinceNow > $1.notifiDate.timeIntervalSinceNow})
                            self.notifyListTv.reloadData()
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return notifyModelList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let model = self.notifyModelList[section]
        
        return model.monthlyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        
        let model = self.notifyModelList[indexPath.section]
        let list = model.monthlyList
        let detailsModel = list[indexPath.row]
        print(detailsModel.typeOfNotification ?? " ")
        cell.icon.image = UIImage(named: "noti_blue")
        cell.icon.backgroundColor = UIColor.clear
        
        if detailsModel.notificationDate != ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss aa"// yyyy-MM-dd"
            let date = dateFormatter.date(from: detailsModel.notificationDate!)
            print(date ?? "")
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm aa"// yyyy-MM-dd"
            let dateStr = dateFormatter.string(from: date!)
            print(dateStr)
            let dateFinal = dateFormatter.date(from: dateStr)
            print(dateFinal ?? "")
            let calendar = Calendar.current
            let month = calendar.component(.month, from: dateFinal!)
            let day = calendar.component(.day, from: dateFinal!)
            let monthName = dateFormatter.shortMonthSymbols[month-1]
            let str: [String] = (dateStr.components(separatedBy: " "))
            cell.timeLabel.text = String(format: "%@-%d %@ %@",monthName,day,str[1], str[2])
        }
        if detailsModel.isRead == false
        {
            cell.firstLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
        else
        {
            cell.firstLabel.font = UIFont.systemFont(ofSize: 13.0)
        }
        
        if detailsModel.typeOfNotification == "unsharedinfo"
        {
            cell.firstLabel.text = detailsModel.subject
        }
        else if detailsModel.typeOfNotification == "smo"
        {
            cell.firstLabel.text = detailsModel.subject
        }
        else if detailsModel.typeOfNotification == "addContact"
        {
            cell.firstLabel.text = detailsModel.subject
        }
        else if detailsModel.typeOfNotification == "shareinfo"
        {
            cell.firstLabel.text = detailsModel.subject
        }
        
        print(cell.firstLabel.text as Any)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.notifyModelList[indexPath.section]
        let list = model.monthlyList
        let detailsModel = list[indexPath.row]
        
        if detailsModel.typeOfNotification == "addContact"
        {
            if detailsModel.isRead == false
            {
                self.notificationOpenClk(detailsModel)
                
                let alert = UIAlertController(title: "Add To Contact", message: String(format: "Would you like to add %@ in your contact list",detailsModel.fromUserName!), preferredStyle: .alert)
                let ok = UIAlertAction(title: "YES", style: .default, handler: {(action: UIAlertAction) -> Void in
                    self.addContact = true
                    if detailsModel.isRead == false
                    {
                        self.notificationOpenClk(detailsModel)
                    }
                    
                    self.acceptContact(detailsModel)
                })
                let cancel = UIAlertAction(title: "NO", style: .default, handler: {(action: UIAlertAction) -> Void in
                    
                    self.addContact = false
                    if detailsModel.isRead == false
                    {
                        self.notificationOpenClk(detailsModel)
                    }
                    self.declineContact(detailsModel)
                })
                
                alert.addAction(ok)
                alert.addAction(cancel)
                present(alert, animated: true)
            }
            else
            {
                let details: MyContactsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MyContacts") as? MyContactsViewController)!
                self.navigationController?.pushViewController(details, animated: true)
            }
        }
        else if detailsModel.typeOfNotification == "smo"
        {
            if detailsModel.isRead == false
            {
                self.notificationOpenClk(detailsModel)
            }
            let details: SMODetailsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SMODetails") as? SMODetailsViewController)!
            details.isFromVC = true
            details.smoId = detailsModel.conversationId!
            self.navigationController?.pushViewController(details, animated: true)
            
        }
        else if detailsModel.typeOfNotification == "shareinfo"
        {
            if detailsModel.isRead == false
            {
                self.notificationOpenClk(detailsModel)
            }
            self.getPermissions(detailsModel)
        }
        else if detailsModel.typeOfNotification == "unsharedinfo"
        {
            if detailsModel.isRead == false
            {
                self.notificationOpenClk(detailsModel)
            }
            let shared: SharedPetsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SharedPets") as! SharedPetsListViewController
            shared.isFromVC = true
            shared.petId = detailsModel.petID!
            self.navigationController?.pushViewController(shared, animated: true)
        }
    }
    func getPermissions(_ model: NotificationDetailsModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlStr = String(format : "%@?petId=%@&userId=%@&fromuserId=%@", API.Owner.GetSharedPetAccept, model.petID!,userId,model.fromUserId!)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if status == 1
                            {
                                let Shared: SharedWithMeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Shared") as! SharedWithMeViewController
                                self.navigationController?.pushViewController(Shared, animated: true)
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
    func acceptContact(_ model: NotificationDetailsModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache","content-type": "application/json"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlStr = String(format : "%@?fromUserId=%@&userId=%@",API.Owner.AcceptContact, model.fromUserId!,userId)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.httpMethod = "POST"
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
                    let msg = json?["msg"] as? String
                {
                    DispatchQueue.main.async
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            let alertDel = UIAlertController(title: nil, message: "Contact has been added sucessfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                let details: MyContactsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MyContacts") as? MyContactsViewController)!
                                self.navigationController?.pushViewController(details, animated: true)
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
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
    func declineContact(_ model: NotificationDetailsModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache","content-type": "application/json"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlStr = String(format : "%@?fromUserId=%@&userId=%@&message=%@",API.Owner.DeclineContact, model.fromUserId!,userId,"")
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.httpMethod = "POST"
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
                    let msg = json?["msg"] as? String
                {
                    DispatchQueue.main.async
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            let alertDel = UIAlertController(title: nil, message: "Contact has been declined sucessfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                let details: MyContactsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MyContacts") as? MyContactsViewController)!
                                self.navigationController?.pushViewController(details, animated: true)
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
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
    func notificationOpenClk(_ model : NotificationDetailsModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var urlStr: String = ""
            var str: String = ""
            if model.typeOfNotification == "addContact"
            {
                
                if self.addContact
                {
                    str = String(format : "userId=%@&ConversationId=%@&MessageType=%@",userId,model.conversationId!, "addContact")
                    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                    str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    urlStr = String(format : "%@?%@",API.Owner.NotificationOpen,str)
                }
                else
                {
                    str = String(format : "userId=%@&ConversationId=%@&MessageType=%@",userId,model.conversationId!, "addContactForDeleted")
                    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                    str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    urlStr = String(format : "%@?%@",API.Owner.NotificationOpen,str)
                }
            }
            else
            {
                str = String(format : "userId=%@&ConversationId=%@&MessageType=%@",userId,model.conversationId!, model.typeOfNotification!)
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                urlStr = String(format : "%@?%@",API.Owner.NotificationOpen,str)
            }
            
            let requestUrl = URL(string: urlStr)
            var request = URLRequest(url:requestUrl!)
            request.httpMethod = "GET"
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
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if status == 1
                            {
                                //                                let alertDel = UIAlertController(title: nil, message: "Reminder has been deleted successfully", preferredStyle: .alert)
                                //                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                //                                    _ = self.navigationController?.popViewController(animated: true)
                                //                                })
                                //
                                //                                alertDel.addAction(ok)
                                //                                self.present(alertDel, animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let model = self.notifyModelList[section]
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: tableView.frame.size.width-30, height: 30)
        label.textColor = UIColor(red: (6.0 / 255.0), green: (103.0 / 255.0), blue: (184.0 / 255.0), alpha: 1)
        label.textAlignment = .left
        label.text = String(format: "%@ %@", model.month, model.year)
        view.addSubview(label)
        
        return view
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

