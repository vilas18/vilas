//
//  EditAddVeterinarianViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 27/07/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class EditAddVeterinarianViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate
{
    var model: VetModel?
    var emgModel: EmergencyContactModel?
    var filterArr = [Any]()
    var listArr = [Any]()
    var dropDownType: String = ""
    var detailsDict = [String: Any]()
    var isEmergency: String = "false"
    var isCurrentVet: String = "false"
    var dateSelect: String = ""
    var textFld: UITextField?
    var isFromVC: Bool = false
    var isFromEmerg: Bool = false
    var isFromdetails: Bool = false
    var selectedTextFld: UITextField?
    
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView?
    @IBOutlet weak var fstNameTxtfld: UITextField!
    @IBOutlet weak var lstNameTxtfld: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var NPI: UITextField!
    @IBOutlet weak var address1Txtfld: UITextField!
    @IBOutlet weak var address2Txtfld: UITextField!
    @IBOutlet weak var cityTxtfld: UITextField!
    @IBOutlet weak var countryTxtfld: UITextField!
    @IBOutlet weak var stateTxtfld: UITextField!
    @IBOutlet weak var zipcodeTxtfld: UITextField!
    @IBOutlet weak var homeTxtfld: UITextField!
    @IBOutlet weak var officeTxtfld: UITextField!
    @IBOutlet weak var cellTxtfld: UITextField!
    @IBOutlet weak var faxTxtFld: UITextField!
    @IBOutlet weak var emailTxtfld: UITextField!
    @IBOutlet weak var specialityTxtFld: UITextField!
    @IBOutlet weak var hospitalTxtFld: UITextField!
    @IBOutlet weak var commentTxtfld: UITextView!
    
    @IBOutlet weak var isEmerg: UISwitch!
    @IBOutlet weak var isCurrent: UISwitch!
    var listTv: UIPickerView!
    
    var datePicker = UIDatePicker()
    @IBOutlet weak var mandatoryLbl: UILabel!
    
    var stateId: String = ""
    var stateCountryID: String = ""
    var countryId: String = "3"
    var vetSpecialId: String = ""
    var urlStr: String = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        listTv.delegate = self
        listTv.dataSource = self
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        
        self.mandatoryLbl?.isHidden = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapG)
        
        self.startDate?.isUserInteractionEnabled = true
        self.endDate?.isUserInteractionEnabled = false
        self.countryTxtfld?.isUserInteractionEnabled = true
        self.stateTxtfld?.isUserInteractionEnabled = true
        self.specialityTxtFld.isUserInteractionEnabled = true
        
        //self.scroll?.contentSize = CGSize(width: 320, height: 1400)
        
        
        self.fstNameTxtfld?.layer.masksToBounds = true
        self.fstNameTxtfld?.layer.borderWidth = 2
        self.fstNameTxtfld?.layer.cornerRadius = 3.0
        self.fstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.lstNameTxtfld?.layer.masksToBounds = true
        self.lstNameTxtfld?.layer.borderWidth = 2
        self.lstNameTxtfld?.layer.cornerRadius = 3.0
        self.lstNameTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.startDate?.layer.masksToBounds = true
        self.startDate?.layer.borderWidth = 2
        self.startDate?.layer.cornerRadius = 3.0
        self.startDate?.layer.borderColor = UIColor.clear.cgColor
        
        self.endDate?.layer.masksToBounds = true
        self.endDate?.layer.borderWidth = 2
        self.endDate?.layer.cornerRadius = 3.0
        self.endDate?.layer.borderColor = UIColor.clear.cgColor
        
        self.NPI?.layer.masksToBounds = true
        self.NPI?.layer.borderWidth = 2
        self.NPI?.layer.cornerRadius = 3.0
        self.NPI?.layer.borderColor = UIColor.clear.cgColor
        
        self.address1Txtfld?.layer.masksToBounds = true
        self.address1Txtfld?.layer.borderWidth = 2
        self.address1Txtfld?.layer.cornerRadius = 3.0
        self.address1Txtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.address2Txtfld?.layer.masksToBounds = true
        self.address2Txtfld?.layer.borderWidth = 2
        self.address2Txtfld?.layer.cornerRadius = 3.0
        self.address2Txtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.cityTxtfld?.layer.masksToBounds = true
        self.cityTxtfld?.layer.borderWidth = 2
        self.cityTxtfld?.layer.cornerRadius = 3.0
        self.cityTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.countryTxtfld?.layer.masksToBounds = true
        self.countryTxtfld?.layer.borderWidth = 2
        self.countryTxtfld?.layer.cornerRadius = 3.0
        self.countryTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.stateTxtfld?.layer.masksToBounds = true
        self.stateTxtfld?.layer.borderWidth = 2
        self.stateTxtfld?.layer.cornerRadius = 3.0
        self.stateTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.zipcodeTxtfld?.layer.masksToBounds = true
        self.zipcodeTxtfld?.layer.borderWidth = 2
        self.zipcodeTxtfld?.layer.cornerRadius = 3.0
        self.zipcodeTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.homeTxtfld?.layer.masksToBounds = true
        self.homeTxtfld?.layer.borderWidth = 2
        self.homeTxtfld?.layer.cornerRadius = 3.0
        self.homeTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.officeTxtfld?.layer.masksToBounds = true
        self.officeTxtfld?.layer.borderWidth = 2
        self.officeTxtfld?.layer.cornerRadius = 3.0
        self.officeTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.cellTxtfld?.layer.masksToBounds = true
        self.cellTxtfld?.layer.borderWidth = 2
        self.cellTxtfld?.layer.cornerRadius = 3.0
        self.cellTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.faxTxtFld?.layer.masksToBounds = true
        self.faxTxtFld?.layer.borderWidth = 2
        self.faxTxtFld?.layer.cornerRadius = 3.0
        self.faxTxtFld?.layer.borderColor = UIColor.clear.cgColor
        
        self.emailTxtfld?.layer.masksToBounds = true
        self.emailTxtfld?.layer.borderWidth = 2
        self.emailTxtfld?.layer.cornerRadius = 3.0
        self.emailTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.specialityTxtFld?.layer.masksToBounds = true
        self.specialityTxtFld?.layer.borderWidth = 2
        self.specialityTxtFld?.layer.cornerRadius = 3.0
        self.specialityTxtFld?.layer.borderColor = UIColor.clear.cgColor
        
        self.commentTxtfld?.layer.masksToBounds = true
        self.commentTxtfld?.layer.borderWidth = 2
        self.commentTxtfld?.layer.cornerRadius = 3.0
        self.commentTxtfld?.layer.borderColor = UIColor.clear.cgColor
        
        self.hospitalTxtFld?.layer.masksToBounds = true
        self.hospitalTxtFld?.layer.borderWidth = 2
        self.hospitalTxtFld?.layer.cornerRadius = 3.0
        self.hospitalTxtFld?.layer.borderColor = UIColor.clear.cgColor
        
        self.urlStr = API.Vet.vetAdd
        self.hospitalTxtFld?.text = ""
        self.fstNameTxtfld?.text = ""
        self.lstNameTxtfld?.text = ""
        self.NPI?.text = ""
        self.startDate?.text = ""
        self.endDate?.text = ""
        self.address1Txtfld?.text = ""
        self.address2Txtfld?.text = ""
        self.countryTxtfld?.text = ""
        self.stateTxtfld?.text = ""
        self.countryTxtfld?.text = "United States"
        self.cityTxtfld?.text = ""
        self.zipcodeTxtfld?.text = ""
        self.homeTxtfld?.text = ""
        self.officeTxtfld?.text = ""
        self.cellTxtfld?.text = ""
        self.faxTxtFld?.text = ""
        self.emailTxtfld?.text = ""
        self.vetSpecialId = ""
        self.commentTxtfld?.text = ""
        self.isEmergency = "false"
        self.isCurrentVet = "false"
        self.isEmerg?.isOn = false
        self.isCurrent?.isOn = false
        self.isEmerg?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        self.isCurrent?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        self.title = "Add Veterinarian"
        if self.isFromVC == true
        {
            self.title = "Edit Veterinarian"
            self.urlStr = API.Vet.vetEdit
            if model != nil
            {
                self.hospitalTxtFld?.text = self.model?.hospName as String?
                self.fstNameTxtfld?.text = self.model?.fstName as String?
                self.lstNameTxtfld?.text = self.model?.lstName
                self.NPI?.text = self.model?.npi
                self.startDate?.text = self.model?.startDate
                if startDate?.text != nil && startDate?.text != ""
                {
                    self.endDate?.isUserInteractionEnabled = true
                }
                self.endDate?.text = self.model?.endDate
                self.address1Txtfld?.text = self.model?.address1
                self.address2Txtfld?.text = self.model?.address2
                self.countryTxtfld?.text = self.model?.countryName;
                self.countryId = (self.model?.countryId)!
                self.stateTxtfld?.text = self.model?.stateName
                self.stateId = (self.model?.stateId)!
                self.cityTxtfld?.text = self.model?.city
                self.zipcodeTxtfld?.text = self.model?.zip
                self.homeTxtfld?.text = self.model?.phoneHome
                self.officeTxtfld?.text = self.model?.phoneOffice
                self.cellTxtfld?.text = self.model?.phoneCell
                self.faxTxtFld?.text = self.model?.fax
                self.emailTxtfld?.text = self.model?.email
                self.vetSpecialId = (self.model?.vetSpecialId)!
                self.specialityTxtFld.text = self.model?.vetSpeciality
                self.commentTxtfld?.text = self.model?.comments
                if commentTxtfld?.text != ""
                {
                    commentTxtfld?.textColor = UIColor.black
                }
                
                if (self.model?.isEmerGCont!)!
                {
                    self.isEmerg?.isOn = true
                    self.isEmergency = "true"
                }
                else
                {
                    self.isEmerg?.isOn = false
                    self.isEmergency = "false"
                }
                if (self.model?.isCurrentVet!)!
                {
                    self.isCurrent?.isOn = true
                    self.isCurrentVet = "true"
                }
                else
                {
                    self.isCurrent?.isOn = false
                    self.isCurrentVet = "false"
                }
            }
            
        }
        else if self.isFromEmerg || self.isFromdetails
        {
            self.title = "Edit Veterinarian"
            self.urlStr = API.Vet.vetEdit
            if emgModel != nil
            {
                self.hospitalTxtFld?.text = self.emgModel?.hospitalName as String?
                self.fstNameTxtfld?.text = self.emgModel?.fstName as String?
                self.lstNameTxtfld?.text = self.emgModel?.lstName as! String
                self.NPI?.text = self.emgModel?.npi
                self.startDate?.text = self.emgModel?.startDate
                if startDate?.text != nil && startDate?.text != ""
                {
                    self.endDate?.isUserInteractionEnabled = true
                }
                self.endDate?.text = self.emgModel?.endDate
                self.address1Txtfld?.text = self.emgModel?.address1
                self.address2Txtfld?.text = self.emgModel?.address2
                self.countryTxtfld?.text = self.emgModel?.countryName;
                self.countryId = self.emgModel?.countryId ?? "0"
                self.stateTxtfld?.text = self.emgModel?.stateName
                self.stateId = self.emgModel?.stateId ?? "0"
                self.cityTxtfld?.text = self.emgModel?.city
                self.zipcodeTxtfld?.text = self.emgModel?.zip
                self.homeTxtfld?.text = self.emgModel?.phoneHome
                self.officeTxtfld?.text = self.emgModel?.phoneOffice
                self.cellTxtfld?.text = self.emgModel?.phoneCell
                self.faxTxtFld?.text = self.emgModel?.fax
                self.emailTxtfld?.text = self.emgModel?.email
                self.vetSpecialId = self.emgModel?.vetSpecialityId ?? "0"
                self.specialityTxtFld.text = self.emgModel?.vetSpeciality
                self.commentTxtfld?.text = self.emgModel?.comments
                if commentTxtfld?.text != ""
                {
                    commentTxtfld?.textColor = UIColor.black
                }
                
                if (self.emgModel?.isEmerGCont!)!
                {
                    self.isEmerg?.isOn = true
                    self.isEmergency = "true"
                }
                else
                {
                    self.isEmerg?.isOn = false
                    self.isEmergency = "false"
                }
                if (self.emgModel?.iscurrentVet!)!
                {
                    self.isCurrent?.isOn = true
                    self.isCurrentVet = "true"
                }
                else
                {
                    self.isCurrent?.isOn = false
                    self.isCurrentVet = "false"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func isSwitchOn(sender: UISwitch) -> Void
    {
        if sender.tag == 1
        {
            if (self.isEmerg?.isOn)! {
                self.isEmergency = "true"
            }
            else{
                self.isEmergency = "false"
            }
        }
        else if sender.tag == 2
        {
            if (self.isCurrent?.isOn)! {
                self.isCurrentVet = "true"
            }
            else{
                self.isCurrentVet = "false"
            }
            
        }
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        fstNameTxtfld?.resignFirstResponder()
        lstNameTxtfld?.resignFirstResponder()
        startDate?.resignFirstResponder()
        endDate?.resignFirstResponder()
        NPI?.resignFirstResponder()
        address1Txtfld?.resignFirstResponder()
        address2Txtfld?.resignFirstResponder()
        cityTxtfld?.resignFirstResponder()
        zipcodeTxtfld?.resignFirstResponder()
        homeTxtfld?.resignFirstResponder()
        officeTxtfld?.resignFirstResponder()
        cellTxtfld?.resignFirstResponder()
        faxTxtFld?.resignFirstResponder()
        countryTxtfld?.resignFirstResponder()
        stateTxtfld?.resignFirstResponder()
        emailTxtfld?.resignFirstResponder()
        specialityTxtFld?.resignFirstResponder()
        commentTxtfld?.resignFirstResponder()
        hospitalTxtFld?.resignFirstResponder()
        
    }
    
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            RestClient.getList(dropDownType, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = [Any]()
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    
                    for dict in detailsArr
                    {
                        if (self.dropDownType == "VetSpeciality")
                        {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "Country") {
                            let model = CommonResponseModel()
                            model.paramID = (dict["Id"] as! NSNumber).stringValue
                            model.paramName = dict["Name"] as! String?
                            self.listArr.append(model)
                        }
                        else if (self.dropDownType == "State") {
                            let model = CommonResponseModel()
                            if self.countryId != "" && self.countryId == dict["ConversationId"] as! String? {
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                model.paramSubID = dict["ConversationId"] as! String?
                                self.listArr.append(model)
                            }
                        }
                    }
                    
                    self.listTv?.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == zipcodeTxtfld
        {
            if (textField.text?.count)! < 5
            {
                zipcodeTxtfld?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid zipcode ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else
            {
                zipcodeTxtfld?.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == homeTxtfld
        {
            if textField.text?.count == 0 {
                print("Nmber is correct...")
            }
            else {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor.white.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == officeTxtfld
        {
            if textField.text?.count == 0 {
                print("Nmber is correct...")
            }
            else {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor.white.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == cellTxtfld
        {
            if textField.text?.count == 0 {
                print("Nmber is correct...")
            }
            else {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor.white.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == faxTxtFld
        {
            if textField.text?.count == 0 {
                print("Nmber is correct...")
            }
            else {
                let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
                let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
                if numberTest.evaluate(with: textField.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor.white.cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == self.startDate
        {
            if startDate?.text == nil || startDate?.text == ""
            {
                self.endDate?.isUserInteractionEnabled = false
            }
            else
            {
                self.endDate?.isUserInteractionEnabled = true
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == zipcodeTxtfld
        {
            let newStr: NSString = textField.text! as NSString
            let currentString: String = newStr.replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 5 {
                return false
            }
        }
        else if textField == homeTxtfld || textField == officeTxtfld || textField == cellTxtfld || textField == faxTxtFld
        {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if textField == homeTxtfld
            {
                self.textFld = homeTxtfld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == officeTxtfld
            {
                self.textFld = officeTxtfld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == cellTxtfld
            {
                self.textFld = cellTxtfld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == faxTxtFld
            {
                self.textFld = faxTxtFld
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else
            {
                return true
            }
            
        }
        if textField == homeTxtfld || textField == officeTxtfld || textField == cellTxtfld || textField == faxTxtFld
        {
            let cs = NSCharacterSet(charactersIn: API.Login.ACCEPTABLE_CHARACTERS).inverted;
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                self.textFld?.text = "("
            }
            
        }else if str!.count == 5{
            
            self.textFld?.text = (self.textFld?.text!)! + ") "
            
        }else if str!.count == 10{
            
            self.textFld?.text = (self.textFld?.text!)! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        return true
    }
    func doValidationsForTextFields() -> Bool
        
    {
        let emailString: String = emailTxtfld!.text!
        let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        let contactNumberString: String = homeTxtfld!.text!
        let secNumString: String = officeTxtfld!.text!
        let cellNumStr: String = cellTxtfld!.text!
        let faxNumStr: String = faxTxtFld!.text!
        
        let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
        
        
        if homeTxtfld?.text?.count == 0 && officeTxtfld?.text?.count == 0 && cellTxtfld?.text?.count == 0 && faxTxtFld?.text?.count == 0 && emailTxtfld?.text?.count == 0
        {
            return true
        }
        else if (emailTxtfld?.text?.count)! > 0 && (emailTest.evaluate(with: emailString) != true)
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct email", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            emailTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (homeTxtfld?.text?.count)! > 0 && (numberTest.evaluate(with: contactNumberString) != true)
        {
            
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct home phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            homeTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (officeTxtfld?.text?.count)! > 0 && (numberTest.evaluate(with: secNumString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct office phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            officeTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (cellTxtfld?.text?.count)! > 0 && (numberTest.evaluate(with: cellNumStr) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct cell phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            cellTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (faxTxtFld?.text?.count)! > 0 && (numberTest.evaluate(with: faxNumStr) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct fax number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            officeTxtfld?.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else {
            return true
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return listArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row]
        return (model as AnyObject).paramName
    }
    @objc func submitDetails(_ sender: Any)
    {
        fstNameTxtfld?.resignFirstResponder()
        lstNameTxtfld?.resignFirstResponder()
        startDate?.resignFirstResponder()
        endDate?.resignFirstResponder()
        NPI?.resignFirstResponder()
        address1Txtfld?.resignFirstResponder()
        address2Txtfld?.resignFirstResponder()
        cityTxtfld?.resignFirstResponder()
        zipcodeTxtfld?.resignFirstResponder()
        homeTxtfld?.resignFirstResponder()
        officeTxtfld?.resignFirstResponder()
        cellTxtfld?.resignFirstResponder()
        faxTxtFld?.resignFirstResponder()
        countryTxtfld?.resignFirstResponder()
        stateTxtfld?.resignFirstResponder()
        emailTxtfld?.resignFirstResponder()
        specialityTxtFld?.resignFirstResponder()
        commentTxtfld?.resignFirstResponder()
        hospitalTxtFld?.resignFirstResponder()
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.hospitalTxtFld?.text == nil && (self.hospitalTxtFld?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            self.hospitalTxtFld?.layer.borderColor = UIColor.red.cgColor
            
            self.mandatoryLbl?.isHidden = false
        }
        if self.hospitalTxtFld?.text == nil || (self.hospitalTxtFld?.text == "")
        {
            self.hospitalTxtFld?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.hospitalTxtFld?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        
        if !(self.hospitalTxtFld?.text == nil) && !(self.hospitalTxtFld?.text == "") // && !(self.fstNameTxtfld?.text == nil) && !(self.fstNameTxtfld?.text == "") && !(self.lstNameTxtfld?.text == nil) && !(self.lstNameTxtfld?.text == "") && !(self.cellTxtfld?.text == nil) && !(self.cellTxtfld.text == "")
        {
            self.mandatoryLbl?.isHidden = true
            if doValidationsForTextFields()
            {
                checkInternetConnection()
            }
        }
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpadteAdd()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webServiceToUpadteAdd()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "content-type": "application/json",
                "cache-control": "no-cache"
            ]
            var str: String = ""
            var message: String = ""
            if self.commentTxtfld?.text == "Enter Comments"
            {
                self.commentTxtfld?.text = ""
            }
            if self.isFromVC == true || self.isFromEmerg == true || self.isFromdetails == true
            {
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                var vetId: String = ""
                if self.isFromVC
                {
                    vetId = (self.model?.vetId)!
                }
                else if self.isFromEmerg || self.isFromdetails
                {
                    vetId = (self.emgModel?.contactId)!
                }
                message = "Veterinarian has been updated successfully"
                str = String(format : "VeterinarianId=%@&UserId=%@&HospitalName=%@&FirstName=%@&LastName=%@&NPI=%@&IsEmergencyContact=%@&IsCurrentVeterinarian=%@&StartDate=%@&EndDate=%@&Address1=%@&Address2=%@&City=%@&CountryId=%@&StateId=%@&Zip=%@&Home=%@&Office=%@&Cell=%@&Fax=%@&Email=%@&VetSpecialityId=%@&Comments=%@", vetId, userId,self.hospitalTxtFld!.text!, self.fstNameTxtfld!.text!, self.lstNameTxtfld!.text!, self.NPI!.text!, self.isEmergency, self.isCurrentVet, self.startDate!.text!, self.endDate!.text!, self.address1Txtfld!.text!, self.address2Txtfld!.text!, self.cityTxtfld!.text!, self.countryId, self.stateId, self.zipcodeTxtfld!.text!, self.homeTxtfld!.text!, self.officeTxtfld!.text!, self.cellTxtfld!.text!, self.faxTxtFld!.text!, self.emailTxtfld!.text!, self.vetSpecialId, self.commentTxtfld!.text )
            }
            else if self.isFromVC == false
            {
                message = "Veterinarian has been added successfully"
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "PetId=%@&UserId=%@&HospitalName=%@&FirstName=%@&LastName=%@&NPI=%@&IsEmergencyContact=%@&IsCurrentVeterinarian=%@&StartDate=%@&EndDate=%@&Address1=%@&Address2=%@&City=%@&CountryId=%@&StateId=%@&Zip=%@&Home=%@&Office=%@&Cell=%@&Fax=%@&Email=%@&VetSpecialityId=%@&Comments=%@", petId, userId, self.hospitalTxtFld!.text!, self.fstNameTxtfld!.text!, self.lstNameTxtfld!.text!, self.NPI!.text!, self.isEmergency, self.isCurrentVet, self.startDate!.text!, self.endDate!.text!, self.address1Txtfld!.text!, self.address2Txtfld!.text!, self.cityTxtfld!.text!, self.countryId, self.stateId, self.zipcodeTxtfld!.text!, self.homeTxtfld!.text!, self.officeTxtfld!.text!, self.cellTxtfld!.text!, self.faxTxtFld!.text!, self.emailTxtfld!.text!, self.vetSpecialId, self.commentTxtfld!.text  )
                
            }
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", self.urlStr, str)
            let requestUrl = URL(string: urlString)
            var request = URLRequest(url: requestUrl!)
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
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
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
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    if self.isFromEmerg
                                    {
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is NewMedicalSummaryViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                
                                            }
                                        }
                                    }
                                    else if self.isFromdetails
                                    {
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is EmergencyContactsListViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                
                                            }
                                        }
                                    }
                                    else
                                    {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                                
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == commentTxtfld {
            commentTxtfld?.text = ""
            commentTxtfld?.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if commentTxtfld?.text.count == 0
        {
            commentTxtfld?.textColor = UIColor.lightGray
            commentTxtfld?.text = "Enter comments"
            commentTxtfld?.resignFirstResponder()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.countryTxtfld || textField == self.stateTxtfld || textField == self.specialityTxtFld
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == homeTxtfld || textField == officeTxtfld || textField == cellTxtfld || textField == faxTxtFld || textField == zipcodeTxtfld
        {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donewithNumberPad))
            done.tag = textField.tag
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad))
            cancel.tag = textField.tag
            numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
            numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar
        }
        else if textField == self.startDate
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.selectedTextFld = textField
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
        else if textField == self.endDate
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.selectedTextFld = textField
            if startDate?.text != nil && startDate.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: self.startDate!.text!)!
                self.datePicker.minimumDate = date
            }
            self.datePicker.maximumDate = nil
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
        else if textField == self.countryTxtfld
        {
            textFld = textField
            dropDownType = "Country"
            self.listArr = []
            self.listTv.reloadAllComponents()
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
            textField.inputView = listTv
        }
        else if textField == self.stateTxtfld
        {
            
            textFld = textField
            dropDownType = "State"
            self.listArr = []
            self.listTv.reloadAllComponents()
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
            textField.inputView = listTv
        }
        else if textField == self.specialityTxtFld
        {
            textFld = textField
            dropDownType = "VetSpeciality"
            self.listArr = []
            self.listTv.reloadAllComponents()
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
            textField.inputView = listTv
        }
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            if (dropDownType == "Country")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                countryTxtfld?.text = model?.paramName
                countryId = (model?.paramID)!
                stateTxtfld?.text = ""
                stateId = ""
            }
            else if (dropDownType == "State")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                stateTxtfld?.text = model?.paramName
                stateId = (model?.paramID)!
                stateCountryID = (model?.paramSubID)!
            }
            else if (dropDownType == "VetSpeciality")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                specialityTxtFld?.text = model?.paramName
                vetSpecialId = (model?.paramID)!
            }
            self.textFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.textFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.textFld?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.selectedTextFld?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.selectedTextFld?.resignFirstResponder()
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem) {
        if item.tag == 1 {
            homeTxtfld?.resignFirstResponder()
            //_advTimeTxt.text=@"";
        }
        else if item.tag == 2 {
            officeTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        else if item.tag == 3 {
            cellTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        else if item.tag == 4 {
            faxTxtFld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
            
        else if item.tag == 5 {
            zipcodeTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        
        
    }
    
    @objc func donewithNumberPad(item: UIBarButtonItem) {
        if item.tag == 1 {
            homeTxtfld?.resignFirstResponder()
            //_advTimeTxt.text=@"";
        }
        else if item.tag == 2 {
            officeTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        else if item.tag == 3 {
            cellTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        else if item.tag == 4 {
            faxTxtFld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
            
        else if item.tag == 5 {
            zipcodeTxtfld?.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
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
