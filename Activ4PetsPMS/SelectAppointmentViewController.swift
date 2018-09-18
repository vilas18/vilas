//
//  SelectAppointmentViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 01/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SelectAppointmentViewController: UIViewController
{

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
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectAppointment(_ sender: UIButton)
    {
        let details = SharedDetails.SharedInstance
        if sender.tag == 1
        {
            
            details.appt = "Clinic Visit"
            details.flag = "CV"
            
        }
        else
        {
            details.appt = "Online Consultation"
            details.flag = "OC"
        }
        self.performSegue(withIdentifier: "SelectPet", sender: nil)
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
