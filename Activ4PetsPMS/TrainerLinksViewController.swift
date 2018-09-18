//
//  TrainerLinksViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class TrainerLinksViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        for controller: UIViewController in (self.navigationController?.viewControllers)!
        {
            if (controller is MyPetsViewController)
            {
                _ = self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showLinksDetails(_ sender: UIButton)
    {
        var urlStr = ""
        
        if sender.tag == 1
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "https://apdt.com"
                self.performSegue(withIdentifier: "TrainerLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 2
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "http://www.animalbehaviorcollege.com"
                self.performSegue(withIdentifier: "TrainerLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 3
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "https://www.karenpryoracademy.com"
                self.performSegue(withIdentifier: "TrainerLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
    }
    @IBAction func moveToSeletecdLinksPage(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is VeterinariansLinksViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let vetLinks: VeterinariansLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "VetLinks") as! VeterinariansLinksViewController
                    _ = self.navigationController?.pushViewController(vetLinks, animated: true)
                    break
                }
            }
            
        }
        else if sender.tag == 2
        {
            
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is GroomersLinksViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let groomer: GroomersLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroomerLinks") as! GroomersLinksViewController
                    _ = self.navigationController?.pushViewController(groomer, animated: true)
                    break
                }
            }
        }
        else if sender.tag == 3
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is AdoptionLinksViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let adopt: AdoptionLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdoptLinks") as! AdoptionLinksViewController
                    _ = self.navigationController?.pushViewController(adopt, animated: true)
                    
                    break
                }
            }
        }
        else if sender.tag == 4
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is BoarderLinksViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let boarder: BoarderLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "BoarderLinks") as! BoarderLinksViewController
                    _ = self.navigationController?.pushViewController(boarder, animated: true)
                    
                    break
                }
            }
        }
        else if sender.tag == 5
        {
            for controller: UIViewController in (self.navigationController?.viewControllers)!
            {
                if (controller is PetSittersLinksViewController)
                {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
                else
                {
                    let sitter: PetSittersLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "SitterLinks") as! PetSittersLinksViewController
                    _ = self.navigationController?.pushViewController(sitter, animated: true)
                    
                    break
                }
            }
            
        }
        else if sender.tag == 6
        {
            //            let trainer: TrainerLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrainerLinks") as! TrainerLinksViewController
            //            _ = self.navigationController?.pushViewController(trainer, animated: true)
        }
        else if sender.tag == 7
        {
            let other: OtherLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "OtherLinks") as! OtherLinksViewController
            _ = self.navigationController?.pushViewController(other, animated: true)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let web = segue.destination as! WebViewController
        web.urlStr = sender as! String
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
