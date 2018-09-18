//
//  RenewPlanViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 24/01/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class RenewPlanViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    var model: MyPlanModel?
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var creditCardType: UITextField!
    @IBOutlet weak var creditCardNo: UITextField!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    var commonTv: UIPickerView!
    var datePicker: UIPickerView!
    @IBOutlet weak var mandatoryLbl: UILabel!
    @IBOutlet weak var planNameLbl: UILabel!
    @IBOutlet weak var priceNameLbl: UILabel!
    var txtFld: UITextField?
    
    var cardTypeArr = [Any]()
    var listArr = [Any]()
    var dropDownType: String = ""
    var cardTypeId: String = ""
    var countryId: String = ""
    var stateId: String = ""
    var stateCountryID: String = ""
    var monthList : [String] = []
    var yearList : [String] = []
    var month: String = ""
    var year: String = ""
    var paymentDate: String = ""
    var paymentRefNo: String = ""
    var paymentCharged: String = ""
    var paymentMsg: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.commonTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        commonTv.delegate = self
        commonTv.dataSource = self
        self.commonTv.tag = 1
        self.datePicker = UIPickerView.init(frame: CGRect(x:0, y:0, width: 0, height:220))
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        mandatoryLbl.isHidden = true
        zipCode.keyboardType = .numberPad
        creditCardType.isUserInteractionEnabled = true
        country.isUserInteractionEnabled = true
        state.isUserInteractionEnabled = true
        expiryDate.isUserInteractionEnabled = true
        creditCardNo.tag = 1
        cvv.tag = 2
        zipCode.tag = 3
        cardTypeArr = ["Discover", "JCB Card", "Master Card", "Visa"]
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        self.monthList = ["01","02","03","04", "05","06", "07", "08", "09", "10", "11", "12"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let i2 = Int(formatter.string(from: Date())) ?? 0
        for i in i2...(i2+50)
        {
            self.yearList.append(String(format: "%d", i))
        }
        self.countryId = "3"
        self.country.text = "United States"
        self.datePicker.reloadAllComponents()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        creditCardType.layer.masksToBounds = true
        creditCardType.layer.borderWidth = 2
        creditCardType.layer.cornerRadius = 3.0
        creditCardType.layer.borderColor = UIColor.clear.cgColor
        
        creditCardNo.layer.masksToBounds = true
        creditCardNo.layer.borderWidth = 2
        creditCardNo.layer.cornerRadius = 3.0
        creditCardNo.layer.borderColor = UIColor.clear.cgColor
        
        expiryDate.layer.masksToBounds = true
        expiryDate.layer.borderWidth = 2
        expiryDate.layer.cornerRadius = 3.0
        expiryDate.layer.borderColor = UIColor.clear.cgColor
        
        cvv.layer.masksToBounds = true
        cvv.layer.borderWidth = 2
        cvv.layer.cornerRadius = 3.0
        cvv.layer.borderColor = UIColor.clear.cgColor
        
        address1.layer.masksToBounds = true
        address1.layer.borderWidth = 2
        address1.layer.cornerRadius = 3.0
        address1.layer.borderColor = UIColor.clear.cgColor
        
        city.layer.masksToBounds = true
        city.layer.borderWidth = 2
        city.layer.cornerRadius = 3.0
        city.layer.borderColor = UIColor.clear.cgColor
        
        country.layer.masksToBounds = true
        country.layer.borderWidth = 2
        country.layer.cornerRadius = 3.0
        country.layer.borderColor = UIColor.clear.cgColor
        
        state.layer.masksToBounds = true
        state.layer.borderWidth = 2
        state.layer.cornerRadius = 3.0
        state.layer.borderColor = UIColor.clear.cgColor
        
        zipCode.layer.masksToBounds = true
        zipCode.layer.borderWidth = 2
        zipCode.layer.cornerRadius = 3.0
        zipCode.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.startAuthenticatingUser()
    }
    
    func startAuthenticatingUser() -> Void
    {
        if CheckNetwork.isExistenceNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.getDetails()
        }
        else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getDetails() -> Void
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@",API.Owner.RenewPlanDetails, userId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let queryDic = json
            {
                if queryDic.count == 0
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                else
                {
                    
                    var prunedDictionary = [String: Any]()
                    for key: String in queryDic.keys
                    {
                        if !(queryDic[key] is NSNull) {
                            prunedDictionary[key] = queryDic[key]
                        }
                        else {
                            prunedDictionary[key] = ""
                        }
                    }
                    DispatchQueue.main.async
                        {
                            
                            let plan = MyPlanModel(startDate: prunedDictionary["StartDate"] as? String, endDate : prunedDictionary["EndDate"] as? String, planDescription : prunedDictionary["BasePlanDescription"] as? String, planId : prunedDictionary["PlanId"] as? NSNumber, palnType : prunedDictionary["PlanType"] as? String, addPetCharge : prunedDictionary["AddPetCharge"] as? String, plan : prunedDictionary["Plan"] as? String, price : prunedDictionary["Price"] as? String, promoCode : prunedDictionary["PromoCode"] as? String, userName : prunedDictionary["UserName"] as? String, userId : prunedDictionary["UserId"] as? String, userDescript : prunedDictionary["UserDescription"] as? String, creditType :prunedDictionary["CreditCardType"] as? String, creditNo: prunedDictionary["CreditCardNumber"] as? String, expDate: prunedDictionary["ExpirationDate"] as? String, cvv: prunedDictionary["CVV"] as? String, billAdd1 : prunedDictionary["BillingAddress1"] as? String, billAdd2 : prunedDictionary["BillingAddress2"] as? String, billCity :prunedDictionary["BillingCity"] as? String, billCountry : prunedDictionary["BillingCountry"] as? String, billState :prunedDictionary["BillingState"] as? String, billZip : prunedDictionary["BillingZip"] as? String, isActive: prunedDictionary["Isactiv"] as? Bool, planStartDate: prunedDictionary["PlanStartDate"] as? String, planEndDate: prunedDictionary["PlanEndDate"] as? String, maxPets: prunedDictionary["MaxPet"] as? String, duration: prunedDictionary["Duration"] as? String, remainingDays: prunedDictionary["RemainingDays"] as? String, firstName: prunedDictionary["FirstName"] as? String, lastName: prunedDictionary["LastName"] as? String, cardExp: prunedDictionary["CardExpiry"] as? String, transId: prunedDictionary["TransID"] as? String, isPaymentSuccess: prunedDictionary["IsPaymentSuccess"] as? Bool, message: prunedDictionary["Message"] as? String,isFreeUser: prunedDictionary["IsBasicFreePlan"] as? Bool,isShelterUser: prunedDictionary["IsShelterPlan"] as? Bool,isAccExpired: prunedDictionary["IsAccountExpired"] as? Bool
                            )
                            
                            self.model = plan
                            UserDefaults.standard.set(self.model?.plan, forKey: "PlanName")
                            UserDefaults.standard.set(self.model?.price, forKey: "PlanPrice")
                            UserDefaults.standard.set(self.model?.planId, forKey: "PlanId")
                            UserDefaults.standard.set(self.model?.promoCode, forKey: "PlanPromoCode")
                            UserDefaults.standard.synchronize()
                            self.planNameLbl.text = self.model?.plan
                            self.priceNameLbl.text = "$" + (self.model?.price)! + "/Year"
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
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        creditCardType.resignFirstResponder()
        creditCardNo.resignFirstResponder()
        expiryDate.resignFirstResponder()
        cvv.resignFirstResponder()
        address1.resignFirstResponder()
        address2.resignFirstResponder()
        city.resignFirstResponder()
        country.resignFirstResponder()
        state.resignFirstResponder()
        zipCode.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1
        {
            return 1
        }
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1
        {
            return listArr.count
        }
        else
        {
            if component == 0
            {
                return self.monthList.count
            }
            else
            {
                return self.yearList.count
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 1
        {
            if (dropDownType == "CardType")
            {
                return listArr[row] as? String
            }
            else
            {
                let model = listArr[row] as? CommonResponseModel
                return model?.paramName
            }
            
        }
        else
        {
            if component == 0
            {
                return self.monthList[row]
            }
            else
            {
                return self.yearList[row]
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1
        {
            
        }
        else
        {
            if component == 0
            {
                self.month = self.monthList[row]
            }
            else
            {
                self.year = self.yearList[row]
            }
        }
    }
    @objc func doneWithDatePicker(_ item: UIBarButtonItem)
    {
        self.month = self.monthList[self.datePicker.selectedRow(inComponent: 0)]
        self.year = self.yearList[self.datePicker.selectedRow(inComponent: 1)]
        expiryDate.text = String(format: "%@/%@",month, year)
        
        self.expiryDate.resignFirstResponder()
    }
    @objc func cancelWithDatePicker(_ item: UIBarButtonItem)
    {
        expiryDate.text = ""
        self.expiryDate.resignFirstResponder()
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
                        else if (self.dropDownType == "State")
                        {
                            let model = CommonResponseModel()
                            if self.countryId != "" && self.countryId == dict["ConversationId"] as! String? {
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                model.paramSubID = dict["ConversationId"] as! String?
                                self.listArr.append(model)
                            }
                        }
                    }
                    
                    self.commonTv?.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    @IBAction func selectNextStep(_ sender: Any)
    {
        creditCardType.resignFirstResponder()
        creditCardNo.resignFirstResponder()
        expiryDate.resignFirstResponder()
        cvv.resignFirstResponder()
        address1.resignFirstResponder()
        address2.resignFirstResponder()
        city.resignFirstResponder()
        country.resignFirstResponder()
        state.resignFirstResponder()
        zipCode.resignFirstResponder()
        doValidationForRenewPlan()
    }
    func doValidationForRenewPlan()
    {
        if creditCardType.text == nil && creditCardNo.text == nil && expiryDate.text == nil && cvv.text == nil && address1.text == nil && city.text == nil && country.text == nil && state.text == nil && zipCode.text == nil && (creditCardType.text == "") && (creditCardNo.text == "") && (expiryDate.text == "") && (cvv.text == "") && (address1.text == "") && (city.text == "") && (country.text == "") && (state.text == "") && (zipCode.text == "") {
            mandatoryLbl.isHidden = false
            creditCardType.layer.borderColor = UIColor.red.cgColor
            creditCardNo.layer.borderColor = UIColor.red.cgColor
            expiryDate.layer.borderColor = UIColor.red.cgColor
            cvv.layer.borderColor = UIColor.red.cgColor
            address1.layer.borderColor = UIColor.red.cgColor
            city.layer.borderColor = UIColor.red.cgColor
            country.layer.borderColor = UIColor.red.cgColor
            state.layer.borderColor = UIColor.red.cgColor
            zipCode.layer.borderColor = UIColor.red.cgColor
        }
        if creditCardType.text == nil || (creditCardType.text == "") {
            creditCardType.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            creditCardType.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if creditCardNo.text == nil || (creditCardNo.text! == "") || (creditCardNo.text?.count)! < 19 {
            creditCardNo.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            creditCardNo.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if expiryDate.text == nil || (expiryDate.text == "") {
            expiryDate.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            expiryDate.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if cvv.text == nil || (cvv.text! == "") || (cvv.text?.count)! < 3 {
            cvv.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            cvv.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if address1.text == nil || (address1.text == "") {
            address1.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            address1.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if city.text == nil || (city.text == "") {
            city.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            city.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if country.text == nil || (country.text == "") {
            country.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            country.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if state.text == nil || (state.text == "") {
            state.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            state.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if zipCode.text == nil || (zipCode.text == "") {
            zipCode.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else {
            zipCode.layer.borderColor = UIColor.clear.cgColor
            mandatoryLbl.isHidden = false
        }
        if !(creditCardType.text == nil) && !(creditCardNo.text == nil) && !(expiryDate.text == nil) && !(cvv.text == nil) && !(address1.text == nil) && !(city.text == nil) && !(country.text == nil) && !(state.text == nil) && !(zipCode.text == nil) && !(creditCardType.text == "") && !(creditCardNo.text == "") && !(expiryDate.text == "") && !(cvv.text == "") && !(address1.text == "") && !(city.text == "") && !(country.text == "") && !(state.text == "") && !(zipCode.text == "")
        {
            mandatoryLbl.isHidden = true
            if doValidationForZipCode()
            {
                //let prefs = UserDefaults.standard
                let prefs = UserDefaults.standard
                prefs.set(self.creditCardNo.text, forKey: "CreditCardNo")
                prefs.set(self.expiryDate.text, forKey: "ExpDate")
                prefs.set(self.cvv.text, forKey: "CVV")
                prefs.set(self.address1.text, forKey: "address1")
                prefs.set(self.address2.text, forKey: "address2")
                prefs.set(self.city.text, forKey: "City")
                prefs.set(self.country.text, forKey: "Country")
                prefs.set(self.state.text, forKey: "State")
                prefs.set(self.countryId, forKey: "CountryId")
                prefs.set(self.stateId, forKey: "StateId")
                prefs.set(self.zipCode.text, forKey: "ZipCode")
                
                prefs.synchronize()
                
                self.checkInternetConnection()
            }
            else
            {
                zipCode.layer.borderColor = UIColor.red.cgColor
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
            self.callPaymentAPI()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func callPaymentAPI()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache"
            ]
            let prefs = UserDefaults.standard
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let email: String = UserDefaults.standard.string(forKey: "UserEmail")!
            var str = String(format : "UserId=%@&PetId=%@&CardNumber=%@&ExpDate=%@&CVV=%@&Price=%@&Email=%@&FirstName=%@&LastName=%@&BillingAddress1=%@&BillingAddress2=%@&BillingCity=%@&BillingCountryId=%@&BillingStateId=%@&BillingZip=%@", userId, "0", prefs.value(forKey: "CreditCardNo") as? String ?? " ", prefs.value(forKey: "ExpDate") as? String ?? " ", prefs.value(forKey: "CVV") as? String ?? " ", prefs.value(forKey: "PlanPrice") as? String ?? " ", email," ", " ", prefs.value(forKey:"address1") as? String ?? " ", prefs.value(forKey: "address2") as? String ?? " ", prefs.value(forKey: "City") as? String ?? " ", prefs.value(forKey: "CountryId") as? String ?? " ", prefs.value(forKey: "StateId") as? String ?? " ", prefs.value(forKey: "ZipCode") as? String ?? " " )
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Payment.DoPayment, str)
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
                        
                        self.paymentCharged = json?["PaymentCharged"] as! String
                        self.paymentDate = json?["PaymentTransferDateTime"] as! String
                        self.paymentRefNo = json?["PaymentTransferNum"] as! String
                        self.paymentMsg = json?["PaymentTransferMsg"] as! String
                        self.webServiceToUpdateRenewPlan()
                    }
                }
            }
            task.resume()
        }
        
    }
    func webServiceToUpdateRenewPlan()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache",
                "content-type": "application/json"
            ]
            // let prefs = UserDefaults.standard
            //let userId:String = UserDefaults.standard.string(forKey: "userID")!
            
            let dict: [String: Any] = ["Isactiv":self.model?.isActive! ?? "","StartDate": self.model?.planStartDate! ?? "","EndDate": self.model?.planEndDate! ?? "", "PlanStartDate": self.model?.planStartDate! ?? "","PlanEndDate": self.model?.planEndDate! ?? "","MaxPet": self.model?.maxPets! ?? "" ,"BasePlanDescription": self.model?.planDescription! ?? "", "PlanId": self.model?.planId! ?? "", "PlanType": self.model?.palnType! ?? "", "AddPetCharge":self.model?.addPetCharge! ?? "", "Duration":self.model?.duration! ?? "", "RemainingDays":self.model?.duration! ?? "", "Plan": self.model?.plan! ?? "", "Price": self.model?.price! ?? "", "PromoCode":self.model?.promoCode! ?? "","IsBasicFreePlan": self.model?.isFreeUser! ?? "", "IsShelterPlan": self.model?.isShelterUser! ?? "","UserName": self.model?.userName! ?? "","UserId": self.model?.userId! ?? "" ,"UserDescription": self.model?.userDescript! ?? "", "UserTimeZone": "","UserCountry": "", "UserState": "","CreditCardType": self.creditCardType.text! ,"FirstName": "" ,"LastName": "", "CreditCardNumber": "","ExpirationDate": self.model?.planEndDate! ?? "", "CVV": "","CardExpiry": "","TransID": self.paymentRefNo ,"IsPaymentSuccess": "true", "Message": self.paymentMsg,"BillingAddress1": self.address1.text! , "BillingAddress2": self.address2.text! ,"BillingCity": self.city.text! ,"BillingCountry": self.countryId ,"BillingState": self.stateId, "BillingZip": self.zipCode.text! ]
            
            // let objDict = dict as NSDictionary
            print(dict)
            let requestUrl = URL(string: API.Owner.RenewPlanUpdate) //else { return }
            var request = URLRequest(url:requestUrl!)
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                
            } catch
            {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
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
                    MBProgressHUD.hide(for: self.view, animated: true)
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
                                let alert = UIAlertController(title: nil, message: "Your plan has been renewed successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                                    let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                                    MyPets.isFromNS = true
                                    self.navigationController?.pushViewController(MyPets, animated: true)
                                })
                                alert.addAction(ok)
                                self.present(alert, animated: true)
                                
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
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.creditCardType || textField == self.expiryDate || textField == self.country || textField == self.state
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == creditCardNo || textField == cvv || textField == zipCode
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
        else if textField == self.creditCardType
        {
            txtFld = textField
            dropDownType = "CardType"
            listArr = cardTypeArr
            commonTv.reloadAllComponents()
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
            textField.inputView = commonTv
        }
        else if textField == self.expiryDate
        {
            let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
            numberToolbar.barStyle = .blackTranslucent
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneWithDatePicker))
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelWithDatePicker))
            numberToolbar.items = [cancel, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
            numberToolbar.sizeToFit()
            textField.inputAccessoryView = numberToolbar
            textField.inputView = datePicker
        }
        else if textField == self.country
        {
            txtFld = textField
            dropDownType = "Country"
            self.listArr = []
            self.commonTv.reloadAllComponents()
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
            textField.inputView = commonTv
        }
        else if textField == self.state
        {
            txtFld = textField
            dropDownType = "State"
            self.listArr = []
            self.commonTv.reloadAllComponents()
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
            textField.inputView = commonTv
        }
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            if (dropDownType == "Country")
            {
                let model = listArr[self.commonTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                country.text = model?.paramName
                countryId = (model?.paramID)!
                state.text = ""
                stateId = ""
            }
            else if (dropDownType == "State")
            {
                let model = listArr[self.commonTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                state.text = model?.paramName
                stateId = (model?.paramID)!
                stateCountryID = (model?.paramSubID)!
            }
            else if (dropDownType == "CardType")
            {
                creditCardType.text = listArr[self.commonTv.selectedRow(inComponent: 0)] as? String
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
        if item.tag == 1 {
            creditCardNo.resignFirstResponder()
            //_advTimeTxt.text=@"";
        }
        else if item.tag == 2 {
            cvv.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        else if item.tag == 3 {
            zipCode.resignFirstResponder()
            //_cancelTimeTxt.text=@"";
        }
        
    }
    
    @objc func donewithNumberPad (_ item: UIBarButtonItem) {
        if item.tag == 1 {
            creditCardNo.resignFirstResponder()
        }
        else if item.tag == 2 {
            cvv.resignFirstResponder()
        }
        else if item.tag == 3 {
            zipCode.resignFirstResponder()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == creditCardNo
        {
            if (textField.text?.count)! < 19
            {
                creditCardNo.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid card number", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else
            {
                creditCardNo.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == cvv {
            if (textField.text?.count)! < 3 {
                cvv.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid CVV number", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else {
                cvv.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == zipCode {
            if (textField.text?.count)! < 5
            {
                zipCode.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: "Warning", message: "Please enter a valid zipcode ", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true)
            }
            else {
                zipCode.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == zipCode
        {
            let currentString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 5 {
                return false
            }
        }
        else if textField == creditCardNo
        {
            let currentString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if string.count == 0
            {
                return true
            }
            if creditCardNo.text?.count == 4 {
                creditCardNo.text = String(format: "%@ ",creditCardNo.text!) //"\(String(describing: creditCardNo.text)) "
            }
            if creditCardNo.text?.count == 9 {
                creditCardNo.text = String(format: "%@ ",creditCardNo.text!)
            }
            if creditCardNo.text?.count == 14 {
                var _: String? = (creditCardNo.text as NSString?)?.substring(from: (creditCardNo.text?.count)! - 1)
                creditCardNo.text = String(format: "%@ ",creditCardNo.text!)
            }
            if length > 19 {
                return false
            }
        }
        else if textField == cvv
        {
            let currentString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length: Int = (currentString.count )
            if length > 3 {
                return false
            }
        }
        return true
    }
    func doValidationForZipCode() -> Bool
    {
        let pinRegex: String = "^[0-9]{5}(-[0-9]{4})?$"
        let pinTest = NSPredicate(format: "SELF MATCHES %@", pinRegex)
        let pinValidates: Bool = pinTest.evaluate(with: zipCode.text)
        return pinValidates
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
