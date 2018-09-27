//
//  SelectPetVetOnCallViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 17/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectPetVetOnCallViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITextViewDelegate
{
    @IBOutlet weak var dateTime: UITextField!
    @IBOutlet weak var healthCondition: UITextView!
    @IBOutlet weak var petList: UICollectionView!
    @IBOutlet weak var timeList: UICollectionView!
    var slotList = [[String: String]]()
    var petModelList=[MyPetsModel]()
    var petId: NSNumber = 0
    var petName: String = ""
    var petType: String = ""
    var petImageUrl: String = ""
    var selectedDate: String = ""
    var selectedTime:String = ""
    var datePicker = UIDatePicker()
    var vetOnCallPrice: String = ""
    var selectedIndex:IndexPath? = nil
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        
        dateTime.layer.masksToBounds = true
        dateTime.layer.borderWidth = 2
        dateTime.layer.cornerRadius = 3.0
        dateTime.layer.borderColor = UIColor.clear.cgColor
        
        self.healthCondition.layer.masksToBounds = true
        self.healthCondition.layer.borderWidth = 2.0
        self.healthCondition.layer.borderColor = UIColor.lightGray.cgColor
        self.healthCondition.layer.cornerRadius = 10
        self.healthCondition.text = "Describe the symptoms or issues with your pet.."
        healthCondition.textColor = UIColor.lightGray
        
        self.timeList.allowsMultipleSelection = false
        
        self.timeHeight.constant = 0
        self.petModelList = []
        self.webServiceToGetpetList()
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        dateTime.resignFirstResponder()
        healthCondition.resignFirstResponder()
    }
    @IBAction func showTermsAndConditions(_ sender: UIButton)
    {
        let termsCond: TermsAndConditionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TandC") as! TermsAndConditionsViewController
        termsCond.isFromVetOnCall = true
        
        termsCond.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(termsCond, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.petList
        {
            return petModelList.count
        }
        else
        {
            return slotList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == petList
        {
            let cell = collectionView.cellForItem(at: indexPath) as? MainGalleryCell
            cell?.petImage.layer.borderWidth = 3.0
            cell?.petImage.layer.borderColor = UIColor.green.cgColor
            cell?.petImage.layer.cornerRadius = 40
            let model = self.petModelList[indexPath.row]
            self.petId = model.petId!
            self.petName = model.petName!
            self.petType = model.petType!
            self.petImageUrl = model.imagePath!
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as? MainGalleryCell
            cell?.backgroundColor = UIColor.green
            let dict:[String: String] = slotList[indexPath.row]
            selectedTime = dict["Time"]!
            print(selectedTime)
            self.selectedIndex = indexPath
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if collectionView == self.petList
        {
            let cell = collectionView.cellForItem(at: indexPath) as? MainGalleryCell
            cell?.petImage.layer.borderWidth = 3.0
            cell?.petImage.layer.borderColor = UIColor.clear.cgColor
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as? MainGalleryCell
            cell?.backgroundColor = UIColor.white
            self.selectedIndex = nil
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == petList
        {
            let cell = petList.dequeueReusableCell(withReuseIdentifier: "PetList", for :indexPath) as! MainGalleryCell
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0
            let model = petModelList[indexPath.row]
            cell.albumName.text = model.petName
            cell.petImage.layer.borderWidth = 3.0
            cell.petImage.layer.borderColor = UIColor.clear.cgColor
            cell.petImage.layer.cornerRadius = 40
            cell.petImage.imageFromServerURL(urlString: (model.imagePath)!, defaultImage: "petImage-default.png")
            cell.tag = model.petId as! Int
            return cell
        }
        else
        {
            let cell = timeList.dequeueReusableCell(withReuseIdentifier: "TimeSlot", for :indexPath) as! MainGalleryCell
            if selectedIndex != nil && indexPath == self.selectedIndex
            {
                cell.backgroundColor = UIColor.green
            }
            else{
                cell.backgroundColor = UIColor.white
            }
            let dict:[String: String] = slotList[indexPath.row]
            cell.albumName.text = dict["Time"]
            
            return cell
        }
    }
    
    func webServiceToGetpetList()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading Pet list", comment: "")
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
                                        else
                                        {
                                            prunedDictionary[key] = ""
                                        }
                                    }
                                    print(prunedDictionary)
                                    filtered.append(prunedDictionary)
                                }
                                for item in filtered
                                {
                                    let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : (item["PetType"] as? String)!, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["DateofBirth"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["ImagePath"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false,secColor : item["SecondaryColor"] as? String, canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                                    self.petModelList.append(MyPets!)
                                }
                                self.petList.reloadData()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        let view = UIView()
        textField.inputView = view
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.minimumDate = Date()
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
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.dateTime?.text = formatter.string(from: datePicker.date)
        dateTime.resignFirstResponder()
        self.webServiceToGetTimeSlots()
        self.selectedIndex = nil
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.dateTime?.resignFirstResponder()
    }
    func webServiceToGetTimeSlots()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading Time slot list", comment: "")
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@&SelectDate=%@", API.VetOnCall.TimeSlotList, userId,self.dateTime.text!)
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
                let queryDic = json?["timeSlotList"] as? [[String : Any]]
            {
                var filtered = [[String : String]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.timeList.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            for item in queryDic
                            {
                                var prunedDictionary = [String: String]()
                                for key: String in item.keys
                                {
                                    if !(item[key] is NSNull) {
                                        prunedDictionary[key] = item[key] as? String
                                    }
                                    else {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            self.slotList = filtered
                        }
                        if self.slotList.count > 0
                        {
                            self.timeList.reloadData()
                            self.timeHeight.constant = 156
                        }
                        else
                        {
                            self.timeHeight.constant = 0
                            let alert = UIAlertController(title: nil, message: "No slots found\n Please select some other date and try again", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        }
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        task.resume()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        healthCondition.text = ""
        healthCondition.textColor = UIColor.black
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text == "Describe the symptoms or issues with your pet.." || textView.text == nil || textView.text == ""
        {
            textView.layer.borderColor = UIColor.red.cgColor
        }
        else
        {
            textView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    func textViewDidChange(_ textView: UITextView)
    {
        if healthCondition.text.count == 0
        {
            healthCondition.textColor = UIColor.lightGray
            healthCondition.text = "Describe the symptoms or issues with your pet.."
            healthCondition.resignFirstResponder()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @IBAction func moveNext(_ sender: UIButton)
    {
        if self.petId == 0 && (self.dateTime.text == "" || self.dateTime.text == nil) && self.selectedTime == "" && (self.healthCondition.text == "Describe the symptoms or issues with your pet.." || self.healthCondition.text == nil || self.healthCondition.text == "")
        {
            let alert = UIAlertController(title: "Warning", message: "Please select a Pet, Appointment Date and Time and enter issues of your pet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else if self.petId == 0
        {
            let alert = UIAlertController(title: "Warning", message: "Please select a Pet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else if self.dateTime.text == "" || self.dateTime.text == nil
        {
            let alert = UIAlertController(title: "Warning", message: "Please select Appointment Date", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else if self.selectedTime == ""
        {
            let alert = UIAlertController(title: "Warning", message: "Please select Appointment Time", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        else if (self.healthCondition.text == "Describe the symptoms or issues with your pet.." || self.healthCondition.text == nil || self.healthCondition.text == "")
        {
            let alert = UIAlertController(title: "Warning", message: "Please enter the issues with your pet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
            
        }
        else
        {
            UserDefaults.standard.set(self.petId, forKey: "TalkToVetPetId")
            UserDefaults.standard.set(self.petName, forKey: "TalkToVetPetName")
            UserDefaults.standard.set(self.petType, forKey: "TalkToVetPetType")
            UserDefaults.standard.set(self.petImageUrl, forKey: "TalkToVetPetImage")
            UserDefaults.standard.set(self.dateTime.text, forKey: "TalkToVetSelectedDate")
            UserDefaults.standard.set(self.selectedTime, forKey: "TalkToVetSelectedTime")
            UserDefaults.standard.set(self.healthCondition.text, forKey: "TalkToVetPetHealthIssue")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "ScheduleVetOnCall", sender: nil)
        }
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
