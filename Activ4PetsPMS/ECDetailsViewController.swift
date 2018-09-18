//
//  ECDetailsViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class ECDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var model: ECModel?
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var ecId: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var contactType: UILabel!
    @IBOutlet weak var conditions: UILabel!
    @IBOutlet weak var symptoms: UILabel!
    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var ecDetailsView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var vetDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.title = "EC ID - EC" + (self.model?.ecId)!
        self.segCtrl.selectedSegmentIndex = 0
        self.vetDetails.isHidden = true
        self.ecDetailsView.isHidden = false
        self.vetDetails.reloadData()
        self.petName.text = self.model?.petName as String?
        self.ecId.text = self.model?.ecId
        self.country.text = self.model?.countryId
        self.timeZone.text = self.model?.timeZone
        self.conditions.text = self.model?.petCondition
        self.date.text = self.model?.ecDate
        self.time.text = self.model?.ecTime
        self.status.text = self.model?.status
        self.contactType.text = self.model?.contactType
        self.symptoms.text = String(format: "%@, %@, %@", (self.model?.sympt1)!, (self.model?.sympt2)!, (self.model?.sympt3)!)
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EC", for: indexPath) as!  MyPetsTableViewCell
        
        cell.petName.text = self.model?.firstName as String?
        cell.petType.text = self.model?.lastName
        cell.condition.text = self.model?.email
        cell.dob.text = self.model?.speciality
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func leftClk(sender: AnyObject)
    {
        self.navigationController!.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showVetDetails(_ sender: UISegmentedControl)
    {
        if  sender.selectedSegmentIndex == 0
        {
            self.ecDetailsView.isHidden = false
            self.vetDetails.isHidden = true
        }
        else
        {
            self.ecDetailsView.isHidden = true
            self.vetDetails.isHidden = false
            self.vetDetails.reloadData()
        }
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
