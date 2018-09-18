//
//  AddEditConsultationViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditConsultationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    var model: ConsultationModel?
    
    @IBOutlet var consultName: UITextField!
    @IBOutlet var visitDate: UITextField!
    @IBOutlet var reason: UITextField!
    @IBOutlet var comments: UITextView!
    
    @IBOutlet var mandatoryLbl: UILabel!
    
    var datePicker = UIDatePicker()
    
    
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
        
        self.visitDate?.isUserInteractionEnabled = true
        
        self.consultName?.layer.masksToBounds = true
        self.consultName?.layer.borderWidth = 2
        self.consultName?.layer.cornerRadius = 3.0
        self.consultName?.layer.borderColor = UIColor.clear.cgColor
        
        self.visitDate?.layer.masksToBounds = true
        self.visitDate?.layer.borderWidth = 2
        self.visitDate?.layer.cornerRadius = 3.0
        self.visitDate?.layer.borderColor = UIColor.clear.cgColor
        
        self.urlStr = API.Consultation.ConsultationAdd
        
        self.comments?.textColor = UIColor.lightGray
        self.comments?.text = "Enter comments"
        self.title = "Add Consultation"
        if self.isFromVC == true
        {
            self.title = "Edit Consultation"
            self.consultName.text = self.model?.consultName
            self.visitDate.text = self.model?.visitDate
            let df = DateFormatter()
            df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
            let date: Date = df.date(from: self.visitDate!.text!)!
            self.datePicker.date = date
            self.reason.text = self.model?.reason
            self.comments.text = self.model?.comment
            self.comments?.textColor = UIColor.black
            
            self.urlStr = API.Consultation.ConsultationEdit
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        consultName?.resignFirstResponder()
        visitDate?.resignFirstResponder()
        reason?.resignFirstResponder()
        comments?.resignFirstResponder()
        
    }
    //    @IBAction func dateClk(_ sender: UIButton)
    //    {
    //        consultName?.resignFirstResponder()
    //        visitDate?.resignFirstResponder()
    //        reason?.resignFirstResponder()
    //        comments?.resignFirstResponder()
    //
    //
    //            self.dateView?.frame = CGRect.init(x: (self.dateView?.frame.origin.x)!, y: (self.visitDate?.frame.origin.y)! + (self.visitDate?.frame.size.height)!, width: (self.dateView?.frame.size.width)!, height: (self.dateView?.frame.size.height)!)
    //            self.datePicker.maximumDate = NSDate() as Date
    //
    //            if (dateView?.isHidden)! {
    //                dateView?.isHidden = false
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //            else {
    //                dateView?.isHidden = true
    //                let df = DateFormatter()
    //                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //                if visitDate.text == nil || visitDate.text == ""
    //                {
    //                    self.visitDate?.text = df.string(from: (datePicker?.date)!)
    //                }
    //
    //                datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //            }
    //
    //    }
    //
    //    @objc func dateChange(_ sender: UIDatePicker)
    //    {
    //        let df = DateFormatter()
    //        df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //        self.visitDate?.text = "\(df.string(from: (datePicker?.date)!))"
    //        visitDate?.resignFirstResponder()
    //    }
    
    
    @objc func submitDetails(_ sender: Any)
    {
        consultName?.resignFirstResponder()
        visitDate?.resignFirstResponder()
        reason?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.consultName?.text == nil && (self.consultName?.text == "") && self.visitDate?.text == nil && (self.visitDate?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.consultName?.layer.borderColor = UIColor.red.cgColor
            self.visitDate?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        
        if self.consultName?.text == nil || (self.consultName?.text == "")
        {
            self.consultName?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.consultName?.layer.borderColor = UIColor.clear.cgColor
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
        if !(self.consultName?.text == nil) && !(self.consultName?.text == "") && !(self.visitDate?.text == nil) && !(self.visitDate?.text == "")
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
                message = "Consultation details has been updated successfully"
                str = String(format: "consultationId=%@&ConsultationName=%@&VisitDate=%@&Reason=%@&Comment=%@", (self.model?.consultId)!, self.consultName.text!, self.visitDate.text!, self.reason.text!, self.comments.text!)
            }
            else if self.isFromVC == false
            {
                message = "Consultation details has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "UserId=%@&PetId=%@&ConsultationName=%@&VisitDate=%@&Reason=%@&Comment=%@", userId,petId, self.consultName.text!, self.visitDate.text!, self.reason.text!, self.comments.text!)
                
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
                                        if (controller is ConsultationListViewController)
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
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.visitDate
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
