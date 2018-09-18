//
//  ViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 16/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.firstView.isHidden = false
        self.secondView.isHidden = true
        self.thirdView.isHidden = true
        self.perform(#selector(showSecond), with: firstView, afterDelay: 10)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    @objc func showSecond()
    {
        self.firstView.isHidden = true
        self.secondView.isHidden = false
        self.thirdView.isHidden = true
        self.perform(#selector(showThird), with: secondView, afterDelay: 10)
    }
    @objc func showThird()
    {
        self.firstView.isHidden = true
        self.secondView.isHidden = true
        self.thirdView.isHidden = false
        
    }
    @IBAction func showSecView(_ sender: UIButton)
    {
        self.firstView.isHidden = true
        self.secondView.isHidden = false
        self.thirdView.isHidden = true
    }
    @IBAction func showThirdView(_ sender: UIButton)
    {
        self.firstView.isHidden = true
        self.secondView.isHidden = true
        self.thirdView.isHidden = false
    }
    
    @IBAction func getStarted(_ sender: UIButton)
    {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "IsLoggedIn")
        if isLoggedIn
        {
            let SavedLogin: SavedUserLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedLogin") as! SavedUserLoginViewController
            
            self.navigationController?.pushViewController(SavedLogin, animated: true)
            
        }
        else
        {
            let Login: LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            
            self.navigationController?.pushViewController(Login, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

