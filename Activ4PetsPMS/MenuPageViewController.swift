//
//  MenuPageViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class MenuPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var menuListTv: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var notificationCount: UILabel!
    
    
    var menuItems = [String]()
    var menuItemsIcons = [UIImage]()
    var menuItemdescripts = [String]()
    
    var notifyModelList = [NotificationsModel]()
    var notifyDetailsModelList = [NotificationDetailsModel]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.notificationCount.isHidden = true
        
        self.menuItems = ["My Pets","Pet Care", "My Contacts", "Online Veterinary Services", "Local Pet Services","Shop pet Health Supplies", "Emergency Contacts", "Refer A Friend","Invite A Vet","Settings", "Help", "Logout"]
        self.menuItemsIcons = [UIImage(named: "My Pet.png")!,UIImage(named: "Records.png")!, UIImage(named: "Mycntacts.png")!, UIImage(named: "Forma_1.png")!, UIImage(named: "Local pet Service")!,UIImage(named: "nsala_vfc_app_shop_icon_shop")!, UIImage(named: "Emergency Contact.png")!, UIImage(named: "ReferFriend.png")!,UIImage(named: "Invitevet.png")!,UIImage(named: "Settings-2.png")!, UIImage(named: "Help.png")!, UIImage(named: "LogOut-1.png")!]
        self.menuItemdescripts = ["List of pets in your account","Read your pet related articles", "Manage your contacts with us","One stop place for your pet medical needs", "Contact pet services providers with ease","Shop pet Health Supplies", "Manage your emergency contacts with us", "Invite a friend and get rewarded", "Request your vet to get connected with us","Manage your profile","How can we assist you ?","Logout from Activ4Pets"]
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
//        let rightItem = UIBarButtonItem(image: UIImage(named: "Profile New")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightClk))
//        navigationItem.rightBarButtonItem = rightItem
        
        self.userImage.layer.cornerRadius = 25
        
        //  self.userImage.imageFromServerURL(urlString: userDefaults.string(forKey: "ProfilePicUrl")!,defaultImage: "profile-icon.png")
        // self.userImage.sd_setImage(with: NSURL( string: userDefaults.object(forKey: "ProfilePicUrl") as! String)! as URL!, placeholderImage: UIImage(named: "profile-icon.png")!, options: SDWebImageOptions(rawValue: 1))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.userImage.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "ProfilePicUrl")!,defaultImage: "ic_user_prof")
        let userDefaults = UserDefaults.standard
        self.userName.text = userDefaults.object(forKey: "UserName") as? String
        self.checkInternetConnection()
    }
//    @objc func rightClk(_ sender: Any)
//    {
//        self.performSegue(withIdentifier: "MyProfile", sender: nil)
//    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as? CommonTableViewCell
        cell?.icon?.image = menuItemsIcons[indexPath.row]
        cell?.firstLabel?.text = menuItems[indexPath.row]
        cell?.secLabel.text = menuItemdescripts[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "MyPets", sender: nil)
        }
        else if indexPath.row == 1
        {
            performSegue(withIdentifier: "PetCare", sender: nil)
        }
//        else if indexPath.row == 2
//        {
//            self.performSegue(withIdentifier: "TalkToVet", sender: nil)
//        }
        else if indexPath.row == 2
        {
            performSegue(withIdentifier: "MyContacts", sender: nil)
        }
        else if indexPath.row == 3
        {
            performSegue(withIdentifier: "OnlineServices", sender: nil)
        }
        else if indexPath.row == 4
        {
            performSegue(withIdentifier: "LocalPetServices", sender: nil)
        }
        else if indexPath.row == 5
        {
            performSegue(withIdentifier: "ShopPet", sender: nil)
        }
        else if indexPath.row == 6
        {
            performSegue(withIdentifier: "EmergencyContacts", sender: nil)
        }
        else if indexPath.row == 7
        {
            performSegue(withIdentifier: "ReferFriend", sender: nil)
        }
        else if indexPath.row == 8
        {
            performSegue(withIdentifier: "InviteVet", sender: nil)
        }
        else if indexPath.row == 9
        {
             self.performSegue(withIdentifier: "MyProfile", sender: nil)
        }
        else if indexPath.row == 10
        {
            performSegue(withIdentifier: "Help", sender: nil)
        }
            
        else if indexPath.row == 11
        {
            let alert = UIAlertController(title: nil, message: "Are you sure, you want to logout ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(action: UIAlertAction) -> Void in
                
                let saved: SavedUserLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedLogin") as! SavedUserLoginViewController
                self.navigationController?.setViewControllers([saved], animated: true)
                UserDefaults.standard.set(true, forKey: "LoggedOut")
                UserDefaults.standard.synchronize()
                for controller: UIViewController in self.navigationController?.viewControllers ?? []
                {
                    if (controller is SavedUserLoginViewController)
                    {
                        
                        _ = self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            })
            let cancel = UIAlertAction(title: "NO", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            //self.notifyModelList = []
            self.getVerifiedEmail()
            self.getNotificationCount()
            
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getVerifiedEmail()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?userId=%@", API.Login.GetVerifiedEmail, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {
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
                        
                        if status == 1
                        {
                            self.userEmail.text = json?["Message"] as? String
                        }
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
    func getNotificationCount()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.Owner.NewNotificationsCount, userId)
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
                        if str == "0"
                        {
                            self.notificationCount.isHidden = true
                        }
                        else
                        {
                            self.notificationCount.text = str
                            self.notificationCount.isHidden = false
                        }
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
    @IBAction func showNotificationsList(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "NewNotifications", sender: nil)
    }
    @IBAction func showRemindersAppointments(_ sender: UIButton)
    {
        let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
        if centerId as? Int == 57
        {
            let storyboard = UIStoryboard(name: "appointment", bundle: nil)
            let calendar: CkViewController = storyboard.instantiateViewController(withIdentifier: "calendar") as! CkViewController
            navigationController?.pushViewController(calendar, animated: true)
        }
        else
        {
            self.performSegue(withIdentifier: "RemindersList", sender: nil)
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
