//
//  TermsAndConditionsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 27/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController
{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    var isFromVC: Bool = false
    var isFromRefer: Bool = false
    var isFromVetOnCall: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: nil, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        var urlString: String = ""
        if self.isFromRefer
        {
            urlString = "https://login.activ4pets.com/TermsConditionsReferAndEarn.html"
        }
        else
        {
            urlString = "https://login.activ4pets.com/TermsConditions.html"
        }
        let encodedString = (urlString as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("URL string is:\(String(describing: encodedString))")
        let urlRequest = URLRequest(url: URL(string: encodedString!)!)
        self.webView.loadRequest(urlRequest)
        if self.isFromVC == true || isFromRefer == true || isFromVetOnCall == true
        {
            self.backButton.setTitle("Ok", for: .normal)
            self.backButton.addTarget(self, action: #selector(dissmissTerms), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func dissmissTerms()
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
    }
    @IBAction func acceptClk(_ sender: Any) {
        checkInternetConnection()
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("", comment: "")
            webServiceToAcceptTNC()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func webServiceToAcceptTNC()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        var details = String(format : "userId=%@&IsAccepted=%@", userId,"true")
        details = details.trimmingCharacters(in: CharacterSet.whitespaces)
        details = details.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Login.AcceptTermsAndCond, details)
        var request = URLRequest(url: URL(string: urlStr)!)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        print(json ?? " ")
                        if status == 1
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let MyPets: MyPetsViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                            MyPets.isFromNS = true
                            self.navigationController?.pushViewController(MyPets, animated: true)
                        }
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
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
