//
//  HelpViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 18/11/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var medAsst:UIButton!
    @IBOutlet weak var payRefund:UIButton!
    @IBOutlet weak var econsult:UIButton!
    @IBOutlet weak var complaint:UIButton!
    @IBOutlet weak var others:UIButton!
    @IBOutlet weak var msgTxtView:UITextView!
    var helpStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        self.msgTxtView.delegate = self
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        self.msgTxtView.clipsToBounds = true
        self.msgTxtView.layer.cornerRadius = 15
        self.msgTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.msgTxtView.layer.borderWidth = 1.0
        
        self.medAsst.setImage(UIImage(named: "radio-on-button"), for: .selected)
        self.payRefund.setImage(UIImage(named: "radio-on-button"), for: .selected)
        self.econsult.setImage(UIImage(named: "radio-on-button"), for: .selected)
        self.complaint.setImage(UIImage(named: "radio-on-button"), for: .selected)
        self.others.setImage(UIImage(named: "radio-on-button"), for: .selected)
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func selectChoice(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.medAsst.isSelected = true
            self.medAsst.setImage(UIImage(named: "radio-on-button"), for: .selected)
            self.payRefund.isSelected = false
            self.econsult.isSelected = false
            self.complaint.isSelected = false
            self.others.isSelected = false
            self.helpStr = "Medical Assistance"
        }
        else if sender.tag == 2
        {
            self.payRefund.isSelected = true
            self.payRefund.setImage(UIImage(named: "radio-on-button"), for: .selected)
            self.medAsst.isSelected = false
            self.econsult.isSelected = false
            self.complaint.isSelected = false
            self.others.isSelected = false
            self.helpStr = "Payment & Refund"
        }
        else if sender.tag == 3
        {
            self.econsult.isSelected = true
            self.econsult.setImage(UIImage(named: "radio-on-button"), for: .selected)
            self.payRefund.isSelected = false
            self.medAsst.isSelected = false
            self.complaint.isSelected = false
            self.others.isSelected = false
            self.helpStr = "E-Consultation"
        }
        else if sender.tag == 4
        {
            self.complaint.isSelected = true
            self.complaint.setImage(UIImage(named: "radio-on-button"), for: .selected)
            self.medAsst.isSelected = false
            self.econsult.isSelected = false
            self.payRefund.isSelected = false
            self.others.isSelected = false
            self.helpStr = "Complaints"
        }
        else if sender.tag == 5
        {
            self.others.isSelected = true
            self.others.setImage(UIImage(named: "radio-on-button"), for: .selected)
            self.medAsst.isSelected = false
            self.econsult.isSelected = false
            self.complaint.isSelected = false
            self.payRefund.isSelected = false
            let alert = UIAlertController(title: "Others", message: "Please choose your relevant subject to proceed further", preferredStyle: .actionSheet)
            let medical = UIAlertAction(title: "Medical record", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.helpStr = "Medical record"
            })
            let app = UIAlertAction(title: "App related", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.helpStr = "App related"
            })
            let fedback = UIAlertAction(title: "Feedback", style: .default, handler: {(action: UIAlertAction) -> Void in
                self.helpStr = "Feedback"
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(medical)
            alert.addAction(app)
            alert.addAction(fedback)
            alert.addAction(cancel)
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @IBAction func sendFeedbackEmail(_ sender: UIButton)
    {
        if self.helpStr == nil && self.helpStr == "" && self.msgTxtView.text == nil && self.msgTxtView.text == ""
        {
            let alert = UIAlertController(title: "Warning !", message: "Please choose your relevant subject and enter your query", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        if self.helpStr == nil || self.helpStr == ""
        {
            let alert = UIAlertController(title: "Warning !", message: "Please choose your relevant subject", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        if self.msgTxtView.text == nil || self.msgTxtView.text == ""
        {
            let alert = UIAlertController(title: "Warning !", message: "Please enter your query", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        if !(self.helpStr == nil) && !(self.helpStr == "") && !(self.msgTxtView.text == nil) && !(self.msgTxtView.text == "")
        {
            self.checkInternetConnection()
        }
        
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("", comment: "")
            webServiceToSendEmail()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToSendEmail()
    {
        let headers: [String: String] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
        var str : String = String(format: "fullName=%@&emailId=%@&subject=%@&queryText=%@",UserDefaults.standard.string(forKey: "UserName")!,UserDefaults.standard.string(forKey: "UserEmail")!,self.helpStr,self.msgTxtView.text)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr: String = String(format: "%@?%@",API.Owner.help, str)
        let requestUrl = URL(string: urlStr)
        var request = URLRequest(url:requestUrl!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                // check for http errors
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
                            let alertDel = UIAlertController(title: "Done !", message: "Your query has been sent successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
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
