//
//  PetDetailsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

func incrementAppOpenedCount()
{ // called from appdelegate didfinishLaunchingWithOptions:
    guard var appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int else
    {
        UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
        return
    }
    appOpenCount += 1
    print(appOpenCount)
    UserDefaults.standard.set(appOpenCount, forKey: "APP_OPENED_COUNT")
    UserDefaults.standard.synchronize()
}
class PetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var secBreed: UILabel!
    @IBOutlet weak var pedigree: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var chipNo: UILabel!
    @IBOutlet weak var tattooNo: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var adoptionDate: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var pob: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var hairType: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var sterile: UILabel!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petType: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    var petInfo: MyPetsModel?
    
    @IBOutlet weak var menuTv: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var petImg: UIButton!
    @IBOutlet weak var mediRec: UIButton!
    @IBOutlet weak var veterinarians: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var pasadenaView: UIView!
    @IBOutlet weak var tagNo: UILabel!
    @IBOutlet weak var tagType: UILabel!
    @IBOutlet weak var tagExp: UILabel!
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var step2: UIButton!
    @IBOutlet weak var step3: UIButton!
    @IBOutlet weak var step1Lbl: UILabel!
    var senderId: Int = 0
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var list = [String]()
    var petDetailsAppt = [String: Any]()
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var contentView: UIView!
    var isFromMedical: Bool = false
    var petModelList = [MyPetsModel]()
    var isFromAppt: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.isFromMedical == true
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.offerView.isHidden = true
            self.webServiceToGetpetList()
            
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
            let menu = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editPetDetails))
            if self.petInfo?.isInSmo == "1"
            {
                navigationItem.rightBarButtonItem = rightItem1
                let alert = UIAlertController(title: "Alert !", message: "Second medical opinion is in progress. You can not modify the pet information till it is complete.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                navigationItem.rightBarButtonItems = [rightItem1, menu]
            }
            
            let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
            if centerId as? Int == 67
            {
                self.pasadenaView.isHidden = false
                self.tagNo.text = self.petInfo?.tagNo
                self.tagType.text = self.petInfo?.tagType
                if self.petInfo?.tagExp != nil && self.petInfo?.tagExp != ""
                {
                    let strList: [String] = (self.petInfo?.tagExp?.components(separatedBy: " "))!
                    self.tagExp.text = strList[0]
                }
                else
                {
                    self.tagExp.text = self.petInfo?.tagExp
                }
            }
            else{
                self.pasadenaView.isHidden = true
            }
            popUpView.clipsToBounds = true
            popUpView.layer.borderWidth = 2.0
            popUpView.layer.borderColor = UIColor(red: 28.0 / 255.0, green: 150.0 / 255.0, blue: 109.0 / 255.0, alpha: 1).cgColor
            self.offerView.isHidden = true
            let isShown: Bool = UserDefaults.standard.bool(forKey: "PopUpPetId")
            let step2Str = NSAttributedString(string: " Download your rebate form here!")
            let step3Str = NSAttributedString(string: "After purchasing Tri-Heart® Plus mail in your rebate form and invoice, or submit them online here.")
            let text2 = NSMutableAttributedString(attributedString: step2Str)
            text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 27, length: 4))
            let text3 = NSMutableAttributedString(attributedString: step3Str)
            text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 93, length: 4))
            let step1str = NSAttributedString(string: "Visit your veterinarian to get more information about Tri-Heart® Plus")
            step1Lbl.attributedText = step1str
            step1Lbl.numberOfLines = 6
            step1Lbl.font = UIFont.systemFont(ofSize: 9.0)
            step1Lbl.textColor = UIColor.darkGray
            step1Lbl.lineBreakMode = .byTruncatingTail
            step2.titleLabel?.lineBreakMode = .byTruncatingTail
            step2.titleLabel?.numberOfLines = 4
            step2.titleLabel?.adjustsFontSizeToFitWidth = true
            step2.titleLabel?.textColor = UIColor.darkGray
            step2.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step2.setAttributedTitle(text2, for: .normal)
            step3.titleLabel?.lineBreakMode = .byTruncatingTail
            step3.titleLabel?.numberOfLines = 10
            step3.titleLabel?.adjustsFontSizeToFitWidth = true
            step3.titleLabel?.textColor = UIColor.darkGray
            step3.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step3.setAttributedTitle(text3, for: .normal)
            if isShown {
                
            }
            else
            {
                //getPopupCount()
            }
            
            list = ["PET DETAILS", "ADOPTION", "INSURANCE"]
            menuTv.isHidden = true
            breed.text = petInfo?.breed
            secBreed.text = petInfo?.secBreed
            pedigree.text = petInfo?.pedigree
            bloodType.text = petInfo?.bloodType
            chipNo.text = petInfo?.chipNo
            tattooNo.text = petInfo?.tattooNo
            gender.text = petInfo?.gender
            adoptionDate.text = petInfo?.adoptDate
            dob.text = petInfo?.dob
            pob.text = petInfo?.pob
            country.text = petInfo?.country
            
            state.text = petInfo?.state
            zip.text = petInfo?.zip
            hairType.text = petInfo?.hairType
            color.text = petInfo?.color
            if petInfo?.sterile == "Yes"
            {
                sterile.text = "Yes"
            }
            else if petInfo?.sterile == "No"
            {
                sterile.text = "No"
            }
            else
            {
                sterile.text = "Unknown"
            }
            
            petName.text = petInfo?.petName
            if self.petInfo?.petType == "Other"
            {
                petType.text = (petInfo?.petType)! + String(format: "(%@)", (petInfo?.customPetType)!)
            }
            else
            {
                petType.text = petInfo?.petType
            }
            if self.petInfo?.hairType == "Other"
            {
                hairType.text = petInfo?.otherHairType
            }
            else
            {
                hairType.text = petInfo?.hairType
            }
            if self.petInfo?.color == "Other"
            {
                color.text = petInfo?.otherColorType
            }
            else
            {
                color.text = petInfo?.color
            }
            //            print(petInfo?.otherSecColorType)
            //            print(petInfo?.otherColorType)
            
            //            self.petImage.sd_setImage(with: URL(string: (self.petInfo?.imagePath)!), placeholderImage: UIImage(named: "petImage-default.png"), options: SDWebImageOptions(rawValue: 1))
            //            self.petImg.setImage(self.petImage.image, for: .normal)
            //            self.petImg.setImage(self.petImage.image, for: .selected)
            
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
    @objc func viewTouched(_ sender: Any)
    {
        self.menuTv.isHidden = true
        self.galleryView.isHidden = true
        
    }
    func prepareUI()
    {
        breed.text = petInfo?.breed
        secBreed.text = petInfo?.secBreed
        pedigree.text = petInfo?.pedigree
        bloodType.text = petInfo?.bloodType
        chipNo.text = petInfo?.chipNo
        tattooNo.text = petInfo?.tattooNo
        gender.text = petInfo?.gender
        print(gender.text ?? "")
        adoptionDate.text = petInfo?.adoptDate
        dob.text = petInfo?.dob
        pob.text = petInfo?.pob
        country.text = petInfo?.country
        state.text = petInfo?.state
        zip.text = petInfo?.zip
        if self.petInfo?.hairType == "Other"
        {
            hairType.text = petInfo?.otherHairType
        }
        else
        {
            hairType.text = petInfo?.hairType
        }
        if self.petInfo?.color == "Other"
        {
            color.text = petInfo?.otherColorType
        }
        else
        {
            color.text = petInfo?.color
        }
        
        if petInfo?.sterile == "Yes"
        {
            sterile.text = "Yes"
        }
        else if petInfo?.sterile == "No"
        {
            sterile.text = "No"
        }
        else
        {
            sterile.text = "Unknown"
        }
        let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
        if centerId as? Int == 67
        {
            self.pasadenaView.isHidden = false
            self.tagNo.text = self.petInfo?.tagNo
            self.tagType.text = self.petInfo?.tagType
            if self.petInfo?.tagExp != nil && self.petInfo?.tagExp != ""
            {
                let strList: [String] = (self.petInfo?.tagExp?.components(separatedBy: " "))!
                self.tagExp.text = strList[0]
            }
            else
            {
                self.tagExp.text = self.petInfo?.tagExp
            }
            
        }
        else
        {
            self.pasadenaView.isHidden = true
        }
        
        if petInfo?.isInSmo == "1"
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
        UserDefaults.standard.set(petInfo?.petId, forKey: "SelectedPet")
        UserDefaults.standard.set(petInfo?.petName, forKey: "SelectedPetName")
        UserDefaults.standard.set(petInfo?.petId, forKey: "SelectedPet")
        UserDefaults.standard.set(petInfo?.imagePath, forKey: "PetProfile")
        UserDefaults.standard.set(petInfo?.bloodType, forKey: "PetBlood")
        UserDefaults.standard.set(petInfo?.dob, forKey: "PetDob")
        UserDefaults.standard.set(petInfo?.gender, forKey: "PetGender")
        UserDefaults.standard.set(petInfo?.petName, forKey: "PetName")
        UserDefaults.standard.set(petInfo?.petType, forKey: "PetType")
        UserDefaults.standard.synchronize()
        let prefs = UserDefaults.standard
        prefs.set(petInfo?.petName, forKey: "PetName")
        prefs.set(petInfo?.petType, forKey: "PetType")
        prefs.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BasicDetailView"), object: self, userInfo: ["ZeroBasicDetail": prefs.value(forKey: "PetName") ?? "","BasicDetailType": prefs.value(forKey: "PetType") ?? "" ])
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isFromAppt
        {
            if self.petDetailsAppt.count != 0
            {
                var item = [String: Any]()
                for key: String in petDetailsAppt.keys
                {
                    if !(petDetailsAppt[key] is NSNull) {
                        item[key] = petDetailsAppt[key]
                    }
                    else {
                        item[key] = ""
                    }
                }
                let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetType"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["DateofBirth"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["ImagePath"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false, secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                
                self.petInfo = MyPets
            }
        }
    }
    func getPopupCount()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d",userId,12,2)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.GetCount,str)
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
                if let str = String(data: data, encoding: .utf8),
                    let count: Int = Int(str)
                {
                    DispatchQueue.main.async
                        {
                            if count > 0
                            {
                                self.offerView.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else {
                                self.callOpenPopupAPI()
                                self.offerView.isHidden = false
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callOpenPopupAPI()
    {
        let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date: String = formater.string(from: Date())
        var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",userId,12,2,"Open","IOS",date)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format: "%@?%@",API.MerkNotification.OpenPopUP,str)
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let status = json?["Status"] as? Int
            {
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            let dict:[String: Any] = json?["Message"] as! [String : Any]
                            self.senderId = dict["Id"] as! Int
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    }
    @IBAction func closePopup(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,2,"Close","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.offerView.isHidden = true
                                UserDefaults.standard.set(true, forKey: "PopUpPetId")
                                UserDefaults.standard.synchronize()
                                
                            }
                            else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
    }
    func callClickPopupAPI()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,2,"Download","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                // self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://login.activ4pets.com/content/images/Merck/THP_Merck_Dual_Rebate.pdf"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://login.activ4pets.com/content/images/Merck/THP_Merck_Dual_Rebate.pdf"))!)
                                }
                                
                            }
                            else
                            {
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
    }
    @IBAction func popupClick(_ sender: UIButton)
    {
        callClickPopupAPI()
    }
    
    @IBAction func openClick(_ sender: UIButton)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,2,"IOS-App","ClickRewards")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                }
                                
                            }
                            else
                            {
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
        
    }
    
    @IBAction func callWebLink(_ sender: Any)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,2,"IOS-App","ClickHome")
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                //self.offerView.isHidden = true
                                if UIApplication.shared.canOpenURL((URL(string: "https://www.triheartplus.com"))!)
                                {
                                    UIApplication.shared.openURL((URL(string: "https://www.triheartplus.com"))!)
                                }
                                
                            }
                            else
                            {
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
            let prefs = UserDefaults.standard
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BasicDetailView"), object: self, userInfo: ["ZeroBasicDetail": prefs.value(forKey: "PetName") ?? "","BasicDetailType": prefs.value(forKey: "PetType") ?? "" ])
        }
        else
        {
            galleryView.isHidden = true
            more.isSelected = false
            more.backgroundColor = UIColor.white
            more.setImage(UIImage(named: "tab_more"), for: .normal)
            backView.backgroundColor = UIColor(red: 6.0 / 255.0, green: 103.0 / 255.0, blue: 184.0 / 255.0, alpha: 1)
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
    }
    
    @objc func rightClk1(_ sender: Any) {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    func webServiceToGetpetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?PatientId=%@", API.Owner.PetList, userId)
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
                let queryDic = json?["PetsList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                if queryDic.count == 0
                {
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
                        let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetType"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["DateofBirth"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["ImagePath"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false, secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                        
                        
                        self.petModelList.append(MyPets!)
                    }
                    DispatchQueue.main.async
                        {
                            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                            for model in self.petModelList
                            {
                                if model.petId?.stringValue == petId
                                {
                                    self.petInfo = model
                                    self.prepareUI()
                                }
                            }
                            
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
    @objc func editPetDetails(_ sender: Any)
    {
        self.performSegue(withIdentifier: "editpet", sender: petInfo)
    }
    @objc func aMethod(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "editMedicalSummaryPet", sender: petInfo)
    }
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
            
        }
        else if indexPath.row == 1 {
            performSegue(withIdentifier: "showAdoption", sender: petInfo)
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "showInsurance", sender: petInfo)
        }
        
        menuTv.isHidden = true
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
        if (segue.identifier == "editpet")
        {
            let edit: AddEditPetViewController? = segue.destination as? AddEditPetViewController
            edit?.petInfo = sender as? MyPetsModel
            edit?.isFromVC = true
        }
        else if (segue.identifier == "showAdoption")
        {
            let adopt: AdoptionDetailsViewController? = segue.destination as? AdoptionDetailsViewController
            adopt?.petInfo = sender as? MyPetsModel
        }
        else if (segue.identifier == "showInsurance")
        {
            let insure: PetInsuranceListViewController? = segue.destination as? PetInsuranceListViewController
            insure?.petInfo = sender as? MyPetsModel
        }
        else if(segue.identifier == "editMedicalSummaryPet")
        {
            let edit: AddEditPetViewController? = segue.destination as? AddEditPetViewController
            edit?.petInfo = sender as? MyPetsModel
            edit?.isFromVC = true
            edit?.isFromMedical = true
        }
        
    }
    @IBAction func showTabs(_ item: UIButton)
    {
        if item.tag == 1 {
            print("Self")
        }
        else if item.tag == 2
        {
            let storyboard = UIStoryboard(name: "PHR", bundle: nil)
            if (self.petInfo?.canAccessMedRec)!
            {
                let medical: MedicalRecordsViewController = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as! MedicalRecordsViewController
                navigationController?.pushViewController(medical, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: nil, message: "Your membership does not include the medical records feature. To access it you need to upgrade your account to a premium or premium+ membership.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        else if item.tag == 3 {
            let details: VeterinarianListViewController = self.storyboard?.instantiateViewController(withIdentifier: "vetList") as! VeterinarianListViewController
            navigationController?.pushViewController(details, animated: true)
            
        }
        else if item.tag == 4 {
            let details: ContactListViewController = self.storyboard?.instantiateViewController(withIdentifier: "contactList") as! ContactListViewController
            navigationController?.pushViewController(details, animated: true)
            
        }
        else if item.tag == 5
        {
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
            let details: GalleryListViewController = storyboard?.instantiateViewController(withIdentifier: "photosList") as! GalleryListViewController
            navigationController?.pushViewController(details, animated: true)
            
        }
        else
        {
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
