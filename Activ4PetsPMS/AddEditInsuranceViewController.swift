//
//  AddEditInsuranceViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit


class AddEditInsuranceViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    var petInfo: MyPetsModel?
    var details: InsuranceModel?
    
    @IBOutlet weak var mandatoryLbl: UILabel!
    @IBOutlet weak var insuranceNameTxtF: UITextField!
    @IBOutlet weak var accountNumTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var startDateTxtF: UITextField!
    @IBOutlet weak var endDateTxtF: UITextField!
    @IBOutlet weak var phoneNumTxtF: UITextField!
    @IBOutlet weak var commentTxtF: UITextField!
    
    @IBOutlet weak var emailSwtch: UISwitch!
    @IBOutlet weak var emailLbl: UILabel!
    var datePicker = UIDatePicker()
    var selectedTextFld: UITextField?
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    var swtchData: String = ""
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var insureTv: UIPickerView!
    @IBOutlet weak var insureTypeTxt: UITextField!
    var insuranceTypeId: String = ""
    var dropDownType: String = ""
    var isFromVC = false
    var urlStr: String = ""
    var listArr: [CommonResponseModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insureTv = UIPickerView.init(frame: CGRect(x:0, y:0, width: 0, height: 220))
        insureTv.delegate = self
        insureTv.dataSource = self
        
        mandatoryLbl.isHidden = true
        emailSwtch.isOn = false
        topSpace.constant = 2
        insuranceNameTxtF.isHidden = true
        insureTypeTxt.isUserInteractionEnabled = true
        startDateTxtF.isUserInteractionEnabled = true
        endDateTxtF.isUserInteractionEnabled = false
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.rightClk))
        navigationItem.rightBarButtonItem = rightItem
        insuranceNameTxtF.layer.masksToBounds = true
        insuranceNameTxtF.layer.borderWidth = 2
        insuranceNameTxtF.layer.cornerRadius = 3.0
        insuranceNameTxtF.layer.borderColor = UIColor.clear.cgColor
        insureTypeTxt.layer.masksToBounds = true
        insureTypeTxt.layer.borderWidth = 2
        insureTypeTxt.layer.cornerRadius = 3.0
        insureTypeTxt.layer.borderColor = UIColor.clear.cgColor
        self.urlStr = API.Pet.AddPetInsurance
        self.title = "ADD INSURANCE"
        if self.isFromVC == true
        {
            self.title = "EDIT INSURANCE"
            if self.details?.insuranceTypeId == "1"
            {
                self.insureTypeTxt.text = "Other";
                self.insuranceTypeId = "1"
                insuranceNameTxtF.isHidden = false
                topSpace.constant = 43
                self.insuranceNameTxtF.text = self.details?.customInsure
            }
            else
            {
                self.insureTypeTxt.text = self.details?.planName
                self.insuranceTypeId = (self.details?.insuranceTypeId)!
            }
            
            self.accountNumTxtF.text = self.details?.accountNo
            self.emailTxtF.text = self.details?.email
            self.startDateTxtF.text = self.details?.startDate
            if startDateTxtF.text != nil && startDateTxtF.text != ""
            {
                self.endDateTxtF.isUserInteractionEnabled = true
            }
            self.endDateTxtF.text = self.details?.endDate
            self.phoneNumTxtF.text = self.details?.phone
            self.commentTxtF.text = self.details?.comment
            if self.details?.isEmail == true
            {
                self.emailSwtch.isOn = true
            }
            else{
                self.emailSwtch.isOn = false
            }
            self.urlStr = API.Pet.EditPetInsurance
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        var scrollViewHeight: CGFloat = 0.0
        for view: UIView in scrollView.subviews {
            scrollViewHeight += view.frame.size.height
        }
        scrollView.contentSize = (CGSize(width: 320, height: 650))
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: 320, height: 650)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.listArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row]
        return model.paramName
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.listArr[indexPath.row]
        insureTypeTxt.text = model.paramName
        insuranceTypeId = model.paramID
        print(insuranceTypeId)
        if insureTypeTxt.text == "Other" || Int(self.insuranceTypeId) == 1
        {
            insuranceNameTxtF.isHidden = false
            topSpace.constant = 43
        }
        self.insureTypeTxt.resignFirstResponder()
    }
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            RestClient.getList(dropDownType, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = [CommonResponseModel]()
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    
                    for dict in detailsArr
                    {
                        let model = CommonResponseModel()
                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                        model.paramName = dict["Name"] as! String?
                        self.listArr.append(model)
                    }
                    
                    self.insureTv.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == phoneNumTxtF {
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
                    textField.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
                    print("Nmber is correct...")
                }
            }
        }
        else if textField == emailTxtF
        {
            if textField.text?.count == 0 {
                print("email is correct...")
            }
            else {
                let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                if emailTest.evaluate(with: emailTxtF.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                else {
                    textField.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
                    print("email is correct...")
                }
            }
        }
        else if (insureTypeTxt.text == "Other") && CInt(insuranceTypeId) == 1 {
            topSpace.constant = 43
            insuranceNameTxtF.isHidden = false
        }
        else if textField == self.startDateTxtF
        {
            if startDateTxtF.text == nil || startDateTxtF.text == ""
            {
                self.endDateTxtF.isUserInteractionEnabled = false
            }
            else
            {
                self.endDateTxtF.isUserInteractionEnabled = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneNumTxtF
        {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if textField == phoneNumTxtF
            {
                
                return checkEnglishPhoneNumberFormat(string: string, str: str)
                
            }else{
                
                return true
            }
        }
        
        if textField == phoneNumTxtF
        {
            let cs = CharacterSet(charactersIn: API.Login.ACCEPTABLE_CHARACTERS).inverted
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
                
                phoneNumTxtF.text = "("
            }
            
        }else if str!.count == 5{
            
            phoneNumTxtF.text = phoneNumTxtF.text! + ") "
            
        }else if str!.count == 10{
            
            phoneNumTxtF.text = phoneNumTxtF.text! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.insureTypeTxt
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.startDateTxtF
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
        else if textField == self.endDateTxtF
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            if startDateTxtF.text != nil && startDateTxtF.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: self.startDateTxtF.text!)!
                self.datePicker.minimumDate = date
                
            }
            
            self.selectedTextFld = textField
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
        else if textField == self.insureTypeTxt
        {
            self.dropDownType = "InsuranceType"
            self.listArr = []
            self.insureTv.reloadAllComponents()
            self.getList()
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
            textField.inputView = insureTv
        }
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            let model = listArr[self.insureTv.selectedRow(inComponent: 0)]
            if (dropDownType == "InsuranceType")
            {
                insureTypeTxt.text = model.paramName
                insuranceTypeId = model.paramID
                print(insuranceTypeId)
                if insureTypeTxt.text == "Other" || Int(self.insuranceTypeId) == 1
                {
                    insuranceNameTxtF.isHidden = false
                    topSpace.constant = 43
                }
                self.insureTypeTxt.resignFirstResponder()
            }
            self.view.endEditing(true)
        }
        else
        {
            self.insureTypeTxt?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.insureTypeTxt?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.selectedTextFld?.text = formatter.string(from: datePicker.date)
        if selectedTextFld == self.startDateTxtF
        {
            if startDateTxtF.text != nil && startDateTxtF.text != ""
            {
                self.endDateTxtF.isUserInteractionEnabled = true
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.selectedTextFld?.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == insuranceNameTxtF {
            accountNumTxtF.becomeFirstResponder()
        }
        else if textField == accountNumTxtF {
            phoneNumTxtF.becomeFirstResponder()
        }
        else if textField == phoneNumTxtF {
            commentTxtF.becomeFirstResponder()
        }
        else if textField == commentTxtF {
            commentTxtF.resignFirstResponder()
        }
        
        return true
    }
    // MARK: -
    // MARK: UISwitch Methods
    func switchMethod()
    {
        if emailSwtch.isOn
        {
            swtchData = "true"
        }
        else
        {
            swtchData = "false"
        }
    }
    @objc func rightClk(_ sender: Any)
    {
        insuranceNameTxtF.resignFirstResponder()
        accountNumTxtF.resignFirstResponder()
        startDateTxtF.resignFirstResponder()
        endDateTxtF.resignFirstResponder()
        phoneNumTxtF.resignFirstResponder()
        commentTxtF.resignFirstResponder()
        insureTypeTxt.resignFirstResponder()
        insureTv.isHidden = true
        if startDateTxtF.text?.count == 0 || endDateTxtF.text?.count == 0
        {
            doValidationsForAddInsurance()
        }
        else
        {
            if doValidationForDate()
            {
                doValidationsForAddInsurance()
            }
        }
    }
    func doValidationForDate() -> Bool
    {
        print("Executing Do Validation For Date")
        let string1: String = startDateTxtF.text!
        let string2: String = endDateTxtF.text!
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
        let date1: Date? = dateFormat.date(from: string1)
        let date2: Date? = dateFormat.date(from: string2)
        let comparisonResult: ComparisonResult? = date1?.compare(date2!)
        if comparisonResult == .orderedDescending {
            print("Wrong date input")
            let alert = UIAlertController(title: NSLocalizedString("Wrong date input", comment: ""), message: NSLocalizedString("End date should be greater than Start date", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true) 
            return false
        }
        else if comparisonResult == .orderedAscending {
            print("Correct date input")
            return true
        }
        else if comparisonResult == .orderedSame {
            print("same date input")
            return true
        }
        
        return true
    }
    func doValidationsForAddInsurance()
    {
        switchMethod()
        if insureTypeTxt.text == nil && (insureTypeTxt.text == "")
        {
            insureTypeTxt.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        if insureTypeTxt.text == nil || (insureTypeTxt.text == "")
        {
            insureTypeTxt.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            insureTypeTxt.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if !(insureTypeTxt.text == nil) && !(insureTypeTxt.text == "")
        {
            if self.insureTypeTxt.text == "Other" || Int(self.insuranceTypeId) == 1
            {
                if self.insuranceNameTxtF.text == nil || self.insuranceNameTxtF.text == ""
                {
                    mandatoryLbl.isHidden = false
                    self.insuranceNameTxtF.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter custom insurance name", comment: ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    
                }
                else
                {
                    if doValidationForTextFields()
                    {
                        mandatoryLbl.isHidden = true
                        checkInternetConnection()
                    }
                }
            }
            else if doValidationForTextFields()
            {
                mandatoryLbl.isHidden = true
                checkInternetConnection()
            }
        }
    }
    func doValidationForTextFields() -> Bool
    {
        let phoneNumber: String = phoneNumTxtF.text!
        let emailString: String = emailTxtF.text!
        let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
        if phoneNumTxtF.text?.count == 0 && startDateTxtF.text?.count == 0 && endDateTxtF.text?.count == 0 && emailTxtF.text?.count == 0 {
            return true
        }
        else if (phoneNumTxtF.text?.count)! > 0 && (numberTest.evaluate(with: phoneNumber) != true)
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct phone number", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            phoneNumTxtF.layer.borderColor = UIColor.red.cgColor
            return false
        }
        else if (emailTest.evaluate(with: emailString) != true)
        {
            emailTxtF.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct Email", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            
            return false
        }
        else
        {
            return true
        }
        
    }
    func checkInternetConnection()
    {
        print("Executing check internet connection...")
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            webserviceToAddInsurance()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webserviceToAddInsurance()
    {
        var insureName: String = ""
        if (insureTypeTxt.text == "Other" || self.insuranceTypeId == "1") {
            insureName = insuranceNameTxtF.text!
        }
        let headers = [
            "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        var str: String = ""
        var message: String = ""
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        if self.isFromVC == true
        {
            str = String(format : "InsuranceId=%@&CustomInsuranceType=%@&InsuranceTypeId=%@&AccountNumber=%@&Email=%@&StartDate=%@&EndDate=%@&Phone=%@&Comment=%@&NotificationMail=%@",(self.details?.insuranceId)!,insureName,insuranceTypeId,accountNumTxtF.text!,emailTxtF.text!,startDateTxtF.text!,endDateTxtF.text!,phoneNumTxtF.text!,commentTxtF.text!,swtchData)
            message = "Insurance details has been updated successfully"
        }
        else
        {
            str = String(format : "PetId=%@&CustomInsuranceType=%@&InsuranceTypeId=%@&AccountNumber=%@&Email=%@&StartDate=%@&EndDate=%@&Phone=%@&Comment=%@&NotificationMail=%@",petId,insureName,insuranceTypeId,accountNumTxtF.text!,emailTxtF.text!,startDateTxtF.text!,endDateTxtF.text!,phoneNumTxtF.text!,commentTxtF.text!,swtchData)
            message = "Insurance details has been added successfully"
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
                            let alertDel = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
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
