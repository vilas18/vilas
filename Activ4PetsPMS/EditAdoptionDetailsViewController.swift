//
//  EditAdoptionDetailsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class EditAdoptionDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var citytxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBOutlet weak var homePhoneTxt: UITextField!
    @IBOutlet weak var officePhoneTxt: UITextField!
    @IBOutlet weak var cellNoTxt: UITextField!
    @IBOutlet weak var faxNoTxt: UITextField!
    @IBOutlet weak var adoptNoTxt: UITextField!
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var mandatoryLbl: UILabel!
    var listTv: UIPickerView!
    var txtFld: UITextField?
    var stateId: String = ""
    var stateCountryID: String = ""
    var countryId: String = ""
    var model: AdoptionDetailsModel?
    var textFld: UITextField?
    var filterArr = [String]()
    var listArr = [CommonResponseModel]()
    var dropDownType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        listTv.delegate = self
        listTv.dataSource = self
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.rightClk))
        navigationItem.rightBarButtonItem = rightItem
        
        mandatoryLbl.isHidden = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        countryId = model?.countryId ?? " "
        stateId = model?.stateId ?? ""
        self.zipTxt.keyboardType = .numberPad
        countryTxt.isUserInteractionEnabled = true
        stateTxt.isUserInteractionEnabled = true
        
        nameTxt.layer.masksToBounds = true
        nameTxt.layer.borderWidth = 2
        nameTxt.layer.cornerRadius = 3.0
        nameTxt.layer.borderColor = UIColor.clear.cgColor
        self.nameTxt.text = model?.farmerName
        
        self.address1Txt.text = model?.farmerAdd1
        self.address2Txt.text = model?.farmerAdd2
        self.countryTxt.text = model?.country
        self.stateTxt.text = model?.state
        self.citytxt.text = model?.city
        self.zipTxt.text = model?.zip
        self.adoptNoTxt.text = model?.adoptionNo
        self.faxNoTxt.isSecureTextEntry = false
        if model?.home?.count ?? 0  > 0
        {
            let str: String = ((model?.home as NSString?)?.substring(to: 1))!
            if (str == "(") {
                homePhoneTxt.text = model?.home
            }
            else
            {
                let stringts: NSMutableString = model?.home as! NSMutableString
                
                stringts.insert("(", at: 0)
                
                stringts.insert(")", at: 4)
                
                stringts.insert(" ", at: 5)
                
                stringts.insert("-", at: 9)
                
                self.homePhoneTxt.text = stringts as String
            }
        }
        else
        {
            homePhoneTxt.text = ""
        }
        
        if model?.office?.count ?? 0 > 0 {
            let str: String? = (model?.office as NSString?)?.substring(to: 1)
            if (str == "(") {
                officePhoneTxt.text = model?.office
            }
            else {
                let stringts: NSMutableString = model?.office as! NSMutableString
                
                stringts.insert("(", at: 0)
                
                stringts.insert(")", at: 4)
                
                stringts.insert(" ", at: 5)
                
                stringts.insert("-", at: 9)
                
                self.officePhoneTxt.text = stringts as String
            }
        }
        else {
            officePhoneTxt.text = ""
        }
        
        if model?.cell?.count ?? 0 > 0 {
            let str: String? = (model?.cell as NSString?)?.substring(to: 1)
            if (str == "(") {
                cellNoTxt.text = model?.cell
            }
            else {
                let stringts: NSMutableString = model?.cell as! NSMutableString
                
                stringts.insert("(", at: 0)
                
                stringts.insert(")", at: 4)
                
                stringts.insert(" ", at: 5)
                
                stringts.insert("-", at: 9)
                
                self.officePhoneTxt.text = stringts as String
            }
        }
        else
        {
            cellNoTxt.text = ""
        }
        
        if model?.fax?.count ?? 0 > 0
        {
            let str: String? = (model?.fax as NSString?)?.substring(to: 1)
            if (str == "(") {
                faxNoTxt.text = model?.fax
            }
            else {
                let stringts: NSMutableString = model?.fax as! NSMutableString
                
                stringts.insert("(", at: 0)
                
                stringts.insert(")", at: 4)
                
                stringts.insert(" ", at: 5)
                
                stringts.insert("-", at: 9)
                
                self.officePhoneTxt.text = stringts as String
            }
        }
        else {
            faxNoTxt.text = ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func rightClk(_ sender: Any) {
        self.submitDetails()
    }
    
    func formatNumbers(_ str: String) -> String
    {
        let strs: NSMutableString = (str as? NSMutableString)!
        strs.insert("(", at: 0)
        strs.insert(")", at: 4)
        strs.replaceCharacters(in: NSRange(location: 5, length: 1), with: " ")
        return strs as String
    }
    
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        nameTxt.resignFirstResponder()
        address1Txt.resignFirstResponder()
        address2Txt.resignFirstResponder()
        countryTxt.resignFirstResponder()
        stateTxt.resignFirstResponder()
        citytxt.resignFirstResponder()
        zipTxt.resignFirstResponder()
        homePhoneTxt.resignFirstResponder()
        officePhoneTxt.resignFirstResponder()
        cellNoTxt.resignFirstResponder()
        faxNoTxt.resignFirstResponder()
        adoptNoTxt.resignFirstResponder()
        
    }
    
    
    
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.countryTxt || textField == self.stateTxt
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if textField == self.zipTxt
        {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donewithNumberPad))
            done.tag = textField.tag
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelNumberPad))
            cancel.tag = textField.tag
            numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
            numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar
            
        }
        else if textField == self.countryTxt
        {
            txtFld = textField
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
        else if textField == self.stateTxt
        {
            txtFld = textField
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
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            if (dropDownType == "Country")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)]
                countryTxt.text = model.paramName
                countryId = (model.paramID)!
                stateTxt.text = ""
                stateId = ""
            }
            else if (dropDownType == "State")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)]
                stateTxt.text = model.paramName
                stateId = (model.paramID)!
                stateCountryID = (model.paramSubID)!
            }
            self.txtFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.txtFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.txtFld?.resignFirstResponder()
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem)
    {
        zipTxt.resignFirstResponder()
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem)
    {
        zipTxt.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == zipTxt
        {
            if (textField.text?.count)! < 5
            {
                zipTxt?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid zipcode ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else
            {
                zipTxt?.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == homePhoneTxt
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
        else if textField == officePhoneTxt
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
        else if textField == cellNoTxt
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
        else if textField == faxNoTxt
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
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == zipTxt
        {
            let newStr: NSString = textField.text! as NSString
            let currentString: String = newStr.replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 5 {
                return false
            }
        }
        else if textField == homePhoneTxt || textField == officePhoneTxt || textField == cellNoTxt || textField == faxNoTxt
        {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if textField == homePhoneTxt
            {
                self.textFld = homePhoneTxt
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == officePhoneTxt
            {
                self.textFld = officePhoneTxt
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == cellNoTxt
            {
                self.textFld = cellNoTxt
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else if textField == faxNoTxt
            {
                self.textFld = faxNoTxt
                return checkEnglishPhoneNumberFormat(string: string, str: str)
            }
            else
            {
                return true
            }
        }
        if textField == homePhoneTxt || textField == officePhoneTxt || textField == cellNoTxt || textField == faxNoTxt
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
        let homeNumberString: String = homePhoneTxt.text!
        let offNumString: String = officePhoneTxt.text!
        let cellNumberString: String = cellNoTxt.text!
        let faxNumString: String = faxNoTxt.text!
        let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
        if homePhoneTxt.text?.count == 0 && officePhoneTxt.text?.count == 0 && cellNoTxt.text?.count == 0 && faxNoTxt.text?.count == 0 {
            return true
        }
        else if (homePhoneTxt.text?.count)! > 0 && (numberTest.evaluate(with: homeNumberString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct home phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            homePhoneTxt.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (officePhoneTxt.text?.count)! > 0 && (numberTest.evaluate(with: offNumString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct office phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            officePhoneTxt.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (cellNoTxt.text?.count)! > 0 && (numberTest.evaluate(with: cellNumberString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct cell phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            cellNoTxt.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (faxNoTxt.text?.count)! > 0 && (numberTest.evaluate(with: faxNumString) != true) {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct fax number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            faxNoTxt.layer.borderColor = UIColor.red.cgColor
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
        return model.paramName
    }
    
    func submitDetails()
    {
        nameTxt.resignFirstResponder()
        address1Txt.resignFirstResponder()
        address2Txt.resignFirstResponder()
        countryTxt.resignFirstResponder()
        stateTxt.resignFirstResponder()
        citytxt.resignFirstResponder()
        zipTxt.resignFirstResponder()
        homePhoneTxt.resignFirstResponder()
        officePhoneTxt.resignFirstResponder()
        cellNoTxt.resignFirstResponder()
        faxNoTxt.resignFirstResponder()
        adoptNoTxt.resignFirstResponder()
        doValidationForEditAdoption()
    }
    
    func doValidationForEditAdoption()
    {
        if nameTxt.text == nil && (nameTxt.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            nameTxt.layer.borderColor = UIColor.red.cgColor
        }
        if nameTxt.text == nil || (nameTxt.text == "") {
            nameTxt.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            nameTxt.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if !(nameTxt.text == nil) && !(nameTxt.text == "") {
            mandatoryLbl.isHidden = true
            if doValidationsForTextFields() {
                checkInternetConnection()
            }
        }
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpadte()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToUpadte()
    {
        let headers = [
            "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        let petId = UserDefaults.standard.string(forKey: "SelectedPet")
        var str: String = String(format: "PetId=%@&FarmerName=%@&FarmerAddress1=%@&FarmerAddress2=%@&FarmerCountryId=%@&FarmerStateId=%@&FarmerCity=%@&FarmerZip=%@&FarmerHomePhone=%@&FarmerOfficePhone=%@&FarmerCellPhone=%@&FarmerFax=%@&AdoptionNumber=%@",petId!,nameTxt.text!,address1Txt.text!,address2Txt.text!,countryId,stateId,citytxt.text!,zipTxt.text!,homePhoneTxt.text!,officePhoneTxt.text!,cellNoTxt.text!,faxNoTxt.text!,adoptNoTxt.text!)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format : "%@?%@", API.Pet.EditPetAdoption, str)
        let requestUrl = URL(string: urlString)
        var request = URLRequest(url: requestUrl!)
        request.httpMethod = "GET"
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
                            let alertDel = UIAlertController(title: "Success", message: "Adoption details has been updated successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
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
