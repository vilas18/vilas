//
//  AddContactViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 22/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class SearchContactModel: NSObject
{
    var contactId: NSNumber?
    var firstName: String?
    var lastName: String?
    var userName: String?
    var profilePic: String?
    
    init(contactId: NSNumber?, firstName: String?, lastName: String?, userName: String?, profilePic: String?) {
        self.contactId = contactId
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.profilePic = profilePic
    }
}
class AddContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var contactListTv: UITableView!
    var contactList = [Any]()
    var contactModelList = [SearchContactModel]()
    var noDataLbl: UILabel?
    
    @IBOutlet weak var searchContact: UISearchBar!
    var searchList = [Any]()
    var isSearchOn: Bool = false
    var model: SearchContactModel?
    
    var isFromVc: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 2
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.text = "No records found.\n Search for a contact to add"
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = false
        noDataLbl?.center = self.view.center
        self.contactListTv.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func startAuthenticatingUser(_ str: String)
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.contactModelList = []
            self.getList(str)
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList(_ str: String)
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var strs: String = String(format : "userId=%@&searchStr=%@", userId, str)
        strs = strs.trimmingCharacters(in: CharacterSet.whitespaces)
        strs = strs.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.MyContacts.SearchContact, strs)
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]],
                let queryDic = json
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            self.noDataLbl?.isHidden = true
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
                                let Serach = SearchContactModel(contactId: item["Id"] as? NSNumber, firstName: item["FirstName"] as? String, lastName: item["LastName"] as? String, userName: item["UserName"] as? String, profilePic: item["ProfilePicPath"] as? String) //profilePic: item["ProfilePic"] as? String) //stateName: item["StateName"] as? String)
                                
                                self.contactModelList.append(Serach)
                            }
                            
                            self.contactListTv.reloadData()
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
            self.contactListTv.reloadData()
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        else
        {
            isSearchOn = true
            searchList = [Any]()
            if text.count>3
            {
                searchBar.resignFirstResponder()
                self.startAuthenticatingUser(text)
            }
        }
        contactListTv.reloadData()
        //searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        // searchBar.resignFirstResponder()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contactModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        let model = contactModelList[indexPath.row]
        cell.icon.layer.cornerRadius = 25
        cell.icon.sd_setImage(with: NSURL(string: model.profilePic!)! as URL!, placeholderImage: UIImage(named: "user_lst.png")!, options: SDWebImageOptions(rawValue: 1))
        cell.firstLabel?.text = String(format : "%@ %@",model.firstName!, model.lastName!)
        
        cell.secLabel?.text = model.userName
        if self.isFromVc == true
        {
            let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
            btn?.tag = Int(truncating: model.contactId ?? 0) //Int(model.contactId!)!
            btn?.addTarget(self, action: #selector(self.moveToSettings), for: .touchUpInside)
        }
        else
        {
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
            self.model = contactModelList[(indexPath?.row)!]
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
            self.model = contactModelList[(indexPath?.row)!]
            print("\(String(describing: self.model?.contactId))")
        }
        //EditAddVeterinarianViewController.
        let alert = UIAlertController(title: "Add To Contact", message: "I would like to add you to my contact list", preferredStyle: .alert)
        let add = UIAlertAction(title: "SEND MESSAGE", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("", comment: "")
            self.contAddMethod(self.model!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func contAddMethod(_ model: SearchContactModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var urlStr = String(format : "%@?userId=%@&contactId=%@&message=%@", API.MyContacts.AddContact,userId, model.contactId!, "I would like to add you to my contact list")
            urlStr = urlStr.trimmingCharacters(in: CharacterSet.whitespaces)
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let request = NSMutableURLRequest(url: NSURL(string: urlStr)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 60.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            //            if let checkedUrl = URL(string: urlStr)
            //            {
            //                request = URLRequest(url: checkedUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            //            }
            //        
            //            request?.allHTTPHeaderFields = headers //as? [String : String]
            //            request?.httpMethod = "Post"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest)
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
                    let status = json?["status"] as? Int
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Contact request has been sent successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                else{
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
