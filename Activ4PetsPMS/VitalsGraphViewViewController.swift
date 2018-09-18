//
//  VitalsGraphViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 14/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class VitalsGraphViewViewController: UIViewController
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var twrChartView: TWRChartView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet var height: UIButton!
    @IBOutlet var weight: UIButton!
    @IBOutlet var temperature: UIButton!
    @IBOutlet var pulse: UIButton!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var model: VitalsCommonModel?
    var vitalsList = [Any]()
    var xDataList = [Any]()
    var feetList = [Any]()
    var meterList = [Any]()
    var revxDataList = [Any]()
    var revfeetList = [Any]()
    var revmeterList = [Any]()
    var vitalsModelList = [VitalsCommonModel]()
    var hmtType: String = "Height"
    var hmtTypeId: String = "1"
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sectionView: TPKeyboardAvoidingScrollView!
    var isVitalsComingFromMedicalSummary: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health Tracker"
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.twrChartView.backgroundColor = UIColor.clear
        self.segControl.selectedSegmentIndex = 0
        self.segControl.addTarget(self, action: #selector(self.switchChart), for: .valueChanged)
        
        if self.hmtType == "Height"
        {
            self.height.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.weight.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            self.segControl.isHidden = false
            self.segControl.setTitle("ft ~ in", forSegmentAt: 0)
            self.segControl.setTitle("m ~ cm", forSegmentAt: 1)
        }
        else if self.hmtType == "Weight"
        {
            self.weight.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            self.segControl.isHidden = false
            self.segControl.setTitle("lb ~ oz", forSegmentAt: 0)
            self.segControl.setTitle("kg ~ gm", forSegmentAt: 1)
        }
        else if self.hmtType == "Temperature"
        {
            self.temperature.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.weight.backgroundColor = UIColor.clear
            self.height.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            self.segControl.isHidden = false
            self.segControl.setTitle("°F", forSegmentAt: 0)
            self.segControl.setTitle("°C", forSegmentAt: 1)
        }
        else if self.hmtType == "Pulse"
        {
            self.pulse.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.weight.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.height.backgroundColor = UIColor.clear
            self.segControl.isHidden = true
        }
        if self.isVitalsComingFromMedicalSummary
        {
            self.bottomView.isHidden = true
            self.sectionView.isHidden = true
            self.topSpace.constant = 0
            self.scrollView.isScrollEnabled = false
            self.segControl.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @objc func switchChart(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            loadFeetLineChart()
        case 1:
            loadMeterLineChart()
        default:
            break
        }
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
            self.vitalsModelList = []
            self.xDataList = []
            self.feetList = []
            revxDataList = []
            revfeetList = []
            revmeterList = []
            meterList = []
            self.getList()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@&HMT_TypeId=%@", API.Vitals.VitalsList, petId, self.hmtTypeId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {
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
                let queryDic = json?["vitalList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                let prefs = UserDefaults.standard
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            if self.isVitalsComingFromMedicalSummary == true
                            {
                                if self.hmtType == "Pulse"
                                {
                                    
                                    prefs.set(true, forKey: "ZeroPulse")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PulseGarphView"), object: self, userInfo: ["ZeroPulse": prefs.bool(forKey: "ZeroPulse")])
                                }
                                else if self.hmtType == "Temperature"
                                {
                                    
                                    prefs.set(true, forKey: "ZeroTemperature")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TemperatureGarphView"), object: self, userInfo: ["ZeroTemperature": prefs.bool(forKey: "ZeroTemperature")])
                                }
                                else if self.hmtType == "Weight"
                                {
                                    
                                    prefs.set(true, forKey: "ZeroWeight")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WeightGarphView"), object: self, userInfo: ["ZeroWeight": prefs.bool(forKey: "ZeroWeight")])
                                }
                                else if self.hmtType == "Height"
                                {
                                    
                                    prefs.set(true, forKey: "ZeroHeight")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeightGarphView"), object: self, userInfo: ["ZeroHeight": prefs.bool(forKey: "ZeroHeight") ])
                                }
                            }
                            else
                            {
                                self.twrChartView.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            
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
                                let Vitals = VitalsCommonModel (commonId: item["Id"] as? String, measureDate: item["Date"] as? String, hmtTypeId: item["HMT_TypeId"] as? String, hmtName: item["HMT_TypeName"] as? String, value1: item["Value1"] as? String, graphValue1: item["GraphVal1"] as? Double,value2: (item["Value2"] as? String)!, graphValue2: item["GraphVal2"] as? Double)
                                
                                self.vitalsModelList.append(Vitals)
                                self.xDataList.append(Vitals.measureDate ?? "")
                                self.feetList.append(Vitals.graphValue1 ?? 0.0)
                                self.meterList.append(Vitals.graphValue2 ?? 0.0)
                            }
                            self.revxDataList = Array((self.xDataList as NSArray).reverseObjectEnumerator())
                            self.revfeetList = Array((self.feetList as NSArray).reverseObjectEnumerator())
                            self.revmeterList = Array((self.meterList as NSArray).reverseObjectEnumerator())
                            self.loadFeetLineChart()
                            if self.isVitalsComingFromMedicalSummary == true
                            {
                                if self.hmtType == "Pulse"
                                {
                                    prefs.set(self.xDataList[0], forKey: "PulseDate")
                                    prefs.set("\(self.feetList[0]) bpm", forKey: "PulseValue")
                                    
                                    prefs.synchronize()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PulseGarphLabels"), object: self, userInfo: ["valueStr": prefs.value(forKey:"PulseValue") ?? " ", "dateStr": prefs.value(forKey: "PulseDate") ?? " "])
                                    prefs.set(false, forKey: "ZeroPulse")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PulseGarphView"), object: self, userInfo: ["ZeroPulse": prefs.bool(forKey: "ZeroPulse")])
                                }
                                else if self.hmtType == "Temperature"
                                {
                                    
                                    prefs.set(self.xDataList[0], forKey: "TemperatureDate")
                                    prefs.set("\(self.feetList[0]) F", forKey: "TemperatureValue")
                                    
                                    prefs.synchronize()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TempGarphLabels"), object: self, userInfo: ["valueStr": prefs.value(forKey: "TemperatureValue") ?? " ", "dateStr": prefs.value(forKey: "TemperatureDate") ?? " "])
                                    prefs.set(false, forKey: "ZeroTemperature")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TemperatureGarphView"), object: self, userInfo: ["ZeroTemperature": prefs.bool(forKey: "ZeroTemperature")])
                                }
                                else if self.hmtType == "Weight"
                                {
                                    prefs.set("\(self.xDataList[0])", forKey: "WeightDate")
                                    prefs.set("\(self.feetList[0]) lb", forKey: "WeightValue")
                                    
                                    prefs.synchronize()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WeightGarphLabels"), object: self, userInfo: ["valueStr": prefs.value(forKey: "WeightValue") ?? " ", "dateStr": prefs.value(forKey: "WeightDate") ?? " "])
                                    prefs.set(false, forKey: "ZeroWeight")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WeightGarphView"), object: self, userInfo: ["ZeroWeight": prefs.bool(forKey: "ZeroWeight")])
                                }
                                else if self.hmtType == "Height"
                                {
                                    prefs.set("\(self.xDataList[0])", forKey: "HeightDate")
                                    prefs.set("\(self.feetList[0]) ft", forKey: "HeightValue")
                                    
                                    prefs.synchronize()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeightGarphLabels"), object: self, userInfo: ["valueStr": prefs.value(forKey: "HeightValue") ?? " ", "dateStr": prefs.value(forKey: "HeightDate") ?? " "])
                                    prefs.set(false, forKey: "ZeroHeight")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeightGarphView"), object: self, userInfo: ["ZeroHeight": prefs.bool(forKey: "ZeroHeight")])
                                }
                            }
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
        if self.isVitalsComingFromMedicalSummary == false
        {
            let dataSet = TWRDataSet(dataPoints: revfeetList)
            let labels: [Any] = revxDataList
            let line = TWRLineChart(labels: labels, dataSets: [dataSet!] , animated: false)
            self.twrChartView.isHidden = false
            twrChartView.load(line)
        }
        else
        {
            let graphView = FDGraphView(frame: CGRect(x: 0, y: 100, width: 280, height: 200))
            graphView.setNeedsDisplay()
            graphView.linesColor = UIColor(red: (117.0 / 255.0), green: (180.0 / 255.0), blue: (37.0 / 255.0), alpha: 1)
            graphView.dataPointColor = UIColor.yellow
            graphView.dataPoints = revfeetList
            view.addSubview(graphView)
        }
    }
    func loadMeterLineChart()
    {
        if self.isVitalsComingFromMedicalSummary == false
        {
            let dataSet = TWRDataSet(dataPoints: revmeterList)
            let labels: [Any] = revxDataList
            let line = TWRLineChart(labels: labels, dataSets: [dataSet ?? " "], animated: false)
            self.twrChartView.isHidden = false
            twrChartView.load(line)
        }
        else
        {
            let graphView = FDGraphView(frame: CGRect(x: 0, y: 100, width: 280, height: 200))
            graphView.setNeedsDisplay()
            graphView.linesColor = UIColor(red: (117.0 / 255.0), green: (180.0 / 255.0), blue: (37.0 / 255.0), alpha: 1)
            graphView.dataPointColor = UIColor.yellow
            graphView.dataPoints = revmeterList
            view.addSubview(graphView)
        }
    }
    @IBAction func showSelectedVitalsList(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.hmtTypeId = "1"
            self.hmtType = "Height"
            self.segControl.isHidden = false
            self.segControl.setTitle("ft ~ in", forSegmentAt: 0)
            self.segControl.setTitle("m ~ cm", forSegmentAt: 1)
            
            self.height.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.weight.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            
        }
        else if sender.tag == 2
        {
            self.hmtTypeId = "2"
            self.hmtType = "Weight"
            self.segControl.isHidden = false
            self.segControl.setTitle("lb ~ oz", forSegmentAt: 0)
            self.segControl.setTitle("kg ~ gm", forSegmentAt: 1)
            
            self.weight.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            
        }
        else if sender.tag == 3
        {
            self.hmtTypeId = "3"
            self.hmtType = "Temperature"
            self.segControl.isHidden = false
            self.segControl.setTitle("°F", forSegmentAt: 0)
            self.segControl.setTitle("°C", forSegmentAt: 1)
            
            self.temperature.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.weight.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
        }
        else if sender.tag == 4
        {
            self.hmtTypeId = "4"
            self.hmtType = "Pulse"
            self.segControl.isHidden = true
            self.pulse.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.weight.backgroundColor = UIColor.clear
            
        }
        self.startAuthenticatingUser()
    }
    
    @IBAction func moveToSeletecdHealthPage(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            print("self")
            
        }
        else if sender.tag == 2
        {
            let CBG: CBGGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "CBGGraph") as! CBGGraphViewViewController
            _ = self.navigationController?.pushViewController(CBG, animated: true)
            
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
