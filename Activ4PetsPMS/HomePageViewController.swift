//
//  HomePageViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController
{
    
    var noDataLbl: UILabel?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Home"
        let leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .done, target: self, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "ic_menu.png")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.showMenu))
       // rightItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightItem
        
        noDataLbl = UILabel(frame: CGRect(x: 100, y: 90, width: 250, height: 30))
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        noDataLbl?.text="No clinics found"
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        // Do any additional setup after loading the view.
    }
   
    // Below method will provide you current location.
   
    
    @objc func showMenu()
    {
        self.performSegue(withIdentifier: "menu", sender: nil)
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
