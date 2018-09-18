//
//  HospitalizationsListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class HospitalizationModel: NSObject
{
    var hospId: String
    var hospName: String
    var reason: String
    var admitDate: String?
    var endDate: String?
    var urgentCare: Bool?
    var comments: String?
    
    
    init(hospId: String, hospName: String, reason: String, admitDate: String?, endDate: String, urgentCare: Bool?, comment: String?)
    {
        self.hospId = hospId
        self.hospName = hospName
        self.reason = reason
        self.admitDate = admitDate
        self.endDate = endDate
        self.urgentCare = urgentCare
        self.comments = comment
        
    }
}
class HospitalizationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var hospitalizeTv: UITableView!
    var hospitalizeList = [Any]()
    var hospModelList = [HospitalizationModel]()
    var noDataLbl: UILabel?
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var sectionView: TPKeyboardAvoidingScrollView!
    var isFromMedical: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Health History"
        var leftItem: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addHospitalization))
        
        
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
            navigationItem.rightBarButtonItem = nil
            noDataLbl?.text =  "No records found"
        }
        else{
            navigationItem.rightBarButtonItem = rightItem2!
            noDataLbl?.text =  "No records found.\n Tap on '+' to add a Hospitalization"
        }
        if isFromMedical
        {
            self.sectionView.isHidden = true
            self.topSpace.constant = 0
        }
        
        // Do any additional setup after loading the view.
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
    @objc func addHospitalization(_ sender: Any)
    {
        let addHospitalization: AddEditHospitalizationViewController? = storyboard?.instantiateViewController(withIdentifier: "addHospitalization") as! AddEditHospitalizationViewController?
        addHospitalization?.isFromVC = false
        navigationController?.pushViewController(addHospitalization!, animated: true)
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
                navigationItem.rightBarButtonItem = nil
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
            self.hospModelList = []
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
        let urlStr = String(format : "%@?petId=%@", API.Hospitalization.HospitalizationList, petId)
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
                let queryDic = json?["hospitalizationList"] as? [[String : Any]]
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
                                self.hospitalizeTv.reloadData()
                                prefs.set(true, forKey: "ZeroHospitalization")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HospitalizationView"), object: self, userInfo: ["ZeroHospitalization": prefs.bool(forKey: "ZeroHospitalization")])
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = false
                                self.hospitalizeTv.reloadData()
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
                                let Hospitalize = HospitalizationModel (hospId: item["Id"] as! String, hospName: item["HospitalName"] as! String, reason: item["Reason"] as! String, admitDate: item["AdmissionDate"] as! String?, endDate: (item["EndDate"] as! String?)!, urgentCare: item["UrgentCareVisit"] as! Bool?, comment: item["Comment"] as! String?)
                                
                                self.hospModelList.append(Hospitalize)
                            }
                            
                            self.hospitalizeTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            prefs.set(false, forKey: "ZeroHospitalization")
                            prefs.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HospitalizationView"), object: self, userInfo: ["ZeroHospitalization": prefs.bool(forKey: "ZeroHospitalization")])
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
        return self.hospModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let model = self.hospModelList[indexPath.row]
        cell.firstLabel.text = model.hospName
        cell.secLabel.text = model.reason
        if self.isFromMedical == true
        {
            cell.firstBtn.isHidden = true
            // cell.isUserInteractionEnabled = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = hospModelList[indexPath.row]
        self.performSegue(withIdentifier: "HospitalizationDetails", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "HospitalizationDetails"
        {
            let edit: HospitalizationDetailsViewController = segue.destination as! HospitalizationDetailsViewController
            if self.isFromMedical
            {
                edit.isFromDetails = true
            }
            edit.model = sender as! HospitalizationModel?
        }
    }
    
    @IBAction func moveToSeletecdHealthPage(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is ConditionListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let condition: ConditionListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConditionList") as! ConditionListViewController
                    _ = self.navigationController?.pushViewController(condition, animated: true)
                    break
                }
            }
            
        }
        else if sender.tag == 2
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is SurgeryListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let surgery: SurgeryListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SurgeriesList") as! SurgeryListViewController
                    _ = self.navigationController?.pushViewController(surgery, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 3
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is MedicationListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let medication: MedicationListViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicationsList") as! MedicationListViewController
                    _ = self.navigationController?.pushViewController(medication, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 4
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is AllergiesListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let allergy: AllergiesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllergiesList") as! AllergiesListViewController
                    _ = self.navigationController?.pushViewController(allergy, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 5
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is ImmunizationsListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let immunization: ImmunizationsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImmunizationsList") as! ImmunizationsListViewController
                    _ = self.navigationController?.pushViewController(immunization, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 6
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is FoodPlanListViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let foodPlan: FoodPlanListViewController = self.storyboard?.instantiateViewController(withIdentifier: "FoodPlanList") as! FoodPlanListViewController
                    _ = self.navigationController?.pushViewController(foodPlan, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 7
        {
            print("self")
        }
        else if sender.tag == 8
        {
            let consultation: ConsultationListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConsultationList") as! ConsultationListViewController
            _ = self.navigationController?.pushViewController(consultation, animated: true)
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
