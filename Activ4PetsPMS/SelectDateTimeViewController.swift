//
//  SelectDateTimeViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectDateTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeSlot: UITableView!
    var timeList = [[String: Any]]()
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dateView.isHidden = true
        self.timeSlot.isHidden = true
        self.dateTxt.isUserInteractionEnabled = false
        self.timeTxt.isUserInteractionEnabled = false
        self.datePicker.minimumDate = Date()
        

        dateTxt.layer.masksToBounds = true
        dateTxt.layer.borderWidth = 2
        dateTxt.layer.cornerRadius = 3.0
        dateTxt.layer.borderColor = UIColor.clear.cgColor
        
        timeTxt.layer.masksToBounds = true
        timeTxt.layer.borderWidth = 2
        timeTxt.layer.cornerRadius = 3.0
        timeTxt.layer.borderColor = UIColor.clear.cgColor

        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
       
        // Do any additional setup after loading the view.
    }

    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
       // self.dateView.isHidden = true
       // self.timeSlot.isHidden = true
    }
    @IBAction func showDatePicker(_ sender: UIButton)
    {
        self.timeSlot.isHidden = true
        if self.dateView.isHidden == true
        {
            self.dateView.isHidden = false
            self.datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        }
        else
        {
            self.dateView.isHidden = true
            let formater = DateFormatter()
            formater.dateFormat = "MM/dd/yyyy"
            dateTxt.text = formater.string(from: datePicker.date)
        }
    }
    @objc func selectDate()
    {
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        dateTxt.text = formater.string(from: datePicker.date)
    }
    @IBAction func showTimeSlotList(_ sender: UIButton)
    {
        if self.timeSlot.isHidden == true
        {
            self.timeSlot.isHidden = false
        }
        else
        {
            self.timeSlot.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        checkInternetConnection()
    }
    
    func checkInternetConnection()
    {
        //first check internet connectivity
        
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
            self.timeList = []
            self.getVetTimeSlot()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getVetTimeSlot()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]

        let details = SharedDetails.SharedInstance
        var str: String =  String(format : "CenterId=%@&StaffId=%@&date=%@&flag=%@&locationName=%@",details.clinicId, details.vetId, self.dateTxt.text!,details.flag,details.clinicName)
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Pet.GetTimeSlot, str)
        
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
                            let list: [[String: Any]] = queryDic["AppointmenttimeList"] as! [[String : Any]]
                            if list.count > 0
                            {
                                self.timeList = list
                                self.timeSlot.reloadData()
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else
                            {
                               
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alertDel = UIAlertController(title: nil, message: "No time slots found. /nPlease select some other date and try again", preferredStyle: .alert)
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
        return timeList.count > 0 ? timeList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommonTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as? CommonTableViewCell
        let dict = timeList[indexPath.row]
        cell?.firstLabel?.text = String(format: "%@",dict["Time"] as! String)
    
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = timeList[indexPath.row]
        self.timeTxt.text = String(format: "%@",dict["Time"] as! String)
        self.timeSlot.isHidden = true
        let details = SharedDetails.SharedInstance
        details.date = self.dateTxt.text!
        details.time = self.timeTxt.text!
        self.performSegue(withIdentifier: "ConfirmAppt", sender: nil)
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
