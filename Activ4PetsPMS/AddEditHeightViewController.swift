//
//  AddEditHeightViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 10/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditHeightViewController: UIViewController, UITextFieldDelegate
{
    
    var model: VitalsCommonModel?
    @IBOutlet var measureDate: UITextField!
    @IBOutlet var feet: UITextField!
    @IBOutlet var inches: UITextField!
    
    var datePicker = UIDatePicker()
    
    @IBOutlet var mandatoryLbl: UILabel!
    
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
        
        self.measureDate?.isUserInteractionEnabled = true
        
        self.measureDate?.layer.masksToBounds = true
        self.measureDate?.layer.borderWidth = 2
        self.measureDate?.layer.cornerRadius = 3.0
        self.measureDate?.layer.borderColor = UIColor.clear.cgColor
        
        self.feet?.layer.masksToBounds = true
        self.feet?.layer.borderWidth = 2
        self.feet?.layer.cornerRadius = 3.0
        self.feet?.layer.borderColor = UIColor.clear.cgColor
        
        self.inches?.layer.masksToBounds = true
        self.inches?.layer.borderWidth = 2
        self.inches?.layer.cornerRadius = 3.0
        self.inches?.layer.borderColor = UIColor.clear.cgColor
        
        self.urlStr = API.Vitals.VitalsAdd
        self.feet.tag = 1
        self.inches.tag = 2
        
        
        if self.isFromVC == true
        {
            self.measureDate.text = self.model?.measureDate
            let df = DateFormatter()
            df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
            let date: Date = df.date(from: self.measureDate!.text!)!
            self.datePicker.date = date
            let str: String = self.model!.value1!
            let list: [String] = str.split(separator: " ").map(String.init)
            self.feet.text = list[0]
            if list.count > 2
            {
                self.inches.text = list[2]
            }
            else
            {
                self.inches.text = "0"
            }
            
            
            self.urlStr = API.Vitals.VitalsEdit
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
        
        measureDate?.resignFirstResponder()
        feet?.resignFirstResponder()
        inches?.resignFirstResponder()
        
    }
    //    @IBAction func dateClk(_ sender: UIButton)
    //    {
    //        measureDate?.resignFirstResponder()
    //        feet?.resignFirstResponder()
    //        inches?.resignFirstResponder()
    //
    //        self.datePicker.maximumDate = NSDate() as Date
    //
    //        if (dateView?.isHidden)!
    //        {
    //            dateView?.isHidden = false
    //            datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //        }
    //        else
    //        {
    //            dateView?.isHidden = true
    //            let df = DateFormatter()
    //            df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //            if measureDate.text == nil || measureDate.text == ""
    //            {
    //                self.measureDate?.text = df.string(from: (datePicker?.date)!)
    //            }
    //
    //            datePicker?.addTarget(self, action: #selector(self.dateChange), for: .valueChanged)
    //        }
    //    }
    //
    //    @objc func dateChange(_ sender: UIDatePicker)
    //    {
    //        let df = DateFormatter()
    //        df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
    //
    //        self.measureDate?.text = "\(df.string(from: (datePicker?.date)!))"
    //    }
    
    @objc func submitDetails(_ sender: Any)
    {
        measureDate?.resignFirstResponder()
        feet?.resignFirstResponder()
        inches?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.measureDate?.text == nil && (self.measureDate?.text == "") && self.feet?.text == nil && (self.feet?.text == "") && self.inches?.text == nil && (self.inches?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.measureDate?.layer.borderColor = UIColor.red.cgColor
            self.feet?.layer.borderColor = UIColor.red.cgColor
            self.inches?.layer.borderColor = UIColor.red.cgColor
            
            self.mandatoryLbl?.isHidden = false
        }
        
        if self.measureDate?.text == nil || (self.measureDate?.text == "")
        {
            self.measureDate?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.measureDate?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if self.feet?.text == nil || (self.feet?.text == "")
        {
            self.feet?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.feet?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if self.inches?.text == nil || (self.inches?.text == "")
        {
            self.inches?.layer.borderColor = UIColor.red.cgColor
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.inches?.layer.borderColor = UIColor.clear.cgColor
            self.mandatoryLbl?.isHidden = false
            
        }
        
        if !(self.measureDate?.text == nil) && !(self.measureDate?.text == "") && !(self.feet?.text == nil) && !(self.feet?.text == "") && !(self.inches?.text == nil) && !(self.inches?.text == "")
        {
            self.mandatoryLbl?.isHidden = true
            
            if doValidationForHeightFt()
            {
                if doValidationForHeightIn()
                {
                    checkInternetConnection()
                }
            }
            
            
        }
    }
    func doValidationForHeightFt() -> Bool
    {
        if  (feet.text?.count)! > 0
        {
            
            let range: Int = Int(feet.text!)!
            
            if (feet.text?.count)! > 2 || range > 49
            {
                feet?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Height must be between 0 and 49 ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
                
                return false
            }
            else
            {
                feet?.layer.borderColor = UIColor.clear.cgColor
            }
            
        }
        return true
    }
    func doValidationForHeightIn() -> Bool
    {
        if (inches.text?.count)! > 0
        {
            
            let range: Int = Int(inches.text!)!
            
            if (inches.text?.count)! > 2 || range > 11
            {
                inches?.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Height must be between 0 and 11 ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
                return false
            }
            else
            {
                inches?.layer.borderColor = UIColor.clear.cgColor
            }
            
        }
        return true
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
            if self.isFromVC == true
            {
                message = "Height details has been updated successfully"
                str = String(format: "HMTID=%@&HMT_TypeId=%@&HMT_UnitId=%@&MeasuredDate=%@&LeftValue=%@&RightValue=%@", (self.model?.commonId)!, "1", "10", self.measureDate.text!, self.feet.text!, self.inches.text!)
            }
            else if self.isFromVC == false
            {
                message = "Height details has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "UserId=%@&PetId=%@&HMT_TypeId=%@&HMT_UnitId=%@&MeasuredDate=%@&LeftValue=%@&RightValue=%@", userId,petId, "1", "10", self.measureDate.text!, self.feet.text!, self.inches.text!)
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
                                    
                                    _ = self.navigationController?.popViewController(animated: true)
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
        if textField == feet || textField == inches
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
        else if textField == self.measureDate
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
        self.measureDate?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.measureDate?.resignFirstResponder()
    }
    @objc func cancelNumberPad(_ item: UIBarButtonItem)
    {
        if item.tag == 1
        {
            feet.resignFirstResponder()
        }
        else if item.tag == 2
        {
            inches.resignFirstResponder()
        }
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem)
    {
        if item.tag == 1
        {
            feet.resignFirstResponder()
        }
        else if item.tag == 2 {
            inches.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == feet
        {
            if textField.text == nil || textField.text == ""
            {
                
            }
            else{
                let range: Int = Int(textField.text!)!
                
                if (textField.text?.count)! > 2 || range > 49
                {
                    feet?.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: "Warning", message: "Height must be between 0 and 49 ", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true) 
                }
                else
                {
                    feet?.layer.borderColor = UIColor.clear.cgColor
                }
            }
            
        }
        else if textField == inches
        {
            if textField.text == nil || textField.text == ""
            {
                
            }
            else
            {
                let range: Int = Int(textField.text!)!
                
                if (textField.text?.count)! > 2 || range > 11
                {
                    inches?.layer.borderColor = UIColor.red.cgColor
                    let alert = UIAlertController(title: "Warning", message: "Height must be between 0 and 11 ", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    present(alert, animated: true) 
                }
                else
                {
                    inches?.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == feet || textField == inches
        {
            let newStr: NSString = textField.text! as NSString
            let currentString: String = newStr.replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count)
            if length > 2 {
                return false
            }
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
