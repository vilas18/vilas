//
//  SMOSetUpViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SMOSetUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var smoTitle: UITextField!
    @IBOutlet weak var smoPet: UITextField!
    @IBOutlet weak var smoDiag: UITextField!
    @IBOutlet weak var smoDateOn: UITextField!
    @IBOutlet weak var smoComments: UITextField!
    @IBOutlet weak var testList: UITableView!
    @IBOutlet weak var smoPetSympt1: UITextField!
    @IBOutlet weak var smoPetSympt2: UITextField!
    @IBOutlet weak var smoPetSympt3: UITextField!
    @IBOutlet weak var firstOpinion: UITextView!
    @IBOutlet weak var detailsOpinion: UITextView!
    @IBOutlet weak var reviewPet: UISwitch!
    @IBOutlet weak var agreeEC: UISwitch!
    var petListArray = [MyPetsModel]()
    var testListArray = [[String: Any]]()
    var commonTv: UIPickerView!
    
    var datePicker = UIDatePicker()
    @IBOutlet weak var mandatoryLbl: UILabel!
    
    @IBOutlet weak var steps: UISegmentedControl!
    @IBOutlet weak var testName: UITextField!
    @IBOutlet weak var testDate: UITextField!
    @IBOutlet weak var testClose: UIButton!
    @IBOutlet weak var testSubmit: UIButton!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var testsView: UIView!
    @IBOutlet weak var symptomsView: UIView!
    @IBOutlet weak var firstOpinionView: UIView!
    @IBOutlet weak var addTestView: UIView!
    @IBOutlet weak var conditionBot: NSLayoutConstraint!
    //201
    @IBOutlet weak var testsBot: NSLayoutConstraint!
    //190
    @IBOutlet weak var testViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addTestViewTop: NSLayoutConstraint!
    @IBOutlet weak var testListHeight: NSLayoutConstraint!
    @IBOutlet weak var symptomsBot: NSLayoutConstraint!
    //144
    @IBOutlet weak var firstOpinionBot: NSLayoutConstraint!
    //175
    @IBOutlet weak var condiBut: UIButton!
    @IBOutlet weak var testBut: UIButton!
    @IBOutlet weak var symptBut: UIButton!
    @IBOutlet weak var firstBut: UIButton!
    
    var reviewPetDetails: Bool = false
    var agreeTC: Bool = false
    var petId: String = ""
    var dropDownType: String = ""
    var selectedTxtFld: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height:220))
        commonTv.delegate = self
        commonTv.dataSource = self
        commonTv.tag = 1
        addTestView.isHidden = true
        conditionView.isHidden = false
        conditionBot.constant = 201
        condiBut.isSelected = true
        condiBut.setImage(UIImage(named: "minus_grey"), for: .selected)
        testsView.isHidden = true
        testsBot.constant = -1
        symptomsView.isHidden = true
        symptomsBot.constant = -1
        firstOpinionView.isHidden = true
        firstOpinionBot.constant = -1
        testList.isHidden = true
        
        
        mandatoryLbl.isHidden = true
        firstOpinion.delegate = self
        detailsOpinion.delegate = self
        smoTitle.delegate = self
        smoPet.delegate = self
        smoDiag.delegate = self
        smoDateOn.delegate = self
        smoComments.delegate = self
        testDate.delegate = self
        testName.delegate = self
        smoPetSympt1.delegate = self
        smoPetSympt2.delegate = self
        smoPetSympt3.delegate = self
        
        steps.isUserInteractionEnabled = true
        steps.selectedSegmentIndex = 0
        smoPet.isUserInteractionEnabled = true
        smoDateOn.isUserInteractionEnabled = true
        testDate.isUserInteractionEnabled = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        self.datePicker.maximumDate = Date()
        smoTitle.layer.masksToBounds = true
        smoTitle.layer.borderWidth = 2
        smoTitle.layer.cornerRadius = 3.0
        smoTitle.layer.borderColor = UIColor.clear.cgColor
        
        smoPet.layer.masksToBounds = true
        smoPet.layer.borderWidth = 2
        smoPet.layer.cornerRadius = 3.0
        smoPet.layer.borderColor = UIColor.clear.cgColor
        
        smoDiag.layer.masksToBounds = true
        smoDiag.layer.borderWidth = 2
        smoDiag.layer.cornerRadius = 3.0
        smoDiag.layer.borderColor = UIColor.clear.cgColor
        
        
        firstOpinion.layer.masksToBounds = true
        firstOpinion.layer.borderWidth = 2
        firstOpinion.layer.cornerRadius = 3.0
        firstOpinion.layer.borderColor = UIColor.clear.cgColor
        
        detailsOpinion.layer.masksToBounds = true
        detailsOpinion.layer.borderWidth = 2
        detailsOpinion.layer.cornerRadius = 3.0
        detailsOpinion.layer.borderColor = UIColor.clear.cgColor
        
        testName.layer.masksToBounds = true
        testName.layer.borderWidth = 2
        testName.layer.cornerRadius = 3.0
        testName.layer.borderColor = UIColor.clear.cgColor
        
        testDate.layer.masksToBounds = true
        testDate.layer.borderWidth = 2
        testDate.layer.cornerRadius = 3.0
        testDate.layer.borderColor = UIColor.clear.cgColor
        
        
        addTestView.layer.masksToBounds = true
        addTestView.layer.borderWidth = 1
        addTestView.layer.cornerRadius = 3.0
        addTestView.layer.borderColor = UIColor.lightGray.cgColor
        
        testClose.layer.masksToBounds = true
        testClose.layer.borderWidth = 1
        testClose.layer.cornerRadius = 3.0
        testClose.layer.borderColor = UIColor.lightGray.cgColor
        
        testSubmit.layer.masksToBounds = true
        testSubmit.layer.borderWidth = 1
        testSubmit.layer.cornerRadius = 3.0
        
        firstOpinion.text = "Enter details"
        firstOpinion.textColor = UIColor.lightGray
        
        detailsOpinion.text = "Enter question"
        detailsOpinion.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        smoTitle.resignFirstResponder()
        smoPet.resignFirstResponder()
        smoDiag.resignFirstResponder()
        smoDateOn.resignFirstResponder()
        smoComments.resignFirstResponder()
        smoPetSympt1.resignFirstResponder()
        smoPetSympt2.resignFirstResponder()
        smoPetSympt3.resignFirstResponder()
        firstOpinion.resignFirstResponder()
        detailsOpinion.resignFirstResponder()
        testName.resignFirstResponder()
        testName.resignFirstResponder()
        
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            print("Inside Setup view only....")
        case 1:
            smoTitle.resignFirstResponder()
            smoPet.resignFirstResponder()
            smoDiag.resignFirstResponder()
            smoDateOn.resignFirstResponder()
            smoComments.resignFirstResponder()
            smoPetSympt1.resignFirstResponder()
            smoPetSympt2.resignFirstResponder()
            smoPetSympt3.resignFirstResponder()
            firstOpinion.resignFirstResponder()
            detailsOpinion.resignFirstResponder()
            testName.resignFirstResponder()
            testName.resignFirstResponder()
            
            doValidationForSMOAdd()
        case 2:
            break
        default:
            break
        }
        
    }
    @IBAction func selectAgreeReviewPetDetails(_ sender: UISwitch)
    {
        if sender.tag == 1
        {
            if sender.isOn == true
            {
                reviewPetDetails = true
            }
            else
            {
                reviewPetDetails = false
            }
        }
        else if sender.tag == 2
        {
            if sender.isOn == true
            {
                agreeTC = true
            }
            else
            {
                agreeTC = false
            }
        }
        
    }
    func webServiceToGetpetList()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading Pet List", comment: "")
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?PatientId=%@", API.Owner.PetList, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                // check for http errors
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
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.commonTv.reloadAllComponents()
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
                                let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetType"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["PetBirthDate"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["PetImage"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false,secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                                
                                if MyPets?.isInSmo == "1"
                                {
                                    
                                }
                                else
                                {
                                    self.petListArray.append(MyPets!)
                                }
                            }
                            
                            self.commonTv.reloadAllComponents()
                            print(self.petListArray.count)
                            if self.petListArray.count > 0
                            {
                                self.commonTv.reloadAllComponents()
                            }
                            else
                            {
                                
                                self.smoPet.resignFirstResponder()
                                let alert = UIAlertController(title: nil, message: "No pets found", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: true)
                            }
                            
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
        return testListArray.count > 0 ? testListArray.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CommonTableViewCell
        let dict = testListArray[indexPath.row] //as? [AnyHashable: Any] ?? [AnyHashable: Any]()
        cell?.firstLabel?.text = dict["TestName"] as? String
        cell?.secLabel?.text = dict["TestDate"] as? String
        cell?.del?.addTarget(self, action: #selector(self.deleteTest), for: .touchUpInside)
        cell?.edit?.addTarget(self, action: #selector(self.editTest), for: .touchUpInside)
        
        return cell!
    }
    
    @objc func editTest(_ sender: UIButton)
    {
        let btnObj: UIButton = sender
        let center: CGPoint? = btnObj.center
        let rootViewPoint: CGPoint? = btnObj.superview?.convert(center!, to: testList)
        let indexPath: IndexPath? = testList.indexPathForRow(at: rootViewPoint!)
        print("indexPath on event list :\(String(describing: indexPath))")
        let dict = testListArray[(indexPath?.row)!] //as? [AnyHashable: Any] ?? [AnyHashable: Any]()
        if addTestView.isHidden == true
        {
            addTestView.isHidden = false
            testName.text = dict["TestName"] as? String
            testDate.text = dict["TestDate"] as? String
        }
    }
    @objc func deleteTest(_ sender: UIButton)
    {
        let btnObj: UIButton = sender
        let center: CGPoint? = btnObj.center
        let rootViewPoint: CGPoint? = btnObj.superview?.convert(center!, to: testList)
        let indexPath: IndexPath? = testList.indexPathForRow(at: rootViewPoint!)
        print("indexPath on event list :\(String(describing: indexPath))")
        let alert = UIAlertController(title: "Warning", message: "Do you really want to delete the test", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.testListArray.remove(at: (indexPath?.row)!)
            self.testList.reloadData()
            self.testListHeight.constant = CGFloat(self.testListArray.count * 69)
            self.testViewHeight.constant = CGFloat(self.testListArray.count * 69 + 53)
            self.testsBot.constant = CGFloat(self.testListArray.count * 69 + 53)+10
        })
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (dropDownType == "PetList")
        {
            let model = petListArray[indexPath.row]
            smoPet.text = model.petName
            petId = (model.petId!).stringValue
            self.smoPet.resignFirstResponder()
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.petListArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = petListArray[row]
        return model.petName
    }
    @IBAction func selectNextStep(_ sender: Any)
    {
        conditionBot.constant = -1
        testsBot.constant = -1
        symptomsBot.constant = -1
        firstOpinionBot.constant = -1
        conditionView.isHidden = true
        conditionBot.constant = -1
        condiBut.isSelected = false
        condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        testsView.isHidden = true
        testsBot.constant = -1
        testBut.isSelected = false
        testBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        symptomsView.isHidden = true
        symptomsBot.constant = -1
        symptBut.isSelected = false
        symptBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        firstOpinionView.isHidden = true
        firstOpinionBot.constant = -1
        firstBut.isSelected = false
        firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        smoTitle.resignFirstResponder()
        smoPet.resignFirstResponder()
        smoDiag.resignFirstResponder()
        smoDateOn.resignFirstResponder()
        smoComments.resignFirstResponder()
        smoPetSympt1.resignFirstResponder()
        smoPetSympt2.resignFirstResponder()
        smoPetSympt3.resignFirstResponder()
        firstOpinion.resignFirstResponder()
        detailsOpinion.resignFirstResponder()
        testName.resignFirstResponder()
        testName.resignFirstResponder()
        
        
        doValidationForSMOAdd()
    }
    func doValidationForSMOAdd()
    {
        if smoTitle.text == nil && smoPet.text == nil && smoDiag.text == nil && firstOpinion.text == nil && detailsOpinion.text == nil && reviewPetDetails == false && agreeTC == false && (smoTitle.text == "") && (smoPet.text == "") && (smoDiag.text == "") && (firstOpinion.text == "") && (detailsOpinion.text == "") && (reviewPetDetails == nil) && (agreeTC == nil) {
            mandatoryLbl.isHidden = false
            smoTitle.layer.borderColor = UIColor.red.cgColor
            smoPet.layer.borderColor = UIColor.red.cgColor
            smoDiag.layer.borderColor = UIColor.red.cgColor
            firstOpinion.layer.borderColor = UIColor.red.cgColor
            detailsOpinion.layer.borderColor = UIColor.red.cgColor
        }
        if smoTitle.text == nil || (smoTitle.text == "")
        {
            smoTitle.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        
        if smoPet.text == nil || (smoPet.text == "") {
            smoPet.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            smoPet.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if smoDiag.text == nil || (smoDiag.text == "") {
            smoDiag.layer.borderColor = UIColor.red.cgColor
            conditionBot.constant = 201
            conditionView.isHidden = false
            condiBut.isSelected = true
            condiBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            mandatoryLbl.isHidden = false
        }
        else {
            smoDiag.layer.borderColor = UIColor.clear.cgColor
            conditionBot.constant = -1
            conditionView.isHidden = true
            condiBut.isSelected = false
            condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            mandatoryLbl.isHidden = false
        }
        if firstOpinion.text == nil || (firstOpinion.text == "Enter details") || (firstOpinion.text == "") {
            firstOpinion.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
            firstOpinionBot.constant = 175
            firstBut.isSelected = true
            firstBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            firstOpinionView.isHidden = false
        }
        else {
            firstOpinion.layer.borderColor = UIColor.clear.cgColor
            firstOpinionBot.constant = -1
            firstOpinionView.isHidden = true
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            mandatoryLbl.isHidden = false
        }
        if detailsOpinion.text == nil || (detailsOpinion.text == "Enter question") || (detailsOpinion.text == "") {
            detailsOpinion.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
            firstOpinionBot.constant = 175
            firstBut.isSelected = true
            firstBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            firstOpinionView.isHidden = false
        }
        else {
            detailsOpinion.layer.borderColor = UIColor.clear.cgColor
            firstOpinionBot.constant = -1
            firstOpinionView.isHidden = true
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            mandatoryLbl.isHidden = false
        }
        if reviewPetDetails == nil || (reviewPetDetails == false)
        {
            let alert = UIAlertController(title: "Warning", message: "Please confirm that pet details are correct", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        if agreeTC == nil || (agreeTC == false)
        {
            let alert = UIAlertController(title: "Warning", message: "Please agree the Terms and Conditions", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        
        if !(smoTitle.text == nil) && !(smoPet.text == nil) && !(smoDiag.text == nil) && !(firstOpinion.text == nil) && !(detailsOpinion.text == nil) && !(reviewPetDetails == nil) && !(agreeTC == nil) && !(smoTitle.text == "") && !(smoPet.text == "") && !(smoDiag.text == "") && !(firstOpinion.text == "") && !(detailsOpinion.text == "") && !(reviewPetDetails == false) && !(agreeTC == false) {
            mandatoryLbl.isHidden = true
            
            let prefs = UserDefaults.standard
            prefs.set(self.smoPet.text, forKey: "SMOPet")
            prefs.set(self.petId, forKey: "SMOPetId")
            prefs.set(self.smoTitle.text, forKey: "SMOTitle")
            prefs.set(self.smoDiag.text, forKey: "SMODiag")
            prefs.set(self.smoDateOn.text, forKey: "SMODateOn")
            prefs.set(self.smoComments.text, forKey: "SMOComments")
            if self.testListArray.count > 0
            {
                prefs.set(self.testListArray, forKey: "SMOTestList")
            }
            else
            {
                prefs.set("null", forKey: "SMOTestList")
            }
            
            prefs.set(self.firstOpinion.text, forKey: "SMOFirst")
            prefs.set(self.detailsOpinion.text, forKey: "SMODetails")
            prefs.set(self.smoPetSympt1.text, forKey: "SMOPetSymp1")
            prefs.set(self.smoPetSympt2.text, forKey: "SMOPetSymp2")
            prefs.set(self.smoPetSympt3.text, forKey: "SMOPetSymp3")
            
            prefs.set(reviewPetDetails, forKey: "AuthorizeVet")
            prefs.set(agreeTC, forKey: "Agree")
            
            prefs.synchronize()
            
            performSegue(withIdentifier: "BillingInfo", sender: nil)
        }
        else
        {
            steps.selectedSegmentIndex = 0
        }
        
        
    }
    @IBAction func enterConditions(_ sender: UIButton)
    {
        if conditionView.isHidden == true
        {
            condiBut.isSelected = true
            condiBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            conditionView.isHidden = false
            conditionBot.constant = 201
            testsView.isHidden = true
            testsBot.constant = -1
            testBut.isSelected = false
            testBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            symptomsView.isHidden = true
            symptomsBot.constant = -1
            symptBut.isSelected = false
            symptBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            firstOpinionView.isHidden = true
            firstOpinionBot.constant = -1
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        }
        else {
            conditionView.isHidden = true
            conditionBot.constant = -1
            condiBut.isSelected = false
            condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        }
    }
    @IBAction func enterTests(_ sender: UIButton)
    {
        if testsView.isHidden == true
        {
            testsView.isHidden = false
            testsBot.constant = 190
            testBut.isSelected = true
            testBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            conditionView.isHidden = true
            conditionBot.constant = -1
            condiBut.isSelected = false
            condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            symptomsView.isHidden = true
            symptomsBot.constant = -1
            symptBut.isSelected = false
            symptBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            firstOpinionView.isHidden = true
            firstOpinionBot.constant = -1
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            testViewHeight.constant = CGFloat(testListArray.count * 80 + 58)
            testsBot.constant = CGFloat(testListArray.count * 80 + 58)
            testListHeight.constant = CGFloat(testListArray.count * 69)
        }
        else{
            testsView.isHidden = true
            testsBot.constant = -1
            testBut.isSelected = false
            testBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        }
    }
    
    @IBAction func addTests(_ sender: UIButton)
    {
        addTestViewTop.constant = 100
        testName.text = ""
        testDate.text = ""
        if addTestView.isHidden == true {
            addTestView.isHidden = false
        }
        else {
            addTestView.isHidden = true
        }
    }
    @IBAction func enterSymptoms(_ sender: UIButton)
    {
        if symptomsView.isHidden == true
        {
            testsView.isHidden = true
            testsBot.constant = -1
            testBut.isSelected = false
            testBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            conditionView.isHidden = true
            conditionBot.constant = -1
            condiBut.isSelected = false
            condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            symptomsView.isHidden = false
            symptomsBot.constant = 144
            symptBut.isSelected = true
            symptBut.setImage(UIImage(named: "minus_grey"), for: .selected)
            firstOpinionView.isHidden = true
            firstOpinionBot.constant = -1
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        }
        else
        {
            symptomsView.isHidden = true
            symptomsBot.constant = -1
            symptBut.isSelected = false
            symptBut.setImage(UIImage(named: "plus_grey"), for: .normal)
        }
    }
    @IBAction func enterFirstOpinion(_ sender: UIButton)
    {
        if firstOpinionView.isHidden == true {
            testsView.isHidden = true
            testsBot.constant = -1
            testBut.isSelected = false
            testBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            conditionView.isHidden = true
            conditionBot.constant = -1
            condiBut.isSelected = false
            condiBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            symptomsView.isHidden = true
            symptomsBot.constant = -1
            symptBut.isSelected = false
            symptBut.setImage(UIImage(named: "plus_grey"), for: .normal)
            firstOpinionView.isHidden = false
            firstOpinionBot.constant = 175
            firstBut.isSelected = true
            firstBut.setImage(UIImage(named: "minus_grey"), for: .selected)
        }
        else
        {
            firstOpinionView.isHidden = true
            firstOpinionBot.constant = -1
            firstBut.isSelected = false
            firstBut.setImage(UIImage(named: "plus_grey"), for: .normal)        }
    }
    @IBAction func submitTests(_ sender: UIButton)
    {
        testName.resignFirstResponder()
        testName.resignFirstResponder()
        
        if testName.text == nil && testDate.text == nil && (testName.text == "") && (testDate.text == "")
        {
            testName.layer.borderColor = UIColor.red.cgColor
            testDate.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: "Warning", message: "Please enter test name and test date", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        if testName.text == nil || (testName.text == "")
        {
            testName.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: "Warning", message: "Please enter test name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
        else
        {
            testName.layer.borderColor = UIColor.clear.cgColor
        }
        if testDate.text == nil || (testDate.text == "")
        {
            testDate.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: "Warning", message: "Please enter test date", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true) 
        }
        else
        {
            testDate.layer.borderColor = UIColor.clear.cgColor
        }
        if !(testName.text == nil) && !(testDate.text == nil) && !(testName.text == "") && !(testDate.text == "")
        {
            testName.layer.borderColor = UIColor.clear.cgColor
            testDate.layer.borderColor = UIColor.clear.cgColor
            addTestView.isHidden = true
            let dict: [String: String] = [
                "TestName" : testName.text! ,
                "TestDate" : testDate.text!
            ]
            
            if testListArray.count == 0
            {
                testListArray = [[String : Any]]()
                testListArray.append(dict )
                testList.isHidden = false
                testList.reloadData()
                testViewHeight.constant = CGFloat(testListArray.count * 90 + 58)
                testsBot.constant = CGFloat(testListArray.count * 80 + 53)
                testListHeight.constant = CGFloat(testListArray.count * 69)
            }
            else {
                testListArray.append(dict)
                testList.isHidden = false
                testList.reloadData()
                testViewHeight.constant = CGFloat(testListArray.count * 80 + 58)
                testsBot.constant = CGFloat(testListArray.count * 80 + 58)
                testListHeight.constant = CGFloat(testListArray.count * 69)
            }
            addTestView.isHidden = true
        }
    }
    @IBAction func closeAddtestView(_ sender: UIButton)
    {
        testName.text = ""
        testDate.text = ""
        addTestView.isHidden = true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == firstOpinion {
            firstOpinion.text = ""
            firstOpinion.textColor = UIColor.black
        }
        else if textView == detailsOpinion {
            detailsOpinion.text = ""
            detailsOpinion.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if firstOpinion.text.count == 0
        {
            firstOpinion.textColor = UIColor.lightGray
            firstOpinion.text = "Enter details"
            firstOpinion.resignFirstResponder()
        }
        else if detailsOpinion.text.count == 0
        {
            detailsOpinion.textColor = UIColor.lightGray
            detailsOpinion.text = "Enter question"
            detailsOpinion.resignFirstResponder()
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.smoPet
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.smoDateOn || textField == self.testDate
        {
            self.selectedTxtFld = textField
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.datePicker.maximumDate = Date()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donedatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = datePicker
        }
        else if textField == self.smoPet
        {
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
    }
    @objc func doneDropDownSelection()
    {
        if petListArray.count > 0
        {
            let model = self.petListArray[self.commonTv.selectedRow(inComponent: 0)]
            self.smoPet.text = model.petName
            self.petId = (model.petId?.stringValue)!
            self.smoPet?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.smoPet?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.smoPet?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.selectedTxtFld?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.selectedTxtFld?.resignFirstResponder()
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
