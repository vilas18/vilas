//
//  SelectPetViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectPetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

     var petModelList = [MyPetsModel]()
     @IBOutlet weak var petListTbl: UITableView!
    var selectedPet: MyPetsModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
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
            self.petModelList = []
            self.webServiceToGetpetList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func webServiceToGetpetList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String(format : "%@?PatientId=%@", API.Owner.PetList, userId)
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
                let queryDic = json?["PetsList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                if queryDic.count == 0
                {
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
                        let MyPets = MyPetsModel(IsActive: false, canDelete: false, SharePetInfoId : "", PetPrefixId : "", OwnerId : 0, PrefixOwnerId : "", OwnerName : "", OwnerInfoPath : "", OwnerFirstName : "", OwnerLastName : "", PetVaccineName : "", DueDate : "", VaccinationId : "", petId: item["PetId"] as? NSNumber, petName: item["PetName"] as! String, petType : item["PetType"] as! String, breed : item["Breed"] as? String, secBreed : item["SecondaryBreed"] as? String, pedigree : item["Pedigree"] as? String, bloodType : item["BloodType"] as? String, chipNo : item["ChipNo"] as? String, tattooNo : item["TattooNo"] as? String, genderId : item["GenderId"] as? NSNumber, gender : item["Gender"] as? String, adoptDate : item["Adoptiondate"] as? String, dob : item["PetBirthDate"] as? String, pob : item["PlaceofBirth"] as? String, country : item["Country"] as? String, countryId : item["CountryId"] as? String, state : item["State"] as? String, stateId : item["StateId"] as? String, zip : item["Zip"] as? String, hairType : item["HairType"] as? String, color : item["Color"] as? String, sterile : item["Sterile"] as? String, imagePath : item["PetImage"] as? String, coverImage : item["CoverImage"] as? String, petTypeId: item["PetTypeId"] as? NSNumber, bloodTypeId: item["BloodTypeId"] as? String, hairTypeId: item["HairTypeId"] as? String, colorId: item["ColorId"] as? String, secColorId: item["SecondaryColorId"] as? String, isInSmo: item["IsSMOInProgress"] as? String, tagNo: item["Tag_No"] as? String,tagType: item["Tag_Type"] as? String, tagExp: item["Tag_Exp"] as? String, customPetType: item["CustomPetType"] as? String, shareId: false, shareMedi: false, shareCont: false, shareVets: false, shareGall: false, canModId: false, canModMedi: false, canModCont: false, canModVet: false, canModGall: false,secColor : item["SecondaryColor"] as? String,canAccessMedRec: item["CanAccessMedicaRecords"] as? Bool,otherHairType: item["OtherHairType"] as? String, otherColorType: item["OtherColor"] as? String, otherSecColorType: item["OtherSecondaryColor"] as? String)
                        
                        
                        self.petModelList.append(MyPets!)
                    }
                   
                            self.petListTbl.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return petModelList.count > 0 ? petModelList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appoint", for: indexPath) as!  MyPetsTableViewCell
        cell.petImage.image = nil
        let pets = self.petModelList[indexPath.row]
        cell.petName.text = pets.petName
        cell.shareBtn.isHidden = false
        cell.shareBtn.tag = Int(truncating: pets.petId!)
        cell.shareBtn.addTarget(self, action: #selector(self.selectPet), for: .touchUpInside)
        cell.petImage.sd_setImage(with: NSURL(string: pets.imagePath!)! as URL!, placeholderImage: UIImage(named: "petImage-default.png")!, options: SDWebImageOptions(rawValue: 1))
        
        return cell
    }
    @objc func selectPet(sender: UIButton)
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
                self.selectedPet = self.petModelList[(indexpath.row)]
                print("\(String(describing:  self.selectedPet?.petId))")
            }
            let details = SharedDetails.SharedInstance
            details.petId = (self.selectedPet?.petId)!.stringValue
            details.petName = (self.selectedPet?.petName)!
            details.petImage = (self.selectedPet?.imagePath)!
            print(details.appt)
            print(details.petId)
            print(details.petName)
            
            self.performSegue(withIdentifier: "SelectApptType", sender: nil)
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
