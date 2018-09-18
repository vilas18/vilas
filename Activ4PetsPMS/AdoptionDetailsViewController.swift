//
//  AdoptionDetailsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class AdoptionDetailsModel: NSObject
{
    var petId : String?
    var petName : String?
    var petType : String?
    var farmerId : String?
    var farmerName : String?
    var farmerAdd1 : String?
    var farmerAdd2 : String?
    var country : String?
    var state : String?
    var city : String?
    var zip : String?
    var home : String?
    var office : String?
    var cell : String?
    var fax : String?
    var adoptionNo : String?
    var countryId : String?
    var stateId : String?
    
    //var profilePicUrl : String?
    
    
    init?(petId: String?, petName: String?, petType : String?, farmerId : String?, farmerName : String?, farmerAdd1 : String?, farmerAdd2 : String?, country : String?, state : String?, city : String?, zip : String?, home : String?, office : String?, cell : String?, fax : String?, adoptionNo : String?, countryId : String?, stateId : String? )
    {
        
        self.petId=petId
        self.petName=petName
        self.petType=petType
        self.farmerId=farmerId
        self.farmerName=farmerName
        self.farmerAdd1=farmerAdd1
        self.farmerAdd2=farmerAdd2
        self.country=country
        self.state=state
        self.city=city
        self.zip=zip
        self.home=home
        self.office=office
        self.cell=cell
        self.fax=fax
        self.adoptionNo=adoptionNo
        self.countryId=countryId
        self.stateId=stateId
    }
}

class AdoptionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var office: UILabel!
    @IBOutlet weak var cell: UILabel!
    @IBOutlet weak var fax: UILabel!
    @IBOutlet weak var adoptionNo: UILabel!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petType: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var menuTv: UITableView!
    var details: AdoptionDetailsModel?
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var petImg: UIButton!
    @IBOutlet weak var mediRec: UIButton!
    @IBOutlet weak var veterinarians: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var galleryView: UIView!
    var list = [String]()
    
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var isFromMedical: Bool = false
    
    var petInfo: MyPetsModel?
    
    var adoptModel = [AdoptionDetailsModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.isFromMedical == true
        {
            let str : String = UserDefaults.standard.string(forKey: "SMO")!
            if str == "1"
            {
                
            }
            else
            {
                let editbutton = UIButton(type: .roundedRect)
                editbutton.addTarget(self, action: #selector(self.aMethod), for: .touchUpInside)
                editbutton.setBackgroundImage(UIImage(named: "id-card_edit-btn.png"), for: .normal)
                editbutton.frame = CGRect(x: 240, y: 30, width: 36, height: 30)
                self.contentView.addSubview(editbutton)
                let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
                let modId: Bool = UserDefaults.standard.bool(forKey: "ModifyId")
                
                if shared && modId
                {
                    editbutton.isHidden = false
                }
                else
                {
                    editbutton.isHidden = false
                }
            }
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
            let menu = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editAdoptionDetails))
            if self.petInfo?.isInSmo == "1"
            {
                navigationItem.rightBarButtonItem = rightItem1
            }
            else
            {
                navigationItem.rightBarButtonItems = [rightItem1, menu]
            }
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
            
            //        self.petImage.sd_setImage(with: URL(string: (self.petInfo?.imagePath)!), placeholderImage: UIImage(named: "petImage-default.png"), options: SDWebImageOptions(rawValue: 1))
            //        petImg.setImage(petImage.image, for: .normal)
            //        petImg.setImage(petImage.image, for: .selected)
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
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        if self.isFromMedical == true
        {
            self.galleryView.isHidden = true
            self.bottomView.isHidden = true
            self.detailsView.isHidden = true
            self.petImage.isHidden = true
            self.menuTv.isHidden = true
            self.topSpace.constant = 0
        }
        else
        {
            galleryView.isHidden = true
            more.isSelected = false
            more.backgroundColor = UIColor.white
            more.setImage(UIImage(named: "tab_more"), for: .normal)
            backView.backgroundColor = UIColor(red: 0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
            petImg.layer.masksToBounds = true
            petImg.layer.borderWidth = 1
            petImg.layer.cornerRadius = petImg.frame.size.width / 2
            petImg.layer.borderColor = UIColor.white.cgColor
            
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
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            self.adoptModel = []
            webServiceToGetAdoptionDetails()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webServiceToGetAdoptionDetails()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?PetId=%@", API.Pet.PetAdoptionDetails, petId)
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
                let queryDic = json?["PetAdoptionDetls"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if (queryDic.count == 0) || (queryDic.isEmpty)
                        {
                            self.name.text = ""
                            self.address1.text = ""
                            self.address2.text = ""
                            self.country.text = ""
                            self.state.text = ""
                            self.city.text = ""
                            self.zip.text = ""
                            self.home.text = ""
                            self.office.text = ""
                            self.cell.text = ""
                            self.fax.text = ""
                            self.adoptionNo.text = ""
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
                                let details = AdoptionDetailsModel (petId: item["PetId"] as? String, petName: item["PetName"] as? String, petType : item["PetTypeName"] as? String, farmerId : item["Farmerid"] as? String, farmerName : item["FarmerName"] as? String, farmerAdd1 : item["FarmerAddress1"] as? String, farmerAdd2 : item["FarmerAddress2"] as? String, country : item["FarmerCountry"] as? String, state : item["FarmerState"] as? String, city : item["FarmerCity"] as? String, zip : item["FarmerZip"] as? String, home : item["FarmerHomePhone"] as? String, office : item["FarmerOfficePhone"] as? String, cell : item["FarmerCellPhone"] as? String, fax : item["FarmerFax"] as? String, adoptionNo : item["FarmerAdoptionNumber"] as? String, countryId : item["FarmerCountryId"] as? String, stateId : item["FarmerStateId"] as? String )
                                
                                
                                self.adoptModel.append(details!)
                                
                            }
                            
                            self.details = self.adoptModel[0]
                            if self.isFromMedical
                            {
                                self.details = self.adoptModel[0]
                            }
                            self.name.text = self.details?.farmerName
                            self.address1.text = self.details?.farmerAdd1
                            self.address2.text = self.details?.farmerAdd2
                            self.country.text = self.details?.country
                            self.state.text = self.details?.state
                            self.city.text = self.details?.city
                            self.zip.text = self.details?.zip
                            self.home.text = self.details?.home
                            self.office.text = self.details?.office
                            self.cell.text = self.details?.cell
                            self.fax.text = self.details?.fax
                            self.adoptionNo.text = self.details?.adoptionNo
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else
            {
                DispatchQueue.main.async
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            
        }
        task.resume()
    }
    @objc func rightClk1(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func editAdoptionDetails(_ sender: Any) {
        performSegue(withIdentifier: "editAdoption", sender: details)
    }
    
    @objc func aMethod(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "editMedicalSummaryAdoption", sender: petInfo)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "pet", for: indexPath) as? CommonTableViewCell)
        cell?.firstLabel?.text = list[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.popViewController(animated: true)
        }
        else if indexPath.row == 1 {
            
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "showInsurance", sender: petInfo)
        }
        
        menuTv.isHidden = true
    }
    
    @IBAction func selectPetDetailsOptions(_ sender: Any) {
        if menuTv.isHidden == true {
            menuTv.isHidden = false
        }
        else {
            menuTv.isHidden = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "editAdoption") {
            let edit: EditAdoptionDetailsViewController? = segue.destination as? EditAdoptionDetailsViewController
            edit?.model = sender as? AdoptionDetailsModel
        }
        else if (segue.identifier == "showInsurance")
        {
            let insure: PetInsuranceListViewController? = segue.destination as? PetInsuranceListViewController
            insure?.petInfo = sender as? MyPetsModel
        }
        else if (segue.identifier == "editMedicalSummaryAdoption")
        {
            let edit: EditAdoptionDetailsViewController? = segue.destination as? EditAdoptionDetailsViewController
            edit?.model = sender as? AdoptionDetailsModel
        }
    }
    @IBAction func showTabs(_ item: UIButton)
    {
        if item.tag == 1 {
            print("Self")
        }
        else if item.tag == 2 {
            let storyboard = UIStoryboard(name: "PHR", bundle: nil)
            let medical: MedicalRecordsViewController = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as! MedicalRecordsViewController
            navigationController?.pushViewController(medical, animated: true)
        }
        else if item.tag == 3 {
            let details: VeterinarianListViewController = self.storyboard?.instantiateViewController(withIdentifier: "vetList") as! VeterinarianListViewController
            navigationController?.pushViewController(details, animated: true)
        }
        else if item.tag == 4
        {
            let details: ContactListViewController = self.storyboard!.instantiateViewController(withIdentifier: "contactList") as! ContactListViewController
            navigationController?.pushViewController(details, animated: true)
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
        if sender.tag == 1 {
            let details: GalleryListViewController? = storyboard?.instantiateViewController(withIdentifier: "photosList") as? GalleryListViewController
            navigationController?.pushViewController(details!, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            navigationController?.pushViewController(medical, animated: true)
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
