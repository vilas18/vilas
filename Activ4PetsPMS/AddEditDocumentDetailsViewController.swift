//
//  AddEditDocumentDetailsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 11/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditDocumentDetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    var imgPkrCon: UIImagePickerController!
    var model: DocumentsModel?
    var base64String: String = ""
    
    @IBOutlet var documentType: UITextField!
    @IBOutlet var documentSubType: UITextField!
    @IBOutlet var docTitle: UITextField!
    @IBOutlet var fileNmae: UITextField!
    @IBOutlet var dateOfService: UITextField!
    @IBOutlet var comments: UITextView!
    
    @IBOutlet var mandatoryLbl: UILabel!
    
    
    var datePicker = UIDatePicker()
    var listTv: UIPickerView!
    
    @IBOutlet var file: UILabel!
    @IBOutlet var downView: UIView!
    @IBOutlet var upload: UIButton!
    @IBOutlet var topSpace: NSLayoutConstraint!//66
    var listArr = [Any]()
    
    var docType: String!
    var docTypeId: String!
    var docSubTypeId: String = ""
    
    var isFromVC: Bool = false
    var urlStr: String = ""
    var dropDownType: String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.listTv = UIPickerView.init(frame: CGRect(x:0, y:0, width:0, height: 220))
        listTv.delegate = self
        listTv.dataSource = self
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        
        self.mandatoryLbl.isHidden = true
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapG)
        
        self.dateOfService?.isUserInteractionEnabled = true
        self.documentType?.isUserInteractionEnabled = false
        self.documentSubType?.isUserInteractionEnabled = true
        
        self.docTitle?.layer.masksToBounds = true
        self.docTitle?.layer.borderWidth = 2
        self.docTitle?.layer.cornerRadius = 3.0
        self.docTitle?.layer.borderColor = UIColor.clear.cgColor
        
        self.fileNmae?.layer.masksToBounds = true
        self.fileNmae?.layer.borderWidth = 2
        self.fileNmae?.layer.cornerRadius = 3.0
        self.fileNmae?.layer.borderColor = UIColor.clear.cgColor
        self.fileNmae.isUserInteractionEnabled = false
        self.dateOfService?.layer.masksToBounds = true
        self.dateOfService?.layer.borderWidth = 2
        self.dateOfService?.layer.cornerRadius = 3.0
        self.dateOfService?.layer.borderColor = UIColor.clear.cgColor
        
        self.documentSubType?.layer.masksToBounds = true
        self.documentSubType?.layer.borderWidth = 2
        self.documentSubType?.layer.cornerRadius = 3.0
        self.documentSubType?.layer.borderColor = UIColor.clear.cgColor
        
        self.title = "Add Document"
        self.urlStr = API.Document.DocumentAdd
        
        self.comments?.textColor = UIColor.lightGray
        self.comments?.text = "Enter comments"
        self.fileNmae.isHidden = false
        self.file.isHidden = false
        self.upload.isHidden = false
        self.topSpace.constant = 66.0
        self.documentType.text = self.docType
        
        if self.isFromVC == true
        {
            self.title = "Edit Document"
            self.documentType.text = self.docType
            self.documentSubType.text = self.model?.docSubType
            self.docTitle.text = self.model?.docTitle
            self.dateOfService.text = self.model?.serviceDate
            let df = DateFormatter()
            df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
            let date: Date = df.date(from: self.dateOfService!.text!)!
            self.datePicker.date = date
            self.comments.text = self.model?.comment
            self.comments?.textColor = UIColor.black
            self.docSubTypeId = (self.model?.docSubTypeId)!
            
            self.fileNmae.isHidden = true
            self.file.isHidden = true
            self.upload.isHidden = true
            self.topSpace.constant = -1.0
            
            
            self.urlStr = API.Document.DocumentEdit
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        documentType?.resignFirstResponder()
        documentSubType?.resignFirstResponder()
        docTitle?.resignFirstResponder()
        fileNmae?.resignFirstResponder()
        dateOfService?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        
        
        // self.dateView.isHidden = true
        
    }
    
    
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            RestClient.getList(dropDownType, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = [Any]()
                print("response", response)
                DispatchQueue.main.async(execute: {() -> Void in
                    let detailsArr = response as? [[String:Any]] ?? []
                    
                    for dict in detailsArr
                    {
                        if (self.dropDownType == "DocumentSubType")
                        {
                            let model = CommonResponseModel()
                            if self.docTypeId != "" && self.docTypeId == dict["ConversationId"] as! String? {
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                self.listArr.append(model)
                            }
                        }
                    }
                    
                    self.listTv?.reloadAllComponents()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
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
    @IBAction func upload(_ up: UIButton)
    {
        self.imgPkrCon = UIImagePickerController()
        self.imgPkrCon.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imgPkrCon?.allowsEditing = true
        let alertControl = UIAlertController(title: "Upload document as an image", message: "Choose to upload from", preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon.sourceType = .photoLibrary
            self.present(self.imgPkrCon!, animated: true, completion: nil)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon.sourceType = .camera
            self.present(self.imgPkrCon!, animated: true, completion: nil)
        })
        let Cancel = UIAlertAction(title: "Cancel ", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon.dismiss(animated: true, completion: nil)
        })
        alertControl.addAction(galary)
        alertControl.addAction(Cancel)
        alertControl.addAction(camera)
        alertControl.popoverPresentationController?.sourceView = self.view
        alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        navigationController?.present(alertControl, animated: true, completion: nil)
    }
    // MARK: -
    // MARK: UIImagePickerController Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String: Any]?) {
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        // profilePic?.setImage(info["UIImagePickerControllerEditedImage"] as! UIImage?, for: .normal)
        let newImage: UIImage? = squareImage(with: (info["UIImagePickerControllerOriginalImage"] as! UIImage?)!, scaledTo: CGSize(width: CGFloat(120), height: CGFloat(120)))
        let imageData: Data? = UIImagePNGRepresentation(newImage!)
        self.base64String = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
        print("Upadated Image base64 string for Pet Image:\(base64String)")
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imgPkrCon?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Scale Image Function
    
    func squareImage(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        var ratio: Double
        var delta: Double
        var offset: CGPoint
        //make a new square size, that is the resized imaged width
        let sz = CGSize(width: CGFloat(newSize.width), height: CGFloat(newSize.width))
        //figure out if the picture is landscape or portrait, then
        //calculate scale factor and offset
        if image.size.width > image.size.height {
            ratio = (Double)(newSize.width / image.size.width)
            delta = (Double)(CGFloat(ratio) * image.size.width - CGFloat(ratio) * image.size.height)
            offset = CGPoint(x: CGFloat(delta / 2), y: CGFloat(0))
        }
        else {
            ratio = (Double)(newSize.width / image.size.height)
            delta = (Double)(CGFloat(ratio) * image.size.height - CGFloat(ratio) * image.size.width)
            offset = CGPoint(x: CGFloat(0), y: CGFloat(delta / 2))
        }
        //make the final clipping rect based on the calculated values
        let clipRect = CGRect(x: CGFloat(-offset.x), y: CGFloat(-offset.y), width: CGFloat((CGFloat(ratio) * image.size.width) + CGFloat(delta)), height: CGFloat((CGFloat(ratio) * image.size.height) + CGFloat(delta)))
        //start a new context, with scale factor 0.0 so retina displays get
        //high quality image
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        }
        else {
            UIGraphicsBeginImageContext(sz)
        }
        UIRectClip(clipRect)
        image.draw(in: clipRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    @objc func submitDetails(_ sender: Any)
    {
        documentType?.resignFirstResponder()
        documentSubType?.resignFirstResponder()
        docTitle?.resignFirstResponder()
        fileNmae?.resignFirstResponder()
        dateOfService?.resignFirstResponder()
        comments?.resignFirstResponder()
        
        doValidationsForUpdateDetails()
    }
    
    func doValidationsForUpdateDetails()
    {
        if self.isFromVC == true
        {
            if self.documentSubType?.text == nil && (self.documentSubType?.text == "") && self.docTitle?.text == nil && (self.docTitle?.text == "") && self.dateOfService?.text == nil && (self.dateOfService?.text == "")
            {
                navigationItem.rightBarButtonItem?.isEnabled = true
                self.documentSubType?.layer.borderColor = UIColor.red.cgColor
                self.docTitle?.layer.borderColor = UIColor.red.cgColor
                self.dateOfService?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            
            if self.documentSubType?.text == nil || (self.documentSubType?.text == "")
            {
                self.documentSubType?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.documentSubType?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            
            if self.docTitle?.text == nil || (self.docTitle?.text == "")
            {
                self.docTitle?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.docTitle?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            if self.dateOfService?.text == nil || (self.dateOfService?.text == "")
            {
                self.dateOfService?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.dateOfService?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            if !(self.documentSubType?.text == nil) && !(self.documentSubType?.text == "") && !(self.docTitle?.text == nil) && !(self.docTitle?.text == "") && !(self.dateOfService?.text == nil) && !(self.dateOfService?.text == "")
            {
                self.mandatoryLbl?.isHidden = true
                
                checkInternetConnection()
                
            }
        }
        else if self.isFromVC == false
        {
            if self.documentSubType?.text == nil && (self.documentSubType?.text == "") && self.docTitle?.text == nil && (self.docTitle?.text == "") && self.dateOfService?.text == nil && (self.dateOfService?.text == "") && self.fileNmae?.text == nil && (self.fileNmae?.text == "") && self.base64String == nil && self.base64String == ""
            {
                navigationItem.rightBarButtonItem?.isEnabled = true
                self.documentSubType?.layer.borderColor = UIColor.red.cgColor
                self.docTitle?.layer.borderColor = UIColor.red.cgColor
                self.dateOfService?.layer.borderColor = UIColor.red.cgColor
                self.fileNmae?.layer.borderColor = UIColor.red.cgColor
                let alertDel = UIAlertController(title: "Warning", message: "Please upload an image", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
                
                self.mandatoryLbl?.isHidden = false
            }
            
            if self.documentSubType?.text == nil || (self.documentSubType?.text == "")
            {
                self.documentSubType?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.documentSubType?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            
            if self.docTitle?.text == nil || (self.docTitle?.text == "")
            {
                self.docTitle?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.docTitle?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            if self.dateOfService?.text == nil || (self.dateOfService?.text == "")
            {
                self.dateOfService?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.dateOfService?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            if self.fileNmae?.text == nil || (self.fileNmae?.text == "")
            {
                self.fileNmae?.layer.borderColor = UIColor.red.cgColor
                self.mandatoryLbl?.isHidden = false
            }
            else
            {
                self.fileNmae?.layer.borderColor = UIColor.clear.cgColor
                self.mandatoryLbl?.isHidden = false
                
            }
            if self.base64String == nil || self.base64String == ""
            {
                let alertDel = UIAlertController(title: "Warning", message: "Please upload an image", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                
                alertDel.addAction(ok)
                self.present(alertDel, animated: true, completion: nil)
            }
            
            if !(self.documentSubType?.text == nil) && !(self.documentSubType?.text == "") && !(self.docTitle?.text == nil) && !(self.docTitle?.text == "") && !(self.dateOfService?.text == nil) && !(self.dateOfService?.text == "") && !(self.fileNmae?.text == nil) && !(self.fileNmae?.text == "") && !(self.base64String == nil) && !(self.base64String == "")
            {
                self.mandatoryLbl?.isHidden = true
                checkInternetConnection()
            }
        }
        
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpdateAdd()
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func webServiceToUpdateAdd()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "content-type": "application/json",
                "cache-control": "no-cache"
            ]
            var str: String = ""
            var message: String = ""
            if self.isFromVC == true
            {
                message = "Document details has been updated successfully"
                str = String(format: "DocId=%@&DocumentSubTypeId=%@&Title=%@&ServiceDate=%@&Comment=%@", (self.model?.documentId)!, self.docSubTypeId, self.docTitle.text!, self.dateOfService.text!, self.comments.text!)
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let urlString = String(format : "%@?%@", self.urlStr, str)
                let requestUrl = URL(string: urlString)
                var request = URLRequest(url: requestUrl!)
                request.allHTTPHeaderFields = headers
                let session = URLSession.shared
                let task = session.dataTask(with: request)
                {
                    (data, response, error) in
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
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
                                if status == 1
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alertDel = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                        for aViewController in viewControllers
                                        {
                                            if aViewController is DocumentsListViewController
                                            {
                                                self.navigationController!.popToViewController(aViewController, animated: true)
                                            }
                                        }
                                    })
                                    
                                    alertDel.addAction(ok)
                                    self.present(alertDel, animated: true, completion: nil)
                                }
                        }
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                task.resume()
                
            }
            else if self.isFromVC == false
            {
                message = "Document details has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                let dict: [String: String] = ["PetId": petId, "DocumentSubTypeId": self.docSubTypeId, "Title": self.docTitle.text!, "DocumentPath": self.fileNmae.text!, "DocBase64String": self.base64String, "ServiceDate": self.dateOfService.text!, "Comment":self.comments.text!]
                let objDict = dict as NSDictionary
                let requestUrl = URL(string: self.urlStr) //else { return }
                var request = URLRequest(url:requestUrl!)
                
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: objDict, options: .prettyPrinted)
                    
                } catch
                {
                    print(error.localizedDescription)
                }
                request.httpMethod = "POST"
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
                                    let alertDel = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                        for aViewController in viewControllers
                                        {
                                            if aViewController is DocumentsListViewController
                                            {
                                                self.navigationController!.popToViewController(aViewController, animated: true)
                                            }
                                        }
                                    })
                                    
                                    alertDel.addAction(ok)
                                    self.present(alertDel, animated: true, completion: nil)
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
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if textView == comments {
            comments?.text = ""
            comments?.textColor = UIColor.black
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.documentSubType
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.dateOfService
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            
            self.datePicker.maximumDate = Date()
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.isTranslucent = true
            toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donedatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = datePicker
        }
        else if textField == self.documentSubType
        {
            dropDownType = "DocumentSubType"
            self.listArr = []
            self.listTv.reloadAllComponents()
            getList()
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
            if (dropDownType == "DocumentSubType")
            {
                let model = listArr[self.listTv.selectedRow(inComponent: 0)] as? CommonResponseModel
                documentSubType?.text = model?.paramName
                self.docSubTypeId = (model?.paramID)!
            }
            self.documentSubType?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.documentSubType?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.documentSubType?.resignFirstResponder()
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.dateOfService?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.dateOfService?.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.docTitle
        {
            self.fileNmae.text = self.docTitle.text! + ".png"
        }
    }
    func textViewDidChange(_ textView: UITextView)
    {
        if comments?.text.count == 0
        {
            comments?.textColor = UIColor.lightGray
            comments?.text = "Enter comments"
            comments?.resignFirstResponder()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
