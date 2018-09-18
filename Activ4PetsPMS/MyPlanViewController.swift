//
//  MyPlanViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class MyPlanModel: NSObject
{
    var startDate: String?
    var endDate: String?
    var planDescription: String?
    var planId: NSNumber?
    var palnType: String?
    var addPetCharge: String?
    var plan: String?
    var price: String?
    var promoCode: String?
    var userName: String?
    var userId: String?
    var userDescript: String?
    var creditType: String?
    var creditNo: String?
    var expDate: String?
    var cvv: String?
    var billAdd1: String?
    var billAdd2: String?
    var billCity: String?
    var billCountry: String?
    var billState: String?
    var billZip: String?
    var isActive: Bool?
    var planStartDate: String?
    var planEndDate: String?
    var maxPets: String?
    var duration: String?
    var remainingDays: String?
    var firstName: String?
    var lastName: String?
    var cardExp: String?
    var transId: String?
    var isPaymentSuccess: Bool?
    var message: String?
    var isFreeUser: Bool?
    var isShelterUser: Bool?
    var isAccExpired: Bool?
    
    
    
    init?(startDate: String?, endDate : String?, planDescription : String?, planId : NSNumber?, palnType : String?, addPetCharge : String?, plan : String?, price : String?, promoCode : String?, userName : String?, userId : String?, userDescript : String?, creditType : String?, creditNo: String?, expDate: String?, cvv: String?, billAdd1 : String?, billAdd2 : String?, billCity : String?, billCountry : String?, billState : String?, billZip : String?,isActive: Bool?, planStartDate: String?, planEndDate: String?, maxPets: String?, duration: String?, remainingDays: String?, firstName: String?, lastName: String?, cardExp: String?, transId: String?, isPaymentSuccess: Bool?, message: String?,isFreeUser: Bool?,isShelterUser: Bool?,isAccExpired: Bool?)
    {
        
        self.startDate = startDate
        self.endDate = endDate
        self.planDescription = planDescription
        self.planId = planId
        self.palnType = palnType
        self.addPetCharge = addPetCharge
        self.plan = plan
        self.price = price
        self.promoCode = promoCode
        self.userName = userName
        self.userId = userId
        self.userDescript = userDescript
        self.creditType = creditType
        self.creditNo = creditNo
        self.expDate = expDate
        self.cvv = cvv
        self.billAdd1 = billAdd1
        self.billAdd2 = billAdd2
        self.billCity = billCity
        self.billCountry = billCountry
        self.billState = billState
        self.billZip = billZip
        self.isActive = isActive
        self.planStartDate = planStartDate
        self.planEndDate = planEndDate
        self.maxPets = maxPets
        self.duration = duration
        self.remainingDays = remainingDays
        self.firstName = firstName
        self.lastName = lastName
        self.cardExp = cardExp
        self.transId = transId
        self.isPaymentSuccess = isPaymentSuccess
        self.message = message
        self.isFreeUser = isFreeUser
        self.isShelterUser = isShelterUser
        self.isAccExpired = isAccExpired
    }
}

class MyPlanViewController: UIViewController
{
    
