//
//  ShopPetHealthSuppliesViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 26/06/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class ShopPetHealthSuppliesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func showLink(_ sender: UIButton)
    {
        var urlStr = ""
        let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
            urlStr = "https://animalleagueamerica.vetsfirstchoice.com?&s_src=referral&s_subsrc=fy18actv4pts_vetsfrstchc&utm_source=1806phc&utm_medium=referral&utm_campaign=fy18activ4pets"
            self.performSegue(withIdentifier: "shopPet", sender: urlStr)
            
        })
        alertDel.addAction(cancel)
        alertDel.addAction(ok)
        self.present(alertDel, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let web = segue.destination as! WebViewController
        web.urlStr = sender as! String
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
