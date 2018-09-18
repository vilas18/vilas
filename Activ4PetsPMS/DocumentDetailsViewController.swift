//
//  DocumentDetailsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 11/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class DocumentDetailsViewController: UIViewController, UIDocumentInteractionControllerDelegate
{
    
    @IBOutlet weak var docSubType: UILabel!
    @IBOutlet weak var docTitle: UILabel!
    @IBOutlet weak var dateOfService: UILabel!
    @IBOutlet weak var uploadDate: UILabel!
    @IBOutlet weak var imageFile: UIImageView!
    var docInteractionCon: UIDocumentInteractionController?
    var isFromVC: Bool = false
    var model: DocumentsModel?
    
    var doctType: String!
    var docTypeId: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
        self.docSubType.text = self.model?.docSubType
        self.docTitle.text = self.model?.docTitle
        self.dateOfService.text = self.model?.serviceDate
        self.uploadDate.text = self.model?.uploadDate
        
        self.title = self.doctType
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let edit = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editConsultation))
        let del = UIBarButtonItem(image: UIImage(named: "trash.png"), style: .done, target: self, action: #selector(self.deleteConsultation))
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = nil
        }
        else
        {
            navigationItem.rightBarButtonItems = [del, edit]
        }
        if self.isFromVC == true
        {
            navigationItem.rightBarButtonItems = [edit]
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func editConsultation(_ sender: Any)
    {
        performSegue(withIdentifier: "editDocument", sender: model)
    }
    
    @objc func deleteConsultation(_ sender: Any)
    {
        let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
            self.documentDelMethod()
        })
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true) 
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func previewClick(_ sender: UIButton)
    {
        let url = URL(string: (self.model?.url)!)
        if let urlData = try? Data(contentsOf: url!) as? Data,
            let urlDataByte = urlData
        {
            if urlDataByte.count > 0
            {
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory: String = paths[0]
                let str: String = (self.model?.path)!
                var list:[String] = str.components(separatedBy: ".")
                let exten: String = list[1]
                let filePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("document." + exten).absoluteString
                DispatchQueue.main.async(execute: {() -> Void in
                    try? urlDataByte.write(to: URL(string: filePath)!, options: Data.WritingOptions(rawValue: 1))
                    print("File Saved !")
                    let fileURL = URL(string: filePath)
                    self.docInteractionCon = UIDocumentInteractionController(url: fileURL!)
                    self.docInteractionCon?.delegate = self
                    self.docInteractionCon?.name = self.model?.docSubType
                    self.docInteractionCon?.presentPreview(animated: true)
                })
            }
        }
    }
    func documentDelMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            
            let urlStr = String(format : "%@?DocumentId=%@",API.Document.DocumentDelete, (self.model?.documentId)!)
            
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
                        let alertDel = UIAlertController(title: nil, message: "Document details has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "editDocument"
        {
            let edit: AddEditDocumentDetailsViewController = segue.destination as! AddEditDocumentDetailsViewController
            edit.model = sender as! DocumentsModel?
            edit.isFromVC = true
            edit.docType = self.doctType
            edit.docTypeId = self.docTypeId
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController)
    {
        
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
