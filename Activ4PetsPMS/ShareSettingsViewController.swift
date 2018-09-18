//
//  ShareSettingsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 25/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ShareSettingsViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var shareId: UIButton!
    @IBOutlet weak var sharedMed: UIButton!
    @IBOutlet weak var shareCont: UIButton!
    @IBOutlet weak var shareVet: UIButton!
    @IBOutlet weak var shareGal: UIButton!
    @IBOutlet weak var modifyId: UIButton!
    @IBOutlet weak var modifyMed: UIButton!
    @IBOutlet weak var modifyCont: UIButton!
    @IBOutlet weak var modifyVet: UIButton!
    @IBOutlet weak var modifyGal: UIButton!
    
    @IBOutlet weak var sharedWith: UILabel!
    
    @IBOutlet weak var comments: UITextField!
    var model: SharedPetsModel?
    
    var sharedModList: [Int] = [0,0,0,0,0,0,0,0,0,0]
    var isFromVc: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.rightClk))
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.hidesBackButton = true
        self.modifyId.isUserInteractionEnabled = false
        self.modifyMed.isUserInteractionEnabled = false
        self.modifyCont.isUserInteractionEnabled = false
        self.modifyVet.isUserInteractionEnabled = false
        self.modifyGal.isUserInteractionEnabled = false
        
        
        if self.isFromVc == true
        {
            let str: String = UserDefaults.standard.string(forKey: "SelectedPetName")!
            self.sharedWith.text = String(format: "Share settings for %@ with %@", str, (self.model?.ownerFirstName)!)
            if (self.model?.viewList?.count)! > 0
            {
                for key in (self.model?.viewList?.keys)!
                {
                    switch key {
                    case "1":
                        self.shareId.isSelected = true
                        self.shareId.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.modifyId.isUserInteractionEnabled = true
                        self.sharedModList[0] = 1
                        break
                    case "2":
                        self.sharedMed.isSelected = true
                        self.sharedMed.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.modifyMed.isUserInteractionEnabled = true
                        self.sharedModList[1] = 2
                        break
                    case "3":
                        self.shareCont.isSelected = true
                        self.shareCont.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.modifyCont.isUserInteractionEnabled = true
                        self.sharedModList[2] = 3
                        break
                    case "4":
                        self.shareVet.isSelected = true
                        self.shareVet.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.modifyVet.isUserInteractionEnabled = true
                        self.sharedModList[3] = 4
                        break
                    case "5":
                        self.shareGal.isSelected = true
                        self.shareGal.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.modifyGal.isUserInteractionEnabled = true
                        self.sharedModList[4] = 5
                        break
                        
                    default:
                        break
                        
                    }
                }
            }
            if (self.model?.modifyList?.count)! > 0
            {
                for key in (self.model?.modifyList?.keys)!
                {
                    switch key {
                    case "6":
                        self.modifyId.isSelected = true
                        self.modifyId.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.sharedModList[5] = 6
                        
                        break
                    case "7":
                        self.modifyMed.isSelected = true
                        self.modifyMed.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.sharedModList[6] = 7
                        break
                    case "8":
                        self.modifyCont.isSelected = true
                        self.modifyCont.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.sharedModList[7] = 8
                        break
                    case "9":
                        self.modifyVet.isSelected = true
                        self.modifyVet.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.sharedModList[8] = 9
                        break
                    case "10":
                        self.modifyGal.isSelected = true
                        self.modifyGal.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
                        self.sharedModList[9] = 10
                        break
                        
                    default:
                        break
                        
                    }
                }
            }
            self.comments.text = self.model?.message
        }
        else{
            let str: String = UserDefaults.standard.string(forKey: "SelectedPetName")!
            let strName: String = UserDefaults.standard.string(forKey: "ContactName")!
            self.sharedWith.text = String(format: "Share settings for %@ with %@", str, strName)
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightClk(_ sender: Any)
    {
        doValidationForSharePet()
    }
    @IBAction func selectShareModifySettings(_ sender: UIButton)
    {
        
        
        if sender.isSelected == true
        {
            sender.isSelected = false
            sender.setImage(UIImage(named: "ckbx_uncheked.png"), for: .normal)
            let ind: Int = sender.tag - 1
            self.sharedModList[ind] = 0
            print(self.sharedModList)
        }
        else
        {
            sender.isSelected = true
            sender.setImage(UIImage(named: "ckbx_checked.png"), for: .selected)
            let ind: Int = sender.tag - 1
            self.sharedModList[ind] = sender.tag
            //self.sharedModList[sender.tag-1] = sender.tag
            print(self.sharedModList)
            
        }
        switch sender.tag
        {
        case 1:
            if sender.isSelected == true
            {
                self.modifyId.isUserInteractionEnabled = true
            }
            else{
                self.modifyId.isUserInteractionEnabled = false
            }
            
            break
            
        case 2:
            if sender.isSelected == true
            {
                self.modifyMed.isUserInteractionEnabled = true
            }
            else{
                self.modifyMed.isUserInteractionEnabled = false
            }
            break
            
        case 3:
            
            if sender.isSelected == true
            {
                self.modifyCont.isUserInteractionEnabled = true
            }
            else{
                self.modifyCont.isUserInteractionEnabled = false
            }
            break
            
        case 4:
            if sender.isSelected == true
            {
                self.modifyVet.isUserInteractionEnabled = true
            }
            else{
                self.modifyVet.isUserInteractionEnabled = false
            }
            break
            
        case 5:
            if sender.isSelected == true
            {
                self.modifyGal.isUserInteractionEnabled = true
            }
            else{
                self.modifyGal.isUserInteractionEnabled = false
            }
            break
            
        default: break
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func doValidationForSharePet()
    {
        if self.sharedModList == [0,0,0,0,0,0,0,0,0,0]
        {
            let alert = UIAlertController(title: nil, message: "Please select atleast one category", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.checkInternetConnection()
        }
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            webServiceToSharePet()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToSharePet()
    {
        // Id,ShareInputs: [1,2,3,4,5,0,7,0,0,0],ShareCategoryTypeId,PetId,ContactId,Message,StatusMsg,UserId,IsModify,IsView,SharePetInfoId,bool IsNew)
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache","content-type": "application/json"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        var dict = [String: Any]()
        var urlStr: String = ""
        //        var str: String = ""
        //        var arr: [Int] = []
        //        for item in self.sharedModList
        //        {
        //            arr.append(item)
        //            print(arr)
        //        }
        //        let stringRepresentation = arr.description
        //        print(stringRepresentation)
        if self.isFromVc == false
        {
            //str = String(format: "Id=%d&ShareInputs=%@&PetId=%d&ContactId=%d&Message=%@&UserId=%d&IsNew=%@",0,stringRepresentation,Int(petId)!, Int(UserDefaults.standard.string(forKey: "ContactId")!)!,self.comments.text!, Int(userId)!, "true" )
            dict["ShareInputs"] = self.sharedModList
            dict["PetId"] = petId
            dict["ContactId"] = UserDefaults.standard.string(forKey: "ContactId")
            dict["Message"] = self.comments.text
            dict["UserId"] = userId
            dict["IsNew"] = true
            urlStr = API.Owner.SharePet
        }
        else
        {
            // str = String(format: "Id=%d&ShareInputs=%@&PetId=%d&ContactId=%d&Message=%@&UserId=%d&IsNew=%@",0,self.sharedModList,Int(petId)!, Int((self.model?.ownerId)!),self.comments.text!, Int(userId)!, "false")
            
            dict["ShareInputs"] = self.sharedModList
            dict["PetId"] = petId
            dict["ContactId"] = self.model?.ownerId
            dict["Message"] = self.comments.text
            dict["UserId"] = userId
            dict["IsNew"] = false
            urlStr = API.Owner.EditSharePet
            
        }
        //        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        //        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //        let url = String(format : "%@?%@", urlStr,str)
        //        var request = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        //        request.allHTTPHeaderFields = headers
        //        let session = URLSession.shared
        
        let objDict = dict as NSDictionary
        let requestUrl = URL(string: urlStr) //else { return }
        var request = URLRequest(url:requestUrl!)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: objDict, options: .prettyPrinted)
            
        } catch
        {
            print(error.localizedDescription)
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let status = json?["status"] as? Int
            {
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: nil, message: "Pet has been shared successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                for controller: UIViewController in (self.navigationController?.viewControllers)!
                                {
                                    if (controller is SharedPetsListViewController)
                                    {
                                        _ = self.navigationController?.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                                
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                        else
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alertDel = UIAlertController(title: "Error", message: json?["StatusMsg"] as? String, preferredStyle: .alert)
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
