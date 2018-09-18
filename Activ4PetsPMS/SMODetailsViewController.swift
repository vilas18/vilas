//
//  SMODetailsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SMODetailsViewController: UIViewController
{
    @IBOutlet weak var diagnosis: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var dateOfOnset: UILabel!
    @IBOutlet weak var tests: UILabel!
    @IBOutlet weak var symptoms: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var questions: UILabel!
    var SMOModelList = [SMOModel]()
    @IBOutlet weak var testList: UIButton!
    
    var model: SMOModel?
    var isFromVC : Bool = false
    var smoId: String = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        if self.isFromVC
        {
            // self.prepareUI()
            checkInternetConnection()
        }
        else{
            self.prepareUI()
        }
        
        // Do any additional setup after loading the view.
    }
    func prepareUI()
    {
        let str = String(format: "SMO ID - SM%@", (self.model?.smoId)!)
        self.title = str
        self.diagnosis.text = self.model?.diagnosis
        self.comments.text = self.model?.comments
        self.dateOfOnset.text = self.model?.dateOfOnset
        //print(self.model?.testList)
        let count = self.model?.testList?.count ?? 0
        if count == 0
        {
            self.testList.isUserInteractionEnabled = false
        }
        else{
            self.testList.addTarget(self, action: #selector(showTestList), for: .touchUpInside)
        }
        print(count)
        self.tests.text = String(format: "%d tests accomplished", count)
        
        self.symptoms.text = String(format: "%@ %@ %@", (self.model?.sympt1)!, (self.model?.sympt2)!, (self.model?.sympt3)!)
        if model?.status == "Assigned"
        {
            self.status.text = "In progress"
           
        }
        else if model?.status == "Validated"
        {
            self.status.text = "In progress"
        }
        else
        {
            self.status.text = self.model?.status
        }
        
        self.questions.text = self.model?.question
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.SMOModelList = []
            self.webServiceToGetSMOList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
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
                                let SMO = SMOModel(smoId: item["Id"] as! String, petName: item["PetName"] as! String, diagnosis : item["Diagnosis"] as! String, smoTitle : item["SMOTitle"] as! String, comments : item["Comments"] as? String, question : item["Question"] as? String, smoDate : item["SMODate"] as! String, testList : item["TestList"] as? [[String: Any]], sympt1 : item["Symptoms1"] as? String, sympt2 : item["Symptoms2"] as? String, sympt3 : item["Symptoms3"] as? String, status : item["Status"] as! String, petType : item["PetType"] as! String,dateOfOnset: item["DateOfOnSet"] as? String)
                                
                                self.SMOModelList.append(SMO!)
                            }
                            for model in self.SMOModelList
                            {
                                if self.smoId == model.smoId
                                {
                                    self.model = model
                                    self.prepareUI()
                                }
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
    @objc func leftClk(sender: AnyObject)
    {
        self.navigationController!.popViewController(animated: true)
    }
    @objc func showTestList()
    {
        var testNameLst: [String] = []
        var testDateLst: [String] = []
        for item in (self.model?.testList)!
        {
            testNameLst.append(String(format: "TestName: %@-",(item["TestDescription"] as? String)!))
            let dateString = item["TestDate"] as? String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let dateFromString = formatter.date(from: dateString!)
            {
                formatter.dateFormat = "MM/dd/yyyy" //which format is needed
                let stringFromDate = formatter.string(from: dateFromString)
                testDateLst.append(String(format: "TestDate: %@",stringFromDate))
                print(stringFromDate)
            }
        }
        print(testNameLst)
        print(testDateLst)
        let a = testNameLst
        let b = testDateLst
        
        let result = zip(a, b).map{$0 + String($1)}
        
        print(result)
        let str = result.joined(separator: "\n")
        print(str)
        let alert = UIAlertController(title: "Test(s) Details", message: str, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
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
