//
//  ConfirmAppointmentViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ConfirmAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var listTv: UITableView!
    var cvHeaderList: [String] = []
    var ocHeaderList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem

        self.cvHeaderList = ["Consultation Type", "Select Pet", "Appointment Type", "Clinic Location", "Veterinarian", "Date & Time"]
        self.ocHeaderList = ["Consultation Type", "Select Pet", "Appointment Type", "Mode of Consultation", "Veterinarian", "Date & Time"]
        // Do any additional setup after loading the view.
    }

    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  CommonTableViewCell
        cell.icon.image = nil
        let details = SharedDetails.SharedInstance
        if details.flag == "CV"
        {
            cell.firstLabel.text = self.cvHeaderList[indexPath.row]
        }
        else if details.flag == "OC"
        {
            cell.firstLabel.text = self.ocHeaderList[indexPath.row]
        }
        switch indexPath.row {
        case 0:
            cell.secLabel.text = details.appt
            if details.flag == "CV"
            {
                cell.icon.image = UIImage(named: "clinicvisit_36")
            }
            else if details.flag == "OC"
            {
                cell.icon.image = UIImage(named: "onlineconsult_36")
            }
            break
        case 1:
            cell.secLabel.text = details.petName
            cell.icon.sd_setImage(with: NSURL(string: details.petImage)! as URL!, placeholderImage: UIImage(named: "petImage-default.png")!, options: SDWebImageOptions(rawValue: 1))
            break
        case 2:
            cell.secLabel.text = details.apptType
            cell.icon.image = UIImage(named: "emg_user")
            break
        case 3:
            if details.flag == "CV" {
                cell.secLabel.text = details.clinicName
                cell.icon.image = UIImage(named: "clinic_location_lst")
            }
            else if details.flag == "OC"
            {
                cell.secLabel.text = details.clinicName
                cell.icon.image = UIImage(named: "clinic_location_lst")
            }
           
            break
        case 4:
            break
        case 5:
            break
        default:
            break
        }
       
        
        
        return cell
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
