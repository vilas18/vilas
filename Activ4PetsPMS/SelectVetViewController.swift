//
//  SelectVetViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectVetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var vetListArray = [[String: Any]]()
    @IBOutlet weak var vetListTbl: UITableView!
    var dict = [String: Any]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        checkInternetConnection()
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.vetListArray = []
            self.webServiceToGetVetList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    func webServiceToGetVetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let details = SharedDetails.SharedInstance
        let urlStr: String = String(format: "%@?CenterId=%@",API.Pet.VetStaffList, details.clinicId)
        
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
                    let queryDic = json
                {
                    DispatchQueue.main.async
                        {
                            let list: [[String: Any]] = queryDic["StaffList"] as! [[String : Any]]
                            if list.count > 0
                            {
                                self.vetListArray = list
                                self.vetListTbl.reloadData()
                                MBProgressHUD.hide(for: self.view, animated: true)
                                
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "No veterinarians found. /nPlease select some other clinic and try again", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                })
                                
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
            }
            }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vetListArray.count > 0 ? vetListArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as? CommonTableViewCell
        let dict = vetListArray[indexPath.row]
        cell?.firstLabel?.text = String(format: "%@",dict["StaffName"] as! String)
      //  cell?.icon.sd_setImage(with: NSURL(string: dict?[""] as! String)! as URL!, placeholderImage: UIImage(named: "petImage-default.png")!, options: SDWebImageOptions(rawValue: 1))
        cell?.icon.image = UIImage(named: "emg_user")
        let btn: UIButton? = cell?.viewWithTag(1) as! UIButton?
        btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        return cell!
    }
    @objc func showOptions(_ sender: UIButton)
    {
        
        if sender.isSelected == true
        {
            sender.isSelected = false
            sender.setImage(UIImage(named: "opt_unchecked"), for: .normal)
        }
        else
        {
            sender.isSelected = true
            sender.setImage(UIImage(named: "opt_checked"), for: .selected)
            var superView = sender.superview
            while !(superView is UITableViewCell) {
                superView = superView?.superview
            }
            let cell = superView as! UITableViewCell
            let tableView: UITableView? = cell.superview?.superview as! UITableView?
            if let indexpath = tableView?.indexPath(for: cell)
            {
                self.dict = self.vetListArray[indexpath.row]
            }
            let details = SharedDetails.SharedInstance
            details.vetId = ((self.dict["StaffId"]! as? NSNumber)?.stringValue)!
            details.vetName = String(format: "%@",self.dict["StaffName"]! as! CVarArg)
            print(details.appt)
            print(details.petName)
            print(details.petId)
            print(details.apptTypeId)
            print(details.apptType)
            print(details.clinicId)
            print(details.clinicName)
            
            self.performSegue(withIdentifier: "SelectDate", sender: nil)
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
