//
//  VitalsListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 10/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class VitalsCommonModel: NSObject
{
    var commonId: String?
    var measureDate: String?
    var hmtTypeId: String?
    var hmtName: String?
    var value1: String?
    var graphValue1: Double?
    var value2: String?
    var graphValue2: Double?
    
    
    
    init(commonId: String?, measureDate: String?, hmtTypeId: String?, hmtName: String?, value1: String?, graphValue1: Double?, value2: String, graphValue2: Double?)
    {
        self.commonId = commonId
        self.measureDate = measureDate
        self.hmtTypeId = hmtTypeId
        self.hmtName = hmtName
        self.value1 = value1
        self.graphValue1 = graphValue1
        self.value2 = value2
        self.graphValue2 = graphValue2
        
        
    }
    
}
class VitalsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var height: UIButton!
    @IBOutlet var weight: UIButton!
    @IBOutlet var temperature: UIButton!
    @IBOutlet var pulse: UIButton!
    var model: VitalsCommonModel?
    var vitalsList = [Any]()
    var vitalsModelList = [VitalsCommonModel]()
    var noDataLbl: UILabel?
    var hmtType: String = "Height"
    var hmtTypeId: String = "1"
    
    @IBOutlet var vitalsTv: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health Tracker"
        var leftItem: UIBarButtonItem?
        var rightItem: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addVitals))
        rightItem = UIBarButtonItem(image: UIImage(named: "health_tracker"), style: .done, target: self, action: #selector(self.viewGraph))
        
        
        
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 50))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 2
        
        noDataLbl?.lineBreakMode = .byTruncatingTail
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = rightItem
            noDataLbl?.text =  "No records found"
        }
        else
        {
            navigationItem.rightBarButtonItems = [rightItem2!, rightItem!]
            noDataLbl?.text =  "No records found.\n Tap on '+' to add a Vital"
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func viewGraph(_ sender: Any)
    {
        if self.vitalsModelList.count == 0 || self.vitalsModelList.count == 1
        {
            let alertDel = UIAlertController(title: "Alert", message: "To see the graph, add minimum two values", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else
        {
            if self.hmtType == "Height"
            {
                let vitals: VitalsGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsGraph") as! VitalsGraphViewViewController
                vitals.hmtType = "Height"
                vitals.hmtTypeId = "1"
                _ = self.navigationController?.pushViewController(vitals, animated: true)
                
            }
            else if self.hmtType == "Weight"
            {
                let vitals: VitalsGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsGraph") as! VitalsGraphViewViewController
                vitals.hmtType = "Weight"
                vitals.hmtTypeId = "2"
                _ = self.navigationController?.pushViewController(vitals, animated: true)
            }
            else if self.hmtType == "Temperature"
            {
                let vitals: VitalsGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsGraph") as! VitalsGraphViewViewController
                vitals.hmtType = "Temperature"
                vitals.hmtTypeId = "3"
                _ = self.navigationController?.pushViewController(vitals, animated: true)
            }
            else if self.hmtType == "Pulse"
            {
                let vitals: VitalsGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsGraph") as! VitalsGraphViewViewController
                vitals.hmtType = "Pulse"
                vitals.hmtTypeId = "4"
                _ = self.navigationController?.pushViewController(vitals, animated: true)
            }
            
            
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        for controller: UIViewController in (self.navigationController?.viewControllers)!
        {
            if (controller is MedicalRecordsViewController)
            {
                _ = self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @objc func addVitals(_ sender: Any)
    {
        if self.hmtType == "Height"
        {
            let addHeight: AddEditHeightViewController? = storyboard?.instantiateViewController(withIdentifier: "addHeight") as! AddEditHeightViewController?
            addHeight?.isFromVC = false
            navigationController?.pushViewController(addHeight!, animated: true)
        }
        else if self.hmtType == "Weight"
        {
            let addWeight: AddEditWeightViewController? = storyboard?.instantiateViewController(withIdentifier: "addWeight") as! AddEditWeightViewController?
            addWeight?.isFromVC = false
            navigationController?.pushViewController(addWeight!, animated: true)
        }
        else if self.hmtType == "Temperature"
        {
            let addTemperature: AddEditTemperatureViewController? = storyboard?.instantiateViewController(withIdentifier: "addTemp") as! AddEditTemperatureViewController?
            addTemperature?.isFromVC = false
            navigationController?.pushViewController(addTemperature!, animated: true)
        }
        else if self.hmtType == "Pulse"
        {
            let addPulse: AddEditPulseViewController? = storyboard?.instantiateViewController(withIdentifier: "addPulse") as! AddEditPulseViewController?
            addPulse?.isFromVC = false
            navigationController?.pushViewController(addPulse!, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let modVet: Bool = UserDefaults.standard.bool(forKey: "ModifyMedi")
            if modVet
            {
                
            }
            else
            {
                let rightItem = UIBarButtonItem(image: UIImage(named: "mr_tab_0005_hlth_trac_in.png"), style: .done, target: self, action: #selector(self.viewGraph))
                navigationItem.rightBarButtonItem = rightItem
            }
        }
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
        let urlStr = String(format : "%@?petId=%@&HMT_TypeId=%@", API.Vitals.VitalsList, petId, self.hmtTypeId)
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
                let queryDic = json?["vitalList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            DispatchQueue.main.async
                                {
                                    self.noDataLbl?.isHidden = false
                                    self.vitalsTv.reloadData()
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
                            }
                            
                            self.vitalsTv.reloadData()
                            self.noDataLbl?.isHidden = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.vitalsModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let model = self.vitalsModelList[indexPath.row]
        if self.hmtType == "Height"
        {
            cell.firstLabel.text = String(format: "Height %@", model.value1!)
            cell.secLabel.text = model.measureDate
        }
        else if self.hmtType == "Weight"
        {
            cell.firstLabel.text = String(format: "Weight %@", model.value1!)
            cell.secLabel.text = model.measureDate
        }
        else if self.hmtType == "Temperature"
        {
            cell.firstLabel.text = String(format: "Temperature %@", model.value1!)
            cell.secLabel.text = model.measureDate
        }
        else if self.hmtType == "Pulse"
        {
            cell.firstLabel.text = String(format: "Pulse %@", model.value1!)
            cell.secLabel.text = model.measureDate
        }
        let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
        
        btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let modVet: Bool = UserDefaults.standard.bool(forKey: "ModifyMedi")
            if modVet
            {
                btn?.isUserInteractionEnabled = true
            }
            else
            {
                btn?.isUserInteractionEnabled = false
            }
        }
        
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            cell.isUserInteractionEnabled = false
        }
        else{
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    @objc func showOptions(_ sender: UIButton)
    {
        let clickedCell: CommonTableViewCell? = (sender.superview?.superview as? CommonTableViewCell)
        var views: Any? = clickedCell?.superview
        while (views != nil) && (views is UITableView) == false {
            views = (views as AnyObject).superview ?? " "
        }
        let tableView: UITableView? = (views as? UITableView)
        let indexPath: IndexPath? = tableView?.indexPath(for: clickedCell!)
        self.model = vitalsModelList[(indexPath?.row)!]
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let submit = UIAlertAction(title: "Edit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if self.hmtType == "Height"
            {
                self.performSegue(withIdentifier: "editHeight", sender: self.model)
            }
            else if self.hmtType == "Weight"
            {
                self.performSegue(withIdentifier: "editWeight", sender: self.model)
            }
            else if self.hmtType == "Temperature"
            {
                self.performSegue(withIdentifier: "editTemp", sender: self.model)
            }
            else if self.hmtType == "Pulse"
            {
                self.performSegue(withIdentifier: "editPulse", sender: self.model)
            }
        })
        let delete = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let alertDel = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Deleting", comment: "")
                self.vitalsDelMethod(self.model!)
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertDel.addAction(ok)
            alertDel.addAction(cancel)
            self.present(alertDel, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submit)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(alert, animated: true, completion: nil)
    }
    func vitalsDelMethod(_ model: VitalsCommonModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?HMTID=%@", API.Vitals.VitalsDelete, model.commonId!)
            
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
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
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Vital details has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.startAuthenticatingUser()
                        })
                        
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            task.resume()
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "editHeight"
        {
            let edit: AddEditHeightViewController = segue.destination as! AddEditHeightViewController
            edit.isFromVC = true
            edit.model = sender as! VitalsCommonModel?
        }
        else if segue.identifier == "editWeight"
        {
            let edit: AddEditWeightViewController = segue.destination as! AddEditWeightViewController
            edit.isFromVC = true
            edit.model = sender as! VitalsCommonModel?
        }
        else if segue.identifier == "editTemp"
        {
            let edit: AddEditTemperatureViewController = segue.destination as! AddEditTemperatureViewController
            edit.isFromVC = true
            edit.model = sender as! VitalsCommonModel?
        }
        else if segue.identifier == "editPulse"
        {
            let edit: AddEditPulseViewController = segue.destination as! AddEditPulseViewController
            edit.isFromVC = true
            edit.model = sender as! VitalsCommonModel?
        }
    }
    @IBAction func showSelectedVitalsList(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.hmtTypeId = "1"
            self.hmtType = "Height"
            
            self.height.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.weight.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            
        }
        else if sender.tag == 2
        {
            self.hmtTypeId = "2"
            self.hmtType = "Weight"
            
            self.weight.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.temperature.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
            
        }
        else if sender.tag == 3
        {
            self.hmtTypeId = "3"
            self.hmtType = "Temperature"
            
            self.temperature.backgroundColor = UIColor.init(red: 6.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            self.height.backgroundColor = UIColor.clear
            self.weight.backgroundColor = UIColor.clear
            self.pulse.backgroundColor = UIColor.clear
        }
        else if sender.tag == 4
        {
            self.hmtTypeId = "4"
            self.hmtType = "Pulse"
            
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
            let CBG: CBGListViewController = self.storyboard?.instantiateViewController(withIdentifier: "CBGList") as! CBGListViewController
            _ = self.navigationController?.pushViewController(CBG, animated: true)
            
        }
        else if sender.tag == 3
        {
            let Hemoglobin: HemoglobinListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemoglobinList") as! HemoglobinListViewController
            _ = self.navigationController?.pushViewController(Hemoglobin, animated: true)
            
        }
        else if sender.tag == 4
        {
            let Hemogram: HemogramListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemogramList") as! HemogramListViewController
            _ = self.navigationController?.pushViewController(Hemogram, animated: true)
        }
        else if sender.tag == 5
        {
            let SerumElectrolytes: SerumElectrolytesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SerumElectrolytesList") as! SerumElectrolytesListViewController
            _ = self.navigationController?.pushViewController(SerumElectrolytes, animated: true)
            
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
