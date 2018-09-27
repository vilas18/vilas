//
//  FreeQuestionVC.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 18/09/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit
class FreeQuestionVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var querytextView: UITextView!
    @IBOutlet weak var queryCategory: UITextField!
    @IBOutlet weak var petType: UITextField!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    var petModelList = [MyPetsModel1]()
    var note2 :String = "take your pet to an emergency vet if you belive they are at serious and immediate risk"
    var note1 : String = "Please note, "
    var listArr = [Any]()
    var listTv: UIPickerView!
    var petInfo: MyPetsModel?
    var queryCategoryId: String = ""
    var textFld: UITextField?
    var dropDownTbl: UIPickerView!
    var dropDownString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        listTv.delegate = self
        listTv.dataSource = self
        navigationItem.leftBarButtonItem = leftItem
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        prepareUI()
        let email: String = UserDefaults.standard.string(forKey: "UserEmail")!
        let pettype : String = UserDefaults.standard.string(forKey: "PetType")!
        self.petType.text = pettype
        self.emailTxt.text = email
        self.title = "Ask a Question"
        petType.isUserInteractionEnabled = false
        queryCategory.isUserInteractionEnabled = true
        emailTxt.isUserInteractionEnabled = true
        querytextView.isUserInteractionEnabled = true
        self.querytextView.delegate = self
        self.querytextView.textColor =  UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    func prepareUI()
    {
        let pettype = UserDefaults.standard.object(forKey: "SelectedPet")
        petType.text = pettype as? String
        self.querytextView.layer.masksToBounds = true
        self.querytextView.layer.borderWidth = 2
        self.querytextView.layer.cornerRadius = 5.0
        self.querytextView.layer.borderColor = UIColor.green.cgColor
        emailTxt.layer.masksToBounds = true
        emailTxt.layer.borderWidth = 2
        emailTxt.layer.cornerRadius = 3.0
        emailTxt.layer.borderColor = UIColor.clear.cgColor
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.borderWidth = 2
        submitBtn.layer.cornerRadius = 3.0
        submitBtn.layer.borderColor = UIColor.clear.cgColor
        queryCategory.layer.masksToBounds = true
        queryCategory.layer.borderWidth = 2
        queryCategory.layer.cornerRadius = 3.0
        queryCategory.layer.borderColor = UIColor.clear.cgColor
//        self.GetQueryCategories() // MBHUD spinner should appear and then picker should load
//        let yourAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
//        let finalString =  NSMutableAttributedString(string: note1, attributes: yourAttributes)
//        let attributeStr =  NSMutableAttributedString(string: note2 , attributes: yourAttributes)
//        finalString.append(attributeStr)
//        self.note.text = attributeStr
        
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        queryCategory.resignFirstResponder()
        petType.resignFirstResponder()
        emailTxt.resignFirstResponder()
        querytextView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 500;
    }
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return listArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row]
        return (model as AnyObject).paramName
    }
    func GetQueryCategories()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
//        let userId:String = UserDefaults.standard.string(forKey: "userID")!
        let urlStr = String("http://qapetsvetscom.activdoctorsconsult.com/Vet/GetCategories") // change to live URL ***
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//               let queryDic = json?["Categories"] as? [[String : Any]]
//            {
//                var filtered = [[String : Any]]()
//                DispatchQueue.main.async
//                    {
//                        if queryDic.count == 0
//                        {
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                        }
//                        else
//                        {
//                            for item in queryDic
//                            {
//                                var prunedDictionary = [String: Any]()
//                                for key: String in item.keys
//                                {
//                                    if !(item[key] is NSNull) {
//                                        prunedDictionary[key] = item[key]
//                                    }
//                                    else
//                                    {
//                                        prunedDictionary[key] = ""
//                                    }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            {
                if let queryDic = json?["Categories"] as? [[String : Any]]
                {
                    var filtered = [[String : Any]]()
                    DispatchQueue.main.async
                        {
                            let detailsArr = response as! [[String:Any]]
                            for dict in detailsArr
                            if queryDic.count == 0
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                            else
                            {
                                for item in queryDic
                                {
                                    var prunedDictionary = [String: Any]()
                                    for key: String in item.keys
                                    {
                                        if !(item[key] is NSNull) {
                                            prunedDictionary[key] = item[key]
                                        }
                                        else
                                        {
                                            prunedDictionary[key] = ""
                                        }
                                }
                                print(prunedDictionary)
                                filtered.append(prunedDictionary)
                            }
                            for item in filtered
                            {
                                let model = CommonResponseModel()
                                model.paramID = ((item["Id"] as! NSNumber).stringValue)
                                model.paramName = (item["Category"] as! String)
                                self.listArr.append(model)
                                print(model.paramName)
                                print(model.paramID)
                              }
                        }
                            self.dropDownTbl.reloadAllComponents()
                            MBProgressHUD.hide(for: self.view, animated: true)
                    }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            }
        }
        task.resume()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == querytextView
        {
            if querytextView.text == "Type your question here(500 characters max)"
            {
                querytextView.text = ""
            }
            querytextView.textColor = UIColor.black
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
       {
           if textField == queryCategory
            {
            self.textFld = textField
            self.listArr = []
            self.listTv.reloadAllComponents()
            GetQueryCategories()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDropDownSelection))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDropDownSelection))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = listTv
            }
       }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                queryCategory?.text = model?.paramName
                queryCategoryId = (model?.paramID)!
        }
    }
    @objc func cancelDropDownSelection()
      {
            self.view.endEditing(true)
            self.textFld?.resignFirstResponder()
       }
    @IBAction func submit(_ sender: Any)
    {
        querytextView.resignFirstResponder()
        petType.resignFirstResponder()
        queryCategory.resignFirstResponder()
        emailTxt.resignFirstResponder() 
        doValidationForEmptyField()
    }
    func doValidationForEmptyField()
    {
        if querytextView.text == nil || (querytextView.text == "") || querytextView.text == "Type your question here(500 characters max)"
        {
            let alert = UIAlertController(title: "Warning", message: "Please enter problem of pet", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            querytextView.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true)
        }
          else  if queryCategory.text == nil || (queryCategory.text == "")
        {
            let alert = UIAlertController(title: "Warning", message: "Please choose pet category", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            queryCategory.layer.borderColor = UIColor.red.cgColor
            present(alert, animated: true)
        }
        else  if emailTxt.text == nil || (emailTxt.text == "")
        {
            if querytextView.text != nil && querytextView.text != ""
            {
                querytextView.text = querytextView.text?.lowercased()
            }
            let emailReg: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            if emailTest.evaluate(with: emailTxt.text) == false
            {
                querytextView.layer.borderColor = UIColor.red.cgColor
                let alert = UIAlertController(title: nil, message: "Please Enter Valid Email Address.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            else
            {
                queryCategory.layer.borderColor = UIColor.clear.cgColor
                querytextView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else
        {
            let freefinal : FreeSubmitVCViewController = self.storyboard?.instantiateViewController(withIdentifier: "FreeFinal") as! FreeSubmitVCViewController
           self.navigationController?.pushViewController(freefinal, animated: true)
        }
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
