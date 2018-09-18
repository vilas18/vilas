//
//  VeterinariansLinksViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 22/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class VeterinariansLinksViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
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
                urlStr = "http://www.webvet.com/main/vetFinder"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
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
                urlStr = "http://www.myveterinarian.com/avma/vclPublic/"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
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
                urlStr = "http://www.veterinarians.com/"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 4
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "http://www.animalhospitals.com/"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 5
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "https://www.aaha.org/pet_owner/about_aaha/hospital_search/default.aspx"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 6
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "http://www.vcahospitals.com/main/directory"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
            })
            alertDel.addAction(cancel)
            alertDel.addAction(ok)
            self.present(alertDel, animated: true, completion: nil)
        }
        else if sender.tag == 7
        {
            let alertDel = UIAlertController(title: "Confirmation !", message: "You are being redirected to a Web site external to Activ4Pets. This linked web site is provided for your convenience. Activ4Pets is not responsible or liable for the content, information or security; the failure of any products or services advertised or promoted on this linked site and any issue that may arise out of the site’s privacy policy.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let ok = UIAlertAction(title: "I Agree", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                urlStr = "http://www.lastchanceanimalrescue.org"
                self.performSegue(withIdentifier: "VetLinks", sender: urlStr)
                
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
            print("self")
            
        }
        else if sender.tag == 2
        {
            let groomer: GroomersLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroomerLinks") as! GroomersLinksViewController
            _ = self.navigationController?.pushViewController(groomer, animated: true)
        }
        else if sender.tag == 3
        {
            let adopt: AdoptionLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdoptLinks") as! AdoptionLinksViewController
            _ = self.navigationController?.pushViewController(adopt, animated: true)
        }
        else if sender.tag == 4
        {
            let boarder: BoarderLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "BoarderLinks") as! BoarderLinksViewController
            _ = self.navigationController?.pushViewController(boarder, animated: true)
        }
        else if sender.tag == 5
        {
            let sitter: PetSittersLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "SitterLinks") as! PetSittersLinksViewController
            _ = self.navigationController?.pushViewController(sitter, animated: true)
        }
        else if sender.tag == 6
        {
            let trainer: TrainerLinksViewController = self.storyboard?.instantiateViewController(withIdentifier: "TrainerLinks") as! TrainerLinksViewController
            _ = self.navigationController?.pushViewController(trainer, animated: true)
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
