//
//  ECListViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class ECModel: NSObject
{
    var ecId: String?
    var petName: NSString?
    var countryId: String?
    var petCondition: String?
    var timeZone: String?
    var ecDate: String?
    var ecTime: String?
    var sympt1: String?
    var sympt2: String?
    var sympt3: String?
    var firstName: NSString?
    var lastName: String?
    var email: String?
    var speciality: String?
    var contactType: String?
    var status: String?
    var petType: String?
    
    init?(ecId: String?, petName: String?, countryId : String?, petCondition : String?, timeZone : String?, ecDate : String?, ecTime : String?, sympt1 : String?, sympt2 : String?, sympt3 : String?, firstName : String?, lastName : String?, email : String?, speciality : String?, contactType: String?, status: String?, petType: String? )
    {
        
        self.ecId=ecId
        self.petName=petName as NSString?
        self.countryId=countryId
        self.petCondition=petCondition
        self.timeZone=timeZone
        self.ecDate=ecDate
        self.ecTime=ecTime
        self.sympt1=sympt1
        self.sympt2=sympt2
        self.sympt3=sympt3
        self.firstName=firstName as NSString?
        self.lastName=lastName
        self.email=email
        self.speciality=speciality
        self.contactType = contactType
        self.status = status
        self.petType = petType
        
    }
    
}

class ECListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    
    
    @IBOutlet weak var searchEC: UISearchBar!
    var noDataLbl: UILabel?
    var patientID: String = ""
    var ECListArray = [Any]()
    var ECModelList = [ECModel]()
    var prefs: UserDefaults?
    @IBOutlet weak var ECListTbl: UITableView!
    var selectedPet: ECModel?
    var ecPrice: String = ""
    var searchList = [Any]()
    var isSearchOn: Bool = false
    var haveDiscount: Bool = false
    var discPercent: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus.png"), style: .done, target: self, action: #selector(self.rightClk2))
        navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 60))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.text =  "No records found.\n Tap on '+' to add a new E-Consultation"
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        //ZeroPetList
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightClk1(sender: AnyObject)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    @objc func rightClk2(sender: AnyObject)
    {
        if UserDefaults.standard.bool(forKey: "ZeroPetList")
        {
            let alert = UIAlertController(title: "Warning", message: "Please add a Pet to create a new E-Consultaion." , preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }
        else if self.haveDiscount 
        {
            let alert = UIAlertController(title: "Congratulations!", message: String(format: "You got a dicount of %@ %@ \n After discount, the payable service charge for one E-consultation is $%@.\n Do you want to continue?",self.discPercent,"%",self.ecPrice) , preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "ScheduleEC", sender: nil)
            })
            let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Notice", message: String(format: "Service charge - $%@ for one E-consultation service.\n Do you want to continue?",self.ecPrice) , preferredStyle: .alert)
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "ScheduleEC", sender: nil)
            })
            let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
        checkInternetConnection()
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.ECModelList = []
            self.getPriceForEC()
            self.webServiceToGetpetList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getPriceForEC()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@&Service=%@", API.Online.GetPrice, userId,"EC")
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let queryDic = json
            {
                DispatchQueue.main.async
                    {
                        let actualPrice: NSNumber = (queryDic["ActualPrice"] as? NSNumber)!
                        let discount: NSNumber = (queryDic["EarnedDiscount"] as? NSNumber)!
                        let discPrice: NSNumber = (queryDic["TotalPrice"] as? NSNumber)!
                        if discount == 0
                        {
                            self.ecPrice = actualPrice.stringValue
                            self.haveDiscount = false
                            UserDefaults.standard.set(self.discPercent, forKey: "ECDiscount")
                            UserDefaults.standard.synchronize()
                        }
                        else
                        {
                            self.ecPrice = discPrice.stringValue
                            self.discPercent = discount.stringValue
                            self.haveDiscount = true
                            UserDefaults.standard.set(self.discPercent, forKey: "ECDiscount")
                            UserDefaults.standard.synchronize()
                        }
                        UserDefaults.standard.set(self.ecPrice, forKey: "ECPriceValue")
                        UserDefaults.standard.synchronize()
                }
            }
        }
        task.resume()
        
    }
    func webServiceToGetpetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.Online.ECList, userId)
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
                let queryDic = json?["econsultationList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
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
                                    else {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            //  self.vetModelList = [VetModel]()
                            for item in filtered
                            {
                                let EC = ECModel(ecId: item["Id"] as? String, petName: item["PetName"] as? String, countryId : item["Country"] as? String, petCondition : item["PetCondition"] as? String, timeZone : item["TimeZone"] as? String, ecDate : item["ECDate"] as? String, ecTime : item["ECTime"] as? String, sympt1 : item["Symptoms1"] as? String, sympt2 : item["Symptoms2"] as? String, sympt3 : item["Symptoms3"] as? String, firstName : item["FristName"] as? String, lastName : item["LastName"] as? String, email : item["Email"] as? String, speciality : item["VetSpecialities"] as? String, contactType: item["ConatctType"] as? String, status: item["Status"] as? String, petType: item["PetType"] as? String )
                                
                                self.ECModelList.append(EC!)
                            }
                            for model in self.ECModelList
                            {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                                let date = dateFormatter.date(from: model.ecDate!)
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                model.ecDate = dateFormatter.string(from: date!)
                            }
                            self.ECModelList = self.ECModelList.sorted(by: {$0.ecDate!.compare($1.ecDate!) == .orderedDescending})
                            self.ECListTbl.reloadData()
                            self.noDataLbl?.isHidden = true
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String)
    {
        if (text.count ) == 0
        {
            isSearchOn = false
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        else
        {
            isSearchOn = true
            searchList = [Any]()
            for srchVet: ECModel in ECModelList
            {
                
                let tmp1: NSString = srchVet.petName!
                let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                let lastNameRange = srchVet.firstName?.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                if range.location != NSNotFound || lastNameRange?.location != NSNotFound
                {
                    self.searchList.append(srchVet)
                }
            }
        }
        ECListTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int
        if isSearchOn {
            rowCount = Int(searchList.count)
        }
        else {
            rowCount = Int(ECModelList.count)
        }
        return rowCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EC", for: indexPath) as!  MyPetsTableViewCell
        var EC: ECModel
        cell.shareBtn.isHidden = true
        if isSearchOn
        {
            EC = searchList[indexPath.row] as! ECModel
        }
        else
        {
            EC = ECModelList[indexPath.row]
        }
        cell.petType.text = EC.petType
        cell.petName.text = EC.petName! as String
        cell.condition.text = EC.petCondition
        cell.dob.text = EC.ecDate
        cell.gender.text = EC.ecTime
        cell.status.text = EC.status
        if EC.status == "Complete"// 92,184,92
        {
            cell.status.backgroundColor = UIColor(red: (92.0 / 255.0), green: (184.0 / 255.0), blue: (92.0 / 255.0), alpha: 1)
           // cell.shareBtn.isHidden = true
        }
        else if EC.status == "Open" //66,139,202
        {
            cell.status.backgroundColor = UIColor(red: (66.0 / 255.0), green: (139.0 / 255.0), blue: (202.0 / 255.0), alpha: 1)
            //cell.shareBtn.isHidden = false
//            cell.shareBtn.addTarget(self, action: #selector(self.viewMenuClk), for: .touchUpInside)
        }
        // 
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var EC: ECModel
        if isSearchOn
        {
            EC = searchList[indexPath.row] as! ECModel
        }
        else {
            EC = ECModelList[indexPath.row]
        }
        self.performSegue(withIdentifier: "ECDetails", sender: EC)
    }
//    @objc func viewMenuClk(sender: AnyObject)
//    {
//        self.performSegue(withIdentifier: "room", sender: nil)
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ECDetails"
        {
            let details = segue.destination as! ECDetailsViewController
            details.model = sender as? ECModel
            
        }
        else if segue.identifier == "ScheduleEC"
        {
            
        }
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
