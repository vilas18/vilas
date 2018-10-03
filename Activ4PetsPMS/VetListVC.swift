//
//  VetListVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 21/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//
import UIKit
import StoreKit
let imageCache2 = NSCache<AnyObject, AnyObject>()
class OnlineVetsModel: NSObject
    {
    var vetId: NSNumber?
    var vetName: String?
    var amount : String?
    var slotDuration : String?
    var profilePic: String?
    init?(vetId: NSNumber?, vetName: String?, amount: String?, slotDuration : String?,profilePic: String?)
    {
        self.vetId = vetId
        self.vetName = vetName
        self.amount = amount
        self.slotDuration = slotDuration
        self.profilePic = profilePic
    }
    }

import UIKit
class VetListVC: UITableViewController
   {
    var vetModelList = [OnlineVetsModel]()
    var noDataLbl: UILabel?
    var model: OnlineVetsModel!
    var petInfo: MyPetsModel?
    var ispaid: Bool = false
    var petId: NSNumber = 0
    var petTypeId: NSNumber = 0
    var petName: String?
    var vetid : NSNumber?
    var vetname : String?
    var timeslot: String?
    var amount: String?
    var callduration : String?
    var timeZoneId: String?
    var IsSubscribed: Bool = false
    var vetpic: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.font = UIFont.systemFont(ofSize: 17.0)
        noDataLbl?.numberOfLines = 1
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.text =  "No vets found please check back in some time" // verbiage from immanueal ***
        noDataLbl?.textAlignment = .center
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.center = self.view.center
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func viewTouched()
    {
        resignFirstResponder()
        self.resignFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Finding available Vets", comment: "")
        webServiceToGetVetList()
        checkIfPaid()  // *** check this function which one to call on priority ***
        self.petId = (petInfo?.petId)!
        self.petTypeId = (petInfo?.petTypeId)!
        self.petName = (petInfo?.petName)!
    }
     func checkIfPaid()
     {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache"
            ]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let  urlStr = String(format : "/Vet/CheckVetcallSubscription?UserId=",userId)
            // ** before release change the url to live **
            let requestUrl = URL(string: urlStr)
            var request = URLRequest(url:requestUrl!)
            request.httpMethod = "GET"
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
                    let queryDic = json?["ispaid"] as? [[String : Any]]
                {
                    var filtered = [[String : Any]]()
                    DispatchQueue.main.async
                        {
                            if queryDic.count == 0
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else
                            {
                                for item in queryDic
                                {
                                    var prunedDictionary = [String: Any]()
                                    for key: String in item.keys
                                    {
                                        if !(item[key] is NSNull) {
                                            prunedDictionary[key] = item[key]
                                        }
                                        else
                                        {
                                            prunedDictionary[key] = ""
                                        }
                                    }
                                    print(prunedDictionary)
                                    filtered.append(prunedDictionary)
                                }
                                for item in filtered
                                {
                                    let paid = (item["ispaid"] as? Bool)!
                                    self.ispaid = paid
                                    UserDefaults.standard.set(paid, forKey: "ispaid")
                                    UserDefaults.standard.synchronize()
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
        
    }
    @objc func leftClk(sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
            func webServiceToGetVetList()
            {
                let reachability = Reachability.forInternetConnection
                let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
                if internetStatus != NotReachable
                {
                    let headers = [
                        "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                        "cache-control": "no-cache"]
                    let timeZoneId = ""
                    let  urlStr = String(format : "http://qapetsvetscom.activdoctorsconsult.com/Vet/ShowDoctorsList?timezoneId=",timeZoneId)
                    // ** before release change the url to live **
                    let requestUrl = URL(string: urlStr)
                    var request = URLRequest(url:requestUrl!)
                    request.httpMethod = "GET"
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
                            let queryDic = json?["Vets"] as? [[String : Any]]
                        {
                            var filtered = [[String : Any]]()
                            DispatchQueue.main.async
                                {
                                    if queryDic.count == 0
                                    {
                                        MBProgressHUD.hide(for: self.view, animated: true)
                                    }
                                    else
                                    {
                                        for item in queryDic
                                        {
                                            var prunedDictionary = [String: Any]()
                                            for key: String in item.keys
                                            {
                                                if !(item[key] is NSNull) {
                                                    prunedDictionary[key] = item[key]
                                                }
                                                else
                                                {
                                                    prunedDictionary[key] = ""
                                                }
                                            }
                                            print(prunedDictionary)
                                            filtered.append(prunedDictionary)
                                        }
                                        for item in filtered
                                        {
                                            let timeSlot = OnlineVetsModel(vetId: item["VetId"] as! NSNumber?, vetName : item["VetName"] as? String, amount : (item["Amount"] as? String)!, slotDuration : (item["SlotDuration"] as? String)!, profilePic: (item["ProfilePicUrl"] as? String)! )
                                            self.model = timeSlot
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
                
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vetModelList.count > 0 ? vetModelList.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vets", for: indexPath) as!  CommonTableViewCell
        cell.icon.image = nil
        cell.icon.layer.cornerRadius = 35
        cell.icon.clipsToBounds = true
        let vets = self.vetModelList[indexPath.row]
        var amount = vets.amount
        cell.firstLabel.text = vets.vetName
        if ispaid == true
        {
           amount = "Free"
        }
        else if ispaid == false
        {
            amount = vets.amount
        }
        cell.secLabel.text = (amount)! +  " for " + (vets.slotDuration)! + "minutes"
        cell.icon.imageFromServerURL(urlString: (vets.profilePic)!, defaultImage: "ic_user_prof")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vet = vetModelList[indexPath.row]
        self.vetid = vet.vetId
        self.vetname = vet.vetName
        self.amount = vet.amount
        self.callduration = vet.slotDuration
        self.vetpic = vet.profilePic
        if ispaid == true
        {
            RequestVetCall()
        }
        else
        {
            let payment : PaymentCardDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CardPayment") as! PaymentCardDetailsVC
            payment.vetName.text = self.vetname
            payment.amount.text = self.amount
            payment.appTime.text = self.callduration
            payment.vetimage = self.vetpic
            payment.vetImage.image = UIImage(named: vet.profilePic!)!
            self.navigationController?.pushViewController(payment, animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    func RequestVetCall()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "cache-control": "no-cache"
            ]
            let firstname :  String = UserDefaults.standard.string(forKey:"UserName")!
            let phone :  String = UserDefaults.standard.string(forKey:"UserPhoneNumber")! // it may come null handle it ***
            let email: String = UserDefaults.standard.string(forKey: "UserEmail")! // it may come null handle it ***
            let dict: [String: Any] = [ "OwnerId":"","FirstName": firstname,"LastName": "" ,"Email": email,"PhoneNumber": phone,"StateId": "","PetId": petId ,"PetTypeId": petTypeId ,"PetName": petName as Any,"Condition": "","RequestedTime": "","IsPaymentDone": ispaid,"ChkDisclaimer":""]
            print(dict)
            let requestUrl = URL(string: "http://qapetsvetscom.activdoctorsconsult.com/Vet/RequestVetCall") // ** before release change the url to live **
//            OwnerId : int - PetOwnerId
//            FirstName : string - PetOwner FirstName
//            LastName : string - PetOwner LastName
//            Email : string - PetOwner Email
//            PhoneNumber : string - PetOwner PhoneNumber
//            StateId : int - StateId
//            PetId : int - PetId
//            PetTypeId: int - PetTypeId
//            PetName: string - PetName
//            Condition: string - Question to be asked
//            RequestedTime: string - Requested Date and Time
//            IsPaymentDone : string - Paid or not (Get this from (1) ispaid)
//            ChkDisclaimer : bool - Disclaimer read or not
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
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
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
                                // perform segue to desired page as payment is done
                                //                            "status": 1,
                                //                            "request_id": 1290,
                                //                            "message": "Vetcall requested"
                                
                                
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
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
