//
//  CBGGraphViewViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 14/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class CBGGraphViewViewController: UIViewController
{
    
    var cbgList = [Any]()
    var cbgModelList = [CbgHemHemSerumModel]()
    var xDataList = [Any]()
    var gramList = [Any]()
    var revxDataList = [Any]()
    var revgramList = [Any]()
    var model: CbgHemHemSerumModel?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var twrChartView: TWRChartView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health Tracker"
        var leftItem: UIBarButtonItem?
        
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.twrChartView.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        startAuthenticatingUser()
    }
    
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.cbgModelList = []
            self.xDataList = []
            self.gramList = []
            revxDataList = []
            revgramList = []
            self.getList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@&HMT_TypeId=%@", API.CBG.CBGList, petId, "5")
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
                let queryDic = json?["cbgList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
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
                        let CBG = CbgHemHemSerumModel (commonId: item["Id"] as! String, measureDate: item["MeasureDate"] as! String, value: item["Value"] as! String, graphValue: item["GraphValue"] as! NSNumber)
                        
                        self.cbgModelList.append(CBG)
                        self.xDataList.append(CBG.measureDate)
                        self.gramList.append(CBG.graphValue)
                    }
                    DispatchQueue.main.async
                        {
                            self.revxDataList = Array((self.xDataList as NSArray).reverseObjectEnumerator())
                            self.revgramList = Array((self.gramList as NSArray).reverseObjectEnumerator())
                            self.loadFeetLineChart()
                            MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
            else
            {
                //self.noDataLbl?.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    
    func loadFeetLineChart()
    {
        let dataSet = TWRDataSet(dataPoints: revgramList)
        let labels: [Any] = revxDataList
        let line = TWRLineChart(labels: labels, dataSets: [dataSet ?? " "], animated: false)
        twrChartView.load(line)
    }
    
    @IBAction func moveToSeletecdHealthPage(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is VitalsGraphViewViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let Vitals: VitalsGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsGraph") as! VitalsGraphViewViewController
                    _ = self.navigationController?.pushViewController(Vitals, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 2
        {
            
            print("self")
        }
        else if sender.tag == 3
        {
            let Hemoglobin: HemoglobinGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemoglobinGraph") as! HemoglobinGraphViewViewController
            _ = self.navigationController?.pushViewController(Hemoglobin, animated: true)
            
        }
        else if sender.tag == 4
        {
            let Hemogram: HemogramGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemogramGraph") as! HemogramGraphViewViewController
            _ = self.navigationController?.pushViewController(Hemogram, animated: true)
        }
        else if sender.tag == 5
        {
            let Serum: SerumElectrolytesGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "SerumElectrolytesGraph") as! SerumElectrolytesGraphViewViewController
            _ = self.navigationController?.pushViewController(Serum, animated: true)
            
        }
        
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
