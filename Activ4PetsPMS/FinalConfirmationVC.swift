//
//  FinalConfirmationVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 21/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class FinalConfirmationVC: UIViewController {
    
    @IBOutlet weak var vetImage: UIImageView!
    @IBOutlet weak var vetName: UILabel!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var timeSlot: UITextField!
    @IBOutlet weak var animalType: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var petCondition: UITextField!
    @IBOutlet weak var payAmount: UILabel!
    @IBOutlet weak var submit: UIButton!
    var vetImg : String?
    var vetname : String?
    var selectedTime : String?
    var username : String?
    var petname :  String?
    var state : String?
    var petType : String?
    var email : String?
    var phone : String?
    var petQuery : String?
    var petid : String?
    var pettypeid : String?
    var petInfo: OnlineVetsModel?
    var stateid: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        
        navigationItem.leftBarButtonItem = leftItem
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        let petImageUrl: String =  (self.petInfo?.profilePic)!
        if let url = NSURL(string: petImageUrl)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                if data.length > 0
                {
                    self.vetImage.image = UIImage(data: data as Data)
                }
                else
                {
                    self.vetImage.image = UIImage(named: "ic_user_prof")
                }
                
            }
            else
            {
                self.vetImage.image = UIImage(named: "ic_user_prof")
            }
        }
        else
        {
            self.vetImage.image = UIImage(named: "ic_user_prof")
        }
        
        submit.layer.masksToBounds = true
        submit.layer.borderWidth = 2
        submit.layer.cornerRadius = 3.0
        submit.layer.borderColor = UIColor.clear.cgColor
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    @objc func viewTouched()
    {
        resignFirstResponder()
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func removeSpecialCharsFromString(_ str: String) -> String
        {
            struct Constants {
                static let validChars = Set("1234567890")
            }
            return String(str.filter { Constants.validChars.contains($0) })
        }
    func paidquery()
        {
            let reachability = Reachability.forInternetConnection
            let internetStatus: NetworkStatus = reachability()!.currentReachabilityStatus()
            if internetStatus != NotReachable
            {
                let headers = [
                    "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                    "cache-control": "no-cache"
                ]
                let firstname :  String = UserDefaults.standard.string(forKey:"UserName")!
                let phone :  String = UserDefaults.standard.string(forKey:"UserPhoneNumber")! // it may come null handle it ***
                let newPhone : String = self.removeSpecialCharsFromString(phone)
                let userId: String = UserDefaults.standard.string(forKey: "userID")!
                let email: String = UserDefaults.standard.string(forKey: "UserEmail")! // it may come null handle it ***
                let dict: [String: Any] = [ "OwnerId" : userId,"FirstName": firstname,"LastName": "" ,"Email": email,"PhoneNumber": newPhone ,"StateId": stateid ,"PetId": petid ,"PetTypeId": pettypeid ,"PetName":self.petName.text!,"Condition": petQuery,"RequestedTime": "Bool" ,"IsPaymentDone": "Bool","ChkDisclaimer": "Bool" ]
                print(dict)
                let requestUrl = URL(string: "http://qapetsvetscom.activdoctorsconsult.com/Vet/RequestVetCall") // ** before release change the url to live **
                //     Post
                //  /Vet/RequestVetCall
                //    OwnerId : int - PetOwnerId
                //    FirstName : string - PetOwner FirstName
                //    LastName : string - PetOwner LastName
                //    Email : string - PetOwner Email
                //    PhoneNumber : string - PetOwner PhoneNumber
                //    StateId : int - StateId
                //    PetId : int - PetId
                //    PetTypeId: int - PetTypeId
                //    PetName: string - PetName
                //    Condition: string - Question to be asked
                //    RequestedTime: string - Requested Date and Time
                //    IsPaymentDone : string - Paid or not (Get this from (1) ispaid)
                //    ChkDisclaimer : bool - Disclaimer read or not
                var request = URLRequest(url:requestUrl!)
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                } catch
                {
                    print(error.localizedDescription)
                }
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                let session = URLSession.shared
                let task = session.dataTask(with: request)
                {
                    (data, response, error) in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        MBProgressHUD.hide(for: self.view, animated: true)
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
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
                                if status == 1
                                {
                                    let alert = UIAlertController(title: NSLocalizedString("Thank you!", comment: ""), message: NSLocalizedString("your ask a vet call has been scheduled sucessfully", comment: ""), preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                                        self.navigationController?.pushViewController(MyPets, animated: true)
                                    })
                                    alert.addAction(ok)
                                }
                                else
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
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
}
