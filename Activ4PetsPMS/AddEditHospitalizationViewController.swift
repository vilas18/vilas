//
//  AddEditHospitalizationViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditHospitalizationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    var model: HospitalizationModel?
    
    @IBOutlet var hospName: UITextField!
    @IBOutlet var reason: UITextField!
    @IBOutlet var admitDate: UITextField!
    @IBOutlet var endDate: UITextField!
    @IBOutlet var comments: UITextView!
    @IBOutlet var mandatoryLbl: UILabel!
    @IBOutlet var urgentCare: UISwitch!
    var selectedTextFld: UITextField?
    var datePicker = UIDatePicker()
    var dateSelect: String = ""
    
    
    var urgentCareStr: String = "true"
    
    var isFromVC: Bool = false
    
    var urlStr: String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        
        self.mandatoryLbl?.isHidden = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapG)
        
        self.admitDate?.isUserInteractionEnabled = true
        self.endDate?.isUserInteractionEnabled = false
        
        self.hospName?.layer.masksToBounds = true
        self.hospName?.layer.borderWidth = 2
        self.hospName?.layer.cornerRadius = 3.0
        self.hospName?.layer.borderColor = UIColor.clear.cgColor
        
        self.reason?.layer.masksToBounds = true
        self.reason?.layer.borderWidth = 2
        self.reason?.layer.cornerRadius = 3.0
        self.reason?.layer.borderColor = UIColor.clear.cgColor
        
        
        self.urgentCare?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        
        self.comments?.textColor = UIColor.lightGray
        self.comments?.text = "Enter comments"
        
        
        self.urlStr = API.Hospitalization.HospitalizationAdd
        self.title = "Add Hospitalization"
        if self.isFromVC == true
        {
            self.title = "Edit Hospitalization"
            self.hospName.text = self.model?.hospName
            self.reason.text = self.model?.reason
            self.admitDate.text = self.model?.admitDate
            if admitDate?.text != nil && admitDate?.text != ""
            {
                self.endDate?.isUserInteractionEnabled = true
            }
            self.endDate.text = self.model?.endDate
            
            self.comments.text = self.model?.comments
            self.comments?.textColor = UIColor.black
            if self.model?.urgentCare == true
            {
                self.urgentCare.isOn = true
                self.urgentCareStr = "true"
            }
            else
            {
                self.urgentCare.isOn = false
                self.urgentCareStr = "false"
            }
            
            self.urlStr = API.Hospitalization.HospitalizationEdit
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func isSwitchOn(sender: UISwitch) -> Void
    {
        
        if (self.urgentCare?.isOn)! {
            self.urgentCareStr = "true"
        }
        else{
            self.urgentCareStr = "false"
        }
        
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        hospName?.resignFirstResponder()
        reason?.resignFirstResponder()
        admitDate?.resignFirstResponder()
        endDate?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        // self.dateView.isHidden = true
        
    }
    //    @IBAction func dateClk(_ sender: UIButton)
    //    {
    //        hospName?.resignFirstResponder()
    //        reason?.resignFirstResponder()
    //        admitDate?.resignFirstResponder()
    //        endDate?.resignFirstResponder()
    //        comments?.resignFirstResponder()
    //
    //        
    //        
    //        if sender.tag == 1
    //        {
    //            self.dateView?.frame = CGRect.init(x: (self.admitDate?.frame.origin.x)!, y: (self.admitDate?.frame.origin.y)! + (self.admitDate?.frame.size.height)!, width: (self.dateView?.frame.size.width)!, height: (self.dateView?.frame.size.height)!)
    //            self.dateSelect="start"
    //            self.datePicker.maximumDate = NSDate() as Date
    //            
    //            if (dateView?.isHidden)!
    //            {
    //                dateView?.isHidden = false
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //            else {
    //                dateView?.isHidden = true
    //                let df = DateFormatter()
    //                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //                if admitDate.text == nil || admitDate.text == ""
    //                {
    //                    self.admitDate?.text = df.string(from: (datePicker?.date)!)
    //                }
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //        }
    //        else if sender.tag == 2
    //        {
    //            self.dateView?.frame = CGRect.init(x: (self.endDate?.frame.origin.x)!, y: (self.endDate?.frame.origin.y)! + (self.endDate?.frame.size.height)!, width: (self.dateView?.frame.size.width)!, height: (self.dateView?.frame.size.height)!)
    //            self.dateSelect="end"
    //            if (dateView?.isHidden)! {
    //                dateView?.isHidden = false
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //            else {
    //                dateView?.isHidden = true
    //                let df = DateFormatter()
    //                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //                if endDate.text == nil || endDate.text == ""
    //                {
    //                    self.endDate?.text = df.string(from: (datePicker?.date)!)
    //                }
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //        }
    //    }
    //    @objc func dateChange(_ sender: UIDatePicker)
    //    {
    //        let df = DateFormatter()
    //        df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //        if (self.dateSelect == "start")
    //        {
    //            self.admitDate?.text = "\(df.string(from: (datePicker?.date)!))"
    //            self.datePicker.minimumDate = datePicker.date
    //            self.dateView.isHidden = true
    //        }
    //        else if (self.dateSelect == "end")
    //        {
    //            endDate?.text = "\(df.string(from: (datePicker?.date)!))"
    //            self.dateView.isHidden = true
    //        }
    //    }
    
    
    
    @objc func submitDetails(_ sender: Any)
    {
        hospName?.resignFirstResponder()
        reason?.resignFirstResponder()
        admitDate?.resignFirstResponder()
        endDate?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.hospName?.text == nil && (self.hospName?.text == "") && self.reason?.text == nil && (self.reason?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.hospName?.layer.borderColor = UIColor.red.cgColor
            self.reason?.layer.borderColor = UIColor.red.cgColor
            
            
            self.mandatoryLbl?.isHidden = false
        }
        
        if self.hospName?.text == nil || (self.hospName?.text == "")
        {
            self.hospName?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.hospName?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if self.reason?.text == nil || (self.reason?.text == "")
        {
            self.reason?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.reason?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if !(self.hospName?.text == nil) && !(self.hospName?.text == "") && !(self.reason?.text == nil) && !(self.reason?.text == "")
        {
            self.mandatoryLbl?.isHidden = true
            checkInternetConnection()
            
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
                message = "Hospitalization details has been updated successfully"
                str = String(format: "hospitalizationId=%@&HospitalName=%@&Reason=%@&AdmissionDate=%@&EndDate=%@&Comment=%@&UrgentCareVisit=%@", (self.model?.hospId)!, self.hospName.text!, self.reason.text!, self.admitDate.text!, (self.endDate?.text!)!, self.comments.text, self.urgentCareStr)
            }
            else if self.isFromVC == false
            {
                message = "Hospitalization details has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "UserId=%@&PetId=%@&HospitalName=%@&Reason=%@&AdmissionDate=%@&EndDate=%@&Comment=%@&UrgentCareVisit=%@", userId,petId, self.hospName.text!, self.reason.text!, self.admitDate.text!, (self.endDate?.text!)!, self.comments.text, self.urgentCareStr)
                
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
                                        if (controller is HospitalizationsListViewController)
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
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
            
        }
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.admitDate
        {
            if admitDate?.text == nil || admitDate?.text == ""
            {
                self.endDate?.isUserInteractionEnabled = false
            }
            else
            {
                self.endDate?.isUserInteractionEnabled = true
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.admitDate
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
            if admitDate?.text != nil && admitDate.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: self.admitDate!.text!)!
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
