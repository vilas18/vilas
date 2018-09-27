//
//  ThankYouSMOECViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ThankYouSMOECViewController: UIViewController
{
    var isFromEC: Bool = false
    var isFromSMO: Bool = false
    var isFromFreeVet : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        for controller: UIViewController in (navigationController?.viewControllers)! {
            if isFromEC == true
            {
                if (controller is ECListViewController)
                {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
            else if isFromFreeVet == true
            {
                let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                self.navigationController?.pushViewController(MyPets, animated: true)
                break
             }
            else if isFromSMO == true
            {
                if (controller is SMOListViewController) {
                    navigationController?.popToViewController(controller, animated: true)
                }
                
            }
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
