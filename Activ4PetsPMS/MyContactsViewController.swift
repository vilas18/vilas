//
//  MyContactsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 22/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class MyContactsModel: NSObject
{
    var petList: [String: String]?
    var id: String?
    var contactId: NSNumber?
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var userType: String?
    var isContcatExist: Bool?
    var userName: String?
    var user: String?
    var pet: String?
    var petName: String?
    var isInfoDel: Bool?
    var shareInfoDel: Bool?
    var isAccept: Bool?
    var contPetList: String?
    var isAcceptedUser: Bool?
    var profilePic: String?
    
    init(petList: [String: String]?,id: String?, contactId: NSNumber?, userId: String?, firstName: String?, lastName: String?, email: String?, userType: String?, isContcatExist: Bool?, userName: String?, user: String?, pet: String?, petName: String?, isInfoDel: Bool?, shareInfoDel: Bool?, isAccept: Bool?, contPetList: String?, isAcceptedUser: Bool?, profilePic: String?)
    {
        self.petList = petList
        self.id = id
        self.contactId = contactId
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userType = userType
        self.isContcatExist = isContcatExist
        self.userName = userName
        self.user = user
        self.pet = pet
        self.petName = petName
        self.isInfoDel = isInfoDel
        self.shareInfoDel = shareInfoDel
        self.isAccept = isAccept
        self.contPetList = contPetList
        self.isAcceptedUser = isAcceptedUser
        self.profilePic = profilePic
        
    }
}

class MyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var contactListTv: UITableView!
    
    var contactList = [Any]()
    var contactModelList = [MyContactsModel]()
    var noDataLbl: UILabel?
    
    @IBOutlet weak var searchContact: UISearchBar!
    var searchList = [Any]()
    var isSearchOn: Bool = false
    var model: MyContactsModel?
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    @IBOutlet weak var addContact: UIButton!
    
    var isFromVc : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        rightItem2 = UIBarButtonItem(image: UIImage(named: "Delete Group"), style: .done, target: self, action: #selector(self.unfollowedCont))
        if self.isFromVc == false{
            navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        }
        else
        {
            navigationItem.rightBarButtonItems = nil
        }
        
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        noDataLbl?.text="No contacts found"
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func unfollowedCont(_ sender: Any)
    {
        let unfollow: UnFollowedContactsViewController = storyboard?.instantiateViewController(withIdentifier: "unfollow") as! UnFollowedContactsViewController
        navigationController?.pushViewController(unfollow, animated: true)
    }
    @objc func showMenu(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if self.isFromVc == true
        {
            self.searchView.isHidden = true
            self.topSpace.constant = -50
            self.addContact.isHidden = true
        }
        startAuthenticatingUser()
    }
    
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.contactModelList = []
            self.getList()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var str: String = String(format : "userId=%@&ownerId=%@",userId,"0")
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.MyContacts.ContactList,str)
        
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]],
                let queryDic = json
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            self.contactListTv.reloadData()
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
                            for item in filtered
                            {
                                let Contact = MyContactsModel(petList: item["lstPetName"] as? [String: String],id: item["Id"] as? String, contactId: item["ContactId"] as? NSNumber, userId: item["UserId"] as? String, firstName: item["FirstName"] as? String, lastName: item["LastName"] as? String, email: item["Email"] as? String, userType: item["UserType"] as? String, isContcatExist: item["IsContactExist"] as? Bool, userName: item["UserName"] as? String, user: item["User"] as? String, pet: item["Pet"] as? String, petName: item["PetName"] as? String, isInfoDel: item["IsInfoDeleted1"] as? Bool, shareInfoDel: item["shareInfoDeleted"] as? Bool, isAccept: item["IsAccepted"] as? Bool, contPetList: item["PetList"] as? String, isAcceptedUser: item["IsAcceptedUser"] as? Bool, profilePic: item["ProfilePic"] as? String) //stateName: item["StateName"] as? String)
                                
                                if self.isFromVc == true
                                {
                                    let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                                    
                                    if Contact.isAccept == true && Contact.petList?[petId] == nil
                                    {
                                        self.contactModelList.append(Contact)
                                    }
                                }
                                else
                                {
                                    self.contactModelList.append(Contact)
                                }
                            }
                            
                            self.contactListTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else
            {
                self.noDataLbl?.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String)
    {
        if (text.count ) == 0 {
            isSearchOn = false
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        else {
            isSearchOn = true
            searchList = [Any]()
            for srchVet: MyContactsModel in contactModelList
            {
                
                let tmp1: NSString = srchVet.firstName! as NSString
                let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                let tmp2: NSString = srchVet.lastName! as NSString
                let lastNameRange = tmp2.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                if range.location != NSNotFound || lastNameRange.location != NSNotFound
                {
                    self.searchList.append(srchVet)
                }
            }
        }
        contactListTv.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int
        if isSearchOn {
            rowCount = Int(searchList.count)
        }
        else {
            rowCount = Int(contactModelList.count)
        }
        return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        var model: MyContactsModel
        if isSearchOn {
            model = searchList[indexPath.row] as! MyContactsModel
        }
        else {
            model = contactModelList[indexPath.row]
        }
        if  self.isFromVc == true
        {
            cell.timeLabel.isHidden = true
            let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
            cell.icon.layer.cornerRadius = 25
            cell.icon.sd_setImage(with: NSURL(string: model.profilePic!)! as URL?, placeholderImage: UIImage(named: "user_lst.png")!, options: SDWebImageOptions(rawValue: 1))
            cell.firstLabel?.text = String(format : "%@ %@",model.firstName!, model.lastName!)
            
            cell.secLabel?.text = model.userName
            cell.thirdLabel.text = model.petList?.values.joined(separator: ",")
            btn?.setImage(UIImage(named: "plus_blue"), for: .normal)
            btn?.tag = Int(truncating: model.contactId ?? 0) //Int(model.contactId!)!
            btn?.addTarget(self, action: #selector(self.moveToSettings), for: .touchUpInside)
        }
        else
        {
            cell.icon.layer.cornerRadius = 25
            cell.icon.sd_setImage(with: NSURL(string: model.profilePic!)! as URL?, placeholderImage: UIImage(named: "user_lst.png")!, options: SDWebImageOptions(rawValue: 1))
            cell.firstLabel?.text = String(format : "%@ %@",model.firstName!, model.lastName!)
            
            cell.secLabel?.text = model.userName
            cell.thirdLabel.text = model.petList?.values.joined(separator: ",")
            if model.isAccept == true
            {
                cell.timeLabel.isHidden = true
            }else{
                cell.timeLabel.isHidden = false
            }
            let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
            btn?.tag = Int(truncating: model.contactId ?? 0) //Int(model.contactId!)!
            btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        }
        return cell
    }
    @objc func moveToSettings(_ sender: UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.contactListTv)
        let indexPath = self.contactListTv.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            if isSearchOn
            {
                self.model = searchList[(indexPath?.row)!] as? MyContactsModel
            }
            else {
                self.model = contactModelList[(indexPath?.row)!]
            }
            print("\(String(describing: self.model?.contactId))")
            UserDefaults.standard.set(model?.firstName, forKey: "ContactName")
            UserDefaults.standard.set(model?.contactId, forKey: "ContactId")
            UserDefaults.standard.synchronize()
            let settings: ShareSettingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SharedSettings") as! ShareSettingsViewController
            settings.isFromVc = false
            self.navigationController?.pushViewController(settings, animated: true)
        }
    }
    @objc func showOptions(_ sender: UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.contactListTv)
        let indexPath = self.contactListTv.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            if isSearchOn
            {
                self.model = searchList[(indexPath?.row)!] as? MyContactsModel
            }
            else {
                self.model = contactModelList[(indexPath?.row)!]
            }
            print("\(String(describing: self.model?.contactId))")
        }
        //EditAddVeterinarianViewController.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Remove", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let alertDel = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Deleting", comment: "")
                self.contDelMethod(self.model!)
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertDel.addAction(ok)
            alertDel.addAction(cancel)
            self.present(alertDel, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(alert, animated: true, completion: nil)
    }
    func contDelMethod(_ model: MyContactsModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let urlStr = String(format : "%@?ContactId=%@&UserId=%@", API.MyContacts.DelContact, model.contactId!, userId)
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
                    let status = json?["status"] as? Int
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Contact has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.startAuthenticatingUser()
                        })
                        
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
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
