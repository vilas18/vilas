//
//  WebViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 23/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate
{
    
    @IBOutlet weak var webView: UIWebView!
    var urlStr: String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let urlRequest = URLRequest(url: URL(string: self.urlStr)!)
        webView?.loadRequest(urlRequest)
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("External site started to load....")
        //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("External site loaded...")
        //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print("Error loading external site is:\(error)")
        let alertDel = UIAlertController(title: "Error Loading page", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertDel.addAction(ok)
        self.present(alertDel, animated: true, completion: nil)
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
