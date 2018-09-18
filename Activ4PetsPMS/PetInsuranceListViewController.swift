//
//  PetInsuranceListViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class InsuranceModel: NSObject
{
    var insuranceId : String
    var insuranceTypeId : String
    var accountNo : String?
    var planName : String?
    var email : String?
    var startDate : String?
    var endDate : String?
    var phone : String?
    var comment : String?
    var isEmail : Bool?
    var customInsure: String?
    
    init? (insuranceId : String, insuranceTypeId : String, accountNo : String?, planName : String?, email : String?, startDate : String?, endDate : String?, phone : String?, comment : String?, isEmail : Bool? , customInsure: String?)
    {
        
        self.insuranceId=insuranceId
        self.insuranceTypeId=insuranceTypeId
        self.accountNo=accountNo!
        self.planName=planName
        self.email=email
        self.startDate=startDate
        self.endDate=endDate
        self.phone=phone
        self.comment=comment
        self.isEmail=isEmail
        self.customInsure = customInsure
        
    }
    
}

class PetInsuranceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var petInfo: MyPetsModel?
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petType: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var menuTv: UITableView!
    @IBOutlet weak var insuranceTv: UITableView!
    var noDataLbl: UILabel?
    var selectedInsurance: InsuranceModel?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var petImg: UIButton!
    @IBOutlet weak var mediRec: UIButton!
    @IBOutlet weak var veterinarians: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var linksView: UIView!
    
    var list = [String]()
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var isFromMedical: Bool = false
    
    var insureModelList = [InsuranceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isFromMedical == true
        {
            self.galleryView.isHidden = true
            self.bottomView.isHidden = true
            self.detailsView.isHidden = true
            self.petImage.isHidden = true
            self.menuTv.isHidden = true
            self.topSpace.constant = 0
            self.linksView.isHidden = true
        }
        else
        {
            //            let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
            //            tapG.numberOfTapsRequired = 1
            //            tapG.cancelsTouchesInView = false
            //            view.addGestureRecognizer(tapG)
            self.petImage.layer.masksToBounds = true
            self.petImage.layer.borderWidth = 1.0
            self.petImage.layer.cornerRadius = 4
            self.petImage.layer.borderColor = UIColor.white.cgColor
            let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
            navigationItem.leftBarButtonItem = leftItem
            let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
            //  [self.navigationItem setRightBarButtonItem:rightItem1];
            let menu = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addNewInsurance))
            
            //navigationItem.rightBarButtonItems = [rightItem1, menu]
            
            list = ["PET DETAILS", "ADOPTION", "INSURANCE"]
            menuTv.isHidden = true
            petName.text = petInfo?.petName
            if self.petInfo?.petType == "Other"
            {
                petType.text = (petInfo?.petType)! +  String(format: "(%@)", (petInfo?.customPetType)!)
            }
            else
            {
                petType.text = petInfo?.petType
            }
            
            //            self.petImage.sd_setImage(with: URL(string: (self.petInfo?.imagePath)!), placeholderImage: UIImage(named: "petImage-default.png"), options: SDWebImageOptions(rawValue: 1))
            //            petImg.setImage(petImage.image, for: .normal)
            //            petImg.setImage(petImage.image, for: .selected)
            let petImageUrl: String =  (self.petInfo?.imagePath)!
            if let url = NSURL(string: petImageUrl)
            {
                if let data = NSData(contentsOf: url as URL)
                {
                    if data.length > 0
                    {
                        self.petImage.image = UIImage(data: data as Data)
                        petImg.setImage(UIImage(data: data as Data), for: .normal)
                        petImg.setImage(UIImage(data: data as Data), for: .selected)
                    }
                    else
                    {
                        self.petImage.image = UIImage(named: "petImage-default.png")
                        petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                        petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
                    }
                }
                else
                {
                    self.petImage.image = UIImage(named: "petImage-default.png")
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
                }
            }
            else
            {
                self.petImage.image = UIImage(named: "petImage-default.png")
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
            }
            selectButton.layer.masksToBounds = true
            selectButton.layer.borderWidth = 2
            selectButton.layer.cornerRadius = 22.0
            selectButton.layer.borderColor = UIColor.white.cgColor
            menuTv.layer.masksToBounds = true
            menuTv.layer.borderWidth = 2
            menuTv.layer.borderColor = UIColor.lightGray.cgColor
            galleryView.isHidden = true
            galleryView.layer.masksToBounds = true
            galleryView.layer.borderWidth = 1
            galleryView.layer.cornerRadius = 2
            galleryView.layer.borderColor = UIColor.lightGray.cgColor
            
            noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y-100, width: 250, height: 50))
            noDataLbl?.textAlignment = .center
            noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
            
            noDataLbl?.numberOfLines = 2
            noDataLbl?.lineBreakMode = .byTruncatingTail
            view.addSubview(noDataLbl!)
            noDataLbl?.isHidden = true
            noDataLbl?.center = CGPoint(x: self.view.center.x, y: self.view.center.y-70)
            if self.petInfo?.isInSmo == "1"
            {
                navigationItem.rightBarButtonItem = rightItem1
                noDataLbl?.text =  "No records found"
            }
            else
            {
                navigationItem.rightBarButtonItems = [rightItem1, menu]
                noDataLbl?.text =  "No records found.\n Tap on '+' to add an Insurance"
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func viewTouched(_ sender: Any)
    {
        self.menuTv.isHidden = true
        self.galleryView.isHidden = true
        
    }
    @objc func rightClk1(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func addNewInsurance(_ sender: Any)
    {
        let add: AddEditInsuranceViewController? = self.storyboard?.instantiateViewController(withIdentifier: "editinsurance") as? AddEditInsuranceViewController
        add?.petInfo = sender as? MyPetsModel
        add?.isFromVC = false
        self.navigationController?.pushViewController(add!, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if self.isFromMedical == true
        {
            self.galleryView.isHidden = true
            self.bottomView.isHidden = true
            self.detailsView.isHidden = true
            self.petImage.isHidden = true
            self.menuTv.isHidden = true
            self.topSpace.constant = 0
            self.linksView.isHidden = true
        }
        else
        {
            self.menuTv.isHidden = true
            galleryView.isHidden = true
            more.isSelected = false
            more.backgroundColor = UIColor.white
            more.setImage(UIImage(named: "tab_more"), for: .normal)
            backView.backgroundColor = UIColor(red: 0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
            petImg.layer.masksToBounds = true
            petImg.layer.borderWidth = 1
            petImg.layer.cornerRadius = petImg.frame.size.width / 2
            petImg.layer.borderColor = UIColor.white.cgColor
            petImg.setImage(petImage.image, for: .normal)
            petImg.setImage(petImage.image, for: .selected)
            let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
            if shared
            {
                if (self.petInfo?.shareMedi!)!
                {
                    self.mediRec.isUserInteractionEnabled = true
                }
                else
                {
                    self.mediRec.isUserInteractionEnabled = false
                    self.mediRec.backgroundColor = UIColor.lightGray
                }
                if (self.petInfo?.shareVets!)!
                {
                    self.veterinarians.isUserInteractionEnabled = true
                }
                else
                {
                    self.veterinarians.isUserInteractionEnabled = false
                    self.veterinarians.backgroundColor = UIColor.lightGray
                }
                if (self.petInfo?.shareCont!)!
                {
                    self.contacts.isUserInteractionEnabled = true
                }
                else
                {
                    self.contacts.isUserInteractionEnabled = false
                    self.contacts.backgroundColor = UIColor.lightGray
                }
                if (self.petInfo?.shareGall!)!
                {
                    self.more.isUserInteractionEnabled = true
                }
                else
                {
                    self.more.isUserInteractionEnabled = false
                    self.more.backgroundColor = UIColor.lightGray
                }
                if (petInfo?.canModId)!
                {
                    
                }
                else
                {
                    let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
                    navigationItem.rightBarButtonItem = rightItem1
                }
            }
        }
        checkInternetConnection()
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            self.insureModelList = []
            webServiceToGetInsuranceList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToGetInsuranceList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?PetId=%@", API.Pet.PetInsuranceList, petId)
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
                let queryDic = json?["PetInsurancesListDetls"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                let prefs = UserDefaults.standard
                DispatchQueue.main.async
                    {
                        
                        if queryDic.count == 0
                        {
                            if self.isFromMedical == true
                            {
                                self.noDataLbl?.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                                prefs.set(true, forKey: "ZeroInsurance")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InsuranceView"), object: self, userInfo: ["ZeroInsurance": prefs.bool(forKey: "ZeroInsurance")])
                            }
                            else{
                                self.noDataLbl?.isHidden = false
                                self.insuranceTv.reloadData()
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        }
                        else
                        {
                            for item in queryDic
                            {
                                var prunedDictionary = [String: Any]()
                                for key: String in item.keys
                                {
                                    if !(item[key] is NSNull)
                                    {
                                        prunedDictionary[key] = item[key]
                                    }
                                    else
                                    {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            //  self.vetModelList = [VetModel]()
                            for item in filtered
                            {
                                let Insurance = InsuranceModel ( insuranceId : item["InsuranceId"] as! String, insuranceTypeId : item["InsuranceTypeId"] as! String, accountNo : item["AccountNumber"] as? String, planName : item["InsuranceName"] as? String, email : item["Email"] as? String, startDate : item["StartDate"] as? String, endDate : item["EndDate"] as? String, phone : item["Phone"] as? String, comment : item["Comment"] as? String, isEmail : item["IsEmailSend"] as? Bool, customInsure: item["CustomInsuranceType"] as? String  )
                                
                                
                                
                                self.insureModelList.append(Insurance!)
                            }
                            self.insuranceTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            prefs.set(false, forKey: "ZeroInsurance")
                            prefs.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InsuranceView"), object: self, userInfo: ["ZeroInsurance": prefs.bool(forKey: "ZeroInsurance")])
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return list.count
        }
        else {
            return insureModelList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let insuCell: InsuranceCell? = (tableView.dequeueReusableCell(withIdentifier: "cell") as? InsuranceCell)
        if tableView.tag == 1 {
            let cell: CommonTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "pet", for: indexPath) as? CommonTableViewCell)
            cell?.firstLabel?.text = list[indexPath.row]
            return cell!
        }
        else
        {
            let details = insureModelList[indexPath.row]
            if details.planName == "Other"
            {
                insuCell?.name?.text = details.customInsure
            }
            else
            {
                insuCell?.name?.text = details.planName
            }
            
            insuCell?.account?.text = details.accountNo
            insuCell?.endDate?.text = details.endDate
            insuCell?.selectionStyle = .none
            if self.isFromMedical == true
            {
                insuCell?.select.isHidden = true
                //insuCell?.isUserInteractionEnabled = false
            }
            else
            {
                insuCell?.select.isHidden = false
                insuCell?.select?.tag = indexPath.row
                insuCell?.select?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
            }
        }
        if self.petInfo?.isInSmo == "1"
        {
            insuCell?.isUserInteractionEnabled = false
        }
        return insuCell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 1
        {
            if indexPath.row == 0
            {
                for controller: UIViewController in (navigationController?.viewControllers)! {
                    if #available(iOS 10.0, *) {
                        if (controller is PetDetailsViewController) {
                            navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            else if indexPath.row == 1 {
                for controller: UIViewController in (navigationController?.viewControllers)! {
                    if (controller is AdoptionDetailsViewController) {
                        navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                    else {
                        let adopt: AdoptionDetailsViewController? = storyboard?.instantiateViewController(withIdentifier: "adoptiondetails") as? AdoptionDetailsViewController
                        adopt?.petInfo = petInfo
                        navigationController?.pushViewController(adopt!, animated: true)
                        break
                    }
                }
            }
            else if indexPath.row == 2
            {
                
            }
            menuTv.isHidden = true
        }
        else
        {
            if self.isFromMedical == true
            {
                selectedInsurance = insureModelList[indexPath.row]
                self.performSegue(withIdentifier: "editinsurance", sender: self.selectedInsurance)
            }
        }
    }
    
    @objc func showOptions(_ sender: UIButton)
    {
        //NSLog(@"%ld",(long)sender.tag);
        let clickedCell: InsuranceCell? = (sender.superview?.superview as? InsuranceCell)
        var views: Any? = clickedCell?.superview
        while (views != nil) && (views is UITableView) == false {
            views = (views as AnyObject).superview ?? " "
        }
        let tableView: UITableView? = (views as? UITableView)
        let indexPath: IndexPath? = tableView?.indexPath(for: clickedCell!)
        selectedInsurance = insureModelList[(indexPath?.row)!]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let submit = UIAlertAction(title: "Edit Insurance", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "editinsurance", sender: self.selectedInsurance)
        })
        let delete = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
                self.callPetInsuranceDeleteMethod()
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true) 
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submit)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(alert, animated: true)
    }
    func callPetInsuranceDeleteMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?InsuranceId=%@", API.Pet.DeletePetInsurance, (self.selectedInsurance?.insuranceId)!)
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
                        let alertDel = UIAlertController(title: nil, message: "Insurance details has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.checkInternetConnection()
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
    @IBAction func selectPetDetailsOptions(_ sender: Any)
    {
        if menuTv.isHidden == true {
            menuTv.isHidden = false
        }
        else {
            menuTv.isHidden = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "editinsurance") {
            let edit: AddEditInsuranceViewController? = segue.destination as? AddEditInsuranceViewController
            edit?.details = sender as? InsuranceModel
            edit?.petInfo = petInfo
            edit?.isFromVC = true
        }
        
    }
    @IBAction func showTabs(_ item: UIButton)
    {
        if item.tag == 1 {
            print("Self")
        }
        else if item.tag == 2 {
            let storyboard = UIStoryboard(name: "PHR", bundle: nil)
            let medical: MedicalRecordsViewController? = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as? MedicalRecordsViewController
            navigationController?.pushViewController(medical!, animated: true)
        }
        else if item.tag == 3 {
            let details: VeterinarianListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "vetList") as? VeterinarianListViewController
            navigationController?.pushViewController(details!, animated: true)
        }
        else if item.tag == 4 {
            let details: ContactListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "contactList") as? ContactListViewController
            navigationController?.pushViewController(details!, animated: true)
        }
        else if item.tag == 5 {
            if galleryView.isHidden == true {
                galleryView.isHidden = false
            }
            else {
                galleryView.isHidden = true
            }
        }
    }
    
    @IBAction func selectGalleryMedicalRecords(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let details: GalleryListViewController? = storyboard?.instantiateViewController(withIdentifier: "photosList") as? GalleryListViewController
            navigationController?.pushViewController(details!, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            navigationController?.pushViewController(medical, animated: true)
        }
    }
    
    @IBAction func showInsuranceLinks(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            UIApplication.shared.openURL(URL(string: "https://www.healthypawspetinsurance.com/")!)
        }
        else if sender.tag == 2
        {
            UIApplication.shared.openURL(URL(string: "https://www.petinsurance.com/")!)
        }
        else if sender.tag == 3
        {
            UIApplication.shared.openURL(URL(string: "https://www.gopetplan.com/")!)
        }
        else if sender.tag == 4
        {
            UIApplication.shared.openURL(URL(string: "http://trupanion.com/")!)
        }
        else if sender.tag == 5 {
            
            UIApplication.shared.openURL(URL(string: "https://www.embracepetinsurance.com/")!)
        }
        else if sender.tag == 6
        {
            UIApplication.shared.openURL(URL(string: "https://www.petsbest.com/")!)
        }
        else if sender.tag == 7
        {
            UIApplication.shared.openURL(URL(string: "https://enroll.petpremium.com/petfullquote/enrollnew2/direct.html?offer_id=1621&aff_id=5039&aff_sub=&source=&aff_sub2=&transaction_id=102b220d0bce75aac28b98f9a53615&ppcpn=877-226-0237")!)
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
