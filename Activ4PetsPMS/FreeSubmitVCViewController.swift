//
//  FreeSubmitVCViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 21/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//
import UIKit
import StoreKit
let imageCache1 = NSCache<AnyObject, AnyObject>()
class MyPetsModel1: NSObject
 {
    var petId : NSNumber?
    var petName : String?
    var petType : String?
    
    init?(petId: NSNumber?, petName: String, petType : String)
    {
    self.petId=petId
    self.petName=petName
    self.petType=petType
    }
  }
import UIKit

class FreeSubmitVCViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var isSterile: UITextField!
    @IBOutlet weak var petGender: UITextField!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var optOffers: UIButton!
    @IBOutlet weak var submit: UIButton!
    var optoffer : Bool = false
    var datePicker = UIDatePicker()
    var dropDownTbl: UIPickerView!
    var selectedTextFld: UITextField?
    var dropDownString: String = ""
    var listArr = [Any]()
    var window: UIWindow?
    var navigationControler: UINavigationController?
    var petModelList = [MyPetsModel1]()
    var petInfo: MyPetsModel?
    var sterileID: String?
    var GenderId: String?
    var PetId: String?
    var PetTypeId: String?
    var query : String?
    var queryCategory : String?
    var isFromFreeVet: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        
        navigationItem.leftBarButtonItem = leftItem
        petName.isUserInteractionEnabled = false
        weight.isUserInteractionEnabled = true
        dobText.isUserInteractionEnabled = true
        isSterile.isUserInteractionEnabled = true
        let petid =  UserDefaults.standard.string(forKey: "SelectedPet")
        self.PetId = petid
        let petname =  UserDefaults.standard.string(forKey: "SelectedPetName")
        self.petName.text = petname
        let pettype = UserDefaults.standard.object(forKey: "PetType")
        self.PetTypeId = pettype as? String
        let gender = UserDefaults.standard.object(forKey: "PetGender")
        self.petGender.text = gender as? String
        if self.petGender.text == nil || self.petGender.text == ""
        {
            self.petGender.isUserInteractionEnabled = true  // *** if gender is from user defaults make interaction = false ***
        }
        let steriletype = UserDefaults.standard.object(forKey: "sterile")
        self.isSterile.text = steriletype as? String
        self.title = "Ask a Question"
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        self.isSterile.isUserInteractionEnabled = false
          // Do any additional setup after loading the view.
         }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    func prepareUI()
    {
        petGender.layer.masksToBounds = true
        petGender.layer.borderWidth = 2
        petGender.layer.cornerRadius = 3.0
        petGender.layer.borderColor = UIColor.clear.cgColor
        
        submit.layer.masksToBounds = true
        submit.layer.borderWidth = 2
        submit.layer.cornerRadius = 3.0
        submit.layer.borderColor = UIColor.clear.cgColor
        
        petName.layer.masksToBounds = true
        petName.layer.borderWidth = 2
        petName.layer.cornerRadius = 3.0
        petName.layer.borderColor = UIColor.clear.cgColor
        
        weight.layer.masksToBounds = true
        weight.layer.borderWidth = 2
        weight.layer.cornerRadius = 3.0
        weight.layer.borderColor = UIColor.clear.cgColor
        
        dobText.layer.masksToBounds = true
        dobText.layer.borderWidth = 2
        dobText.layer.cornerRadius = 3.0
        dobText.layer.borderColor = UIColor.clear.cgColor
        
    }
    @IBAction func submitBtn(_ sender: Any)
    {
            petName.resignFirstResponder()
            petGender.resignFirstResponder()
            isSterile.resignFirstResponder()
            weight.resignFirstResponder()
            dobText.resignFirstResponder()
            doValidationForEmptyField()
    }
    
    @IBAction func okForOffers(_ sender: UIButton) {
        if sender.isSelected == true
        {
          self.optOffers.isSelected = false
          self.optOffers.setImage(UIImage(named: "ckbx_uncheked.png"), for: .normal)
          self.optoffer = true
        }
        else
        {
            self.optOffers.isSelected = true
            self.optOffers.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
            self.optoffer = false
        }
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        resignFirstResponder()
        weight.resignFirstResponder()
        dobText.resignFirstResponder()
        petGender.resignFirstResponder()
        petName.resignFirstResponder()
        isSterile.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.weight
        {
            let range: Int = Int(weight.text!)!
            if (weight.text?.count)! > 5 || range > 11023
            {
                weight?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Weight must be between 0 and 11023 ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
                return false
            }
            else
            {
                weight?.layer.borderColor = UIColor.clear.cgColor
                return true
            }
            
        }
        resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.listArr.count
    }
