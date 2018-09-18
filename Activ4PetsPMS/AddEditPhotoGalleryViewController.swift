//
//  AddEditPhotoGalleryViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 31/07/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditPhotoGalleryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
    var model: PhotoGalleryModel?
    @IBOutlet var photoTitle: UITextField!
    @IBOutlet var petPhoto: UIButton!
    var image: UIImage!
    var base64PetImgString: String = ""
    var ImagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var mandatoryLbl: UILabel?
    var isFromVC: Bool = false
    var urlStr: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ImagePicker.delegate = self
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        
        self.photoTitle?.layer.masksToBounds = true
        self.photoTitle?.layer.borderWidth = 2
        self.photoTitle?.layer.cornerRadius = 3.0
        self.photoTitle?.layer.borderColor = UIColor.clear.cgColor
        
        self.petPhoto?.layer.masksToBounds = true
        self.petPhoto?.layer.borderWidth = 1
        self.petPhoto?.layer.borderColor = UIColor.lightGray.cgColor
        
        self.mandatoryLbl?.isHidden = true
        if self.isFromVC == true
        {
            self.title = "Edit Photo"
            self.photoTitle.text = self.model?.ImageName
            self.petPhoto.isUserInteractionEnabled = false
            let contImageUrl = model?.photoUrl
            if let url = NSURL(string: contImageUrl!)
            {
                if let data = NSData(contentsOf: url as URL)
                {
                    self.petPhoto.setTitle("", for: .normal)
                    self.petPhoto.setImage(UIImage(data: data as Data), for: .normal)
                    let newImage = squareImage(with: self.petPhoto.currentImage!, scaledTo: CGSize(width: 120, height: 120))
                    let imageData: Data? = UIImagePNGRepresentation(newImage)
                    base64PetImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
                    
                }
            }
        }
        else{
            self.title = "Add Photo"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func leftClk(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitDetails(_ sender: Any)
    {
        self.photoTitle.resignFirstResponder()
        doValidationForPhotAdd()
    }
    
    @IBAction func selectPhotoToUpload(_ sender: UIButton)
    {
        
        //self.imgPkrCon?.delegate = self
        ImagePicker.allowsEditing = true
        let alertControl = UIAlertController(title: "Upload Photo", message: "Choose to upload from", preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.ImagePicker.sourceType = .photoLibrary
            self.present(self.ImagePicker, animated: true, completion: nil)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.ImagePicker.sourceType = .camera
            self.present(self.ImagePicker, animated: true, completion: nil)
        })
        let Cancel = UIAlertAction(title: "Cancel ", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.ImagePicker.dismiss(animated: true, completion: nil)
        })
        alertControl.addAction(galary)
        
        alertControl.addAction(camera)
        alertControl.addAction(Cancel)
        alertControl.popoverPresentationController?.sourceView = self.view
        alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        navigationController?.present(alertControl, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.ImagePicker.dismiss(animated: true, completion: nil)
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        self.petPhoto.setImage(image, for: .normal)
        self.petPhoto.setTitle("", for: .normal)
        
        
        
        let newImage: UIImage? = squareImage(with: self.petPhoto.currentImage!, scaledTo: CGSize(width: 120, height: 120))
        let imageData: Data? = UIImagePNGRepresentation(newImage!)
        base64PetImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
        print("Added Image base64 string for Pet Image:\(base64PetImgString)")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String: Any]?) {
        self.ImagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.ImagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Scale Image Function
    func squareImage(with image: UIImage, scaledTo newSize: CGSize) -> UIImage
    {
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
    
    func doValidationForPhotAdd()
    {
        if self.photoTitle.text == nil && self.photoTitle.text == "" && self.base64PetImgString == ""
        {
            self.mandatoryLbl?.isHidden = false
            self.photoTitle?.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please upload a image", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        if self.photoTitle.text == nil || self.photoTitle.text == ""
        {
            self.mandatoryLbl?.isHidden = false
            self.photoTitle?.layer.borderColor = UIColor.red.cgColor
        }
        else
        {
            self.mandatoryLbl?.isHidden = true
            self.photoTitle?.layer.borderColor = UIColor.clear.cgColor
        }
        if self.base64PetImgString == ""
        {
            self.photoTitle?.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please upload a image", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        if !(self.photoTitle.text == nil) && !(self.photoTitle.text == "") && !(self.base64PetImgString == "")
        {
            self.mandatoryLbl?.isHidden = true
            checkInternetConnection()
            
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
            var str = [String: String]()
            var message: String = ""
            if self.isFromVC == true
            {
                message = "Photo has been updated successfully"
                str = ["PhotoGalleryId": (self.model?.galleryId)!, "Title": self.photoTitle.text!, "PhotoImgBase64String": self.base64PetImgString, "FileName": (self.model?.ImageName)!];
                self.urlStr = API.PhotoGallery.PhotoEdit
                
            }
            else if self.isFromVC == false
            {
                message = "Photo has been added successfully"
                let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
                str = ["PetId": petId, "Title": self.photoTitle.text!, "PhotoImgBase64String": self.base64PetImgString, "FileName": "Photo_1"];
                self.urlStr = API.PhotoGallery.PhotoAdd
            }
            guard let requestUrl = URL(string: self.urlStr!) else { return }
            var request = URLRequest(url:requestUrl)
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: str, options: .prettyPrinted)
                
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
                                    if self.isFromVC == true
                                    {
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is GalleryListViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    else
                                    {
                                        _ = self.navigationController?.popViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.photoTitle.resignFirstResponder()
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
