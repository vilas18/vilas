//
//  EmergencyContactsListViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class EmergencyContactModel: NSObject
{
    var contactId : String
    var fstName : NSString
    var lstName : NSString
    var isEmerGCont : Bool?
    var relationId : String?
    var relation : NSString
    var phoneHome : String?
    var phoneOffice : String?
    var phoneCell : String?
    var startDate : String?
    var endDate : String?
    var address1 : String?
    var address2 : String?
    var countryId : String?
    var stateId : String?
    var city : String?
    var zip : String?
    var fax : String?
    var email : String?
    var comments : String?
    var countryName : String?
    var stateName : String?
    var userId: Int?
    var petId: Int?
    var contctType: String?
    var hospitalName: String?
    var iscurrentVet: Bool?
    var npi: String?
    var vetSpeciality: String?
    var vetSpecialityId: String?
    var isInSMO: String?
    var petName: String?
    var petType: String?
    
    //var profilePicUrl : String?
    
    
    init?(contactId: String, fstName: NSString, lstName : NSString, isEmerGCont : Bool?, phoneHome : String?, phoneOffice : String?, phoneCell : String?, startDate : String?, endDate : String?, address1 : String?, address2 : String?, countryId : String?, stateId : String?, city : String?, zip : String?, fax : String?, email : String?, comments : String?, countryName : String?, stateName : String?, relationId : String?, relation : NSString, userId: Int?, petId: Int?, contctType: String?, hospitalName: String?, iscurrentVet: Bool?, npi: String?,vetSpeciality: String?,vetSpecialityId: String?, isInSMO: String?, petName: String?, petType: String?)
    {
        self.contactId=contactId
        self.fstName=fstName
        self.lstName=lstName
        self.isEmerGCont=isEmerGCont
        self.phoneHome=phoneHome
        self.phoneOffice=phoneOffice
        self.phoneCell=phoneCell
        self.startDate=startDate
        self.endDate=endDate
        self.address1=address1
        self.address2=address2
        self.countryId=countryId
        self.stateId=stateId
        self.city=city
        self.zip=zip
        self.fax=fax
        self.email=email
        self.comments=comments
        self.countryName=countryName
        self.stateName=stateName
        //self.profilePicUrl=profilePicUrl
        self.relation=relation
        self.relationId=relationId
        self.userId = userId
        self.petId = petId
        self.contctType = contctType
        self.hospitalName = hospitalName
        self.iscurrentVet = iscurrentVet
        self.npi = npi
        self.vetSpeciality = vetSpeciality
        self.vetSpecialityId = vetSpecialityId
        self.isInSMO = isInSMO
        self.petName = petName
        self.petType = petType
        
    }
}

class EmergencyContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var contactListTv: UITableView!
    var contactList = [Any]()
    var contactModelList = [EmergencyContactModel]()
    var noDataLbl: UILabel?
    var isFromMedical: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        navigationItem.rightBarButtonItem = rightItem1!
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        noDataLbl?.text="No records found"
        noDataLbl?.center = self.view.center
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showMenu(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)    }
    
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
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet") ?? "0"
        var urlStr: String = ""
        if self.isFromMedical
        {
            urlStr = String(format : "%@?UserId=%@&PetId=%@", API.Owner.EmergencyContacts, userId,petId)
        }
        else
        {
            urlStr = String(format : "%@?UserId=%@&PetId=%@", API.Owner.EmergencyContacts, userId,"")
        }
        
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
                let status = json?["Status"] as? Int
            {
                var filtered = [[String : Any]]()
                let pref = UserDefaults.standard
                pref.synchronize()
                DispatchQueue.main.async
                    {
                        if status == 0
                        {
                            if self.isFromMedical == true
                            {
                                self.noDataLbl?.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                                pref.set(true, forKey: "ZeroEmergencyContact")
                                pref.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EmergencyView"), object: self, userInfo: ["ZeroEmergencyContact": pref.bool(forKey: "ZeroEmergencyContact")])
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = false
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        }
                        else
                        {
                            let queryDic = json?["contactList"] as? [[String : Any]]
                            
                            
                            
                            for item in queryDic!
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
                                let Contact = EmergencyContactModel(contactId: item["ContactId"] as! String, fstName: item["FirstName"] as! NSString, lstName: item["LastName"] as! NSString, isEmerGCont: item["IsEmergencyContact"] as? Bool, phoneHome: item["PhoneHome"] as? String, phoneOffice: item["PhoneOffice"] as? String, phoneCell: item["PhoneCell"] as? String, startDate: item["StartDate"] as? String, endDate: item["EndDate"] as? String, address1: item["Address1"] as? String, address2: item["Address2"] as? String, countryId: item["CountryId"] as? String, stateId: item["StateId"] as? String, city: item["City"] as? String, zip: item["Zip"] as? String, fax: item["Fax"] as? String, email: item["Email"] as? String, comments: item["Comment"] as? String, countryName: item["CountryName"] as? String, stateName: item["StateName"] as? String, relationId: item["RelationshipId"] as? String, relation: item["Relationship"] as! NSString,userId: item["UserId"] as? Int, petId: item["PetId"] as? Int, contctType: item["ContactType"] as? String, hospitalName: item["HospitalName"] as? String, iscurrentVet: item["IsCurrentVeterinarian"] as? Bool,npi: item["NPI"] as? String,vetSpeciality: item["VetSpecialty"] as? String,vetSpecialityId: item["VetSpecialtyId"] as? String, isInSMO: item["IsSMOInProgress"] as? String, petName: item["PetName"] as? String, petType: item["PetType"] as? String)
                                
                                self.contactModelList.append(Contact!)
                            }
                            self.contactListTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            pref.set(false, forKey: "ZeroEmergencyContact")
                            pref.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EmergencyView"), object: self, userInfo: ["ZeroEmergencyContact": pref.bool(forKey: "ZeroEmergencyContact")])
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
        return contactModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        let model = contactModelList[indexPath.row]
        if self.isFromMedical == true
        {
            cell.firstBtn.isHidden = true
            //cell.isUserInteractionEnabled = false
        }
        cell.icon.image = UIImage(named: "user_lst.png")
        
        cell.firstLabel?.text = String(format : "%@ %@",model.fstName, model.lstName)
        cell.secLabel?.text = model.phoneCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // EmgDetails
        let model = self.contactModelList[indexPath.row]
        self.performSegue(withIdentifier: "EmgDetails", sender: model)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if self.isFromMedical
        {
            let details: EmergencyContactDetailsViewController = segue.destination as! EmergencyContactDetailsViewController
            details.isFromMedical = true
            details.model = sender as? EmergencyContactModel
        }
        else
        {
            let details: EmergencyContactDetailsViewController = segue.destination as! EmergencyContactDetailsViewController
            details.isFromVC = true
            details.model = sender as? EmergencyContactModel
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
