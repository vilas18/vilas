//
//  ECSetUpViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ECSetUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var ecPet: UITextField!
    @IBOutlet weak var ecCountry: UITextField!
    @IBOutlet weak var ecTimeZone: UITextField!
    @IBOutlet weak var ecDate: UITextField!
    @IBOutlet weak var ecTime: UITextField!
    @IBOutlet weak var ecContactType: UITextField!
    @IBOutlet weak var ecPetCond: UITextField!
    @IBOutlet weak var ecPetSympt1: UITextField!
    @IBOutlet weak var ecPetSympt2: UITextField!
    @IBOutlet weak var ecPetSympt3: UITextField!
    @IBOutlet weak var ecPetVet: UITextField!
    @IBOutlet weak var reviewPet: UISwitch!
    @IBOutlet weak var agreeEC: UISwitch!
    var petListArray = [MyPetsModel]()
    var vetListArray = [Any]()
    var commonTv: UIPickerView!
    var txtFld:UITextField?
    
    var datePicker = UIDatePicker()
    @IBOutlet weak var mandatoryLbl: UILabel!
    @IBOutlet weak var steps: UISegmentedControl!
    @IBOutlet weak var emailPhone: UITextField!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    var filterArr = [Any]()
    var listArr = [Any]()
    var dropDownType: String = ""
    var petId: String = ""
    var countryId: String = ""
    var vetId: String = ""
    var timezoneId: String = ""
    var contactId: String = ""
    var reviewPetDetails: String = ""
    var agreeTC: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.commonTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        commonTv.delegate = self
        commonTv.dataSource = self
        mandatoryLbl.isHidden = true
        datePicker.minimumDate = Date()
        reviewPet.isOn = false
        steps.isUserInteractionEnabled = true
        steps.selectedSegmentIndex = 0
        topSpace.constant = -1
        emailPhone.isHidden = true
        ecDate.isUserInteractionEnabled = true
        ecTime.isUserInteractionEnabled = true
        ecPet.isUserInteractionEnabled = true
        ecCountry.isUserInteractionEnabled = true
        ecTimeZone.isUserInteractionEnabled = true
        ecContactType.isUserInteractionEnabled = true
        ecPetVet.isUserInteractionEnabled = true
        reviewPetDetails = "false"
        agreeTC = "false"
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        
        ecPet.layer.masksToBounds = true
        ecPet.layer.borderWidth = 2
        ecPet.layer.cornerRadius = 3.0
        ecPet.layer.borderColor = UIColor.clear.cgColor
        
        ecCountry.layer.masksToBounds = true
        ecCountry.layer.borderWidth = 2
        ecCountry.layer.cornerRadius = 3.0
        ecCountry.layer.borderColor = UIColor.clear.cgColor
        
        ecTimeZone.layer.masksToBounds = true
        ecTimeZone.layer.borderWidth = 2
        ecTimeZone.layer.cornerRadius = 3.0
        ecTimeZone.layer.borderColor = UIColor.clear.cgColor
        
        ecDate.layer.masksToBounds = true
        ecDate.layer.borderWidth = 2
        ecDate.layer.cornerRadius = 3.0
        ecDate.layer.borderColor = UIColor.clear.cgColor
        
        ecTime.layer.masksToBounds = true
        ecTime.layer.borderWidth = 2
        ecTime.layer.cornerRadius = 3.0
        ecTime.layer.borderColor = UIColor.clear.cgColor
        
        ecPetCond.layer.masksToBounds = true
        ecPetCond.layer.borderWidth = 2
        ecPetCond.layer.cornerRadius = 3.0
        ecPetCond.layer.borderColor = UIColor.clear.cgColor
        
        ecPetVet.layer.masksToBounds = true
        ecPetVet.layer.borderWidth = 2
        ecPetVet.layer.cornerRadius = 3.0
        ecPetVet.layer.borderColor = UIColor.clear.cgColor
        
        emailPhone.layer.masksToBounds = true
        emailPhone.layer.borderWidth = 2
        emailPhone.layer.cornerRadius = 3.0
        emailPhone.layer.borderColor = UIColor.clear.cgColor
        
        
        self.countryId = "3"
        self.ecCountry.text = "United States"
        self.ecTimeZone.text = "(UTC-05:00) Eastern Time (US & Canada)"
        self.timezoneId = "15"
        //        "Id": 15,
        //        "Name": "(UTC-05:00) Eastern Time (US & Canada)",
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        ecPet.resignFirstResponder()
        ecCountry.resignFirstResponder()
        ecTimeZone.resignFirstResponder()
        ecDate.resignFirstResponder()
        ecTime.resignFirstResponder()
        ecContactType.resignFirstResponder()
        ecPetCond.resignFirstResponder()
        ecPetSympt1.resignFirstResponder()
        ecPetSympt2.resignFirstResponder()
        ecPetSympt3.resignFirstResponder()
        ecPetVet.resignFirstResponder()
        
    }
    @IBAction func selectSegment(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Inside Setup view only....")
        case 1:
            ecPet.resignFirstResponder()
            ecCountry.resignFirstResponder()
            ecTimeZone.resignFirstResponder()
            ecDate.resignFirstResponder()
            ecTime.resignFirstResponder()
            ecContactType.resignFirstResponder()
            ecPetCond.resignFirstResponder()
            ecPetSympt1.resignFirstResponder()
            ecPetSympt2.resignFirstResponder()
            ecPetSympt3.resignFirstResponder()
            ecPetVet.resignFirstResponder()
            doValidationForEcAdd()
        case 2:
            break
        default:
            break
        }
        
    }
    @IBAction func selectAgreeReviewPetDetails(_ sender: UISwitch) {
        if sender.tag == 1 {
            if sender.isOn == true {
                reviewPetDetails = "true"
            }
            else {
                reviewPetDetails = "false"
            }
        }
        else if sender.tag == 2 {
            if sender.isOn == true {
                agreeTC = "true"
            }
            else {
                agreeTC = "false"
            }
        }
        
    }
    func webServiceToGetpetList()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var urlStr: String = ""
        self.petListArray = []
        self.vetListArray = []
        if (dropDownType == "PetList") {
            urlStr = "\(API.Owner.PetList)?PatientId=\(userId)"
        }
        else if (dropDownType == "VetList") {
            urlStr = "\(API.Pet.VetList)?OwnerId=\(userId)"
        }
        //let urlStr = String(format : "%@?PatientId=%@", API.Pet.PetList, userId)
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
            if self.dropDownType == "PetList"
            {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let queryDic = json?["PetsList"] as? [[String : Any]]
                {
                    var filtered = [[String : Any]]()
                    if queryDic.count == 0
                    {
                        self.commonTv.reloadAllComponents()
                        self.ecPet.resignFirstResponder()
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
                            let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetType"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["PetBirthDate"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["PetImage"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false, secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                            
                            
                            self.petListArray.append(MyPets!)
                        }
                        DispatchQueue.main.async
                            {
                                self.commonTv.reloadAllComponents()
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                        }
                    }
                }
            }
            else
            {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let queryDic = json?["ExpertList"] as? [[String : Any]]
                {
                    var filtered = [[String : Any]]()
                    DispatchQueue.main.async
                        {
                            if queryDic.count == 0
                            {
                                self.commonTv.reloadAllComponents()
                                self.ecPetVet.resignFirstResponder()
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alert = UIAlertController(title: nil, message: "No veterinarians found", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true)
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
                                
                                if queryDic.count > 0
                                {
                                    self.vetListArray = filtered
                                    self.commonTv.reloadAllComponents()
                                    
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                                else
                                {
                                    self.ecPetVet.resignFirstResponder()
                                    let alert = UIAlertController(title: nil, message: "No veterinarians found", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(ok)
                                    self.present(alert, animated: true)
                                }
                                
                            }
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            RestClient.getList(dropDownType, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = []
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    
                    for dict in detailsArr
                    {
                        if (self.dropDownType == "Country") {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "TimeZone")
                        {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "EConsultationContactType")
                        {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                    }
                    self.commonTv?.reloadAllComponents()
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (dropDownType == "PetList")
        {
            return petListArray.count > 0 ? petListArray.count :0
        }
        else if (dropDownType == "VetList")
        {
            return vetListArray.count > 0 ? vetListArray.count:0
        }
        
        return listArr.count > 0 ? listArr.count : 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (dropDownType == "PetList")
        {
            let model = petListArray[row]
            return model.petName
        }
        else if (dropDownType == "VetList")
        {
            let dict = vetListArray[row] as! [String: Any]
            return String(format: "%@ %@",(dict["FirstName"])! as! CVarArg,(dict["LastName"])! as! CVarArg)
        }
        else
        {
            let model = listArr[row] as? CommonResponseModel
            return model?.paramName
        }
    }
    @IBAction func selectNextStep(_ sender: Any)
    {
        ecPet.resignFirstResponder()
        ecCountry.resignFirstResponder()
        ecTimeZone.resignFirstResponder()
        ecDate.resignFirstResponder()
        ecTime.resignFirstResponder()
        ecContactType.resignFirstResponder()
        ecPetCond.resignFirstResponder()
        ecPetSympt1.resignFirstResponder()
        ecPetSympt2.resignFirstResponder()
        ecPetSympt3.resignFirstResponder()
        ecPetVet.resignFirstResponder()
        
        if self.ecContactType.text == "Phone"
        {
            if emailPhone.text?.count == 0
            {
                print("Nmber is correct...")
            }
            else
            {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: emailPhone.text) == false
                {
                    emailPhone.layer.borderColor = UIColor.red.cgColor
                }
                else
                {
                    emailPhone.layer.borderColor = UIColor.clear.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if self.ecContactType.text == "Email"
        {
            if emailPhone.text?.count == 0
            {
                print("Nmber is correct...")
            }
            else
            {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                
                if emailTest.evaluate(with: emailPhone?.text) == false
                {
                    emailPhone.layer.borderColor = UIColor.red.cgColor
                }
                else
                {
                    emailPhone.layer.borderColor = UIColor.clear.cgColor
                    print("email is correct...")
                }
            }
        }
        
        doValidationForEcAdd()
    }
    func doValidationForEcAdd()
    {
        if ecPet.text == nil && ecCountry.text == nil && ecTimeZone.text == nil && ecDate.text == nil && ecTime.text == nil && ecPetCond.text == nil && ecPetVet.text == nil && reviewPetDetails == "" && agreeTC == "" && (ecPet.text == "") && (ecCountry.text == "") && (ecTimeZone.text == "") && (ecDate.text == "") && (ecTime.text == "") && (ecPetCond.text == "") && (ecPetVet.text == "") && (reviewPetDetails == "false") && (agreeTC == "")
        {
            mandatoryLbl.isHidden = false
            ecPet.layer.borderColor = UIColor.red.cgColor
            ecCountry.layer.borderColor = UIColor.red.cgColor
            ecTimeZone.layer.borderColor = UIColor.red.cgColor
            ecDate.layer.borderColor = UIColor.red.cgColor
            ecTime.layer.borderColor = UIColor.red.cgColor
            ecPetCond.layer.borderColor = UIColor.red.cgColor
            ecPetVet.layer.borderColor = UIColor.red.cgColor
            
            let alert = UIAlertController(title: "Warning", message: "Please confirm that pet details are correct and agree Terms and Conditions", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        if ecPet.text == nil || (ecPet.text == "") {
            ecPet.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecPet.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecCountry.text == nil || (ecCountry.text == "") {
            ecCountry.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecCountry.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecTimeZone.text == nil || (ecTimeZone.text == "") {
            ecTimeZone.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecTimeZone.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecDate.text == nil || (ecDate.text == "") {
            ecDate.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecDate.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecTime.text == nil || (ecTime.text == "") {
            ecTime.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecTime.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecPetCond.text == nil || (ecPetCond.text == "") {
            ecPetCond.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecPetCond.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if ecPetVet.text == nil || (ecPetVet.text == "") {
            ecPetVet.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            ecPetVet.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if reviewPetDetails == "" || (reviewPetDetails == "false") {
            let alert = UIAlertController(title: "Warning", message: "Please confirm that pet details are correct", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        if agreeTC == "" || (agreeTC == "false") {
            let alert = UIAlertController(title: "Warning", message: "Please agree the Terms and Conditions", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true) 
        }
        
        if !(ecPet.text == nil) && !(ecCountry.text == nil) && !(ecTimeZone.text == nil) && !(ecDate.text == nil) && !(ecTime.text == nil) && !(ecPetCond.text == nil) && !(ecPetVet.text == nil) && !(reviewPetDetails == "") && !(agreeTC == "") && !(ecPet.text == "") && !(ecCountry.text == "") && !(ecTimeZone.text == "") && !(ecDate.text == "") && !(ecTime.text == "") && !(ecPetCond.text == "") && !(ecPetVet.text == "") && !(reviewPetDetails == "false") && !(agreeTC == "false") {
            mandatoryLbl.isHidden = true
            let prefs = UserDefaults.standard
            prefs.set(self.ecPet.text, forKey: "ECPet")
            prefs.set(self.petId, forKey: "ECPetId")
            prefs.set(self.vetId, forKey: "ECVetId")
            prefs.set(self.ecPetVet.text, forKey: "ECVetName")
            prefs.set(self.ecTimeZone.text, forKey: "ECTimeZone")
            prefs.set(self.timezoneId, forKey: "ECTimeZoneId")
            prefs.set(self.ecDate.text, forKey: "ECDate")
            prefs.set(self.ecTime.text, forKey: "ECTime")
            prefs.set(self.ecContactType.text, forKey: "ECContactType")
            prefs.set(self.emailPhone.text, forKey: "ECContactValue")
            prefs.set(self.ecPetCond.text, forKey: "ECPetCondition")
            prefs.set(self.ecPetSympt1.text, forKey: "ECPetSymp1")
            prefs.set(self.ecPetSympt2.text, forKey: "ECPetSymp2")
            prefs.set(self.ecPetSympt3.text, forKey: "ECPetSymp3")
            prefs.set(self.countryId, forKey: "ECCountryId")
            
            prefs.synchronize()
            
            
            performSegue(withIdentifier: "BillingInfo", sender: nil)
        }
        else
        {
            steps.selectedSegmentIndex = 0
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.ecPet || textField == self.ecCountry || textField == self.ecTimeZone || textField == self.ecPetVet || textField == self.ecContactType
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.ecDate
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donedatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            ecDate.inputAccessoryView = toolbar
            ecDate.inputView = datePicker
        }
        else if textField == self.ecTime
        {
            self.datePicker.datePickerMode = UIDatePickerMode.time
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneTimePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelTimePicker))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            ecTime.inputAccessoryView = toolbar
            ecTime.inputView = datePicker
        }
        else if textField == ecPet
        {
            self.txtFld = textField
            dropDownType = "PetList"
            self.petListArray = []
            self.commonTv.reloadAllComponents()
            webServiceToGetpetList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = commonTv
        }
        else if textField == ecCountry
        {
            self.txtFld = textField
            dropDownType = "Country"
            self.listArr = []
            self.commonTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = commonTv
        }
        else if textField == ecTimeZone
        {
            self.txtFld = textField
            dropDownType = "TimeZone"
            self.listArr = []
            self.commonTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = commonTv
        }
        else if textField == ecPetVet
        {
            self.txtFld = textField
            dropDownType = "VetList"
            self.vetListArray = []
            self.commonTv.reloadAllComponents()
            webServiceToGetpetList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = commonTv
        }
        else if textField == ecContactType
        {
            dropDownType = "EConsultationContactType"
            self.listArr = []
            self.commonTv.reloadAllComponents()
            getList()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = commonTv
        }
    }
    @objc func doneDropDownSelection()
    {
        if (dropDownType == "Country")
        {
            let model = listArr[commonTv.selectedRow(inComponent: 0)] as? CommonResponseModel
            ecCountry.text = model?.paramName
            countryId = (model?.paramID)!
        }
        else if (dropDownType == "PetList")
        {
            let test = petListArray[commonTv.selectedRow(inComponent: 0)]
            ecPet.text = test.petName
            petId = (test.petId)!.stringValue
        }
        else if (dropDownType == "TimeZone")
        {
            let model = listArr[commonTv.selectedRow(inComponent: 0)] as? CommonResponseModel
            ecTimeZone.text = model?.paramName
            timezoneId = (model?.paramID)!
        }
        else if (dropDownType == "EConsultationContactType")
        {
            let model = listArr[commonTv.selectedRow(inComponent: 0)] as? CommonResponseModel
            ecContactType.text = model?.paramName
            contactId = (model?.paramID)!
            topSpace.constant = 45
            emailPhone.isHidden = false
            if (ecContactType.text == "Phone")
            {
                emailPhone.placeholder = "Enter Phone number"
            }
            else {
                emailPhone.placeholder = "Enter Email"
            }
        }
        else if (dropDownType == "VetList")
        {
            var dict = vetListArray[commonTv.selectedRow(inComponent: 0)] as! [String: Any]
            ecPetVet.text = String(format: "%@ %@",(dict["FirstName"])! as! CVarArg,(dict["LastName"])! as! CVarArg  ) //"\(String(describing: )) \(String(describing: ))"
            vetId = (dict["Id"] as! NSNumber).stringValue
        }
        self.txtFld?.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.txtFld?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        ecDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.ecDate.resignFirstResponder()
    }
    @objc func doneTimePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        ecTime.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker()
    {
        self.view.endEditing(true)
        self.ecTime.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.emailPhone
        {
            if (ecContactType.text == "Phone")
            {
                if textField.text?.count == 0
                {
                    print("Nmber is correct...")
                }
                else
                {
                    let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                    if numberTest.evaluate(with: textField.text) == false
                    {
                        textField.layer.borderColor = UIColor.red.cgColor
                    }
                    else
                    {
                        textField.layer.borderColor = UIColor.clear.cgColor
                        print("Nmber is correct...")
                    }
                }
            }
            else
            {
                if textField.text?.count == 0
                {
                    print("email is correct...")
                }
                else
                {
                    let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                    
                    if emailTest.evaluate(with: emailPhone?.text) == false
                    {
                        textField.layer.borderColor = UIColor.red.cgColor
                    }
                    else
                    {
                        textField.layer.borderColor = UIColor.clear.cgColor
                        print("email is correct...")
                    }
                }
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == emailPhone
        {
            if (ecContactType.text == "Phone")
            {
                let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
        }
        if textField == emailPhone
        {
            if (ecContactType.text == "Phone")
            {
                let cs = NSCharacterSet(charactersIn: API.Login.ACCEPTABLE_CHARACTERS).inverted;
                let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                return (string == filtered)
            }
        }
        return true
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool
    {
        
        if string == ""
        { //BackSpace
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                self.emailPhone?.text = "(" + (self.emailPhone?.text)!
            }
            
        }else if str!.count == 5{
            
            self.emailPhone?.text = (self.emailPhone?.text!)! + ") "
            
        }else if str!.count == 10{
            
            self.emailPhone?.text = (self.emailPhone?.text!)! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func showTerms(_ sender: UIButton)
    {
        let termsCond: TermsAndConditionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TandC") as! TermsAndConditionsViewController
        termsCond.isFromVC = true
        
        termsCond.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(termsCond, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
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
