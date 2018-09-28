//
//  PaidOnlineVetVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 19/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class PaidOnlineVetVC: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
    {
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var timeZone: UITextField!
    @IBOutlet weak var statetxt: UITextField!
    @IBOutlet weak var disclaimerBtn: UIButton!
    @IBOutlet weak var proceed: UIButton!
    var ok : Bool = true
    var countryId: String = "3"
    var stateId: String = ""
    var listArr = [Any]()
    var dropDownType: String = ""
    var textFld: UITextField?
    var model: MyProfileModel?
    var listTv: UIPickerView!
    var datePicker = UIDatePicker()
    var timeZoneId: String = ""
    var disclamairOk: Bool =  false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        listTv.delegate = self
        listTv.dataSource = self
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
         let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        self.title = "Ask a Vet Online"
        self.phoneTxt.isUserInteractionEnabled = true
        self.emailtxt.isUserInteractionEnabled = true
        prepareUI()
        // Do any additional setup after loading the view.
    }
       func prepareUI()
        {
            self.timeZone?.text = self.model?.timeZone
            let phone :  String = UserDefaults.standard.string(forKey:"UserPhoneNumber")! // handle it may come null ***
            let email: String = UserDefaults.standard.string(forKey: "UserEmail")!
            self.emailtxt.text = email
            self.phoneTxt.text = phone
            phoneTxt.layer.masksToBounds = true
            phoneTxt.layer.borderWidth = 2
            phoneTxt.layer.cornerRadius = 3.0
            phoneTxt.layer.borderColor = UIColor.clear.cgColor
            proceed.layer.masksToBounds = true
            proceed.layer.borderWidth = 2
            proceed.layer.cornerRadius = 3.0
            proceed.layer.borderColor = UIColor.clear.cgColor
            
            emailtxt.layer.masksToBounds = true
            emailtxt.layer.borderWidth = 2
            emailtxt.layer.cornerRadius = 3.0
            emailtxt.layer.borderColor = UIColor.clear.cgColor
            
            timeZone.layer.masksToBounds = true
            timeZone.layer.borderWidth = 2
            timeZone.layer.cornerRadius = 3.0
            timeZone.layer.borderColor = UIColor.clear.cgColor
            self.timeZone?.font = UIFont.systemFont(ofSize: 11.0)
            self.timeZone?.adjustsFontSizeToFitWidth = true
            
            statetxt.layer.masksToBounds = true
            statetxt.layer.borderWidth = 2
            statetxt.layer.cornerRadius = 3.0
            statetxt.layer.borderColor = UIColor.clear.cgColor
            
        }
    @objc func viewTouched()
    {
        self.statetxt.resignFirstResponder()
        self.timeZone.resignFirstResponder()
        self.emailtxt.resignFirstResponder()
        self.phoneTxt.resignFirstResponder()
    }
    @objc func leftClk(_ sender: Any)
        {
            navigationController?.popViewController(animated: true)
        }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
         return 1
        }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            return self.listArr.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row]
        return (model as AnyObject).paramName
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.phoneTxt
        {
            let newStr: NSString = textField.text! as NSString
            let currentString: String = newStr.replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 11
            {
                return false
            }
        }
        return true
    }
     func textFieldDidBeginEditing(_ textField: UITextField)
        {
            if textField == self.timeZone
            {
                self.textFld = textField
                dropDownType = "TimeZone"
                self.listArr = []
                self.listTv.reloadAllComponents() // crashes here
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
            else if textField == self.statetxt
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
            else if textField == self.phoneTxt
            {
                let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
                numberToolbar.barStyle = .blackTranslucent
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.cancelDropDownSelection))
                done.tag = textField.tag
                let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDropDownSelection))
                cancel.tag = textField.tag
                numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
                numberToolbar.sizeToFit()
                textField.inputAccessoryView = numberToolbar
            }
        }
    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool
    {
        let shouldDelete = true
        if (textField.text?.count ?? 0) == 0 && (textField.text == "") {
            let tagValue: Int = textField.tag - 1
            let txtField = view.viewWithTag(tagValue) as? UITextField
            txtField?.becomeFirstResponder()
        }
        return shouldDelete
    }
    @objc func changeTextFieldFocus(toNextTextField textField: UITextField)
    {
        let tagValue: Int = textField.tag + 1
        let txtField = view.viewWithTag(tagValue) as? UITextField
        txtField?.becomeFirstResponder()
    }
    
    @IBAction func disclmair1(_ sender: UIButton) {
        if sender.isSelected == true
        {
            self.disclaimerBtn.isSelected = false
            self.disclaimerBtn.setImage(UIImage(named: "ckbx_uncheked.png"), for: .normal)
            self.disclamairOk = true
        }
        else
        {
            self.disclaimerBtn.isSelected = true
            self.disclaimerBtn.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
            self.disclamairOk = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
        @objc func doneDropDownSelection()
        {
            if listArr.count > 0
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                if (dropDownType == "TimeZone")
                {
                    timeZone?.text = model?.paramName
                    timeZoneId = (model?.paramID)!
                }
                else if (dropDownType == "State")
                {
                    statetxt?.text = model?.paramName
                    stateId = (model?.paramID)!
//                    stateCountryID = (model?.paramSubID)!
                }
                self.textFld?.resignFirstResponder()
                self.view.endEditing(true)
            }
        }
       @objc func cancelDropDownSelection()
        {
            self.view.endEditing(true)
            self.textFld?.resignFirstResponder()
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
                        print(detailsArr)
                        for dict in detailsArr
                        {
                            if (self.dropDownType == "TimeZone") {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                self.listArr.append(model)
                            }
                            else if (self.dropDownType == "State")
                            {
                                let model = CommonResponseModel()
                                if self.countryId != "" && self.countryId == dict["ConversationId"] as! String 
                                {
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
    
      @IBAction func proceed(_ sender: Any)
        {
            doValidationsForUpdateDetails()
        }
       func doValidationsForUpdateDetails()
       {
        if emailtxt.text == nil || (emailtxt.text == "")
        {
            if emailtxt.text != nil && emailtxt.text != ""
            {
                emailtxt.text = emailtxt.text?.lowercased()
            }
            let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            if emailTest.evaluate(with: emailtxt.text) == false
            {
                emailtxt.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: nil, message: "Please Enter Valid Email Address.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            else
            {
                emailtxt.layer.borderColor = UIColor.clear.cgColor
            }
            if phoneTxt.text == nil || (phoneTxt.text == "")
            {
                let alert = UIAlertController(title: "Warning", message: "Please enter your contact number", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                phoneTxt.layer.borderColor = UIColor.red.cgColor
                present(alert, animated: true)
            }
            else
            {
                phoneTxt.layer.borderColor = UIColor.clear.cgColor
            }
        
        if timeZone.text == nil || (timeZone.text == "")
        {
            let alert = UIAlertController(title: "Warning", message: "Please choose your time zone", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            timeZone.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true)
        }
        else
        {
            timeZone.layer.borderColor = UIColor.clear.cgColor
        }
            if statetxt.text == nil || (statetxt.text == "")
            {
                let alert = UIAlertController(title: "Warning", message: "Please enter your state", preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                statetxt.layer.borderColor = UIColor.red.cgColor
                present(alert, animated: true)
            }
            else{
                statetxt.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else
        {
            emailtxt.layer.borderColor = UIColor.clear.cgColor
            statetxt.layer.borderColor = UIColor.clear.cgColor
            timeZone.layer.borderColor = UIColor.clear.cgColor
            phoneTxt.layer.borderColor = UIColor.clear.cgColor
            let vetlist : VetListVC = self.storyboard?.instantiateViewController(withIdentifier: "vetlist") as! VetListVC
            self.navigationController?.pushViewController(vetlist, animated: true)
            let vc = FinalConfirmationVC()
            vc.email = self.emailtxt.text
            vc.phone = self.phoneTxt.text
            vc.state = self.statetxt.text
            vc.stateid = stateId
            vetlist.timeZoneId = timeZoneId
        }
    }

      func doValidationsForTextFields() -> Bool
        {
            let contactNumberString: String = phoneTxt!.text!
            let emailString: String = emailtxt!.text!
            let emailReg: String = "^\\s*$|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
            let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
            if (phoneTxt?.text?.count)! > 0 && (numberTest.evaluate(with: contactNumberString) != true)
            {
                let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter correct primary phone number", comment: ""), preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                phoneTxt?.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else if (emailtxt?.text?.count)! > 0 && (emailTest.evaluate(with: emailString) != true)
            {
                let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter a valid email", comment: ""), preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                emailtxt?.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else
            {
                emailtxt?.layer.borderColor = UIColor.lightGray.cgColor
                phoneTxt?.layer.borderColor = UIColor.lightGray.cgColor
                return true
            }
        }
    func textFieldDidEndEditing(_ textField: UITextField)
        {
            if textField == emailtxt
            {
                if textField.text?.count == 0
                {
                    print("email is correct...")
                }
                else
                {
                    let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
                    if emailTest.evaluate(with: emailtxt?.text) == false {
                    textField.layer.borderColor = UIColor.red.cgColor
                    }
                    else
                    {
                        textField.layer.borderColor = UIColor.clear.cgColor
                        self.textFld = emailtxt
                    }
                }
            }
//            else if textField == phoneTxt
//            {
//                if textField.text?.count == 0
//                {
//                    print("Nmber is correct...")
//                }
//                else
//                {
//                    let numberReg: String = "^[(]?[1-9][0-9]{2}[)]?[ -]?[0-9]{3}[ -]?[0-9]{4}$"
//                    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberReg)
//                    if numberTest.evaluate(with: textField.text) == false
//                    {
//                        textField.layer.borderColor = UIColor.red.cgColor
//                    }
//                    else
//                    {
//                        textField.layer.borderColor = UIColor.clear.cgColor
//                        self.textFld = phoneTxt
//                        print("Nmber is correct...")
//                    }
//                }
//            }
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
