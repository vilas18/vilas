//
//  ReminderDetailsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 05/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ReminderDetailsViewController: UIViewController
{
    var model: ReminderModel?
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var veterinarian: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let edit = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editReminder))
        let del = UIBarButtonItem(image: UIImage(named: "trash.png"), style: .done, target: self, action: #selector(self.deleteReminder))
        navigationItem.rightBarButtonItems = [del, edit]
        
        self.reason.text = self.model?.reason
        self.veterinarian.text = self.model?.vet
        self.date.text = self.model?.date
        self.time.text = self.model?.time
        self.comments.text = self.model?.comments
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func editReminder(_ sender: Any)
    {
        performSegue(withIdentifier: "editReminder", sender: model)
    }
    
    @objc func deleteReminder(_ sender: Any)
    {
        let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
            self.callRemDelMethod()
        })
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true) 
    }
    func callRemDelMethod()
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let urlStr = String(format : "%@?ReminderId=%@",API.Reminders.ReminderDelete, (model?.id)!)
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
                    DispatchQueue.main.async
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if status == 1
                            {
                                let alertDel = UIAlertController(title: nil, message: "Reminder has been deleted successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                                
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "editReminder"
        {
            let edit: AddEditReminderViewController = segue.destination as! AddEditReminderViewController
            edit.model = sender as! ReminderModel?
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