//    @objc func doneDropDownSelection()
//    {
//        if listArr.count > 0
//        {
//            let model = listArr[self.dropDownTbl.selectedRow(inComponent: 0)] as? CommonResponseModel
//            if (dropDownString == "Gender")
//            {
//                petGender.text = model?.paramName
//            }
//        }
//    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.petGender || textField == self.weight || textField == self.dobText
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.petGender
        {
            let alertControl = UIAlertController(title: "Pet Gender", message: nil, preferredStyle: .actionSheet)
            let yes = UIAlertAction(title: "Male", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.petGender.text = NSLocalizedString("Male", comment: "")
                self.GenderId = "1"
            })
            let no = UIAlertAction(title: "Female", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.petGender.text = NSLocalizedString("Female", comment: "")
                self.GenderId = "2"
            })
            alertControl.addAction(yes)
            alertControl.addAction(no)
            alertControl.popoverPresentationController?.sourceView = self.view
            alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            navigationController?.present(alertControl, animated: true)
        }
        else if textField == self.dobText
        {
            self.datePicker.maximumDate = Date()
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
            self.dobText.inputAccessoryView = toolbar
            self.dobText.inputView = datePicker
        }
        else if textField == self.isSterile
            {
                let alertControl = UIAlertController(title: "Select Sterile", message: nil, preferredStyle: .actionSheet)
                let yes = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.isSterile.text = NSLocalizedString("Yes", comment: "")
                    self.sterileID = "1"
                })
                let no = UIAlertAction(title: "NO", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.isSterile.text = NSLocalizedString("No", comment: "")
                    self.sterileID = "0"
                })
                let unknown = UIAlertAction(title: "Unknown", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.isSterile.text = NSLocalizedString("Unknown", comment: "")
                    self.sterileID = ""
                })
                let Cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: nil)
                alertControl.addAction(yes)
                alertControl.addAction(no)
                alertControl.addAction(unknown)
                alertControl.addAction(Cancel)
                alertControl.popoverPresentationController?.sourceView = self.view
                alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                navigationController?.present(alertControl, animated: true)
        }
    }
    @objc func cancelDropDownSelection()
        {
            self.view.endEditing(true)
            self.selectedTextFld?.resignFirstResponder()
        }
    @objc func donedatePicker()
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            self.dobText.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.dobText.resignFirstResponder()
    }
    func doValidationForEmptyField()
        {
                if petName.text == nil || (petName.text == "")
                {
                let alert = UIAlertController(title: "Warning", message: "Please enter pet name", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                petName.layer.borderColor = UIColor.red.cgColor
                present(alert, animated: true)
                }
                else  if petGender.text == nil || (petGender.text == "")
                {
                let alert = UIAlertController(title: "Warning", message: "Please choose pet gender", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                petGender.layer.borderColor = UIColor.red.cgColor
                present(alert, animated: true)
                }
                else  if weight.text == nil || (weight.text == "")
                {
                    let alert = UIAlertController(title: "Warning", message: "Please enter pet weight", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    weight.layer.borderColor = UIColor.red.cgColor
                    present(alert, animated: true)
                }
                else  if dobText.text == nil || (dobText.text == "")
                {
                    let alert = UIAlertController(title: "Warning", message: "Please enter pet daet of birth", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    dobText.layer.borderColor = UIColor.red.cgColor
                    present(alert, animated: true)
                }
                else
                {
                    petName.layer.borderColor = UIColor.lightGray.cgColor
                    petGender.layer.borderColor = UIColor.lightGray.cgColor
                    isSterile.layer.borderColor =  UIColor.lightGray.cgColor
                    weight.layer.borderColor = UIColor.lightGray.cgColor
                    dobText.layer.borderColor = UIColor.lightGray.cgColor
                    self.webServiceForFree()
                }
        }
    func removeSpecialCharsFromString(_ str: String) -> String {
        struct Constants {
            static let validChars = Set("1234567890")
        }
        return String(str.filter { Constants.validChars.contains($0) })
    }
        func webServiceForFree()
        {
            let reachability = Reachability.forInternetConnection
            let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
            if internetStatus != NotReachable
            {
                let headers = [
                    "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                    "cache-control": "no-cache"
                ]
                //        petType.text = pettype as? String
                
                let firstname :  String = UserDefaults.standard.string(forKey:"UserName")!
                let phone :  String = UserDefaults.standard.string(forKey:"UserPhoneNumber")! // it may come null handle it ***
                let newPhone : String = self.removeSpecialCharsFromString(phone)
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                let email: String = UserDefaults.standard.string(forKey: "UserEmail")! // it may come null handle it ***
                let dict: [String: Any] = [ "OwnerId" : userId,"FirstName": firstname,"LastName": "" ,"Email": email,"PhoneNumber": newPhone ,"StateId": 3,"PetId": PetId ,"PetTypeId": PetTypeId ,"PetName":self.petName.text!,"IsSpayed": self.isSterile.text!,"IsSubscribed": optoffer ,"PetDob": self.dobText.text!,"GenderId": GenderId ,"Weight": self.weight.text! ,"Question": query,"CategoryId": ""]
                print(dict)
                let requestUrl = URL(string: "http://qapetsvetscom.activdoctorsconsult.com/Vet/AskQuestion") // ** before release change the url to live **
                var request = URLRequest(url:requestUrl!)
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                } catch
                {
                    print(error.localizedDescription)
                }
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                let session = URLSession.shared
                let task = session.dataTask(with: request)
                {
                    (data, response, error) in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        MBProgressHUD.hide(for: self.view, animated: true)
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response))")
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let status = json?["Status"] as? Int
                    {
                        DispatchQueue.main.async
                            {
                                if status == 1
                                {
//                                  "message" = "Question successfully raised"
                                    MBProgressHUD.hide(for: self.view, animated: true)
//                                    let thanks: ThankYouSMOECViewController? = segue.destination as? ThankYouSMOECViewController
//                                    let thanks: ThankYouSMOECViewController? =
//                                    thanks?.isFromFreeVet = true
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
