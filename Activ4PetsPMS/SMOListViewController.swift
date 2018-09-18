//
//  SMOListViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class SMOModel: NSObject
{
    var smoId: String
    var petName: NSString
    var diagnosis: String
    var smoTitle: NSString
    var comments: String?
    var question: String?
    var smoDate: String
    var testList: [[String: Any]]?
    var sympt1: String?
    var sympt2: String?
    var sympt3: String?
    var status: String
    var petType: String
    var dateOfOnset: String?
    
    init?(smoId: String, petName: String, diagnosis : String, smoTitle : String, comments : String?, question : String?, smoDate : String, testList : [[String: Any]]?, sympt1 : String?, sympt2 : String?, sympt3 : String?, status : String, petType : String, dateOfOnset: String?)
    {
        
        self.smoId=smoId
        self.petName=petName as NSString
        self.diagnosis=diagnosis
        self.smoTitle=smoTitle as NSString
        self.comments=comments
        self.question=question
        self.smoDate=smoDate
        self.testList=testList
        self.sympt1=sympt1
        self.sympt2=sympt2
        self.sympt3=sympt3
        self.status = status
        self.petType = petType
        self.dateOfOnset = dateOfOnset
        
    }
    
}

class SMOListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIDocumentInteractionControllerDelegate
{
    
    @IBOutlet weak var searchSMO: UISearchBar!
    var noDataLbl: UILabel?
    var patientID: String = ""
    var SMOListArray = [Any]()
    var SMOModelList = [SMOModel]()
    var prefs: UserDefaults?
    var smoPrice: String = ""
    @IBOutlet weak var SMOListTbl: UITableView!
    var selectedModel: SMOModel?
    var docInteractionCon: UIDocumentInteractionController?
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
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.text =  "No records found.\n Tap on '+' to create a new SMO Request"
        
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
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
    
