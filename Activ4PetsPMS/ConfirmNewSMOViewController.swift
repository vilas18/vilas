//
//  ConfirmNewSMOViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ConfirmNewSMOViewController: UIViewController
{
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var steps: UISegmentedControl!
    
    var isPaymentDone: Bool = false
    var smoId: NSNumber = 0
    override func viewDidLoad() {
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
        self.petName.text = prefs.value(forKey: "SMOPet") as? String
        self.serviceCharge.text = "$" + prefs.string(forKey: "SMOPriceValue")! 
        self.condition.text = prefs.value(forKey: "SMODiag") as? String
        
    }
    @IBAction func selectSegment(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            for controller: UIViewController in (navigationController?.viewControllers)! {
                if (controller is SMOSetUpViewController) {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        case 1:
            for controller: UIViewController in (navigationController?.viewControllers)! {
                if (controller is SMOBillingViewController) {
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
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            self.callPaymentAPI()
        }
        else {
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
            var str = String(format : "UserId=%@&PetId=%@&CardNumber=%@&ExpDate=%@&CVV=%@&Price=%@&Email=%@&FirstName=%@&LastName=%@&BillingAddress1=%@&BillingAddress2=%@&BillingCity=%@&BillingCountryId=%@&BillingStateId=%@&BillingZip=%@", userId, prefs.value(forKey: "SMOPetId") as? String ?? " ", prefs.value(forKey: "CreditCardNo") as? String ?? " ", prefs.value(forKey: "ExpDate") as? String ?? " ", prefs.value(forKey: "CVV") as? String ?? " ", prefs.value(forKey: "SMOPriceValue") as? String ?? " ", email," ", " ", prefs.value(forKey:"address1") as? String ?? " ", prefs.value(forKey: "address2") as? String ?? " ", prefs.value(forKey: "City") as? String ?? " ", prefs.value(forKey: "CountryId") as? String ?? " ", prefs.value(forKey: "StateId") as? String ?? " ", prefs.value(forKey: "ZipCode") as? String ?? " " )
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
                        
                        self.isPaymentDone = true
                        UserDefaults.standard.set(true, forKey: "isPaymentDone")
                        UserDefaults.standard.synchronize()
                        self.webServiceToAddSMO()
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func webServiceToAddSMO()
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
            let prefs = UserDefaults.standard
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            //            UserSMOAdd Post(string Title, string PetId, string Diagnosis, string DateOfOnSet, string Comments, string Symptoms1, string Symptoms2, string Symptoms3, string FirstOpinion, string SecondOpinion, List<SMOTest> objtest, bool authorizeveterinarians, bool certify, string CreditCardNumber, string CreditCardType, string ExpirationDate, string CCV, string Address1, string Address2, string City, string CountryId, string StateId, string Zip)
            let dict: [String: Any] = ["Title":(prefs.string(forKey: "SMOTitle"))!,"PetId":(prefs.string(forKey: "SMOPetId"))!,"UserId": userId,"Diagnosis":(prefs.string(forKey: "SMODiag"))!,"DateOfOnSet":(prefs.string(forKey: "SMODateOn"))!,"Comments": (prefs.string(forKey: "SMOComments"))!,"Symptoms1":(prefs.string(forKey: "SMOPetSymp1"))!,"Symptoms2":(prefs.string(forKey: "SMOPetSymp2"))!,"Symptoms3":(prefs.string(forKey: "SMOPetSymp3"))!,"FirstOpinion":(prefs.string(forKey: "SMOFirst"))!,"Question":(prefs.string(forKey: "SMODetails"))!,"objtest":(prefs.value(forKey: "SMOTestList"))!,"authorizeveterinarians":(prefs.bool(forKey: "AuthorizeVet")),"certify":(prefs.bool(forKey: "Agree")),"IsSMOPaymentDone":(prefs.bool(forKey: "isPaymentDone"))]
            
            // let objDict = dict as NSDictionary
            print(dict)
            let requestUrl = URL(string: API.Online.SMOAdd) //else { return }
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
                                let disc: String = UserDefaults.standard.string(forKey: "SMODiscount")!
                                if disc == ""
                                {
                                    
                                }
                                else
                                {
                                    self.smoId = (json?["smoId"] as? NSNumber)!
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
            //let email: String = UserDefaults.standard.string(forKey: "UserEmail")!
            let dict: [String: String] = ["UserId":userId,"DiscountPercent":UserDefaults.standard.string(forKey: "SMODiscount")! , "ServiceName" : "SMO", "ServiceId": self.smoId.stringValue ]
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
        thanks?.isFromSMO = true
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
