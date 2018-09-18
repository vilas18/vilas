//
//  MedicalRecordsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 07/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class MedicalRecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var petImg: UIButton!
    @IBOutlet weak var mediRec: UIButton!
    @IBOutlet weak var veterinarians: UIButton!
    @IBOutlet weak var contacts: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var listTv: UITableView!
    var historyArr = [String]()
    var trackerArr = [String]()
    var documentArr = [String]()
    var historyArrIcons = [String]()
    var trackerArrIcons = [String]()
    var documentArrIcons = [String]()
    var healthTrackerCount = [0,0,0,0,0]
    var healthHistoryCount = [0,0,0,0,0,0,0,0]
    var healthDocumentCount = [0,0,0,0,0,0]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var rightItem1: UIBarButtonItem?
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        self.navigationItem.rightBarButtonItem = rightItem1
        self.segmentCtrl.selectedSegmentIndex = 0
        galleryView.isHidden = true
        galleryView.layer.masksToBounds = true
        galleryView.layer.borderWidth = 1
        galleryView.layer.cornerRadius = 2
        galleryView.layer.borderColor = UIColor.lightGray.cgColor
        self.historyArr = ["Conditions", "Surgeries/Procedures", "Medications", "Allergies", "Immunizations", "Food Plan", "Hospitalization", "Consultations"]
        self.trackerArr = ["Vitals", "CBG", "Hemoglobin", "Hemogram", "Serum Electrolytes"]
        self.documentArr = ["Notes", "Imaging Services", "Laboratory", "Prescription", "A4P Services", "Insurance"]
        
        self.historyArrIcons = ["ic_condition.png", "ic_surgery.png", "ic_0001s_0004_medication.png", "ic_allergies.png", "ic_vaccination.png", "ic_0001s_0002_foodplan.png", "ic_hospitalization.png", "ic_consultation.png"]
        
        self.trackerArrIcons = ["ic_health_tracker.png", "ic_health_tracker.png", "ic_health_tracker.png", "ic_health_tracker.png", "ic_health_tracker.png"]
        
        self.documentArrIcons = ["doc_ic_0000_note.png", "doc_ic_0001_imaging_services.png", "doc_ic_0002_laboratory.png", "doc_ic_0003_prescription.png", "doc_ic_0004_ado_services.png", "doc_ic_0005_insurance"]
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showMenu(_ sender: Any)
    {
        let story: UIStoryboard = UIStoryboard.init(name: "Main_iPhone", bundle: nil)
        let menu:  MenuPageViewController = story.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    func startAuthenticatingUser()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.getCountofMedicalRecords()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getCountofMedicalRecords()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?PetId=%@", API.Pet.MedicalRecordsCount, petId)
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
                let status = json?["Status"] as? String
            {
                DispatchQueue.main.async
                    {
                        print(json!)
                        if status == "1"
                        {
                            
                            let trackDict = json?["HealthTracker"] as? [String: Int]
                            
                            self.healthTrackerCount = [(trackDict?["VitalList"])!,(trackDict?["CbgList"])!,(trackDict?["HemoglobinList"])!,(trackDict?["HemogramList"])!,(trackDict?["SerumElectrolyteList"])!]
                            print(self.healthTrackerCount)
                            let histDict = json?["HealthHistory"] as? [String: Int]
                            
                            self.healthHistoryCount = [(histDict?["ConditiontList"]!)!,(histDict?["SurgeryList"]!)!,(histDict?["MedicationList"]!)!,(histDict?["AllergyList"]!)!,(histDict?["ImmunizationList"]!)!,(histDict?["FoodplanList"]!)!,(histDict?["HospitalizationList"]!)!,(histDict?["ConsultationList"]!)!]
                            print(self.healthHistoryCount)
                            let docDict = json?["DocumentList"] as? [String: Int]
                            self.healthDocumentCount = [(docDict?["PetNoteList"]!)!,(docDict?["PetImagingServicesList"]!)!,(docDict?["PetLaboratoryList"]!)!,(docDict?["PetPrescriptionList"]!)!,(docDict?["PetADOServicesList"]!)!,(docDict?["PetInsuranceList"]!)!]
                            print(self.healthDocumentCount)
                            self.listTv.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.listTv.reloadData()
                            
                        }
                }
            }
            else
            {
                // self.noDataLbl?.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    
    @IBAction func selectSegmentChoice(_ sender: UISegmentedControl)
    {
        self.listTv.reloadData()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.startAuthenticatingUser()
        self.healthTrackerCount = [0,0,0,0,0]
        self.healthHistoryCount = [0,0,0,0,0,0,0,0]
        self.healthDocumentCount = [0,0,0,0,0,0]
        
        galleryView.isHidden = true
        mediRec.backgroundColor=UIColor(red: 6.0 / 255.0, green: 103.0 / 255.0, blue: 184.0 / 255.0, alpha: 1);
        mediRec.isSelected=true;
        petImg.setImage(UIImage(named: "tab_vets_active"), for: .selected)
        backView.backgroundColor = UIColor.white//(red: 0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        petImg.layer.masksToBounds = true
        petImg.layer.borderWidth = 1
        petImg.layer.cornerRadius=petImg.frame.size.width/2
        petImg.layer.borderColor = UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1).cgColor;
        let petImageUrl: String =  UserDefaults.standard.string(forKey: "PetProfile")!
        if let url = NSURL(string: petImageUrl)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                if data.length > 0
                {
                    
                    petImg.setImage(UIImage(data: data as Data), for: .normal)
                    petImg.setImage(UIImage(data: data as Data), for: .selected)
                }
                else
                {
                    
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                    petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
                }
            }
            else
            {
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
                petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
            }
        }
        else
        {
            petImg.setImage(UIImage(named: "petImage-default.png"), for: .normal)
            petImg.setImage(UIImage(named: "petImage-default.png"), for: .selected)
        }
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let shareCont: Bool = UserDefaults.standard.bool(forKey: "ShareCont")
            let shareVet: Bool = UserDefaults.standard.bool(forKey: "ShareVets")
            let shareGall: Bool = UserDefaults.standard.bool(forKey: "ShareGall")
            if shareVet
            {
                self.veterinarians.isUserInteractionEnabled = true
            }
            else
            {
                self.veterinarians.isUserInteractionEnabled = false
                self.veterinarians.backgroundColor = UIColor.lightGray
            }
            if shareCont
            {
                self.contacts.isUserInteractionEnabled = true
            }
            else
            {
                self.contacts.isUserInteractionEnabled = false
                self.contacts.backgroundColor = UIColor.lightGray
            }
            
            if shareGall
            {
                self.more.isUserInteractionEnabled = true
            }
            else
            {
                self.more.isUserInteractionEnabled = false
                self.more.backgroundColor = UIColor.lightGray
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int = 0
        
        if self.segmentCtrl.selectedSegmentIndex == 0
        {
            rowCount = self.historyArr.count
        }
        else if self.segmentCtrl.selectedSegmentIndex == 1
        {
            rowCount = self.trackerArr.count
        }
        else if self.segmentCtrl.selectedSegmentIndex == 2
        {
            rowCount = self.documentArr.count
        }
        
        return rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        if self.segmentCtrl.selectedSegmentIndex == 0
        {
            cell.icon.image = UIImage(named: self.historyArrIcons[indexPath.row])
            cell.firstLabel.text = self.historyArr[indexPath.row] + String(format: "  (%d)",self.healthHistoryCount[indexPath.row])
        }
        else if self.segmentCtrl.selectedSegmentIndex == 1
        {
            cell.icon.image = UIImage(named: self.trackerArrIcons[indexPath.row])
            cell.firstLabel.text = self.trackerArr[indexPath.row] + String(format: "  (%d)",self.healthTrackerCount[indexPath.row])
        }
        else if self.segmentCtrl.selectedSegmentIndex == 2
        {
            cell.icon.image = UIImage(named: self.documentArrIcons[indexPath.row])
            cell.firstLabel.text = self.documentArr[indexPath.row] + String(format: "  (%d)",self.healthDocumentCount[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.segmentCtrl.selectedSegmentIndex == 0
        {
            if indexPath.row == 0
            {
                let condition: ConditionListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConditionList") as! ConditionListViewController
                self.navigationController?.pushViewController(condition, animated: true)
            }
            else if indexPath.row == 1
            {
                let surgery: SurgeryListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SurgeriesList") as! SurgeryListViewController
                self.navigationController?.pushViewController(surgery, animated: true)
            }
            else if indexPath.row == 2
            {
                let medication: MedicationListViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicationsList") as! MedicationListViewController
                self.navigationController?.pushViewController(medication, animated: true)
            }
            else if indexPath.row == 3
            {
                let allergy: AllergiesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllergiesList") as! AllergiesListViewController
                self.navigationController?.pushViewController(allergy, animated: true)
            }
            else if indexPath.row == 4
            {
                let immunization: ImmunizationsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImmunizationsList") as! ImmunizationsListViewController
                self.navigationController?.pushViewController(immunization, animated: true)
            }
            else if indexPath.row == 5
            {
                let foodPlan: FoodPlanListViewController = self.storyboard?.instantiateViewController(withIdentifier: "FoodPlanList") as! FoodPlanListViewController
                self.navigationController?.pushViewController(foodPlan, animated: true)
            }
            else if indexPath.row == 6
            {
                let hospitalization: HospitalizationsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HospitalizationList") as! HospitalizationsListViewController
                self.navigationController?.pushViewController(hospitalization, animated: true)
            }
            else if indexPath.row == 7
            {
                let consultation: ConsultationListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConsultationList") as! ConsultationListViewController
                self.navigationController?.pushViewController(consultation, animated: true)
            }
        }
        else if self.segmentCtrl.selectedSegmentIndex == 1
        {
            if indexPath.row == 0
            {
                let Vitals: VitalsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "VitalsList") as! VitalsListViewController
                self.navigationController?.pushViewController(Vitals, animated: true)
                
            }
            else if indexPath.row == 1
            {
                let CBG: CBGListViewController = self.storyboard?.instantiateViewController(withIdentifier: "CBGList") as! CBGListViewController
                self.navigationController?.pushViewController(CBG, animated: true)
                
            }
            else if indexPath.row == 2
            {
                let Hemoglobin: HemoglobinListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemoglobinList") as! HemoglobinListViewController
                self.navigationController?.pushViewController(Hemoglobin, animated: true)
                
            }
            else if indexPath.row == 3
            {
                let Hemogram: HemogramListViewController = self.storyboard?.instantiateViewController(withIdentifier: "HemogramList") as! HemogramListViewController
                self.navigationController?.pushViewController(Hemogram, animated: true)
            }
            else if indexPath.row == 4
            {
                let SerumElectrolytes: SerumElectrolytesListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SerumElectrolytesList") as! SerumElectrolytesListViewController
                self.navigationController?.pushViewController(SerumElectrolytes, animated: true)
                
            }
        }
        else if self.segmentCtrl.selectedSegmentIndex == 2
        {
            if indexPath.row == 0
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "Note"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
            }
            else if indexPath.row == 1
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "Imaging Services"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
                
            }
            else if indexPath.row == 2
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "Laboratory"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
                
            }
            else if indexPath.row == 3
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "Prescription"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
            }
            else if indexPath.row == 4
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "A4P Services"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
                
            }
            else if indexPath.row == 5
            {
                let DocumentList: DocumentsListViewController? = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController?
                DocumentList?.comingDocType = "Insurance"
                self.navigationController?.pushViewController(DocumentList!, animated: true)
                
            }
        }
        //tableView.didDeselectRowAt(indexPath)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        
    }
    @IBAction func showTabs(_ item: UIButton)
    {
        if item.tag == 1
        {
            for controller : UIViewController in (self.navigationController?.viewControllers)!
            {
                if #available(iOS 10.0, *) {
                    if (controller is PetDetailsViewController)
                    {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else if item.tag == 2
        {
            print("self")
        }
        else if item.tag == 3
        {
            let story: UIStoryboard = UIStoryboard.init(name: "Main_iPhone", bundle: nil)
            let details: VeterinarianListViewController? = story.instantiateViewController(withIdentifier: "vetList") as? VeterinarianListViewController; //as! VeterinarianListViewController?
            navigationController?.pushViewController(details!, animated: true)
            
        }
        else if item.tag == 4
        {
            let story: UIStoryboard = UIStoryboard.init(name: "Main_iPhone", bundle: nil)
            let details: ContactListViewController? = story.instantiateViewController(withIdentifier: "contactList") as? ContactListViewController
            navigationController?.pushViewController(details!, animated: true)
            
        }
        else if item.tag == 5
        {
            if galleryView.isHidden == true
            {
                
                galleryView.isHidden = false
            }
            else {
                
                galleryView.isHidden = true
            }
        }
        
    }
    @IBAction func selectGalleryMedicalRecords(_ sender: UIButton) {
        if sender.tag == 1
        {
            let story: UIStoryboard = UIStoryboard.init(name: "Main_iPhone", bundle: nil)
            let details: GalleryListViewController? = story.instantiateViewController(withIdentifier: "photosList") as? GalleryListViewController
            navigationController?.pushViewController(details!, animated: true)
            
            
        }
        else {
            let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
            let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
            navigationController?.pushViewController(medical, animated: true)
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
