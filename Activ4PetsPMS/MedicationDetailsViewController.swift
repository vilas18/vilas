//
//  MedicationDetailsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 09/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class MedicationDetailsViewController: UIViewController
{
    
    var model: MedicationModel?
    
    @IBOutlet var MedicName: UILabel!
    @IBOutlet var visitDate: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var comment: UILabel!
    var isFromDetails: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.MedicName.text = self.model?.medicationName
        self.visitDate.text = self.model?.visitDate
        self.status.text = self.model?.status
        self.comment.text = self.model?.comments
        
        self.title = "Medications"
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let edit = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editMedication))
        let del = UIBarButtonItem(image: UIImage(named: "trash.png"), style: .done, target: self, action: #selector(self.deleteMedication))
        
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
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = nil
        }
        else
        {
            navigationItem.rightBarButtonItems = [del, edit]
        }
        if self.isFromDetails
        {
            navigationItem.rightBarButtonItems =  [edit]
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func editMedication(_ sender: Any)
    {
        performSegue(withIdentifier: "EditMedication", sender: model)
    }
    
    @objc func deleteMedication(_ sender: Any)
    {
        let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
            self.medicationDelMethod()
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
    
    func medicationDelMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            
            let urlStr = String(format : "%@?MedicationId=%@",API.Medication.MedicationDelete, (self.model?.medicationId)!)
            
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
                        let alertDel = UIAlertController(title: nil, message: "Medication details has been deleted successfully", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        alertDel.addAction(ok)
                        self.present(alertDel, animated: true, completion: nil)
                    }
                }
            }
            task.resume()
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "EditMedication"
        {
            let edit: AddEditMedicationViewController = segue.destination as! AddEditMedicationViewController
            edit.model = sender as! MedicationModel?
            edit.isFromVC = true
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
