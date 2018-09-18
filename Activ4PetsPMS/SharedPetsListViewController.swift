//
//  SharedPetsListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 22/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class SharedPetsModel: NSObject
{
    var modifyList: [String: String]?
    var viewList: [String: String]?
    var ownerId: NSNumber?
    var ownerName: String?
    var ownerFirstName: String?
    var ownerLastName: String?
    var accepted: Bool?
    var userName: String?
    var email: String?
    var profilePic: String?
    var message: String?
    
    init(modifyList: [String: String]?, viewList: [String: String]?, ownerId: NSNumber?,  ownerName: String?, ownerFirstName: String?,ownerLastName: String? , accepted: Bool? , userName: String? , email: String?, profilePic: String?, message: String?)
    {
        self.modifyList = modifyList
        self.viewList = viewList
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.ownerFirstName = ownerFirstName
        self.ownerLastName = ownerLastName
        self.accepted = accepted
        self.userName = userName
        self.email = email
        self.profilePic = profilePic
        self.message = message
        
    }
}
class SharedPetsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var noDataLbl: UILabel?
    var patientID: String = ""
    var petListArray = [Any]()
    var sharedPetModelList = [SharedPetsModel]()
    var prefs: UserDefaults?
    var selectedPet : SharedPetsModel?
    @IBOutlet weak var sharedPetListTbl: UITableView!
    var isFromVC: Bool = false
    var petId: NSNumber = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "Add User"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        rightItem2 = UIBarButtonItem(image: UIImage(named: "Users"), style: .done, target: self, action: #selector(self.rightClk2))
        navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text =  "No records found"
        noDataLbl?.center = self.view.center
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkInternetConnection()
    }
    @objc func leftClk(sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func rightClk1(sender: AnyObject)
    {
        let AddContact:  AddContactViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddContact") as! AddContactViewController
        AddContact.isFromVc = true
        self.navigationController?.pushViewController(AddContact, animated: true)
    }
    
    @objc func rightClk2(sender: AnyObject)
    {
        let MyContact:  MyContactsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyContacts") as! MyContactsViewController
        MyContact.isFromVc = true
        self.navigationController?.pushViewController(MyContact, animated: true)
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.sharedPetModelList = []
            self.webServiceToGetSharedPetList()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func webServiceToGetSharedPetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var urlStr: String = ""
        if self.isFromVC
        {
            urlStr = String(format : "%@?userId=%@&petId=%@", API.Owner.PetsShared, userId, self.petId)
        }
        else
        {
            let petId1:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            urlStr = String(format : "%@?userId=%@&petId=%@", API.Owner.PetsShared, userId, petId1)
        }
        
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]],
                let queryDic = json
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            self.sharedPetListTbl.reloadData()
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
                                let shared = SharedPetsModel(modifyList: item["ViewModify"] as? [String: String], viewList: item["ViewOnly"] as? [String: String], ownerId: item["Id"] as? NSNumber,  ownerName: item["ShareContactName"] as? String, ownerFirstName: item["FirstNmae"] as? String,ownerLastName: item["LastName"] as? String , accepted: item["IsAccepted"] as? Bool , userName:item["UserName"] as? String , email: item["Email"] as? String, profilePic: item["ProfilePicPath"] as? String, message: item["Message"] as? String )
                                
                                self.sharedPetModelList.append(shared)
                            }
                            
                            self.sharedPetListTbl.reloadData()
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
        return sharedPetModelList.count > 0 ? sharedPetModelList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPets", for: indexPath) as!  MyPetsTableViewCell
        cell.petImage.image = nil
        let pets = self.sharedPetModelList[indexPath.row]
        // cell.type.text = NSLocalizedString("Species")
        cell.petImage.layer.cornerRadius = 35
        cell.petType.text = pets.viewList?.values.joined(separator: ",")
        cell.petName.text = pets.modifyList?.values.joined(separator: ",");
        
        cell.owner.text = String(format : "%@ %@",pets.ownerFirstName!, pets.ownerLastName!)
        //cell.ownerLbl.text = "\(model.firstName) \(model.lastName)"
        cell.shareBtn.isHidden = false
        cell.shareBtn.tag = Int(truncating: pets.ownerId ?? 0)
        cell.shareBtn.addTarget(self, action: #selector(self.viewMenuClk), for: .touchUpInside)
        
        cell.petImage.sd_setImage(with: NSURL(string: pets.profilePic!)! as URL!, placeholderImage: UIImage(named: "emg_user")!, options: SDWebImageOptions(rawValue: 1))
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let pets = self.sharedPetModelList[indexPath.row]
        self.performSegue(withIdentifier: "OwnerDetails", sender: pets)
    }
    @objc func viewMenuClk(sender: AnyObject)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.sharedPetListTbl)
        let indexPath = self.sharedPetListTbl.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            self.selectedPet = self.sharedPetModelList[(indexPath?.row)!]
            print("\(String(describing:  self.selectedPet?.ownerId))")
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let medical = UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction) -> Void in
            let settings: ShareSettingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SharedSettings") as! ShareSettingsViewController
            settings.isFromVc = true
            settings.model = self.selectedPet
            self.navigationController?.pushViewController(settings, animated: true)
        })
        let remove = UIAlertAction(title: "Remove", style: .default, handler: {(action: UIAlertAction) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
                self.callPetDeleteMethod()
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(medical)
        alert.addAction(remove)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.present(alert, animated: true, completion: nil)
    }
    func callPetDeleteMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            let urlStr = String(format : "%@?PetId=%@&UserId=%@&ContactId=%@", API.Owner.DeleteSharePetWithMe, petId, userId, (self.selectedPet?.ownerId)! )
            print(urlStr)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else
                {                                                 // check for fundamental networking error
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
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Pet has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.checkInternetConnection()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "OwnerDetails")
        {
            let destination = segue.destination as! SharedOwnerDetailsViewController
            destination.model = sender as? SharedPetsModel
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
