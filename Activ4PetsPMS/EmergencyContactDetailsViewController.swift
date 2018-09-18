//
//  EmergencyContactDetailsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 30/12/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class EmergencyContactDetailsViewController: UIViewController
{
    var model: EmergencyContactModel?
    @IBOutlet weak var petType: UILabel!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var relationShip: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var office: UILabel!
    @IBOutlet weak var cell: UILabel!
    @IBOutlet weak var fax: UILabel!
    var isFromMedical: Bool = false
    var isFromVC: Bool = false
    
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let edit = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editEmergency))
        self.petType.text = self.model?.petType
        self.petName.text = self.model?.petName
        self.contactName.text = String(format: "%@ %@",(self.model?.fstName)!, (self.model?.lstName)!)
        self.relationShip.text = (self.model?.relation as! String)
        self.email.text = self.model?.email
        self.home.text = self.model?.phoneHome
        self.office.text = self.model?.phoneOffice
        self.cell.text = self.model?.phoneCell
        self.fax.text = self.model?.fax
        if self.model?.isInSMO == "1"
        {
            navigationItem.rightBarButtonItem = nil
        }
        else
        {
            navigationItem.rightBarButtonItem = edit
        }
        // Do any additional setup after loading the view.
    }
    @objc func editEmergency(_ sender: Any)
    {
        if self.model?.contctType == "Veterinarian"
        {
            if self.isFromMedical
            {
                let vetEdit: EditAddVeterinarianViewController = (self.storyboard?.instantiateViewController(withIdentifier: "addEditVet") as? EditAddVeterinarianViewController)!
                vetEdit.isFromEmerg = true
                vetEdit.emgModel = self.model
                self.navigationController?.pushViewController(vetEdit, animated: true)
            }
            else if self.isFromVC
            {
                let vetEdit: EditAddVeterinarianViewController = (self.storyboard?.instantiateViewController(withIdentifier: "addEditVet") as? EditAddVeterinarianViewController)!
                vetEdit.emgModel = self.model
                vetEdit.isFromdetails = true
                self.navigationController?.pushViewController(vetEdit, animated: true)
            }
            
        }
        else if self.model?.contctType == "PetContact"
        {
            if self.isFromMedical
            {
                let contEdit: EditAddContactViewController = (self.storyboard?.instantiateViewController(withIdentifier: "addEditContact") as? EditAddContactViewController)!
                contEdit.isFromEmerg = true
                contEdit.emgModel = self.model
                self.navigationController?.pushViewController(contEdit, animated: true)
            }
            else if self.isFromVC
            {
                let contEdit: EditAddContactViewController = (self.storyboard?.instantiateViewController(withIdentifier: "addEditContact") as? EditAddContactViewController)!
                contEdit.isFromdetails = true
                contEdit.emgModel = self.model
                self.navigationController?.pushViewController(contEdit, animated: true)
            }
            
        }
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
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
