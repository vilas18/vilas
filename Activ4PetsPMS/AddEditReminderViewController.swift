//
//  AddEditReminderViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 05/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditReminderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    var isFromVC: Bool!
    var model: ReminderModel?
    var urlStr: String = ""
    var list = [String]()
    
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var vet: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var comment: UITextView!
    
    
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var mandatoryLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.rightClk))
        navigationItem.rightBarButtonItem = rightItem
        self.list = ["DAILY", "WEEKLY", "MONTHLY", "YEARLY", "NONE"]
        self.comment.delegate = self
        self.urlStr = API.Reminders.ReminderAdd
        //        self.datePicker.minimumDate = Date()
        
        self.date.isUserInteractionEnabled = true
        self.time.isUserInteractionEnabled = true
        
        reason.layer.masksToBounds = true
        reason.layer.borderWidth = 2
        reason.layer.cornerRadius = 3.0
        reason.layer.borderColor = UIColor.clear.cgColor
        
        date.layer.masksToBounds = true
        date.layer.borderWidth = 2
        date.layer.cornerRadius = 3.0
        date.layer.borderColor = UIColor.clear.cgColor
        
        time.layer.masksToBounds = true
        time.layer.borderWidth = 2
        time.layer.cornerRadius = 3.0
        time.layer.borderColor = UIColor.clear.cgColor
        comment.textColor = UIColor.lightGray
        comment.text = "Enter comments"
        comment.resignFirstResponder()
        
        if self.isFromVC == true
        {
            self.reason.text = self.model?.reason
            self.vet.text = self.model?.vet
            self.date.text = self.model?.date
            self.time.text = self.model?.time
            self.comment.text = self.model?.comments
            comment.textColor = UIColor.black
            self.urlStr = API.Reminders.ReminderEdit
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightClk(_ sender: Any)
    {
        self.reason.resignFirstResponder()
        self.vet.resignFirstResponder()
        self.date.resignFirstResponder()
        self.time.resignFirstResponder()
        self.comment.resignFirstResponder()
        
        
        doValidationForAddEditReminder()
    }
    //    @IBAction func selectDate(_ sender: UIButton)
    //    {
    //        self.reason.resignFirstResponder()
    //        self.vet.resignFirstResponder()
    //
    //        self.date.resignFirstResponder()
    //        self.time.resignFirstResponder()
    //        self.comment.resignFirstResponder()
    //
    //        if dateView.isHidden
    //        {
    //            dateView.isHidden = false
    //            datePicker.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //        }
    //        else
    //        {
    //            dateView.isHidden = true
    //            let formater = DateFormatter()
    //            formater.dateFormat = "MM/dd/yyyy"
    //            if self.date.text == nil || self.date.text == ""
    //            {
    //                self.date.text = formater.string(from: self.dateTimePicker.date)
    //            }
    //            datePicker.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //        }
    //    }
    //    @objc func dateChange(_ sender: Any)
    //    {
    //        let formater = DateFormatter()
    //        formater.dateFormat = "MM/dd/yyyy"
    //        self.date.text = formater.string(from: self.datePicker.date)
    //    }
    //    @IBAction func selectTime(_ sender: UIButton)
    //    {
    //        self.reason.resignFirstResponder()
    //        self.vet.resignFirstResponder()
    //        self.date.resignFirstResponder()
    //        self.time.resignFirstResponder()
    //        self.comment.resignFirstResponder()
    //
    //        self.dateTimePicker.datePickerMode = .time
    //
    //        if timeView.isHidden {
    //            timeView.isHidden = false
    //            dateTimePicker.addTarget(self, action: #selector(self.timeChange), for: .valueChanged)
    //        }
    //        else {
    //            timeView.isHidden = true
    //
    //            let formater = DateFormatter()
    //            formater.dateFormat = "hh:mm a"
    //            if self.time.text == nil || self.time.text == ""
    //            {
    //                self.time.text = formater.string(from: self.dateTimePicker.date)
    //            }
    //            dateTimePicker.addTarget(self, action: #selector(self.timeChange), for: .valueChanged)
    //        }
    //    }
    //    @objc func timeChange(_ sender: Any)
    //    {
    //        let formater = DateFormatter()
    //        formater.dateFormat = "hh:mm a"
    //        self.time.text = formater.string(from: self.dateTimePicker.date)
    //
    //    }
    
    func doValidationForAddEditReminder()
    {
        if self.reason.text == nil && self.reason.text == "" && self.date.text == nil && self.date.text == "" && self.time.text == nil && self.time.text == ""
        {
            self.reason.layer.borderColor = UIColor.red.cgColor
            self.date.layer.borderColor = UIColor.red.cgColor
            self.time.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.reason.text == nil || self.reason.text == ""
        {
            self.reason.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.reason.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.time.text == nil || self.time.text == ""
        {
            self.time.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.time.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        if self.date.text == nil || self.date.text == ""
        {
            self.date.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl.isHidden = false
        }
        else{
            self.date.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl.isHidden = false
        }
        
        if !(self.reason.text == nil) && !(self.reason.text == "") && !(self.date.text == nil) && !(self.date.text == "") && !(self.time.text == nil) && !(self.time.text == "")
        {
            self.mandatoryLbl.isHidden = true
            self.checkInternetConnection()
        }
    }
    func checkInternetConnection() {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            webServiceToAddEditRem()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToAddEditRem()
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
            let dateStr = String(format: "%@ %@", self.date.text!, self.time.text!)
            if self.comment.text == "Enter comments"
            {
                self.comment.text = ""
            }
            if self.isFromVC == true
            {
                
                message = "Reminder has been updated successfully"
                str = String(format : "ReminderId=%@&Reason=%@&Date=%@&Physician=%@&Comment=%@", (self.model?.id)!, self.reason!.text!, dateStr, (self.vet?.text)!, (self.comment?.text)! )
            }
            else if self.isFromVC == false
            {
                message = "Reminder has been added successfully"
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                str = String(format : "UserId=%@&Reason=%@&Date=%@&Physician=%@&Comment=%@", userId, self.reason!.text!, dateStr, (self.vet?.text)!, (self.comment?.text)!)
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
                    if status == 1
                    {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alertDel = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            if self.isFromVC == false
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                for controller: UIViewController in (self.navigationController?.viewControllers)!
                                {
                                    if (controller is RemindersListViewController)
                                    {
                                        _ = self.navigationController?.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }
                        })
                        
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            task.resume()
        }
    }
    func textViewDidChange(_ textView: UITextView)
    {
        if comment.text.count == 0
        {
            comment.textColor = UIColor.black
            comment.text = "Enter comments"
            comment.resignFirstResponder()
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == comment {
            comment.text = ""
            comment.textColor = UIColor.black
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.date
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
            date.inputAccessoryView = toolbar
            date.inputView = datePicker
        }
        else if textField == self.time
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
            time.inputAccessoryView = toolbar
            time.inputView = datePicker
        }
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.date.resignFirstResponder()
    }
    @objc func doneTimePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        time.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker()
    {
        self.view.endEditing(true)
        self.time.resignFirstResponder()
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
