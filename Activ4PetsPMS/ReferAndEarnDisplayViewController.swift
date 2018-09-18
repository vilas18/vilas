//
//  ReferAndEarnDisplayViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 26/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class ReferAndEarnDisplayViewController: UIViewController
{
    @IBOutlet weak var referCode: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.checkInternetConnection()
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func showTermsAndConditions(_ sneder: UIButton)
    {
        let termsCond: TermsAndConditionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TandC") as! TermsAndConditionsViewController
        termsCond.isFromRefer = true
        self.present(termsCond, animated: true, completion: nil)
    }
    
    @IBAction func sendInvitation(_ sender: UIButton)
    {
        let firstname:String = (UserDefaults.standard.string(forKey: "UserName"))!
        let str = "I would recommend you to download the Activ4Pets app. You can use it to get online vet consults and read unlimited pet related health articles. Enjoy a hassle-free-experience, anytime,anywhere! Download now http://share.activ4pets.com/?ReffrCode="
        let strs: String = str + self.referCode.text! + " to get 10% off on our services. Use code:" + self.referCode.text! + "\n\n Thanks\n" + firstname
        let vc = UIActivityViewController(activityItems: [strs], applicationActivities: nil)
        vc.setValue("Activ4Pets Referral Program", forKey: "Subject")
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true, completion: nil)
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToGetReferralCode()
        }
        else
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToGetReferralCode()
    {
        let headers = [
            "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
            "cache-control": "no-cache"
        ]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlString = String(format : "%@?UserId=%@", API.Invite.GetRefCode,userId)
        let requestUrl = URL(string: urlString)
        var request = URLRequest(url: requestUrl!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in

            guard let data = data, error == nil else
            {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let status = json?["Status"] as? Int
            {
                DispatchQueue.main.async
                    {
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.referCode.text = json?["UserCode"] as? String
                        }
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }

        }
        task.resume()
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
