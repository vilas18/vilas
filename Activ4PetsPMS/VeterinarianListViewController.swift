    //
    //  VeterinarianListViewController.swift
    //  Active4PetsPMS
    //
    //  Created by Activ Doctors Online on 25/07/17.
    //  Copyright © 2017 Activ Doctors Online. All rights reserved.
    //
    
    import UIKit
    class VetModel: NSObject
    {
        var vetId : String?
        var fstName : NSString?
        var lstName : String?
        var isCurrentVet : Bool?
        var isEmerGCont : Bool?
        var phoneHome : String?
        var phoneOffice : String?
        var phoneCell : String?
        var hospName : NSString?
        var npi : String?
        var startDate : String?
        var endDate : String?
        var address1 : String?
        var address2 : String?
        var countryId : String?
        var stateId : String?
        var city : String?
        var zip : String?
        var fax : String?
        var email : String?
        var vetSpecialId : String?
        var comments : String?
        var countryName : String?
        var stateName : String?
        var vetSpeciality: String?
        //var profilePicUrl : String?
        
        
        init?(vetId: String?, fstName: NSString?, lstName : String?, isCurrentVet : Bool?, isEmerGCont : Bool?, phoneHome : String?, phoneOffice : String?, phoneCell : String?, hospName : NSString?, npi : String?, startDate : String?, endDate : String?, address1 : String?, address2 : String?, countryId : String?, stateId : String?, city : String?, zip : String?, fax : String?, email : String?, vetSpecialId : String?, comments : String?, countryName : String?, stateName : String?, vetSpeciality: String?)
        {
            self.vetId=vetId
            self.hospName=hospName
            self.fstName=fstName
            self.lstName=lstName
            self.isCurrentVet=isCurrentVet
            self.isEmerGCont=isEmerGCont
            self.phoneHome=phoneHome
            self.phoneOffice=phoneOffice
            self.phoneCell=phoneCell
            self.npi=npi
            self.startDate=startDate
            self.endDate=endDate
            self.address1=address1
            self.address2=address2
            self.countryId=countryId
            self.stateId=stateId
            self.city=city
            self.zip=zip
            self.fax=fax
            self.email=email
            self.vetSpecialId=vetSpecialId
            self.comments=comments
            self.countryName=countryName
            self.stateName=stateName
            self.vetSpeciality = vetSpeciality
            //self.profilePicUrl=profilePicUrl
            
        }
    }
    
    
    class VeterinarianListViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource
    {
        
        @IBOutlet weak var vetListTv: UITableView!
        var vetList = [Any]()
        var vetModelList = [VetModel]()
        var noDataLbl: UILabel?
        @IBOutlet weak var searchVet: UISearchBar!
        @IBOutlet weak var backView: UIView!
        @IBOutlet weak var galleryView: UIView!
        @IBOutlet weak var petImg: UIButton!
        @IBOutlet weak var mediRec: UIButton!
        @IBOutlet weak var veterinarians: UIButton!
        @IBOutlet weak var contacts: UIButton!
        @IBOutlet weak var more: UIButton!
        
        @IBOutlet weak var searchView: UIView!
        @IBOutlet weak var bottomView: UIView!
        @IBOutlet weak var topSpace: NSLayoutConstraint!
        var isFromMedical: Bool = false
        @IBOutlet weak var offerView: UIView!
        @IBOutlet weak var popUpView: UIView!
        @IBOutlet weak var step2: UIButton!
        @IBOutlet weak var step3: UIButton!
        @IBOutlet weak var step1Lbl: UILabel!
        var senderId: Int = 0
        var searchList = [Any]()
        var isSearchOn: Bool = false
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            var leftItem: UIBarButtonItem?
            var rightItem1: UIBarButtonItem?
            var rightItem2: UIBarButtonItem?
            leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
            navigationItem.leftBarButtonItem = leftItem
            rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
            rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addVet))
            
            //navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
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
                navigationItem.rightBarButtonItem = rightItem1!
                noDataLbl?.text =  "No records found"
            }
            else{
                navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
                noDataLbl?.text =  "No records found.\n Tap on '+' to add a Veterinarian"
            }
            galleryView.isHidden = true
            galleryView.layer.masksToBounds = true
            galleryView.layer.borderWidth = 1
            galleryView.layer.cornerRadius = 2
            galleryView.layer.borderColor = UIColor.lightGray.cgColor
            popUpView.clipsToBounds = true
            popUpView.layer.borderWidth = 2.0
            popUpView.layer.borderColor = UIColor(red: 28.0 / 255.0, green: 150.0 / 255.0, blue: 109.0 / 255.0, alpha: 1).cgColor
            self.offerView.isHidden = true
            let isShown: Bool = UserDefaults.standard.bool(forKey: "PopUpPetVets")
            let step2Str = NSAttributedString(string: " Download your rebate form here!")
            let step3Str = NSAttributedString(string: "After purchasing Tri-Heart® Plus mail in your rebate form and invoice, or submit them online here.")
            let text2 = NSMutableAttributedString(attributedString: step2Str)
            text2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 27, length: 4))
            let text3 = NSMutableAttributedString(attributedString: step3Str)
            text3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location: 93, length: 4))
            let step1str = NSAttributedString(string: "Visit your veterinarian to get more information about Tri-Heart® Plus")
            step1Lbl.attributedText = step1str
            step1Lbl.numberOfLines = 6
            step1Lbl.font = UIFont.systemFont(ofSize: 9.0)
            step1Lbl.textColor = UIColor.darkGray
            step1Lbl.lineBreakMode = .byTruncatingTail
            step2.titleLabel?.lineBreakMode = .byTruncatingTail
            step2.titleLabel?.numberOfLines = 4
            step2.titleLabel?.adjustsFontSizeToFitWidth = true
            step2.titleLabel?.textColor = UIColor.darkGray
            step2.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step2.setAttributedTitle(text2, for: .normal)
            step3.titleLabel?.lineBreakMode = .byTruncatingTail
            step3.titleLabel?.numberOfLines = 10
            step3.titleLabel?.adjustsFontSizeToFitWidth = true
            step3.titleLabel?.textColor = UIColor.darkGray
            step3.titleLabel?.font = UIFont.systemFont(ofSize: 9.0)
            step3.setAttributedTitle(text3, for: .normal)
            if isShown {
                
            }
            else {
                // getPopupCount()
            }
            // Do any additional setup after loading the view.
        }
        func getPopupCount()
        {
            if CheckNetwork.isExistenceNetwork()
            {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
                let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d",userId,12,2)
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlStr = String(format: "%@?%@",API.MerkNotification.GetCount,str)
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
                    if let str = String(data: data, encoding: .utf8),
                        let count: Int = Int(str)
                    {
                        DispatchQueue.main.async
                            {
                                if count > 0
                                {
                                    self.offerView.isHidden = true
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                                else {
                                    self.callOpenPopupAPI()
                                    self.offerView.isHidden = false
                                    self.noDataLbl?.isHidden = true
                                }
                        }
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                task.resume()
            }
        }
        func callOpenPopupAPI()
        {
            let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let userId:String = UserDefaults.standard.string(forKey: "userID")!
            let formater = DateFormatter()
            formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date: String = formater.string(from: Date())
            var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",userId,12,2,"Open","IOS",date)
            str = str.trimmingCharacters(in: CharacterSet.whitespaces)
            str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let urlStr = String(format: "%@?%@",API.MerkNotification.OpenPopUP,str)
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            if status == 1
                            {
                                let dict:[String: Any] = json?["Message"] as! [String : Any]
                                self.senderId = dict["Id"] as! Int
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            task.resume()
        }
        @IBAction func closePopup(_ sender: Any)
        {
            if CheckNetwork.isExistenceNetwork()
            {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
                let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                let formater = DateFormatter()
                formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date: String = formater.string(from: Date())
                var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,2,"Close","IOS",date)
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let status = json?["Status"] as? Int
                    {
                        DispatchQueue.main.async
                            {
                                if status == 1
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.offerView.isHidden = true
                                    UserDefaults.standard.set(true, forKey: "PopUpPetVets")
                                    UserDefaults.standard.synchronize()
                                    if self.vetModelList.count > 0 {
                                        self.noDataLbl?.isHidden = true
                                    }
                                    else {
                                        self.noDataLbl?.isHidden = false
                                    }
                                }
                                else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                }
                        }
                    }
                    else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                task.resume()
            }
        }
        func callClickPopupAPI()
        {
            if CheckNetwork.isExistenceNetwork()
            {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
                let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                let formater = DateFormatter()
                formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date: String = formater.string(from: Date())
                var str = String(format: "Id=%d&UserId=%@&PromocodeId=%d&PopupId=%d&Action=%s&Platform=%s&ActionDate=%@",self.senderId,userId,12,2,"Download","IOS",date)
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlStr = String(format: "%@?%@",API.MerkNotification.ClickPopUp,str)
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
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let status = json?["Status"] as? Int
                    {
                        DispatchQueue.main.async
                            {
                                if status == 1
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    // self.offerView.isHidden = true
                                    if UIApplication.shared.canOpenURL((URL(string: "https://login.activ4pets.com/content/images/Merck/THP_Merck_Dual_Rebate.pdf"))!)
                                    {
                                        UIApplication.shared.openURL((URL(string: "https://login.activ4pets.com/content/images/Merck/THP_Merck_Dual_Rebate.pdf"))!)
                                    }
                                    
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
        @IBAction func popupClick(_ sender: UIButton)
        {
            callClickPopupAPI()
        }
        
        @IBAction func openClick(_ sender: UIButton)
        {
            if CheckNetwork.isExistenceNetwork()
            {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
                let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                
                var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,2,"IOS-App","ClickRewards")
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let status = json?["Status"] as? Int
                    {
                        DispatchQueue.main.async
                            {
                                if status == 1
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    //self.offerView.isHidden = true
                                    if UIApplication.shared.canOpenURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                    {
                                        UIApplication.shared.openURL((URL(string: "https://rewards.mypet.com/#/"))!)
                                    }
                                    
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
        
        @IBAction func callWebLink(_ sender: Any)
        {
            if CheckNetwork.isExistenceNetwork()
            {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
                let headers = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let userId:String = UserDefaults.standard.string(forKey: "userID")!
                
                var str = String(format: "UserId=%@&PromocodeId=%d&PopupId=%d&Platform=%s&Platform=%s&UserAction=%@",userId,12,2,"IOS-App","ClickHome")
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlStr = String(format: "%@?%@",API.MerkNotification.SubmitOnline,str)
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
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let status = json?["Status"] as? Int
                    {
                        DispatchQueue.main.async
                            {
                                if status == 1
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    //self.offerView.isHidden = true
                                    if UIApplication.shared.canOpenURL((URL(string: "https://www.triheartplus.com"))!)
                                    {
                                        UIApplication.shared.openURL((URL(string: "https://www.triheartplus.com"))!)
                                    }
                                    
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
        @objc func leftClk(_ sender: Any)
        {
            navigationController?.popViewController(animated: true)
        }
        @objc func addVet(_ sender: Any)
        {
            let addVet: EditAddVeterinarianViewController? = storyboard?.instantiateViewController(withIdentifier: "addEditVet") as! EditAddVeterinarianViewController?
            addVet?.isFromVC = false
            navigationController?.pushViewController(addVet!, animated: true)
        }
        @objc func showMenu(_ sender: Any)
        {
            let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
            self.navigationController?.pushViewController(menu, animated: true)
        }
        
        override func viewDidAppear(_ animated: Bool)
        {
            if self.isFromMedical == true
            {
                self.galleryView.isHidden = true
                self.searchView.isHidden = true
                self.bottomView.isHidden = true
                self.topSpace.constant = 0
                self.noDataLbl?.isHidden = true
                self.offerView.isHidden = true
                
            }
            else
            {
                galleryView.isHidden = true
                veterinarians.backgroundColor=UIColor(red: 6.0 / 255.0, green: 103.0 / 255.0, blue: 184.0 / 255.0, alpha: 1);
                veterinarians.isSelected=true;
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
                    let shareMedi: Bool = UserDefaults.standard.bool(forKey: "ShareMedi")
                    let shareGall: Bool = UserDefaults.standard.bool(forKey: "ShareGall")
                    if shareMedi
                    {
                        self.mediRec.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.mediRec.isUserInteractionEnabled = false
                        self.mediRec.backgroundColor = UIColor.lightGray
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
            
            startAuthenticatingUser()
        }
        
        func startAuthenticatingUser()
        {
            //first check internet connectivity
            if CheckNetwork.isExistenceNetwork() {
                print("Internet connection")
                MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
                self.vetModelList = []
                self.getList()
            }
            else {
                print("No internet connection")
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
        func getList()
        {
            let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            let urlStr = String(format : "%@?petId=%@", API.Vet.VetList, petId)
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
                    let queryDic = json?["VeterinarianList"] as? [[String : Any]]
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
                                    prefs.set(true, forKey: "ZeroVeterinarian")
                                    prefs.synchronize()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VeterinarianView"), object: self, userInfo: ["ZeroVeterinarian": prefs.bool(forKey: "ZeroVeterinarian")])
                                    
                                }
                                else{
                                    self.noDataLbl?.isHidden = false
                                    self.vetListTv.reloadData()
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
                                for item in filtered
                                {
                                    let Vet = VetModel(vetId: item["VeterinarianId"] as? String, fstName: item["FirstName"] as? NSString, lstName: item["LastName"] as? String, isCurrentVet: item["IsCurrentVeterinarian"] as? Bool, isEmerGCont: item["IsEmergencyContact"] as? Bool, phoneHome: item["PhoneHome"] as? String, phoneOffice: item["PhoneOffice"] as? String, phoneCell: item["PhoneCell"] as? String, hospName: item["HospitalName"] as? NSString, npi: item["NPI"] as? String, startDate: item["StartDate"] as? String, endDate: item["EndDate"] as? String, address1: item["Address1"] as? String, address2: item["Address2"] as? String, countryId: item["CountryId"] as? String, stateId: item["StateId"] as? String, city: item["City"] as? String, zip: item["Zip"] as? String, fax: item["Fax"] as? String, email: item["Email"] as? String, vetSpecialId: item["VetSpecialityId"] as? String, comments: item["Comments"] as? String, countryName: item["CountryName"] as? String, stateName: item["StateName"] as? String,vetSpeciality: item["VetSpeciality"] as? String )
                                    
                                    self.vetModelList.append(Vet!)
                                }
                                
                                self.vetListTv.reloadData()
                                self.noDataLbl?.isHidden = true
                                MBProgressHUD.hide(for: self.view, animated: true)
                                prefs.set(false, forKey: "ZeroVeterinarian")
                                prefs.synchronize()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VeterinarianView"), object: self, userInfo: ["ZeroVeterinarian": prefs.bool(forKey: "ZeroVeterinarian")])
                            }
                    }
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            self.noDataLbl?.isHidden = false
                            MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                
            }
            task.resume()
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange text: String)
        {
            if (text.count ) == 0
            {
                isSearchOn = false
                searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
            }
            else {
                isSearchOn = true
                searchList = [Any]()
                for srchVet: VetModel in vetModelList
                {
                    
                    let tmp1: NSString = srchVet.fstName!
                    let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                    let lastNameRange = srchVet.hospName?.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                    if range.location != NSNotFound || lastNameRange?.location != NSNotFound
                    {
                        self.searchList.append(srchVet)
                    }
                }
            }
            vetListTv.reloadData()
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var rowCount: Int
            if isSearchOn {
                rowCount = Int(searchList.count)
            }
            else {
                rowCount = Int(vetModelList.count)
            }
            return rowCount
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell: CommonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as! CommonTableViewCell
            var model: VetModel
            if isSearchOn {
                model = searchList[indexPath.row] as! VetModel
            }
            else {
                model = vetModelList[indexPath.row] 
            }
            //        let vetImageUrl = model.profilePicUrl
            //        if let url = NSURL(string: vetImageUrl!)
            //        {
            //            if let data = NSData(contentsOf: url as URL)
            //            {
            //                cell.icon.image=UIImage(data: data as Data)
            //            }
            //            else{
            cell.icon.image = UIImage(named: "user_lst.png")
            //            }
            //        }
            
            //cell.icon?.sd_setImage(with: URL(string: model?.profilePicUrl), placeholderImage: UIImage(named: "user_lst.png"), options: SDWebImageRefreshCached)
            // cell.firstLabel?.text = model.hospName as String//String(format : "%@ %@",model.fstName!, model.lstName!)
            cell.firstLabel.text = String(format : "%@ %@",model.fstName as! NSString, (model.lstName) as! CVarArg)
            print(cell.secLabel.text as Any)
            if model.isEmerGCont!
            {
                cell.timeLabel?.text = "EMG"
                cell.timeLabel.isHidden = false
            }
            else if model.isCurrentVet!
            {
                cell.timeLabel?.text = "CURRENT"
                cell.timeLabel.isHidden = false
            }
            else
            {
                cell.timeLabel.isHidden=true
            }
            let str : String = UserDefaults.standard.string(forKey: "SMO")!
            if str == "1"
            {
                cell.isUserInteractionEnabled = false
            }
            else
            {
                cell.isUserInteractionEnabled = true
            }
            if self.isFromMedical
            {
                cell.firstBtn.isHidden = true
                cell.timeLabel.isHidden = true
                //cell.isUserInteractionEnabled = false
            }
            cell.secLabel?.text = model.phoneCell
            let btn: UIButton? = cell.viewWithTag(1) as! UIButton?
            btn?.tag = Int(model.vetId!)!
            btn?.addTarget(self, action: #selector(self.showOptions), for: .touchUpInside)
            let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
            if shared
            {
                let modVet: Bool = UserDefaults.standard.bool(forKey: "ModifyVet")
                if modVet
                {
                    btn?.isUserInteractionEnabled = true
                }
                else
                {
                    btn?.isUserInteractionEnabled = false
                    let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
                    navigationItem.rightBarButtonItem = rightItem1
                }
            }
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if self.isFromMedical == true
            {
                let model = vetModelList[indexPath.row]
                self.performSegue(withIdentifier: "editVet", sender: model)
            }
        }
        @objc func showOptions(_ sender: UIButton)
        {
            let clickedCell: CommonTableViewCell? = (sender.superview?.superview as? CommonTableViewCell)
            var views: Any? = clickedCell?.superview
            while (views != nil) && (views is UITableView) == false {
                views = (views as AnyObject).superview ?? " "
            }
            let tableView: UITableView? = (views as? UITableView)
            let indexPath: IndexPath? = tableView?.indexPath(for: clickedCell!)
            var model: VetModel?
            if isSearchOn
            {
                model = searchList[(indexPath?.row)!] as? VetModel
            }
            else {
                model = vetModelList[(indexPath?.row)!]
            }
            print("\(String(describing: model?.vetId))")
            
            //EditAddVeterinarianViewController.
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let submit = UIAlertAction(title: "Edit", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "editVet", sender: model)
            })
            let delete = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                let alertDel = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Deleting", comment: "")
                    self.vetDelMethod(model!)
                })
                let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertDel.addAction(ok)
                alertDel.addAction(cancel)
                self.present(alertDel, animated: true, completion: nil)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(submit)
            alert.addAction(delete)
            alert.addAction(cancel)
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            present(alert, animated: true, completion: nil)
        }
        func vetDelMethod(_ model: VetModel)
        {
            if CheckNetwork.isExistenceNetwork() 
            {
                let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
                let urlStr = String(format : "%@?VeterinarianId=%@", API.Vet.VetDelete, model.vetId!)
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
                            let alertDel = UIAlertController(title: nil, message: "Veterinarian has been deleted successfully", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.startAuthenticatingUser()
                            })
                            
                            alertDel.addAction(ok)
                            self.present(alertDel, animated: true, completion: nil)
                        }
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                task.resume()
                
                
            }
        }
        @IBAction func showTabs(_ item: UIButton)
        {
            if item.tag == 1
            {
                for controller: UIViewController in (self.navigationController?.viewControllers)!
                {
                    if #available(iOS 10.0, *) {
                        if (controller is PetDetailsViewController)
                        {
                            _ = self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            else if item.tag == 2
            {
                for controller: UIViewController in (self.navigationController?.viewControllers)!
                {
                    if (controller is MedicalRecordsViewController)
                    {
                        _ = self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                    else
                    {
                        let storyboard = UIStoryboard(name: "PHR", bundle: nil)
                        let medical: MedicalRecordsViewController? = storyboard.instantiateViewController(withIdentifier: "medicalRecords") as? MedicalRecordsViewController
                        navigationController?.pushViewController(medical!, animated: true)
                        break
                    }
                }
            }
            else if item.tag == 3
            {
                print("self")
            }
            else if item.tag == 4
            {
                let details: ContactListViewController? = storyboard?.instantiateViewController(withIdentifier: "contactList") as! ContactListViewController?
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
            if sender.tag == 1 {
                
                let details: GalleryListViewController? = storyboard?.instantiateViewController(withIdentifier: "photosList") as! GalleryListViewController?
                navigationController?.pushViewController(details!, animated: true)
                
                
            }
            else {
                let storyboard = UIStoryboard(name: "MedicalSummary", bundle: nil)
                let medical: NewMedicalSummaryViewController = storyboard.instantiateViewController(withIdentifier: "MedicalSummary") as! NewMedicalSummaryViewController
                navigationController?.pushViewController(medical, animated: true)
            }
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            
            if segue.identifier == "editVet"
            {
                let edit: EditAddVeterinarianViewController = segue.destination as! EditAddVeterinarianViewController
                edit.model = sender as! VetModel?
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
