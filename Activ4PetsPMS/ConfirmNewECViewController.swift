//
//  ConfirmNewECViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ConfirmNewECViewController: UIViewController
{
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var consultDate: UILabel!
    @IBOutlet weak var consultTime: UILabel!
    @IBOutlet weak var steps: UISegmentedControl!
    
    var paymentCharged : String = ""
    var paymentTransferDateTime: String = ""
    var paymentTransferMsg : String = ""
    var paymentTransferNum: String = ""
    var ecId: NSNumber = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        steps.isUserInteractionEnabled = true
        steps.selectedSegmentIndex = 2
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let prefs = UserDefaults.standard
        self.petName.text = prefs.value(forKey: "ECPet") as? String
        self.serviceCharge.text = "$" + prefs.string(forKey: "ECPriceValue")!
        self.condition.text = prefs.value(forKey: "ECPetCondition") as? String
        self.consultDate.text = prefs.value(forKey: "ECDate") as? String
        self.consultTime.text = prefs.value(forKey: "ECTime") as? String
    }
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            for controller: UIViewController in (navigationController?.viewControllers)! {
                if (controller is ECSetUpViewController) {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        case 1:
            for controller: UIViewController in (navigationController?.viewControllers)! {
                if (controller is ECBillingViewController) {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        case 2:
            break
        default:
            break
        }
        
    }
    @IBAction func purchaseClk(_ sender: UIButton)
    {
        self.checkInternetConnection()
        
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            self.callPaymentAPI()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func callPaymentAPI()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache"
            ]
            let prefs = UserDefaults.standard
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let email: String = UserDefaults.standard.string(forKey: "UserEmail")!
            var str = String(format : "UserId=%@&PetId=%@&CardNumber=%@&ExpDate=%@&CVV=%@&Price=%@&Email=%@&FirstName=%@&LastName=%@&BillingAddress1=%@&BillingAddress2=%@&BillingCity=%@&BillingCountryId=%@&BillingStateId=%@&BillingZip=%@", userId, prefs.value(forKey: "ECPetId") as? String ?? " ", prefs.value(forKey: "CreditCardNo") as? String ?? " ", prefs.value(forKey: "ExpDate") as? String ?? " ", prefs.value(forKey: "CVV") as? String ?? " ",prefs.value(forKey: "ECPriceValue") as? String ?? " ", email," ", " ", prefs.value(forKey:"address1") as? String ?? " ", prefs.value(forKey: "address2") as? String ?? " ", prefs.value(forKey: "City") as? String ?? " ", prefs.value(forKey: "CountryId") as? String ?? " ", prefs.value(forKey: "StateId") as? String ?? " ", prefs.value(forKey: "ZipCode") as? String ?? " " )
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
                        self.paymentTransferMsg = json?["PaymentTransferMsg"] as! String
                        self.paymentTransferDateTime = json?["PaymentTransferDateTime"] as! String
                        self.paymentTransferNum = json?["PaymentTransferNum"] as! String
                        
                        self.webServiceToAddEC()
                    }
                }
            }
            task.resume()
        }
        
    }
    func webServiceToAddEC()
    {
        let reachability = Reachability.forInternetConnection
       let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache"
            ]
            let prefs = UserDefaults.standard
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            var str = String(format : "PetId=%@&UserId=%@&VetId=%@&VetName=%@&EDate=%@&CountryId=%@&TimeZone=%@&ETime=%@&ContactType=%@&ContactValue=%@&Title=%@&symptoms1=%@&symptoms2=%@&symptoms3=%@&PaymentType=%@&PaymentCharged=%@&PaymentRefNum=%@&PaymentTransferDateTime=%@&PaymentTransferMsg=%@&PaymentTransferNum=%@&BillingAddress1=%@&BillingAddress2=%@&BillingCity=%@&BillingCountry=%@&BillingState=%@&BillingZip=%@", (prefs.string(forKey: "ECPetId"))!,userId, (prefs.string(forKey: "ECVetId"))!, (prefs.string(forKey: "ECVetName"))!, (prefs.string(forKey: "ECDate"))!,(prefs.string(forKey: "ECCountryId"))!,(prefs.string(forKey: "ECTimeZoneId"))!,(prefs.string(forKey: "ECTime"))!, (prefs.string(forKey: "ECContactType"))!, (prefs.string(forKey:"ECContactValue"))!, (prefs.string(forKey: "ECPetCondition"))!, (prefs.string(forKey: "ECPetSymp1"))!, (prefs.string(forKey: "ECPetSymp2"))!, (prefs.string(forKey: "ECPetSymp3"))!, "5", self.paymentCharged, self.paymentTransferNum, self.paymentTransferDateTime, self.paymentTransferMsg,self.paymentTransferNum,(prefs.string(forKey: "address1"))!, (prefs.string(forKey: "address2"))!,(prefs.string(forKey: "City"))!,(prefs.string(forKey: "CountryId"))!, (prefs.string(forKey: "StateId"))!, (prefs.string(forKey: "ZipCode"))! )
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlString = String(format : "%@?%@", API.Online.ECAdd, str)
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
                                let disc: String = UserDefaults.standard.string(forKey: "ECDiscount")!
                                if disc == ""
                                {
                                    
                                }
                                else
                                {
                                    self.ecId = (json?["ecId"] as? NSNumber)!
                                    self.postUsedDiscountToServer()
                                }
                                
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.performSegue(withIdentifier: "ThankYou", sender: nil)
                                print(json ?? " ")
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
    func postUsedDiscountToServer()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache",
                "content-type": "application/json"
            ]
            // "UserId":"998","DiscountPercent":"10","ServiceName":"EConsultation","ServiceId":"342"
            
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let dict: [String: String] = ["UserId":userId,"DiscountPercent":UserDefaults.standard.string(forKey: "ECDiscount")! , "ServiceName" : "E-Consultation", "ServiceId": self.ecId.stringValue ]
            let objDict = dict as NSDictionary
            print(dict)
            let requestUrl = URL(string: API.VetOnCall.PostRedemptionLog) //else { return }
            var request = URLRequest(url:requestUrl!)
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: objDict, options: .prettyPrinted)
            }
            catch
            {
                print(error.localizedDescription)
            }
            request.httpMethod = "POST"
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
                                
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let thanks: ThankYouSMOECViewController? = segue.destination as? ThankYouSMOECViewController
        thanks?.isFromEC = true
    }
    override func didReceiveMemoryWarning()
    {
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
