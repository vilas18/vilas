//
//  NotificationsListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 08/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class NotificationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var noDataLbl: UILabel?
    var notifyModelList = [NotificationsModel]()
    var notifyDetailsModelList = [NotificationDetailsModel]()
    @IBOutlet weak var notifyListTv: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        
        navigationItem.rightBarButtonItem = rightItem1
        navigationItem.rightBarButtonItem = rightItem1!
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text = "No record found"
        noDataLbl?.center = self.view.center

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
        let urlStr = String(format : "%@?UserId=%@", API.Owner.OldNotifications, userId)
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
                let queryDic = json?["NotificationList"] as? [[String : Any]]
            {
               
                DispatchQueue.main.async
                    {
                if queryDic.count == 0
                {
                    self.noDataLbl?.isHidden = false
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
                            let details = NotificationDetailsModel(isSMOPaymentDone: item["IsSMOPaymentDone"] as? Bool , conversationId: item["ConversationId"] as? String, subject: item["Subject"] as? String, fromUserId: item["FromUserId"] as? NSNumber, illegalPostId: item["IllegalPostId"] as? String, messageDateText: item["MessageDateText"] as? String, fromUserName: item["FromUserName"] as? String, messageTypeId: item["MessageTypeId"] as? String, typeOfNotification: item["TypeOfNotification"] as? String, creationDate: item["CreationDate"] as? String, notificationDate: item["NotificationDateStr"] as? String, petID: item["PetID"] as? NSNumber,shareCategoryTypeId: item["ShareCategoryTypeId"] as? String, isAccepted: item["IsAccepted"] as? Bool, userMessage: item["UserMessage"] as? String, isClinicVisit: item["IsClinicVisit"] as? Bool, isOnlineConsultation: item["IsOnlineConsultation"] as? Bool, bookApptId: item["BookApptId"] as? String,isRead: item["IsNotifRead"] as? Bool)
                            
                            self.notifyDetailsModelList.append(details)
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                        let date = dateFormatter.date(from: item1["NotificationDate"] as! String)
                        let model = NotificationsModel(notifiDate: date! as NSDate, month: item1["Month"] as! String, year: item1["Year"] as! String, monthlyList: self.notifyDetailsModelList)
                        
                        self.notifyModelList.append(model)
                    }
                    
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
            let str: [String] = (detailsModel.notificationDate?.components(separatedBy: " "))!
            cell.timeLabel.text = str[1] + str[2]
        }
        if detailsModel.typeOfNotification == "reminder"
        {
           
            cell.firstLabel.text = detailsModel.subject
        }
        else if detailsModel.typeOfNotification == "message"
        {
           
            cell.firstLabel.text = String(format: "You have a new message from %@", detailsModel.fromUserName!)
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
        else if detailsModel.typeOfNotification == "Appointment"
        {
            
            cell.firstLabel.text = detailsModel.subject
        }
        else if detailsModel.typeOfNotification == "IllegalPost"
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
        if detailsModel.typeOfNotification == "reminder"
        {
            let reminder: RemindersListViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RemindersList") as? RemindersListViewController)!
            self.navigationController?.pushViewController(reminder, animated: true)
        }
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        let model = self.notifyModelList[section]
//        
//        return String(format: "%@ %@", model.month, model.year)
//    }
    
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
        label.textAlignment = .center
        label.text = String(format: "%@ %@", model.month, model.year)
        view.addSubview(label)
        
        return view
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let model = self.remModelList[indexPath.row];
//        self.performSegue(withIdentifier: "ShowReminder", sender: model)
//    }


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
