//
//  PendingContactsListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 22/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class PendingContactsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var contactListTv: UITableView!
    var contactList = [Any]()
    var contactModelList = [MyContactsModel]()
    var noDataLbl: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        noDataLbl?.text="No records found"
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.textAlignment = .center
        noDataLbl?.center = self.view.center
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
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
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?userId=%@", API.Owner.SharedPending, userId)
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
                                
                                self.contactModelList.append(Contact)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int
        
        rowCount = Int(contactModelList.count)
        return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        let model = contactModelList[indexPath.row]
        
        cell.icon.layer.cornerRadius = 25
        cell.icon.sd_setImage(with: NSURL(string: model.profilePic!)! as URL!, placeholderImage: UIImage(named: "user_lst.png")!, options: SDWebImageOptions(rawValue: 1))
        cell.firstLabel?.text = String(format : "%@ %@",model.firstName!, model.lastName!)
        
        cell.secLabel?.text = model.userName
        cell.thirdLabel.text = model.petList?.values.joined(separator: ",")
        
        return cell
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
