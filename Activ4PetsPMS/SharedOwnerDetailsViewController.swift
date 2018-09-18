//
//  SharedOwnerDetailsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 24/10/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class SharedOwnerDetailsViewController: UIViewController
{
    var model : SharedPetsModel?
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        self.username.text = self.model?.userName
        self.firstName.text = self.model?.ownerFirstName
        self.lastName.text = self.model?.ownerLastName
        self.email.text = self.model?.email
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
        
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
