//
//  OnlineChoiceVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 18/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class OnlineChoiceVC: UIViewController {

//    @IBOutlet weak var paid1: UIImageView!
//    @IBOutlet weak var free1: UIImageView!
//    @IBOutlet weak var free2: UILabel!
//    @IBOutlet weak var free3: UILabel!
//    @IBOutlet weak var free4: UIView!
    
    @IBOutlet weak var paidIcon: UIImageView!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var freeIcon: UIImageView!
    @IBOutlet weak var freeLbl: UILabel!
    @IBOutlet weak var freeLbl1: UILabel! 
    @IBOutlet weak var freeView: UIView!
    override func viewDidLoad() {
    super.viewDidLoad()
        
    let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        
        self.paidIcon.addGestureRecognizer(tapG)
        self.freeLbl.addGestureRecognizer(tapG)
        self.freeLbl1.addGestureRecognizer(tapG)
        self.paidLabel.addGestureRecognizer(tapG)
        
        self.paidIcon.isUserInteractionEnabled = true
        self.freeLbl.isUserInteractionEnabled = true
        self.freeLbl1.isUserInteractionEnabled = true
        self.paidLabel.isUserInteractionEnabled = true
        
        
        self.title = "Ask A Vet Online"
        self.paidView.layer.masksToBounds = true
        self.paidView.layer.borderWidth = 1
        self.paidView.layer.cornerRadius = 5.0
        self.paidView.layer.borderColor = UIColor.green.cgColor
        self.freeView.layer.masksToBounds = true
        self.freeView.layer.borderWidth = 1
        self.freeView.layer.cornerRadius = 5.0
        self.freeView.layer.borderColor = UIColor.green.cgColor
        // Do any additional setup after loading the view.
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
    }
    
    func imageTapped(tapG : UITapGestureRecognizer){
        
//        let paid1:UIImage = tapG.view as! UIImageView
        //
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
