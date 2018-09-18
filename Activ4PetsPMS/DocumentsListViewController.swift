//
//  DocumentsListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 11/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class DocumentsModel: NSObject
{
    var documentId: String
    var docTitle: String
    var docSubType: String
    var docSubTypeId: String
    var serviceDate: String
    var uploadDate: String
    var path: String
    var url: String
    var isimported: Bool
    var comment: String
    
    
    
    init(documentId: String, docTitle: String, docSubType: String, serviceDate: String, uploadDate: String, path: String, url: String, isimported: Bool, docSubTypeId: String,comment: String)
    {
        self.documentId = documentId
        self.docTitle = docTitle
        self.docSubType = docSubType
        self.serviceDate = serviceDate
        self.uploadDate = uploadDate
        self.path = path
        self.url = url
        self.isimported = isimported
        self.docSubTypeId = docSubTypeId
        self.comment = comment
        
    }
}

class DocumentsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var note: UIButton!
    @IBOutlet var imaging: UIButton!
    @IBOutlet var lab: UIButton!
    @IBOutlet var prescript: UIButton!
    @IBOutlet var a4p: UIButton!
    @IBOutlet var insure: UIButton!
    @IBOutlet var noteView: UIView!
    @IBOutlet var imageView: UIView!
    @IBOutlet var labView: UIView!
    @IBOutlet var prescriptView: UIView!
    @IBOutlet var a4pView: UIView!
    @IBOutlet var insureView: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var sectionView: TPKeyboardAvoidingScrollView!
    var isFromMedical: Bool = false
    
    var comingDocType: String!
    
    @IBOutlet var documentsTv: UITableView!
    
    var model: DocumentsModel?
    var documentList = [Any]()
    var documentModelList = [DocumentsModel]()
    var noDataLbl: UILabel?
    
    var docType: String = "Notes"
    var docTypeId: String = "1"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if isFromMedical
        {
            self.sectionView.isHidden = true
            self.topSpace.constant = 0
        }
        else
        {
            var leftItem: UIBarButtonItem?
            var rightItem2: UIBarButtonItem?
            leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
            navigationItem.leftBarButtonItem = leftItem
            
            rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addDocument))
            
            
            
            
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
                noDataLbl?.text =  "No records found.\n Tap on '+' to add a Document"
            }
            if self.comingDocType == "Notes"
            {
                self.docType = "Notes"
                self.docTypeId = "1"
                
                self.noteView.backgroundColor = UIColor.white
                self.imageView.backgroundColor = UIColor.clear
                self.labView.backgroundColor = UIColor.clear
                self.prescriptView.backgroundColor = UIColor.clear
                self.a4pView.backgroundColor = UIColor.clear
                self.insureView.backgroundColor = UIColor.clear
                
                self.note.isSelected = true
                self.imaging.isSelected = false
                self.lab.isSelected = false
                self.prescript.isSelected = false
                self.a4p.isSelected = false
                self.insure.isSelected = false
                
                self.note.setTitleColor(UIColor.white, for: .selected)
                self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
            else if self.comingDocType == "Imaging Services"
            {
                self.docType = "Imaging Services"
                self.docTypeId = "2"
                
                self.noteView.backgroundColor = UIColor.clear
                self.imageView.backgroundColor = UIColor.white
                self.labView.backgroundColor = UIColor.clear
                self.prescriptView.backgroundColor = UIColor.clear
                self.a4pView.backgroundColor = UIColor.clear
                self.insureView.backgroundColor = UIColor.clear
                
                self.note.isSelected = false
                self.imaging.isSelected = true
                self.lab.isSelected = false
                self.prescript.isSelected = false
                self.a4p.isSelected = false
                self.insure.isSelected = false
                
                self.imaging.setTitleColor(UIColor.white, for: .selected)
                self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
            else if self.comingDocType == "Laboratory"
            {
                self.docType = "Laboratory"
                self.docTypeId = "3"
                
                self.noteView.backgroundColor = UIColor.clear
                self.imageView.backgroundColor = UIColor.clear
                self.labView.backgroundColor = UIColor.white
                self.prescriptView.backgroundColor = UIColor.clear
                self.a4pView.backgroundColor = UIColor.clear
                self.insureView.backgroundColor = UIColor.clear
                
                self.note.isSelected = false
                self.imaging.isSelected = false
                self.lab.isSelected = true
                self.prescript.isSelected = false
                self.a4p.isSelected = false
                self.insure.isSelected = false
                
                self.lab.setTitleColor(UIColor.white, for: .selected)
                self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
            else if self.comingDocType == "Prescription"
            {
                self.docType = "Prescription"
                self.docTypeId = "4"
                
                self.noteView.backgroundColor = UIColor.clear
                self.imageView.backgroundColor = UIColor.clear
                self.labView.backgroundColor = UIColor.clear
                self.prescriptView.backgroundColor = UIColor.white
                self.a4pView.backgroundColor = UIColor.clear
                self.insureView.backgroundColor = UIColor.clear
                
                self.note.isSelected = false
                self.imaging.isSelected = false
                self.lab.isSelected = false
                self.prescript.isSelected = true
                self.a4p.isSelected = false
                self.insure.isSelected = false
                
                self.prescript.setTitleColor(UIColor.white, for: .selected)
                self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
            else if self.comingDocType == "A4P Services"
            {
                self.docType = "A4P Services"
                self.docTypeId = "5"
                
                self.noteView.backgroundColor = UIColor.clear
                self.imageView.backgroundColor = UIColor.clear
                self.labView.backgroundColor = UIColor.clear
                self.prescriptView.backgroundColor = UIColor.clear
                self.a4pView.backgroundColor = UIColor.white
                self.insureView.backgroundColor = UIColor.clear
                
                self.note.isSelected = false
                self.imaging.isSelected = false
                self.lab.isSelected = false
                self.prescript.isSelected = false
                self.a4p.isSelected = true
                self.insure.isSelected = false
                
                self.a4p.setTitleColor(UIColor.white, for: .selected)
                self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
            else if self.comingDocType == "Insurance"
            {
                self.docType = "Insurance"
                self.docTypeId = "6"
                
                self.noteView.backgroundColor = UIColor.clear
                self.imageView.backgroundColor = UIColor.clear
                self.labView.backgroundColor = UIColor.clear
                self.prescriptView.backgroundColor = UIColor.clear
                self.a4pView.backgroundColor = UIColor.clear
                self.insureView.backgroundColor = UIColor.white
                
                self.note.isSelected = false
                self.imaging.isSelected = false
                self.lab.isSelected = false
                self.prescript.isSelected = false
                self.a4p.isSelected = false
                self.insure.isSelected = true
                
                self.insure.setTitleColor(UIColor.white, for: .selected)
                self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
                self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            }
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
    @objc func addDocument(_ sender: Any)
    {
        
        let addDocument: AddEditDocumentDetailsViewController? = storyboard?.instantiateViewController(withIdentifier: "addDocument") as! AddEditDocumentDetailsViewController?
        addDocument?.isFromVC = false
        addDocument?.docType = self.docType
        addDocument?.docTypeId = self.docTypeId
        navigationController?.pushViewController(addDocument!, animated: true)
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
            self.documentModelList = []
            if self.isFromMedical == true{
                self.getTotalDocumentList()
            }
            else{
                self.getList()
            }
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getTotalDocumentList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@&DocumentTypeId=%@", API.Document.DocumentList, petId, "0")
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
                let queryDic = json?["DocList"] as? [[String : Any]]
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
                                self.documentsTv.reloadData()
                                prefs.set(true, forKey: "ZeroDocument")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DocumentView"), object: self, userInfo: ["ZeroDocument": prefs.bool(forKey: "ZeroDocument")])
                            }
                            else
                            {
                                self.noDataLbl?.isHidden = false
                                self.documentsTv.reloadData()
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
                                let Document = DocumentsModel (documentId: item["DocumentId"] as! String, docTitle: item["Title"] as! String, docSubType: item["DocumentSubType"] as! String, serviceDate: item["ServiceDate"] as! String, uploadDate: item["UploadDate"] as! String, path: item["Path"] as! String, url: item["Url"] as! String, isimported: item["IsImportedData"] as! Bool, docSubTypeId: item["DocumentSubTypeId"] as! String, comment: item["Comment"] as! String)
                                
                                self.documentModelList.append(Document)
                            }
                            self.documentsTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                            prefs.set(false, forKey: "ZeroDocument")
                            prefs.synchronize()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DocumentView"), object: self, userInfo: ["ZeroDocument": prefs.bool(forKey: "ZeroDocument")])
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
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@&DocumentTypeId=%@", API.Document.DocumentList, petId, self.docTypeId)
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
                let queryDic = json?["DocList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            
                            self.noDataLbl?.isHidden = false
                            self.documentsTv.reloadData()
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
                                let Document = DocumentsModel (documentId: item["DocumentId"] as! String, docTitle: item["Title"] as! String, docSubType: item["DocumentSubType"] as! String, serviceDate: item["ServiceDate"] as! String, uploadDate: item["UploadDate"] as! String, path: item["Path"] as! String, url: item["Url"] as! String, isimported: item["IsImportedData"] as! Bool, docSubTypeId: item["DocumentSubTypeId"] as! String,comment: item["Comment"] as! String)
                                
                                self.documentModelList.append(Document)
                            }
                            self.documentsTv.reloadData()
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.documentModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommonTableViewCell
        let model = self.documentModelList[indexPath.row]
        cell.firstLabel.text = model.docSubType
        cell.secLabel.text = String(format: "Date of Service %@", model.serviceDate)
        
        if  self.docType == "Notes"
        {
            cell.icon.image = UIImage(named: "doc_ic_0000_note.png")
        }
        else if self.docType == "Imaging Services"
        {
            cell.icon.image = UIImage(named: "doc_ic_0001_imaging_services.png")
        }
        else if self.docType == "Laboratory"
        {
            cell.icon.image = UIImage(named: "doc_ic_0002_laboratory.png")
        }
        else if self.docType == "Prescription"
        {
            cell.icon.image = UIImage(named: "doc_ic_0003_prescription.png")
        }
        else if self.docType == "A4P Services"
        {
            cell.icon.image = UIImage(named: "doc_ic_0004_ado_services.png")
        }
        else if self.docType == "Insurance"
        {
            cell.icon.image = UIImage(named: "doc_ic_0005_insurance.png")
        }
        if self.isFromMedical == true
        {
            cell.firstBtn.isHidden = true
            // cell.isUserInteractionEnabled = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.model = documentModelList[indexPath.row]
        
        self.performSegue(withIdentifier: "DocumentDetails", sender: self.model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "DocumentDetails"
        {
            let edit: DocumentDetailsViewController = segue.destination as! DocumentDetailsViewController
            edit.model = sender as! DocumentsModel?
            edit.doctType = self.docType
            edit.docTypeId = self.docTypeId
            if self.isFromMedical
            {
                edit.isFromVC = true
            }
        }
    }
    
    @IBAction func showSelectedDocumentList(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.docType = "Notes"
            self.docTypeId = "1"
            
            
            self.noteView.backgroundColor = UIColor.white
            self.imageView.backgroundColor = UIColor.clear
            self.labView.backgroundColor = UIColor.clear
            self.prescriptView.backgroundColor = UIColor.clear
            self.a4pView.backgroundColor = UIColor.clear
            self.insureView.backgroundColor = UIColor.clear
            
            self.note.isSelected = true
            self.imaging.isSelected = false
            self.lab.isSelected = false
            self.prescript.isSelected = false
            self.a4p.isSelected = false
            self.insure.isSelected = false
            
            self.note.setTitleColor(UIColor.white, for: .selected)
            self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
        }
        else if sender.tag == 2
        {
            self.docType = "Imaging Services"
            self.docTypeId = "2"
            
            self.noteView.backgroundColor = UIColor.clear
            self.imageView.backgroundColor = UIColor.white
            self.labView.backgroundColor = UIColor.clear
            self.prescriptView.backgroundColor = UIColor.clear
            self.a4pView.backgroundColor = UIColor.clear
            self.insureView.backgroundColor = UIColor.clear
            
            self.note.isSelected = false
            self.imaging.isSelected = true
            self.lab.isSelected = false
            self.prescript.isSelected = false
            self.a4p.isSelected = false
            self.insure.isSelected = false
            
            self.imaging.setTitleColor(UIColor.white, for: .selected)
            self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            
        }
        else if sender.tag == 3
        {
            self.docType = "Laboratory"
            self.docTypeId = "3"
            
            self.noteView.backgroundColor = UIColor.clear
            self.imageView.backgroundColor = UIColor.clear
            self.labView.backgroundColor = UIColor.white
            self.prescriptView.backgroundColor = UIColor.clear
            self.a4pView.backgroundColor = UIColor.clear
            self.insureView.backgroundColor = UIColor.clear
            
            self.note.isSelected = false
            self.imaging.isSelected = false
            self.lab.isSelected = true
            self.prescript.isSelected = false
            self.a4p.isSelected = false
            self.insure.isSelected = false
            
            self.lab.setTitleColor(UIColor.white, for: .selected)
            self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            
        }
        else if sender.tag == 4
        {
            self.docType = "Prescription"
            self.docTypeId = "4"
            
            self.noteView.backgroundColor = UIColor.clear
            self.imageView.backgroundColor = UIColor.clear
            self.labView.backgroundColor = UIColor.clear
            self.prescriptView.backgroundColor = UIColor.white
            self.a4pView.backgroundColor = UIColor.clear
            self.insureView.backgroundColor = UIColor.clear
            
            self.note.isSelected = false
            self.imaging.isSelected = false
            self.lab.isSelected = false
            self.prescript.isSelected = true
            self.a4p.isSelected = false
            self.insure.isSelected = false
            
            self.prescript.setTitleColor(UIColor.white, for: .selected)
            self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            
        }
        else if sender.tag == 5
        {
            self.docType = "A4P Servies"
            self.docTypeId = "5"
            
            self.noteView.backgroundColor = UIColor.clear
            self.imageView.backgroundColor = UIColor.clear
            self.labView.backgroundColor = UIColor.clear
            self.prescriptView.backgroundColor = UIColor.clear
            self.a4pView.backgroundColor = UIColor.white
            self.insureView.backgroundColor = UIColor.clear
            
            self.note.isSelected = false
            self.imaging.isSelected = false
            self.lab.isSelected = false
            self.prescript.isSelected = false
            self.a4p.isSelected = true
            self.insure.isSelected = false
            
            self.a4p.setTitleColor(UIColor.white, for: .selected)
            self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.insure.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            
        }
        else if sender.tag == 6
        {
            self.docType = "Insurance"
            self.docTypeId = "6"
            
            self.noteView.backgroundColor = UIColor.clear
            self.imageView.backgroundColor = UIColor.clear
            self.labView.backgroundColor = UIColor.clear
            self.prescriptView.backgroundColor = UIColor.clear
            self.a4pView.backgroundColor = UIColor.clear
            self.insureView.backgroundColor = UIColor.white
            
            self.note.isSelected = false
            self.imaging.isSelected = false
            self.lab.isSelected = false
            self.prescript.isSelected = false
            self.a4p.isSelected = false
            self.insure.isSelected = true
            
            self.insure.setTitleColor(UIColor.white, for: .selected)
            self.imaging.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.lab.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.prescript.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.a4p.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            self.note.setTitleColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.21), for: .normal)
            
        }
        self.startAuthenticatingUser()
        
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
