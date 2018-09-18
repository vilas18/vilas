//
//  AddMedicationViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditMedicationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate
{
    
    var model: MedicationModel?
    
    @IBOutlet var medicName: UITextField!
    @IBOutlet var reason: UITextField!
    @IBOutlet var status: UITextField!
    @IBOutlet var visitDate: UITextField!
    @IBOutlet var duration: UITextField!
    @IBOutlet var howOften: UITextField!
    @IBOutlet var dosage: UITextField!
    @IBOutlet var route: UITextField!
    @IBOutlet var veterinarian: UITextField!
    @IBOutlet var comments: UITextView!
    @IBOutlet var mandatoryLbl: UILabel!
    @IBOutlet var sendEmail: UISwitch!
    
    var datePicker = UIDatePicker()
    var listTv: UIPickerView!
    
    var listArr: [Any] = []
    var statusId: String = ""
    var sendEmailStr: String = "true"
    var dropDownType: String = ""
    var isFromVC: Bool = false
    
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
        
        self.visitDate?.isUserInteractionEnabled = true
        self.status?.isUserInteractionEnabled = true
        
        // self.listArr = ["Activ", "Discontinued", "Unknown"]
        self.duration.keyboardType = .numberPad
        self.medicName?.layer.masksToBounds = true
        self.medicName?.layer.borderWidth = 2
        self.medicName?.layer.cornerRadius = 3.0
        self.medicName?.layer.borderColor = UIColor.clear.cgColor
        
        self.duration?.layer.masksToBounds = true
        self.duration?.layer.borderWidth = 2
        self.duration?.layer.cornerRadius = 3.0
        self.duration?.layer.borderColor = UIColor.clear.cgColor
        
        self.visitDate?.layer.masksToBounds = true
        self.visitDate?.layer.borderWidth = 2
        self.visitDate?.layer.cornerRadius = 3.0
        self.visitDate?.layer.borderColor = UIColor.clear.cgColor
        
        self.sendEmail?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        
        self.comments?.textColor = UIColor.lightGray
        self.comments?.text = "Enter comments"
        
        
        self.urlStr = API.Medication.MedicationAdd
        self.title = "Add Medication"
        if self.isFromVC == true
        {
            self.title = "Edit Medication"
            self.medicName.text = self.model?.medicationName
            self.reason.text = self.model?.reason
            self.status.text = self.model?.status
            self.visitDate.text = self.model?.visitDate
            let df = DateFormatter()
            df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
            let date: Date = df.date(from: self.visitDate!.text!)!
            self.datePicker.date = date
            self.duration.text = self.model?.duration
            self.howOften.text = self.model?.howOften
            self.dosage.text = self.model?.dosage
            self.route.text = self.model?.route
            self.veterinarian.text = self.model?.veterinarian
            self.comments.text = self.model?.comments
            self.statusId = (self.model?.statusId)!
            self.comments?.textColor = UIColor.black
            if self.model?.sendReminder == true
            {
                self.sendEmail.isOn = true
                self.sendEmailStr = "true"
            }
            else
            {
                self.sendEmail.isOn = false
                self.sendEmailStr = "false"
            }
            
            self.urlStr = API.Medication.MedicationEdit
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func isSwitchOn(_ sender: UISwitch) -> Void
    {
        if (self.sendEmail?.isOn)!
        {
            self.sendEmailStr = "true"
        }
        else{
            self.sendEmailStr = "false"
        }
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        medicName?.resignFirstResponder()
        reason?.resignFirstResponder()
        status?.resignFirstResponder()
        visitDate?.resignFirstResponder()
        duration?.resignFirstResponder()
        howOften?.resignFirstResponder()
        dosage?.resignFirstResponder()
        route?.resignFirstResponder()
        veterinarian?.resignFirstResponder()
        comments?.resignFirstResponder()
        
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
                        let model = CommonResponseModel()
                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                        model.paramName = dict["Name"] as! String?
                        self.listArr.append(model)
                    }
                    
                    self.listTv?.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.listArr[indexPath.row] as? CommonResponseModel
        self.status.text = model?.paramName
        self.statusId = (model?.paramID)!
        self.status.resignFirstResponder()
    }
    
    @objc func submitDetails(_ sender: Any)
    {
        medicName?.resignFirstResponder()
        reason?.resignFirstResponder()
        status?.resignFirstResponder()
        visitDate?.resignFirstResponder()
        duration?.resignFirstResponder()
        howOften?.resignFirstResponder()
        dosage?.resignFirstResponder()
        route?.resignFirstResponder()
        veterinarian?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.medicName?.text == nil && (self.medicName?.text == "") && self.visitDate?.text == nil && (self.visitDate?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.medicName?.layer.borderColor = UIColor.red.cgColor
            self.visitDate?.layer.borderColor = UIColor.red.cgColor
            
            
            self.mandatoryLbl?.isHidden = false
        }
        
        if self.medicName?.text == nil || (self.medicName?.text == "")
        {
            self.medicName?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.medicName?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if self.visitDate?.text == nil || (self.visitDate?.text == "")
        {
            self.visitDate?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.visitDate?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        
        if !(self.medicName?.text == nil) && !(self.medicName?.text == "") && !(self.visitDate?.text == nil) && !(self.visitDate?.text == "")
        {
            self.mandatoryLbl?.isHidden = true
            checkInternetConnection()
            
        }
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpdateAdd()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webServiceToUpdateAdd()
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
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var str: String = ""
            var message: String = ""
            if self.comments.text == "Enter comments"
            {
                self.comments.text = ""
            }
            if self.isFromVC == true
            {
                message = "Medication details has been updated successfully"
                str = String(format: "MedicationId=%@&MedicationName=%@&Reason=%@&MedicationStatusId=%@&VisitDate=%@&Duration=%@&HowOften=%@&Dosage=%@&Route=%@&Veterinarian=%@&Comment=%@&Sendremindermail=%@", (self.model?.medicationId)!, self.medicName.text!, self.reason.text!, self.statusId, (self.visitDate?.text!)!, (self.duration?.text)!,self.howOften.text!, self.dosage.text!, self.route.text!, self.veterinarian.text!, self.comments.text, self.sendEmailStr)
            }
            else if self.isFromVC == false
            {
                message = "Medication details has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "UserId=%@&PetId=%@&MedicationName=%@&Reason=%@&MedicationStatusId=%@&VisitDate=%@&Duration=%@&HowOften=%@&Dosage=%@&Route=%@&Veterinarian=%@&Comment=%@&Sendremindermail=%@", userId, petId, self.medicName.text!, self.reason.text!, self.statusId, (self.visitDate?.text!)!, (self.duration?.text)!,self.howOften.text!, self.dosage.text!, self.route.text!, self.veterinarian.text!, self.comments.text, self.sendEmailStr)
                
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
                                    
                                    for controller: UIViewController in (self.navigationController?.viewControllers)!
                                    {
                                        if (controller is MedicationListViewController)
                                        {
                                            _ = self.navigationController?.popToViewController(controller, animated: true)
                                            
                                        }
                                    }
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
        
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == comments {
            comments?.text = ""
            comments?.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if comments?.text.count == 0
        {
            comments?.textColor = UIColor.lightGray
            comments?.text = "Enter comments"
            comments?.resignFirstResponder()
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
        if textField == self.status
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.duration
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
        else if textField == self.visitDate
        {
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
        else if textField == status
        {
            self.dropDownType = "MedicationStatus"
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
            if (dropDownType == "MedicationStatus")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                status?.text = model?.paramName
                self.statusId = (model?.paramID)!
            }
            self.status?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.status?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.status?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.visitDate?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.visitDate?.resignFirstResponder()
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem)
    {
        duration.resignFirstResponder()
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem)
    {
        duration.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.duration
        {
            if textField.text == nil || textField.text == ""
            {
                
            }
            else
            {
                let range: Int = Int(textField.text!)!
                
                if (textField.text?.count)! > 3 || range > 999
                {
                    duration?.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: "Warning", message: "Duration must be between 0 and 999", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true)
                }
                else
                {
                    duration?.layer.borderColor = UIColor.clear.cgColor
                }
            }
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
