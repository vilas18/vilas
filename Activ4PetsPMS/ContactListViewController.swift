//
//  ContactListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 28/07/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class ContactModel: NSObject
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
    //var profilePicUrl : String?
    
    
    init?(contactId: String, fstName: NSString, lstName : NSString, isEmerGCont : Bool?, phoneHome : String?, phoneOffice : String?, phoneCell : String?, startDate : String?, endDate : String?, address1 : String?, address2 : String?, countryId : String?, stateId : String?, city : String?, zip : String?, fax : String?, email : String?, comments : String?, countryName : String?, stateName : String?, relationId : String?, relation : NSString )
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
        
    }
}

class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var contactListTv: UITableView!
    var contactList = [Any]()
    var contactModelList = [ContactModel]()
    var noDataLbl: UILabel?
    @IBOutlet weak var searchCont: UISearchBar!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var petImg: UIButton!
    @IBOutlet weak var mediRec: UIButton!
    @IBOutlet weak var veterinarians: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var more: UIButton!
    
    
    var searchList = [Any]()
    var isSearchOn: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addVet))
        
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        
        noDataLbl?.numberOfLines = 2
        noDataLbl?.lineBreakMode = .byTruncatingTail
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = rightItem1!
            noDataLbl?.text =  "No records found"
        }
        else{
            navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
            noDataLbl?.text =  "No records found.\n Tap on '+' to add a Contact"
        }
        
        galleryView.isHidden = true
        galleryView.layer.masksToBounds = true
        galleryView.layer.borderWidth = 1
        galleryView.layer.cornerRadius = 2
        galleryView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func addVet(_ sender: Any)
    {
        let addContact: EditAddContactViewController? = storyboard?.instantiateViewController(withIdentifier: "addEditContact") as! EditAddContactViewController?
        addContact?.isFromVC = false
        navigationController?.pushViewController(addContact!, animated: true)
    }
    
    @objc func showMenu(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        galleryView.isHidden = true
        contacts.backgroundColor=UIColor(red: 6.0 / 255.0, green: 103.0 / 255.0, blue: 184.0 / 255.0, alpha: 1);
        contacts.isSelected=true;
        petImg.setImage(UIImage(named: "tab_vets_active"), for: .selected)
        backView.backgroundColor = UIColor.white//(red: 0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        petImg.layer.masksToBounds = true
        petImg.layer.borderWidth = 1
        petImg.layer.cornerRadius=petImg.frame.size.width/2
        petImg.layer.borderColor = UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1).cgColor;
        let petImageUrl: String =  UserDefaults.standard.string(forKey: "PetProfile")!
        if let url = NSURL(string: petImageUrl)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                if data.length > 0
                {
                    
                    petImg.setImage(UIImage(data: data as Data), for: .normal)
                    petImg.setImage(UIImage(data: data as Data), for: .selected)
                }
                else
                {
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
                }
            }
            else
            {
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
            }
        }
        else
        {
            petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
            petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
        }
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let shareVet: Bool = UserDefaults.standard.bool(forKey: "ShareVets")
            let shareMedi: Bool = UserDefaults.standard.bool(forKey: "ShareMedi")
            let shareGall: Bool = UserDefaults.standard.bool(forKey: "ShareGall")
            if shareMedi
            {
                self.mediRec.isUserInteractionEnabled = true
            }
            else
            {
                self.mediRec.isUserInteractionEnabled = false
                self.mediRec.backgroundColor = UIColor.lightGray
            }
            if shareVet
            {
                self.veterinarians.isUserInteractionEnabled = true
            }
            else
            {
                self.veterinarians.isUserInteractionEnabled = false
                self.veterinarians.backgroundColor = UIColor.lightGray
            }
            
            if shareGall
            {
                self.more.isUserInteractionEnabled = true
            }
            else
            {
                self.more.isUserInteractionEnabled = false
                self.more.backgroundColor = UIColor.lightGray
            }
            
            
        }
        startAuthenticatingUser()
    }
    
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
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
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@", API.Contact.ContactList, petId)
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
                let queryDic = json?["contactList"] as? [[String : Any]]
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
                        else{
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
                                let Contact = ContactModel(contactId: item["ContactId"] as! String, fstName: item["FirstName"] as! NSString, lstName: item["LastName"] as! NSString, isEmerGCont: item["IsEmergencyContact"] as? Bool, phoneHome: item["PhoneHome"] as? String, phoneOffice: item["PhoneOffice"] as? String, phoneCell: item["PhoneCell"] as? String, startDate: item["StartDate"] as? String, endDate: item["EndDate"] as? String, address1: item["Address1"] as? String, address2: item["Address2"] as? String, countryId: item["CountryId"] as? String, stateId: item["StateId"] as? String, city: item["City"] as? String, zip: item["Zip"] as? String, fax: item["Fax"] as? String, email: item["Email"] as? String, comments: item["Comment"] as? String, countryName: item["CountryName"] as? String, stateName: item["StateName"] as? String, relationId: item["RelationshipId"] as? String, relation: item["Relationship"] as! NSString)
                                
                                self.contactModelList.append(Contact!)
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
            for srchCont: ContactModel in contactModelList
            {
                
                let tmp1: NSString = srchCont.fstName
                let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                let lastNameRange = srchCont.lstName.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                if range.location != NSNotFound || lastNameRange.location != NSNotFound
                {
                    self.searchList.append(srchCont)
                }
            }
        }
        contactListTv.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        var model: ContactModel
        if isSearchOn {
            model = searchList[indexPath.row] as! ContactModel
        }
        else {
            model = contactModelList[indexPath.row]
        }
        //        let contImageUrl = model.profilePicUrl
        //        if let url = NSURL(string: contImageUrl!)
        //        {
        //            if let data = NSData(contentsOf: url as URL)
        //            {
        //                cell.icon.image=UIImage(data: data as Data)
        //            }
        //            else{
        cell.icon.image = UIImage(named: "user_lst.png")
        //            }
        //        }
        
        //cell.icon?.sd_setImage(with: URL(string: model?.profilePicUrl), placeholderImage: UIImage(named: "user_lst.png"), options: SDWebImageRefreshCached)
        cell.firstLabel?.text = String(format : "%@ %@",model.fstName, model.lstName) //"\(model.fstName) \(model.lstName)"
        if model.isEmerGCont == true
        {
            cell.timeLabel?.text = "EMG"
            cell.timeLabel.isHidden = false
        }
        else
        {
            cell.timeLabel.isHidden = true
        }
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            cell.isUserInteractionEnabled = false
        }
        else
        {
            cell.isUserInteractionEnabled = true
        }
        cell.secLabel?.text = model.relation as String
        
        let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
        btn?.tag = Int(model.contactId)!
        btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let modCont: Bool = UserDefaults.standard.bool(forKey: "ModifyCont")
            if modCont
            {
                btn?.isUserInteractionEnabled = true
            }
            else
            {
                btn?.isUserInteractionEnabled = false
                let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
                navigationItem.rightBarButtonItem = rightItem1
            }
        }
        
        return cell
    }
    
    @objc func showOptions(_ sender: UIButton)
    {
        let clickedCell: CommonTableViewCell? = (sender.superview?.superview as? CommonTableViewCell)
        var views: Any? = clickedCell?.superview
        while (views != nil) && (views is UITableView) == false {
            views = (views as AnyObject).superview ?? " "
        }
        let tableView: UITableView? = (views as? UITableView)
        let indexPath: IndexPath? = tableView?.indexPath(for: clickedCell!)
        var model: ContactModel?
        
        if isSearchOn
        {
            model = searchList[(indexPath?.row)!] as? ContactModel
        }
        else {
            model = contactModelList[(indexPath?.row)!]
        }
        print("\(String(describing: model?.contactId))")
        
        //EditAddVeterinarianViewController.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let submit = UIAlertAction(title: "Edit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "editContact", sender: model)
        })
        let delete = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let alertDel = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Deleting", comment: "")
                self.contactDelMethod(model!)
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertDel.addAction(ok)
            alertDel.addAction(cancel)
            self.present(alertDel, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submit)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(alert, animated: true, completion: nil)
    }
    func contactDelMethod(_ model: ContactModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?ContactId=%@",API.Contact.ContactDelete, model.contactId)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
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
    @IBAction func showTabs(_ item: UIButton)
    {
        if item.tag == 1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is PetDetailsViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if item.tag == 2
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is MedicalRecordsViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let storyboard = UIStoryboard(name: "PHR", bundle: nil)
                    let medical: MedicalRecordsViewController? = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as? MedicalRecordsViewController
                    navigationController?.pushViewController(medical!, animated: true)
                    break
                }
            }
        }
        else if item.tag == 3
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is VeterinarianListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let details: VeterinarianListViewController? = storyboard?.instantiateViewController(withIdentifier: "vetList") as! VeterinarianListViewController?
                    navigationController?.pushViewController(details!, animated: true)
                    break;
                }
            }
        }
        else if item.tag == 4
        {
            print("self")
        }
        else if item.tag == 5
        {
            if galleryView.isHidden == true
            {
                
                galleryView.isHidden = false
            }
            else {
                
                galleryView.isHidden = true
            }
        }
        
    }
    
    @IBAction func selectGalleryMedicalRecords(_ sender: UIButton) {
        if sender.tag == 1
        {
            let details: GalleryListViewController? = storyboard?.instantiateViewController(withIdentifier: "photosList") as! GalleryListViewController?
            navigationController?.pushViewController(details!, animated: true)
            
        }
        else {
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            navigationController?.pushViewController(medical, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "editContact"
        {
            let edit: EditAddContactViewController = segue.destination as! EditAddContactViewController
            edit.model = sender as! ContactModel?
            edit.isFromVC = true
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
