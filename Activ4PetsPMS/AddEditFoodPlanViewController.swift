//
//  AddEditFoodPlanViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditFoodPlanViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    var model: FoodPlanModel?
    
    @IBOutlet var foodName: UITextField!
    @IBOutlet var recomFood: UISwitch!
    @IBOutlet var forbidFood: UISwitch!
    @IBOutlet var comments: UITextView!
    
    @IBOutlet var mandatoryLbl: UILabel!
    var isRecomFood: String = "false"
    var isForbidFood: String = "false"
    var isFromVC: Bool = false
    var urlStr: String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.recomFood.tag = 1
        self.forbidFood.tag = 2
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        self.mandatoryLbl?.isHidden = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapG)
        
        self.recomFood?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        self.forbidFood?.addTarget(self, action:#selector(self.isSwitchOn), for: .valueChanged)
        
        
        self.foodName?.layer.masksToBounds = true
        self.foodName?.layer.borderWidth = 2
        self.foodName?.layer.cornerRadius = 3.0
        self.foodName?.layer.borderColor = UIColor.clear.cgColor
        
        self.urlStr = API.FoodPlan.FoodPlanAdd
        
        self.comments?.textColor = UIColor.lightGray
        self.comments?.text = "Enter comments"
        self.title = "Add Food Plan"
        if self.isFromVC == true
        {
            self.title = "Edit Food Plan"
            self.foodName.text = self.model?.foodName
            self.comments.text = self.model?.comment
            self.comments?.textColor = UIColor.black
            if self.model?.recomFood == true
            {
                self.recomFood.isOn = true
                self.isRecomFood = "true"
            }
            else
            {
                self.recomFood.isOn = false
                self.isRecomFood = "false"
            }
            
            if self.model?.forbidFood == true
            {
                self.forbidFood.isOn = true
                self.isForbidFood = "true"
            }
            else
            {
                self.forbidFood.isOn = false
                self.isForbidFood = "false"
            }
            
            
            self.urlStr = API.FoodPlan.FoodPlanEdit
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
        
        foodName?.resignFirstResponder()
        comments?.resignFirstResponder()
        
    }
    @objc func isSwitchOn(sender: UISwitch) -> Void
    {
        if sender.tag == 1
        {
            if (self.recomFood?.isOn)! {
                self.isRecomFood = "true"
            }
            else{
                self.isRecomFood = "false"
            }
        }
        else if sender.tag == 2
        {
            if (self.forbidFood?.isOn)! {
                self.isForbidFood = "true"
            }
            else{
                self.isForbidFood = "false"
            }
            
        }
    }
    
    @objc func submitDetails(_ sender: Any)
    {
        foodName?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.foodName?.text == nil || (self.foodName?.text == "")
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            self.foodName?.layer.borderColor = UIColor.red.cgColor
            
            self.mandatoryLbl?.isHidden = false
        }
        else
        {
            self.foodName?.layer.borderColor = UIColor.clear.cgColor
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
        let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
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
                message = "Food Plan has been updated successfully!"
                str = String(format: "foodplanId=%@&FoodName=%@&RecomendedFood=%@&ForbidenFood=%@&Comment=%@", (self.model?.foodId)!, self.foodName.text!, self.isRecomFood, self.isForbidFood, self.comments.text!)
            }
            else if self.isFromVC == false
            {
                message = "Food Plan has been added successfully!"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = String(format: "UserId=%@&PetId=%@&FoodName=%@&RecomendedFood=%@&ForbidenFood=%@&Comment=%@", userId,petId, self.foodName.text!, self.isRecomFood, self.isForbidFood, self.comments.text!)
                
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
                                        if (controller is FoodPlanListViewController)
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
