//
//  SurgeryListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 08/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
import Foundation

class SurgeryModel: NSObject
{
    var surgeryId: String
    var surgeryName: String
    var surgeryDate: String
    var reason: String
    var veterinarian: String?
    var comments: String?
    
    init(surgeryId: String, surgeryName: String, surgeryDate: String, reason: String, veterinarian: String?, comments: String?)
    {
        self.surgeryId = surgeryId
        self.surgeryName = surgeryName
        self.surgeryDate = surgeryDate
        self.reason = reason
        self.veterinarian = veterinarian
        self.comments = comments
    }
    
}
class SurgeryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var surgeryTv: UITableView!
    var surgeryList = [Any]()
    var surgModelList = [SurgeryModel]()
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
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addSurgery))
        
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
            noDataLbl?.text =  "No records found.\n Tap on '+' to add a Surgery"
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
    @objc func addSurgery(_ sender: Any)
    {
        let addSurgery: AddEditSurgeryViewController? = storyboard?.instantiateViewController(withIdentifier: "addSurgery") as! AddEditSurgeryViewController?
        addSurgery?.isFromVC = false
        navigationController?.pushViewController(addSurgery!, animated: true)
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
            self.surgModelList = []
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
        let urlStr = String(format : "%@?petId=%@", API.Surgery.SurgeryList, petId)
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
                let queryDic = json?["surgeryList"] as? [[String : Any]]
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
                                self.surgeryTv.reloadData()
                                prefs.set(true, forKey: "ZeroSurgery")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SurgeriesView"), object: self, userInfo: ["ZeroSurgery": prefs.bool(forKey: "ZeroSurgery")])
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = false
                                self.surgeryTv.reloadData()
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
                                let Surgery = SurgeryModel (surgeryId: item["Id"] as! String, surgeryName: item["Name"] as! String, surgeryDate: item["Date"] as! String, reason: item["Reason"] as! String, veterinarian: item["PhysicianName"] as! String?, comments: item["Comments"] as! String?)
                                
                                self.surgModelList.append(Surgery)
                            }
                            
                            self.surgeryTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            prefs.set(false, forKey: "ZeroSurgery")
                            prefs.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SurgeriesView"), object: self, userInfo: ["ZeroSurgery": prefs.bool(forKey: "ZeroSurgery")])
                        }
                }
            }
            else
            {
                //  self.noDataLbl?.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.surgModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let model = self.surgModelList[indexPath.row]
        cell.firstLabel.text = model.surgeryName
        cell.secLabel.text = model.surgeryDate
        if self.isFromMedical == true
        {
            cell.firstBtn.isHidden = true
            // cell.isUserInteractionEnabled = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = surgModelList[indexPath.row]
        self.performSegue(withIdentifier: "SurgeryDetails", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "SurgeryDetails"
        {
            let edit: SurgeryDetailsViewController = segue.destination as! SurgeryDetailsViewController
            if self.isFromMedical
            {
                edit.isFromDetails = true
            }
            edit.model = sender as! SurgeryModel?
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
            print("self")
        }
        else if sender.tag == 3
        {
            let medication: MedicationListViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicationsList") as! MedicationListViewController
            _ = self.navigationController?.pushViewController(medication, animated: true)
        }
        else if sender.tag == 4
        {
            let allergy: AllergiesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllergiesList") as! AllergiesListViewController
            _ = self.navigationController?.pushViewController(allergy, animated: true)
        }
        else if sender.tag == 5
        {
            let immunization: ImmunizationsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImmunizationsList") as! ImmunizationsListViewController
            _ = self.navigationController?.pushViewController(immunization, animated: true)
        }
        else if sender.tag == 6
        {
            let foodPlan: FoodPlanListViewController = self.storyboard?.instantiateViewController(withIdentifier: "FoodPlanList") as! FoodPlanListViewController
            _ = self.navigationController?.pushViewController(foodPlan, animated: true)
        }
        else if sender.tag == 7
        {
            let hospitalization: HospitalizationsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalizationList") as! HospitalizationsListViewController
            _ = self.navigationController?.pushViewController(hospitalization, animated: true)
            
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
