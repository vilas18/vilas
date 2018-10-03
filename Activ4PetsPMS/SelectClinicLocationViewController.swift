//
//  SelectClinicLocationViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectClinicLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var clinicModelList = [CommonResponseModel]()
    @IBOutlet weak var clinicListTbl: UITableView!
    var selectedClinic: CommonResponseModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
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
            self.clinicModelList = []
           self.getList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            RestClient.getList("ClinicLocation", callBackHandler: {(response: Any, error: Error?) -> Void in
                
                self.clinicModelList = []
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    
                    for dict in detailsArr
                    {
                        let model = CommonResponseModel()
                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                        model.paramName = dict["Name"] as! String?
                        self.clinicModelList.append(model)
                    }
                    
                    self.clinicListTbl?.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.clinicModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
        let model = self.clinicModelList[indexPath.row]
        
        //cell.icon?.sd_setImage(with: URL(string: model?.profilePicUrl), placeholderImage: UIImage(named: "user_lst.png"), options: SDWebImageRefreshCached)
        cell.firstLabel?.text = model.paramName
        let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
        btn?.tag = Int(model.paramID)!
        btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
        return cell
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
                self.selectedClinic = self.clinicModelList[(indexpath.row)]
            }
            let details = SharedDetails.SharedInstance
            details.clinicName = (self.selectedClinic?.paramName)!
            details.clinicId = (self.selectedClinic?.paramID)!
            print(details.appt)
            print(details.petName)
            print(details.petId)
            print(details.apptTypeId)
            print(details.apptType)
            print(details.clinicName)
            print(details.clinicId)
            
            
            
            self.performSegue(withIdentifier: "SelectVet", sender: nil)
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
