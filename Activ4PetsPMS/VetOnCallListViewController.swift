//
//  VetOnCallListViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit
class VetOnCallModel: NSObject
{
    var petId: String?
    var petName: String?
    var petType: String?
    var date: String?
    var time: String?
    var query: String?
    var status: String?
    init?(petId: String?, petName: String?, date: String?, time: String?, query: String?, status: String?,petType: String?)
    {
        self.petId=petId
        self.petType = petType
        self.petName=petName
        self.date=date
        self.time=time
        self.query=query
        self.status=status
    }
}
class VetOnCallListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var noDataLbl: UILabel?
    var patientID: String = ""
    var vetOnCallListArray = [VetOnCallModel]()
    var prefs: UserDefaults?
    var vetOnCallPrice: String = ""
    @IBOutlet weak var vetOnCallListTbl: UITableView!
    
    var haveDiscount: Bool = false
    var discPercent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.rightClk1))
        navigationItem.rightBarButtonItem = rightItem1
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 60))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.text =  "No records found.\n Tap on 'Schedule New' to create a new Talk To Vet Schedule"
        
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = false
        noDataLbl?.center = self.view.center
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
    
    @IBAction func scheduleNewTalkToVet(sender: AnyObject)
    {
        if UserDefaults.standard.bool(forKey: "ZeroPetList")
        {
            let alert = UIAlertController(title: "Warning", message: "Please add a Pet to create a new Schedule" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }
        else if self.haveDiscount
        {
            let alert = UIAlertController(title: "Congratulations!", message: String(format: "You got a dicount of %@ %@ \n After discount, the payable service charge for one Talk to vet schedule is $%@.\n Do you want to continue?",self.discPercent,"%",self.vetOnCallPrice) , preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "ScheduleTalk", sender: nil)
            })
            let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Notice", message: String(format: "Service charge - $%@ for one Talk to vet schedule.\n Do you want to continue?",self.vetOnCallPrice) , preferredStyle: .alert)
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "ScheduleTalk", sender: nil)
            })
            let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        checkInternetConnection()
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.vetOnCallListArray = []
            self.getPriceForVetOnCall()
            self.webServiceToGetVetOnCallList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getPriceForVetOnCall()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@&Service=%@", API.Online.GetPrice, userId,"vetoncall")
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let queryDic = json
            {
                DispatchQueue.main.async
                    {
                        // MBProgressHUD.hide(for: self.view, animated: true)
                        //self.smoPrice = queryDic[1]
                        let actualPrice: NSNumber = (queryDic["ActualPrice"] as? NSNumber)!
                        let discount: NSNumber = (queryDic["EarnedDiscount"] as? NSNumber)!
                        let discPrice: NSNumber = (queryDic["TotalPrice"] as? NSNumber)!
                        if discount == 0
                        {
                            self.vetOnCallPrice = actualPrice.stringValue
                            self.haveDiscount = false
                            UserDefaults.standard.set(self.discPercent, forKey: "TalkToVetDiscount")
                            UserDefaults.standard.synchronize()
                        }
                        else
                        {
                            self.vetOnCallPrice = discPrice.stringValue
                            self.discPercent = discount.stringValue
                            self.haveDiscount = true
                            UserDefaults.standard.set(self.discPercent, forKey: "TalkToVetDiscount")
                            UserDefaults.standard.synchronize()
                        }
                        UserDefaults.standard.set(self.vetOnCallPrice, forKey: "TalkToVetPrice")
                        UserDefaults.standard.synchronize()
                }
            }
        }
        task.resume()
        
    }
    func webServiceToGetVetOnCallList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.VetOnCall.VetOnCallList, userId)
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
                let queryDic = json?["callList"] as? [[String : Any]]
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
                                    if !(item[key] is NSNull)
                                    {
                                        prunedDictionary[key] = item[key]
                                    }
                                    else
                                    {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            //  self.vetModelList = [VetModel]()
                            for item in filtered
                            {
                                var callDate: String = ""
                                var callTime: String = ""
                                if item["DateTime"] as? String != ""
                                {
                                    let str = (item["DateTime"] as? String)?.components(separatedBy: " ")
                                    callDate = str![0]
                                    callTime = String(format: "%@ %@",str![1],str![2])
                                }
                                let call = VetOnCallModel(petId: item["PetId"] as? String, petName: item["PetName"] as? String, date: callDate, time: callTime, query: item["HealthProblem"] as? String, status: item["callStatus"] as? String, petType: item["PetType"] as? String)
                                
                                self.vetOnCallListArray.append(call!)
                            }
                            for model in self.vetOnCallListArray
                            {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                                let date = dateFormatter.date(from: model.date!)
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                model.date = dateFormatter.string(from: date!)
                            }
                            self.vetOnCallListArray = self.vetOnCallListArray.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
                            self.vetOnCallListTbl.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vetOnCallListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VetOnCall", for: indexPath) as!  MyPetsTableViewCell
        let model = self.vetOnCallListArray[indexPath.row]
    
        cell.petType.text = model.petType
        cell.petName.text = model.petName!
        cell.condition.text = model.query
        cell.dob.text = model.date
        cell.gender.text = model.time
        cell.status.text = model.status
        if model.status == "Completed"// 92,184,92
        {
            cell.status.backgroundColor = UIColor(red: (92.0 / 255.0), green: (184.0 / 255.0), blue: (92.0 / 255.0), alpha: 1)
        }
        else if model.status == "Scheduled" //66,139,202
        {
            cell.status.backgroundColor = UIColor(red: (66.0 / 255.0), green: (139.0 / 255.0), blue: (202.0 / 255.0), alpha: 1)
        }
        return cell
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
