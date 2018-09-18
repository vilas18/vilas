//
//  SharedWithMeViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class SharedPetsWithMeModel: NSObject
{
    var isActive : Bool?
    var canDelete : Bool?
    var SharePetInfoId : String?
    var PetPrefixId : String?
    var OwnerId : String?
    var PrefixOwnerId : String?
    var OwnerName : String?
    var OwnerInfoPath : String?
    var OwnerFirstName : String?
    var OwnerLastName : String?
    var PetVaccineName : String?
    var DueDate : String?
    var VaccinationId : String?
    
    var shareId: Bool?
    var shareMedi: Bool?
    var shareCont: Bool?
    var shareVets: Bool?
    var shareGall: Bool?
    var canModId: Bool?
    var canModMedi: Bool?
    var canModCont: Bool?
    var canModVet: Bool?
    var canModGall: Bool?
    
    var petId : String?
    var petName : String?
    var petType : String?
    var breed : String?
    var secBreed : String?
    var pedigree : String?
    var bloodType : String?
    var chipNo : String?
    var tattooNo : String?
    var genderId : String?
    var gender : String?
    var adoptDate : String?
    var dob : String?
    var pob : String?
    var country : String?
    var countryId : String?
    var state : String?
    var stateId : String?
    var zip : String?
    var hairType : String?
    var color : String?
    var sterile : String?
    var imagePath : String?
    var coverImage : String?
    var petTypeId: String?
    var bloodTypeId: String?
    var hairTypeId: String?
    var colorId: String?
    var secColorId: String?
    var isInSmo: String?
    var tagNo: String?
    var tagType: String?
    var tagExp: String?
    var customPetType: String?
    
    
    init?(IsActive: Bool?, canDelete: Bool?, SharePetInfoId : String?, PetPrefixId : String?, OwnerId : String?, PrefixOwnerId : String?, OwnerName : String?, OwnerInfoPath : String?, OwnerFirstName : String?, OwnerLastName : String?, PetVaccineName : String?, DueDate : String?, VaccinationId : String?, petId: String, petName: String, petType : String, breed : String?, secBreed : String?, pedigree : String?, bloodType : String?, chipNo : String?, tattooNo : String?, genderId : String?, gender : String?, adoptDate : String?, dob : String?, pob : String?, country : String?, countryId : String?, state : String?, stateId : String?, zip : String?, hairType : String?, color : String?, sterile : String?, imagePath : String?, coverImage : String? ,petTypeId: String?, bloodTypeId: String?, hairTypeId: String?, colorId: String?, secColorId: String?, isInSmo: String?, tagNo: String?,tagType: String?,tagExp: String?, customPetType: String?, shareId: Bool?, shareMedi: Bool?, shareCont: Bool?, shareVets: Bool?, shareGall: Bool?, canModId: Bool?, canModMedi: Bool?, canModCont: Bool?, canModVet: Bool?, canModGall: Bool?)
    {
        
        self.isActive=IsActive
        self.canDelete=canDelete
        self.SharePetInfoId=SharePetInfoId
        self.PetPrefixId=PetPrefixId
        self.OwnerId=OwnerId
        self.PrefixOwnerId=PrefixOwnerId
        self.OwnerName=OwnerName
        self.OwnerInfoPath=OwnerInfoPath
        self.OwnerFirstName=OwnerFirstName
        self.OwnerLastName=OwnerLastName
        self.PetVaccineName=PetVaccineName
        self.DueDate=DueDate
        self.VaccinationId=VaccinationId
        
        self.petId=petId
        self.petName=petName
        self.petType=petType
        self.breed=breed
        self.secBreed=secBreed
        self.pedigree=pedigree
        self.bloodType=bloodType
        self.chipNo=chipNo
        self.tattooNo=tattooNo
        self.genderId=genderId
        self.gender=gender
        self.adoptDate=adoptDate
        self.dob=dob
        self.pob=pob
        self.country=country
        self.countryId=countryId
        self.state=state
        self.stateId=stateId
        self.zip=zip
        self.hairType=hairType
        self.color=color
        self.sterile=sterile
        self.imagePath=imagePath
        self.coverImage=coverImage
        self.petTypeId = petTypeId
        self.bloodTypeId = bloodTypeId
        self.hairTypeId = hairTypeId
        self.colorId = colorId
        self.secColorId = secColorId
        self.isInSmo = isInSmo
        self.tagNo = tagNo
        self.tagType = tagType
        self.tagExp = tagExp
        self.customPetType = customPetType
        
        self.shareId = shareId
        self.shareMedi = shareMedi
        self.shareCont = shareCont
        self.shareVets = shareVets
        self.shareGall = shareGall
        self.canModId = canModId
        self.canModMedi = canModMedi
        self.canModCont = canModCont
        self.canModVet = canModVet
        self.canModGall = canModGall
    }
}
class SharedWithMeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var mineShared: UISegmentedControl!
    var noDataLbl: UILabel?
    var patientID: String = ""
    var petListArray = [Any]()
    var petModelList = [MyPetsModel]()
    var prefs: UserDefaults?
    @IBOutlet weak var petListTbl: UITableView!
    var selectedPet: MyPetsModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        var rightItem1: UIBarButtonItem?
        rightItem1 = UIBarButtonItem(image: UIImage(named: "pending_contacts"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        
        
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 30))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text =  "No pets found"
        
        noDataLbl?.center = self.view.center
        self.mineShared.addTarget(self, action: #selector(self.showSharedPets), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        self.mineShared.selectedSegmentIndex = 1
        checkInternetConnection()
    }
    @objc func showSharedPets(_ sender: UISegmentedControl)
    {
        if  sender.selectedSegmentIndex == 0
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            print("Self")
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView)
    //    {
    //        if scrollView.contentOffset.x != 0 {
    //            var offset: CGPoint = scrollView.contentOffset
    //            offset.x = 0
    //            scrollView.contentOffset = offset
    //        }
    //    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func rightClk1(sender: AnyObject)
    {
        let pending:  PendingContactsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "Pending") as! PendingContactsListViewController
        self.navigationController?.pushViewController(pending, animated: true)
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.petModelList = []
            self.webServiceToGetpetList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func webServiceToGetpetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?userId=%@", API.Owner.SharedPets, userId)
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
                            self.petListTbl.reloadData()
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
                                let shared = MyPetsModel(IsActive: item["IsActive"] as? Bool, canDelete: item["canDelete"] as? Bool, SharePetInfoId : item["SharePetInfoId"] as? String, PetPrefixId : item["PetPrefixId"] as? String, OwnerId : item["OwnerId"] as? NSNumber, PrefixOwnerId : item["PrefixOwnerId"] as? String, OwnerName : item["OwnerName"] as? String, OwnerInfoPath : item["OwnerInfoPath"] as? String, OwnerFirstName : item["OwnerFirstName"] as? String, OwnerLastName : item["OwnerLastName"] as? String, PetVaccineName : item["PetVaccineName"] as? String, DueDate : item["DueDate"] as? String, VaccinationId : item["VaccinationId"] as? String, petId: item["Id"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetTypeStr"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["PetGender"] as? NSNumber, gender : item["GenderStr"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["PetBirthDate"] as? String, pob : item["PlaceofBirth"] as? String, country : item["PetCountry"] as? String, countryId : item["PetCountryId"] as? String, state : item["PetState"] as? String, stateId : item["PetStateId"] as? String, zip : item["PetZip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["PetImage"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetType"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: item["ShareIDInformation"] as? Bool, shareMedi: item["ShareMedicalRecords"] as? Bool, shareCont: item["ShareContacts"] as? Bool, shareVets: item["ShareVeterinarians"] as? Bool, shareGall: item["ShareGallery"] as? Bool, canModId: item["CanmodifyIDInformation"] as? Bool, canModMedi: item["CanmodifyMedicalRecords"] as? Bool, canModCont: item["CanmodifyContacts"] as? Bool, canModVet: item["CanmodifyVeterinarians"] as? Bool, canModGall: item["CanmodifyGallery"] as? Bool,secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                                
                                self.petModelList.append(shared!)
                            }
                            
                            self.petListTbl.reloadData()
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
        return petModelList.count > 0 ? petModelList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPets", for: indexPath) as!  MyPetsTableViewCell
        cell.petImage.image = nil
        cell.petImage.layer.cornerRadius = 35
        cell.petImage.clipsToBounds = true
        let pets = self.petModelList[indexPath.row]
        cell.petType.text = pets.petType
        cell.petName.text = pets.petName
        cell.dob.text = pets.dob
        cell.gender.text = pets.gender
        cell.owner.text = pets.OwnerName
        //cell.ownerLbl.text = "\(model.firstName) \(model.lastName)"
        cell.shareBtn.isHidden = false
        cell.shareBtn.tag = Int(truncating: pets.petId!)
        print(cell.shareBtn.tag)
        cell.shareBtn.addTarget(self, action: #selector(self.viewMenuClk), for: .touchUpInside)
        cell.petImage.imageFromServerURL(urlString: (pets.imagePath)!, defaultImage: "petImage-default.png")
        // cell.petImage.sd_setImage(with: NSURL(string: pets.imagePath!)! as URL!, placeholderImage: UIImage(named: "petImage-default.png")!, options: SDWebImageOptions(rawValue: 1))
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let pet = petModelList[indexPath.row]
        UserDefaults.standard.set(pet.petId, forKey: "SelectedPet")
        UserDefaults.standard.set(pet.imagePath, forKey: "PetProfile")
        UserDefaults.standard.set(pet.bloodType, forKey: "PetBlood")
        UserDefaults.standard.set(pet.dob, forKey: "PetDob")
        UserDefaults.standard.set(pet.gender, forKey: "PetGender")
        UserDefaults.standard.set(pet.petName, forKey: "PetName")
        UserDefaults.standard.set(pet.petType, forKey: "PetType")
        UserDefaults.standard.set(pet.customPetType, forKey: "PetTypeOther")
        UserDefaults.standard.set(pet.isInSmo, forKey: "SMO")
        UserDefaults.standard.set(true, forKey: "SharedPet")
        UserDefaults.standard.set(pet.shareId, forKey: "ShareId")
        UserDefaults.standard.set(pet.shareMedi, forKey: "ShareMedi")
        UserDefaults.standard.set(pet.shareVets, forKey: "ShareVets")
        UserDefaults.standard.set(pet.shareCont, forKey: "ShareCont")
        UserDefaults.standard.set(pet.shareGall, forKey: "ShareGall")
        UserDefaults.standard.set(pet.canModId, forKey: "ModifyId")
        UserDefaults.standard.set(pet.canModMedi, forKey: "ModifyMedi")
        UserDefaults.standard.set(pet.canModVet, forKey: "ModifyVet")
        UserDefaults.standard.set(pet.canModCont, forKey: "ModifyCont")
        UserDefaults.standard.set(pet.canModGall, forKey: "ModifyGall")
        UserDefaults.standard.set(pet.OwnerId, forKey: "OwnerId")
        UserDefaults.standard.synchronize()
        if pet.shareId!
        {
            self.performSegue(withIdentifier: "petdetails", sender: pet)
        }
        else if pet.shareMedi!
        {
            let storyboard = UIStoryboard(name: "PHR", bundle: nil)
            let medical: MedicalRecordsViewController = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as! MedicalRecordsViewController
            navigationController?.pushViewController(medical, animated: true)
        }
        else if pet.shareVets!
        {
            let details: VeterinarianListViewController = self.storyboard?.instantiateViewController(withIdentifier: "vetList") as! VeterinarianListViewController
            navigationController?.pushViewController(details, animated: true)
        }
        else if pet.shareCont!
        {
            let details: ContactListViewController = self.storyboard?.instantiateViewController(withIdentifier: "contactList") as! ContactListViewController
            navigationController?.pushViewController(details, animated: true)
        }
        else if pet.shareGall!
        {
            let details: GalleryListViewController = storyboard?.instantiateViewController(withIdentifier: "photosList") as! GalleryListViewController
            navigationController?.pushViewController(details, animated: true)
        }
        
    }
    @objc func viewMenuClk(sender: AnyObject)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.petListTbl)
        let indexPath = self.petListTbl.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            self.selectedPet = self.petModelList[(indexPath?.row)!]
            UserDefaults.standard.set(self.selectedPet?.petId, forKey: "SelectedPet")
            UserDefaults.standard.set(self.selectedPet?.imagePath, forKey: "PetProfile")
            UserDefaults.standard.set(self.selectedPet?.bloodType, forKey: "PetBlood")
            UserDefaults.standard.set(self.selectedPet?.dob, forKey: "PetDob")
            UserDefaults.standard.set(self.selectedPet?.gender, forKey: "PetGender")
            UserDefaults.standard.set(self.selectedPet?.petName, forKey: "PetName")
            UserDefaults.standard.set(self.selectedPet?.petType, forKey: "PetType")
            UserDefaults.standard.set(self.selectedPet?.customPetType, forKey: "PetTypeOther")
            UserDefaults.standard.set(self.selectedPet?.isInSmo, forKey: "SMO")
            UserDefaults.standard.set(true, forKey: "SharedPet")
            UserDefaults.standard.set(self.selectedPet?.shareId, forKey: "ShareId")
            UserDefaults.standard.set(self.selectedPet?.shareMedi, forKey: "ShareMedi")
            UserDefaults.standard.set(self.selectedPet?.shareVets, forKey: "ShareVets")
            UserDefaults.standard.set(self.selectedPet?.shareCont, forKey: "ShareCont")
            UserDefaults.standard.set(self.selectedPet?.shareGall, forKey: "ShareGall")
            UserDefaults.standard.set(self.selectedPet?.canModId, forKey: "ModifyId")
            UserDefaults.standard.set(self.selectedPet?.canModMedi, forKey: "ModifyMedi")
            UserDefaults.standard.set(self.selectedPet?.canModVet, forKey: "ModifyVet")
            UserDefaults.standard.set(self.selectedPet?.canModCont, forKey: "ModifyCont")
            UserDefaults.standard.set(self.selectedPet?.canModGall, forKey: "ModifyGall")
            UserDefaults.standard.set(self.selectedPet?.OwnerId, forKey: "OwnerId")
            UserDefaults.standard.synchronize()
            print("\(String(describing:  self.selectedPet?.petId))")
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let medical = UIAlertAction(title: "Medical Summary", style: .default, handler: {(action: UIAlertAction) -> Void in
            print("\(String(describing: self.selectedPet?.petName))")
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            self.navigationController?.pushViewController(medical, animated: true)
            
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
        if self.selectedPet?.isInSmo == "0"
        {
            alert.addAction(medical)
            alert.addAction(remove)
            alert.addAction(cancel)
        }
        else
        {
            alert.addAction(medical)
            alert.addAction(cancel)
        }
        
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
            var str: String = String(format : "PetId=%@&UserId=%@&ContactId=%@", (self.selectedPet?.petId)!, (self.selectedPet?.OwnerId)!,userId)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format : "%@?%@",API.Owner.DeleteSharePetWithMe,str)
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
                        let alertDel = UIAlertController(title: nil, message: "Pet has been deleted successfully", preferredStyle: .alert)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "petdetails")
        {
            let destination = segue.destination as! PetDetailsViewController
            destination.petInfo = sender as? MyPetsModel
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