    @objc func rightClk2(sender: AnyObject)
    {
        if UserDefaults.standard.bool(forKey: "ZeroPetList")
        {
            let alert = UIAlertController(title: "Warning", message: "Please add a Pet to create a new SMO request" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }
        else if self.haveDiscount
        {
            let alert = UIAlertController(title: "Congratulations!", message: String(format: "You got a dicount of %@ %@ \n After discount, the payable service charge for one Second Opinion service is $%@.\n Do you want to continue?",self.discPercent,"%",self.smoPrice) , preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "AddNewSMO", sender: nil)
            })
            let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Notice", message: String(format: "Service charge - $%@ for one E-consultation service.\n Do you want to continue?",self.smoPrice) , preferredStyle: .alert)
            let ok = UIAlertAction(title: "YES", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "AddNewSMO", sender: nil)
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
            self.SMOModelList = []
            self.getPriceForSMO()
            self.webServiceToGetSMOList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getPriceForSMO()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@&Service=%@", API.Online.GetPrice, userId,"SMO")
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
                        //self.smoPrice = queryDic[1]
                        let actualPrice: NSNumber = (queryDic["ActualPrice"] as? NSNumber)!
                        let discount: NSNumber = (queryDic["EarnedDiscount"] as? NSNumber)!
                        let discPrice: NSNumber = (queryDic["TotalPrice"] as? NSNumber)!
                        if discount == 0
                        {
                            self.smoPrice = actualPrice.stringValue
                            self.haveDiscount = false
                            UserDefaults.standard.set(self.discPercent, forKey: "SMODiscount")
                            UserDefaults.standard.synchronize()
                        }
                        else
                        {
                            self.smoPrice = discPrice.stringValue
                            self.discPercent = discount.stringValue
                            self.haveDiscount = true
                            UserDefaults.standard.set(self.discPercent, forKey: "SMODiscount")
                            UserDefaults.standard.synchronize()
                        }
                        UserDefaults.standard.set(self.smoPrice, forKey: "SMOPriceValue")
                        UserDefaults.standard.synchronize()
                        
                }
            }
        }
        task.resume()
        
    }
    func webServiceToGetSMOList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?UserId=%@", API.Online.SMOList, userId)
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
                let queryDic = json?["smolist"] as? [[String : Any]]
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
                                let SMO = SMOModel(smoId: item["Id"] as! String, petName: item["PetName"] as! String, diagnosis : item["Diagnosis"] as! String, smoTitle : item["SMOTitle"] as! String, comments : item["Comments"] as? String, question : item["Question"] as? String, smoDate : item["SMODate"] as! String, testList : item["TestList"] as? [[String: Any]], sympt1 : item["Symptoms1"] as? String, sympt2 : item["Symptoms2"] as? String, sympt3 : item["Symptoms3"] as? String, status : item["Status"] as! String, petType : item["PetType"] as! String,dateOfOnset: item["DateOfOnSet"] as? String)
                                
                                self.SMOModelList.append(SMO!)
                            }
                            for model in self.SMOModelList
                            {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"// yyyy-MM-dd"
                                let date = dateFormatter.date(from: model.smoDate)
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                model.smoDate = dateFormatter.string(from: date!)
                            }
                            self.SMOModelList = self.SMOModelList.sorted(by: {$0.smoDate.compare($1.smoDate) == .orderedDescending})
                            self.SMOListTbl.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        } 
                }
            }
            else
            {
                self.noDataLbl?.isHidden = false
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
            for srchVet: SMOModel in SMOModelList
            {
                let tmp1: NSString = srchVet.petName as NSString
                let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                let lastNameRange = srchVet.smoTitle.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                if range.location != NSNotFound || lastNameRange.location != NSNotFound
                {
                    self.searchList.append(srchVet)
                }
            }
        }
        SMOListTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int
        if isSearchOn {
            rowCount = Int(searchList.count)
        }
        else {
            rowCount = Int(SMOModelList.count)
        }
        return rowCount
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMO", for: indexPath) as!  MyPetsTableViewCell
        var SMO: SMOModel
        if isSearchOn
        {
            SMO = searchList[indexPath.row] as! SMOModel
        }
        else {
            SMO = SMOModelList[indexPath.row]
        }
        cell.shareBtn.isHidden = true
        cell.petType.text = SMO.petType
        cell.petName.text = SMO.petName as String
        cell.condition.text = SMO.smoTitle as String
        cell.dob.text = SMO.smoDate
        cell.status.text = SMO.status
        if SMO.status == "Complete"// 92,184,92
        {
            cell.status.backgroundColor = UIColor(red: (92.0 / 255.0), green: (184.0 / 255.0), blue: (92.0 / 255.0), alpha: 1)
            cell.shareBtn.isHidden = false
            cell.shareBtn.tag = Int(SMO.smoId)!
            cell.shareBtn.addTarget(self, action: #selector(self.downloadReport), for: .touchUpInside)
        }
        else if SMO.status == "Open" //66,139,202
        {
            cell.status.backgroundColor = UIColor(red: (66.0 / 255.0), green: (139.0 / 255.0), blue: (202.0 / 255.0), alpha: 1)
            cell.shareBtn.isHidden = true
        }
        else if SMO.status == "Assigned"
        {
            cell.status.text = "In progress"
            cell.status.backgroundColor = UIColor(red: (91.0 / 255.0), green: (192.0 / 255.0), blue: (222.0 / 255.0), alpha: 1)
        }
        else if SMO.status == "Validated"
        {
            cell.status.text = "In progress"
            cell.status.backgroundColor = UIColor(red: (66.0 / 255.0), green: (139.0 / 255.0), blue: (202.0 / 255.0), alpha: 1)
        }
        return cell
    }
    @objc func downloadReport(sender: AnyObject)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.SMOListTbl)
        let indexPath = self.SMOListTbl.indexPathForRow(at: buttonPosition)
        var SMO: SMOModel
        if indexPath != nil
        {
            if isSearchOn
            {
                SMO = searchList[(indexPath?.row)!] as! SMOModel
            }
            else {
                SMO = SMOModelList[(indexPath?.row)!]
            }
            self.webserviceToGetSMOReportPdf(SMO)
            
        }
    }
    func webserviceToGetSMOReportPdf(_ model: SMOModel)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let urlStr = String(format : "%@?SmoId=%@", API.Online.GetReport, model.smoId )
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
            {           // check for http errors
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
                            let str: String = (json?["Url"] as? String)!
                            self.showPdf(str)
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
    func showPdf(_ sender: String)
    {
        let url = URL(string: sender)
        if let urlData = try? Data(contentsOf: url!) as? Data,
            let urlDataByte = urlData
        {
            if urlDataByte.count > 0
            {
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory: String = paths[0]
                let filePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("SMOReport.pdf").absoluteString
                DispatchQueue.main.async(execute: {() -> Void in
                    try? urlDataByte.write(to: URL(string: filePath)!, options: Data.WritingOptions(rawValue: 1))
                    print("File Saved !")
                    let fileURL = URL(string: filePath)
                    self.docInteractionCon = UIDocumentInteractionController(url: fileURL!)
                    self.docInteractionCon?.delegate = self
                    self.docInteractionCon?.name = "SMO Report"
                    self.docInteractionCon?.presentPreview(animated: true)
                })
            }
        }
    }
    // MARK: -
    // MARK: Document Interaction Delegate Methods
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController)
    {
        print("User has dismissed preview")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var SMO: SMOModel
        if isSearchOn
        {
            SMO = searchList[indexPath.row] as! SMOModel
        }
        else
        {
            SMO = SMOModelList[indexPath.row]
        }
        self.performSegue(withIdentifier: "SMODetails", sender: SMO)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "SMODetails"
        {
            let details = segue.destination as! SMODetailsViewController
            details.model = sender as? SMOModel
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