    var model: MyPlanModel?
    @IBOutlet weak var promoCode:UILabel!
    @IBOutlet weak var startDate:UILabel!
    @IBOutlet weak var expDate:UILabel!
    @IBOutlet weak var maxPets:UILabel!
    @IBOutlet weak var remainDays:UILabel!
    @IBOutlet weak var descript:UILabel!
    @IBOutlet weak var addInfo:UILabel!
    @IBOutlet weak var duration:UILabel!
    @IBOutlet weak var planName:UILabel!
    @IBOutlet weak var prfileSettingsSeg:UISegmentedControl!
    @IBOutlet weak var renewPlan: UIButton!
    @IBOutlet weak var topSpace1: NSLayoutConstraint!//49
    @IBOutlet weak var topSpace2: NSLayoutConstraint!//100
    @IBOutlet weak var topSpace3: NSLayoutConstraint!
    @IBOutlet weak var expdateLbl: UILabel!
    @IBOutlet weak var remainDaysLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var downView1: UIView!
    @IBOutlet weak var maxPetsLbl: UILabel!
    var isFromVC: Bool = false
    var isFromAppDel: Bool = false
    //  @IBOutlet weak var downView2: UIView!
    //  @IBOutlet weak var downView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        navigationController?.navigationBar.isTranslucent = false
        //        navigationController?.setNavigationBarHidden(false, animated: true)
        //        var leftItem: UIBarButtonItem?
        //        var rightItem1: UIBarButtonItem?
        //    
        //        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        //        navigationItem.leftBarButtonItem = leftItem
        //        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        //        navigationItem.rightBarButtonItem = rightItem1
        //        navigationItem.rightBarButtonItem = rightItem1!
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        self.prfileSettingsSeg?.addTarget(self, action: #selector(self.selectProfileSettings), for: .valueChanged)
        self.navigationController?.navigationBar.isHidden = false
        let _: Int = (UserDefaults.standard.value(forKey: "CenterID") as? Int)!
        let expired: Bool = UserDefaults.standard.bool(forKey: "AccountExpired")
        //if centerId as? Int == 57
        if (UserDefaults.standard.string(forKey: "userType") == "6") && expired == true
        {
            renewPlan.isHidden = false
        }
        else
        {
            renewPlan.isHidden = true
        }
        if self.isFromVC
        {
            self.prfileSettingsSeg.isUserInteractionEnabled = false
            
        }
        if self.isFromAppDel
        {
            leftItem.isEnabled = false
            let alert = UIAlertController(title: nil, message: "Your account has been Expired. Please renew your plan.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
        
    }
    @objc func leftClk(sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func selectProfileSettings (sender:UISegmentedControl)-> Void
    {
        if sender.selectedSegmentIndex==0
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is MyProfileViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if sender.selectedSegmentIndex==1
        {
        }
        else if sender.selectedSegmentIndex==2
        {
            self.performSegue(withIdentifier: "Settings", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.prfileSettingsSeg.selectedSegmentIndex = 1
        self.startAuthenticatingUser()
    }
    
    func startAuthenticatingUser() -> Void {
        if CheckNetwork.isExistenceNetwork() {
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
        let urlStr = String(format : "%@?UserId=%@",API.Owner.MyPlan, userId)
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
                            
                            let plan = MyPlanModel(startDate: prunedDictionary["StartDate"] as? String, endDate : prunedDictionary["EndDate"] as? String, planDescription : prunedDictionary["BasePlanDescription"] as? String, planId : prunedDictionary["PlanId"] as? NSNumber, palnType : prunedDictionary["PlanType"] as? String, addPetCharge : prunedDictionary["AddPetCharge"] as? String, plan : prunedDictionary["Plan"] as? String, price : prunedDictionary["Price"] as? String, promoCode : prunedDictionary["PromoCode"] as? String, userName : prunedDictionary["UserName"] as? String, userId : prunedDictionary["UserId"] as? String, userDescript : prunedDictionary["UserDescription"] as? String, creditType :prunedDictionary["CreditCardType"] as? String, creditNo: prunedDictionary["CreditCardNumber"] as? String, expDate: prunedDictionary["ExpirationDate"] as? String, cvv: prunedDictionary["CVV"] as? String, billAdd1 : prunedDictionary["BillingAddress1"] as? String, billAdd2 : prunedDictionary["BillingAddress2"] as? String, billCity :prunedDictionary["BillingCity"] as? String, billCountry : prunedDictionary["BillingCountry"] as? String, billState :prunedDictionary["BillingState"] as? String, billZip : prunedDictionary["BillingZip"] as? String, isActive: prunedDictionary["Isactiv"] as? Bool, planStartDate: prunedDictionary["PlanStartDate"] as? String, planEndDate: prunedDictionary["PlanEndDate"] as? String, maxPets: prunedDictionary["MaxPet"] as? String, duration: prunedDictionary["Duration"] as? String, remainingDays: prunedDictionary["RemainingDays"] as? String, firstName: prunedDictionary["FirstName"] as? String, lastName: prunedDictionary["LastName"] as? String, cardExp: prunedDictionary["CardExpiry"] as? String, transId: prunedDictionary["TransID"] as? String, isPaymentSuccess: prunedDictionary["IsPaymentSuccess"] as? Bool, message: prunedDictionary["Message"] as? String,isFreeUser: prunedDictionary["IsBasicFreePlan"] as? Bool,
                                                   isShelterUser: prunedDictionary["IsShelterPlan"] as? Bool, isAccExpired: prunedDictionary["IsAccountExpired"] as? Bool
                            )
                            
                            self.model = plan
                            self.planName.text = self.model?.plan
                            self.promoCode.text = self.model?.promoCode
                            self.startDate.text = self.model?.planStartDate
                            self.expDate.text = self.model?.planEndDate
                            self.maxPets.text = self.model?.maxPets
                            self.remainDays.text = self.model?.remainingDays
                            self.duration.text = self.model?.duration
                            self.descript.text = self.model?.planDescription
                            self.addInfo.text = self.model?.userDescript
                            if self.planName.text == "Basic (free account with limited access)" || self.model?.isFreeUser == true
                            {
                                self.topSpace1.constant = -1
                                self.topSpace2.constant = -1
                                self.remainDays.isHidden = true
                                self.remainDaysLbl.isHidden = true
                                self.duration.isHidden = true
                                self.durationLbl.isHidden = true
                                self.expDate.isHidden = true
                                self.expdateLbl.isHidden = true
                                self.topSpace3.constant = 49
                            }
                            else
                            {
                                self.topSpace1.constant = 50
                                self.topSpace2.constant = 101
                                self.topSpace3.constant = 49
                                self.remainDays.isHidden = false
                                self.remainDaysLbl.isHidden = false
                                self.duration.isHidden = false
                                self.durationLbl.isHidden = false
                                self.expDate.isHidden = false
                                self.expdateLbl.isHidden = false
                            }
                            if (self.model?.isShelterUser)!
                            {
                                self.topSpace3.constant = -1
                                self.maxPetsLbl.isHidden = true
                                self.maxPets.isHidden = true
                                self.topSpace1.constant = 50
                                self.topSpace2.constant = 101
                                self.remainDays.isHidden = false
                                self.remainDaysLbl.isHidden = false
                                self.duration.isHidden = false
                                self.durationLbl.isHidden = false
                                self.expDate.isHidden = false
                                self.expdateLbl.isHidden = false
                            }
                            if self.model?.isAccExpired == true
                            {
                                self.renewPlan.isHidden = false
                            }
                            else
                            {
                                self.renewPlan.isHidden = true
                            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Settings"
        {
            
        }
        
    }
    @IBAction func showRenewPlanPage(_ sender: Any)
    {
        //        let urlStr = "https://login.activ4pets.com/SubscriptionRenewal/Renew/\(patientID)"
        //        let url = URL(string: urlStr)
        //        if UIApplication.shared.canOpenURL(url!) {
        //            UIApplication.shared.openURL(url!)
        //        }
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
