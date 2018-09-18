//
//  OnlineChoiceVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 18/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class OnlineChoiceVC: UIViewController {

    @IBOutlet weak var paid1: UIImageView!
    @IBOutlet weak var Paid2: UIView!
    @IBOutlet weak var free1: UIImageView!
    @IBOutlet weak var free2: UILabel!
    @IBOutlet weak var free3: UILabel!
    @IBOutlet weak var free4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapG)
        self.title = "Ask A Vet Online"
        self.Paid2.layer.masksToBounds = true
        self.Paid2.layer.borderWidth = 1
        self.Paid2.layer.cornerRadius = 5.0
        self.Paid2.layer.borderColor = UIColor.green.cgColor
        self.free4.layer.masksToBounds = true
        self.free4.layer.borderWidth = 1
        self.free4.layer.cornerRadius = 5.0
        self.free4.layer.borderColor = UIColor.green.cgColor
        // Do any additional setup after loading the view.
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
//        free1.
        
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
