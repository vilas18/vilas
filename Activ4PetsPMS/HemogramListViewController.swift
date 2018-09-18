//
//  HemogramListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 10/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class HemogramListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // hmt type id = 6
    var model: CbgHemHemSerumModel?
    var hemogramList = [Any]()
    var hemogramModelList = [CbgHemHemSerumModel]()
    var noDataLbl: UILabel?
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    @IBOutlet weak var sectionView: TPKeyboardAvoidingScrollView!
    var isFromMedical: Bool = false
    
    
    @IBOutlet var hemogramTv: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health Tracker"
        var leftItem: UIBarButtonItem?
        var rightItem: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addHemogram))
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
            noDataLbl?.text =  "No records found.\n Tap on '+' to add a Hemogram"
        }
        
        if isFromMedical
        {
            self.sectionView.isHidden = true
            self.topSpace.constant = 0
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func viewGraph(_ sender: Any)
    {
        if self.hemogramModelList.count == 0 || self.hemogramModelList.count == 1
        {
            let alertDel = UIAlertController(title: "Alert", message: "To see the graph, add minimum two values", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else
        {
            let Hemogram: HemogramGraphViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemogramGraph") as! HemogramGraphViewViewController
            _ = self.navigationController?.pushViewController(Hemogram, animated: true)
            
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
    @objc func addHemogram(_ sender: Any)
    {
        
        let addHemogram: AddEditHemogramViewController? = storyboard?.instantiateViewController(withIdentifier: "addHemogram") as! AddEditHemogramViewController?
        addHemogram?.isFromVC = false
        navigationController?.pushViewController(addHemogram!, animated: true)
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
            self.hemogramModelList = []
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
        let urlStr = String(format : "%@?petId=%@&HMT_TypeId=%@", API.Hemogram.HemogramList, petId, "6")
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
                let queryDic = json?["hemogramList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                let prefs = UserDefaults.standard
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            if self.isFromMedical == true
                            {
                                
                                self.noDataLbl?.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.hemogramTv.reloadData()
                                prefs.set(true, forKey: "ZeroHemogram")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HemogramView"), object: self, userInfo: ["ZeroHemogram": prefs.bool(forKey: "ZeroHemogram")])
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = false
                                self.hemogramTv.reloadData()
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
                                let hemogram = CbgHemHemSerumModel (commonId: item["Id"] as! String, measureDate: item["MeasureDate"] as! String, value: item["HemogramValue"] as! String, graphValue: item["GraphValue"] as! NSNumber)
                                
                                self.hemogramModelList.append(hemogram)
                            }
                            
                            self.hemogramTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            prefs.set(false, forKey: "ZeroHemogram")
                            prefs.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HemogramView"), object: self, userInfo: ["ZeroHemogram": prefs.bool(forKey: "ZeroHemogram")])
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
        return self.hemogramModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let model = self.hemogramModelList[indexPath.row]
        
        cell.firstLabel.text = String(format: "Hemogram %@", model.value)
        cell.secLabel.text = model.measureDate
        
        let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
        
        btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        if self.isFromMedical == true
        {
            btn?.isHidden = true
            cell.isUserInteractionEnabled = false
        }
        else
        {
            btn?.isHidden = false
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.isFromMedical == true
        {
            self.model = hemogramModelList[indexPath.row]
            self.performSegue(withIdentifier: "editHemogram", sender: self.model)
        }
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
        
        self.model = hemogramModelList[(indexPath?.row)!]
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let submit = UIAlertAction(title: "Edit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.performSegue(withIdentifier: "editHemogram", sender: self.model)
            
        })
        let delete = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            let alertDel = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Deleting", comment: "")
                self.hemogramDelMethod(self.model!)
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
    func hemogramDelMethod(_ model: CbgHemHemSerumModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?HemogramId=%@", API.Hemogram.HemogramDelete, model.commonId)
            
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
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
                    let status = json?["Status"] as? Int
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if status == 1
                    {
                        let alertDel = UIAlertController(title: nil, message: "Hemogram details has been deleted successfully", preferredStyle: .alert)
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
        
        if segue.identifier == "editHemogram"
        {
            let edit: AddEditHemogramViewController = segue.destination as! AddEditHemogramViewController
            edit.isFromVC = true
            edit.model = sender as! CbgHemHemSerumModel?
        }
    }
    
    @IBAction func moveToSeletecdHealthPage(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is VitalsListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let Vitals: VitalsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsList") as! VitalsListViewController
                    _ = self.navigationController?.pushViewController(Vitals, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 2
        {
            
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is CBGListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let CBG: CBGListViewController = self.storyboard?.instantiateViewController(withIdentifier: "CBGList") as! CBGListViewController
                    _ = self.navigationController?.pushViewController(CBG, animated: true)
                    break
                }
            }
            
        }
        else if sender.tag == 3
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is HemoglobinListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let Hemoglobin: HemoglobinListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemoglobinList") as! HemoglobinListViewController
                    _ = self.navigationController?.pushViewController(Hemoglobin, animated: true)
                    break
                }
            }
            
        }
        else if sender.tag == 4
        {
            print("self")
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
