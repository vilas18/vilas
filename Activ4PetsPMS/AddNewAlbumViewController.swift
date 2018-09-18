//
//  AddNewAlbumViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 01/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddNewAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, sendDataBack
{
    
    @IBOutlet var selectedPhotosView: UICollectionView!
    @IBOutlet var imageNameView: UIView!
    @IBOutlet var albumTitle: UITextField!
    @IBOutlet var imageTitle: UITextField!
    var base64String: String = ""
    var isCamera: Bool = false
    var isGallery: Bool = false
    var selectedList = [[String: String]]()
    var urlList = [[String: String]]()
    var ImagePicker: UIImagePickerController = UIImagePickerController()
    var isFromVC: Bool = false
    var urlStr: String = ""
    var model: AlbumGalleryModel?
    var selectedPhoto = [String: String]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ImagePicker.delegate = self
        var leftItem: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        
        imageNameView.layer.shadowColor = UIColor.black.cgColor
        imageNameView.layer.shadowOpacity = 0.5
        imageNameView.layer.shadowRadius = 4.0
        imageNameView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageTitle.layer.masksToBounds = true
        imageTitle.layer.borderWidth = 2
        imageTitle.layer.cornerRadius = 3.0
        imageTitle.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
        self.imageNameView.isHidden = true
        self.urlStr = API.AlbumGallery.AlbumAdd
        if self.isFromVC == true
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            self.selectedList = []
            for dict in (self.model?.photosList)!
            {
                var newDict = [String : String]()
                if dict["Title"] == ""
                {
                    newDict = ["Id": dict["GalleryId"]!, "ImageName": "Image", "Title": "Image", "ImageURL": (dict["ImageURL"])!]
                }
                else
                {
                    newDict = ["Id": dict["GalleryId"]!, "ImageName": dict["Title"]!, "Title": dict["Title"]!, "ImageURL": (dict["ImageURL"])!]
                }
                self.selectedList.append(newDict)
            }
            // self.selectedList = (self.model?.photosList)!
            print(self.selectedList)
            self.albumTitle.text = self.model?.albumTitle
            self.urlStr = API.AlbumGallery.AlbumUpdate
            self.selectedPhotosView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return selectedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        let dict = selectedList[indexPath.row]
        if self.isFromVC
        {
            cell.selectPhoto.setImage(UIImage(named: "dlt_orng.png"), for: .normal)
            cell.selectPhoto.setImage(UIImage(named: "dlt_orng.png"), for: .selected)
            cell.selectPhoto.isUserInteractionEnabled = true
            cell.selectPhoto.addTarget(self, action: #selector(self.removeAlbumPhoto), for: .touchUpInside)
            cell.selectPhoto.tag = indexPath.row
        }
        else
        {
            
        }
        var petImageUrl = dict["ImageURL"]
        petImageUrl = petImageUrl?.trimmingCharacters(in: CharacterSet.whitespaces)
        petImageUrl = petImageUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        cell.petImage.imageFromServerURL(urlString: petImageUrl!, defaultImage: "")
        MBProgressHUD.hide(for: self.view, animated: true)
        
        //        DispatchQueue.main.async
        //            {
        //
        //                petImageUrl = petImageUrl?.trimmingCharacters(in: CharacterSet.whitespaces)
        //                petImageUrl = petImageUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //                if let url = NSURL(string: petImageUrl!)
        //                {
        //                    if let data = NSData(contentsOf: url as URL)
        //                    {
        //                        cell.petImage.image=UIImage(data: data as Data)
        //                    }
        //                }
        //                MBProgressHUD.hide(for: self.view, animated: true)
        //
        //        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return CGSize(width: 150.0, height: 150.0)
        }
        else {
            return CGSize(width: 90.0, height: 90.0)
        }
    }
    @objc func removeAlbumPhoto(_ sender: UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.selectedPhotosView)
        let indexPath = self.selectedPhotosView.indexPathForItem(at: buttonPosition)
        if indexPath != nil
        {
            self.selectedPhoto = self.selectedList[(indexPath?.row)!]
            let galleryId: String = (self.selectedPhoto["Id"])!
            for i in 0..<self.selectedList.count
            {
                let dict = self.selectedList[i]
                if dict["Id"] == galleryId
                {
                    self.selectedList.remove(at: i)
                    
                }
            }
            self.selectedPhotosView.reloadData()
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @objc func submitDetails(_ sender: Any)
    {
        self.albumTitle.resignFirstResponder()
        
        if self.albumTitle.text == nil && self.albumTitle.text == "" && self.selectedList.count == 0
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please select or upload a image and enter the album title", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        if self.albumTitle.text == nil || self.albumTitle.text == ""
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please enter the album title", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        if self.selectedList.count == 0
        {
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Please select or upload a image", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        if !(self.albumTitle.text == nil) && !(self.albumTitle.text == "") && !(self.selectedList.count == 0)
        {
            self.checkInternetConnection()
        }
        
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        navigationItem.rightBarButtonItem?.isEnabled = true
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = nil
            webServiceToUpdateAdd()
        }
        else
        {
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
            print(self.selectedList)
            var newList:[[String: String]] = []
            for  i in 0..<self.selectedList.count
            {
                var item = self.selectedList[i]
                item["ImageURL"] = nil
                newList.append(item)
            }
            print(newList)
            var item = newList.last
            let defaultName = item?["ImageName"]
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            var str: [String : Any] = [:]
            var msg: String = ""
            if self.isFromVC
            {
                str = ["AlbumId": (self.model?.albumId)!,"PetId": petId, "IsDefault": defaultName!,  "lstGallery": newList,"Title": self.albumTitle.text!]
                msg = "Album has been updated successfully"
            }
            else
            {
                str = ["PetId": petId, "IsDefault": defaultName!, "Title": self.albumTitle.text!, "lstGallery": newList]
                msg = "Album has been added successfully"
            }
            print(str)
            guard let requestUrl = URL(string: self.urlStr) else { return }
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
                                
                                let alertDel = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                                alertDel.addAction(ok)
                                self.present(alertDel, animated: true, completion: nil)
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
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
    
    @IBAction func choosePhotosUpload(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let List: SelectPhotosForAlbumViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectPhotos") as! SelectPhotosForAlbumViewController
            
            List.delegate = self
            self.navigationController?.pushViewController(List, animated: true)
            
        }
        else if sender.tag == 2
        {
            ImagePicker.allowsEditing = true
            let alertControl = UIAlertController(title: "Upload Photo", message: "Choose to upload from", preferredStyle: .actionSheet)
            let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.isGallery = true
                self.isCamera = false
                if self.imageNameView.isHidden {
                    self.imageTitle.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
                    self.imageNameView.isHidden = false
                }
                else {
                    self.imageNameView.isHidden = true
                }
            })
            let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.isCamera = true
                self.isGallery = false
                if self.imageNameView.isHidden {
                    self.imageTitle.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
                    self.imageNameView.isHidden = false
                }
                else {
                    self.imageNameView.isHidden = true
                }
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
    }
    @IBAction func saveClk(_ sender: Any)
    {
        self.imageTitle.resignFirstResponder()
        if self.imageTitle.text == nil || self.imageTitle.text == ""
        {
            self.imageTitle.layer.borderColor = UIColor.red.cgColor
        }
        else
        {
            self.imageTitle.layer.borderColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1).cgColor
            self.imageNameView.isHidden = true
            if self.isGallery == true
            {
                self.ImagePicker.sourceType = .photoLibrary
                self.present(ImagePicker, animated: true, completion: nil)
            }
            else if self.isCamera == true
            {
                self.ImagePicker.sourceType = .camera
                self.present(ImagePicker, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelClk(_ sender: Any)
    {
        self.imageNameView.isHidden = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.ImagePicker.dismiss(animated: true, completion: nil)
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let newImage: UIImage? = squareImage(with: image, scaledTo: CGSize(width: 120, height: 120))
        let imageData: Data? = UIImagePNGRepresentation(newImage!)
        self.base64String = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
        uploadPhotoToAddToAlbum()
        print("Added Image base64 string for Pet Image:\(base64String)")
    }
    
    func uploadPhotoToAddToAlbum()
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
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            str = ["petId": petId, "UploadFileName": self.imageTitle.text!, "Base64String": self.base64String];
            
            
            guard let requestUrl = URL(string: API.AlbumGallery.UploadPhoto) else { return }
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
                    let list = json?["albumuploadList"] as?  [[String : Any]]
                {
                    
                    for item in list
                    {
                        var dict: [String: String] = ["Id": "0", "ImageName": item["FileName"]! as! String, "Title": self.imageTitle.text!, "ImageURL": item["Url"] as! String]
                        self.selectedList.append(dict)
                        print(self.selectedList)
                        self.selectedPhotosView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            task.resume()
            
        }
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
    
    func sendData(toAddAlbum passedArray: [[String: String]])
    {
        print("Count of array is:\(UInt(passedArray.count))")
        if passedArray.count == 0 {
            print("User has not selected photo from pet gallery")
        }
        else
        {
            for dict: [String: String] in passedArray
            {
                self.selectedList.append(dict)
                self.selectedPhotosView.reloadData()
            }
            
        }
    }
    
    //    func webServiceToDeleteAlbumPhoto(_ sender: String)
    //    {
    //        if CheckNetwork.isExistenceNetwork()
    //        {
    //            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
    //            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
    //            let urlStr = String(format : "%@?PetId=%@&AlbumId=%@&GalleryId=%@",API.AlbumGallery.AlbumPhotoDelete, petId,(self.model?.albumId)!,sender)
    //            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
    //            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
    //            let session = URLSession.shared
    //            let task = session.dataTask(with: request)
    //            {
    //                (data, response, error) in
    //                guard let data = data, error == nil else {                                                 // check for fundamental networking error
    //                    print("error=\(String(describing: error))")
    //                    MBProgressHUD.hide(for: self.view, animated: true)
    //                    return
    //                }
    //
    //                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
    //                {           // check for http errors
    //                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
    //                    print("response = \(String(describing: response))")
    //                    MBProgressHUD.hide(for: self.view, animated: true)
    //                }
    //
    //                let responseString = String(data: data, encoding: .utf8)
    //                print("responseString = \(String(describing: responseString))")
    //                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
    //                    let status = json?["Status"] as? Int
    //                {
    //                    DispatchQueue.main.async
    //                        {
    //                            MBProgressHUD.hide(for: self.view, animated: true)
    //                            if status == 1
    //                            {
    //                                for i in 0..<self.selectedList.count
    //                                {
    //                                    let dict = self.selectedList[i]
    //                                    if dict["GalleryId"] == sender
    //                                    {
    //                                        self.selectedList.remove(at: i)
    //                                        self.selectedPhotosView.reloadData()
    //                                    }
    //                                }
    //                            }
    //                    }
    //                }
    //                else
    //                {
    //                    MBProgressHUD.hide(for: self.view, animated: true)
    //                }
    //            }
    //            task.resume()
    //
    //        }
    //    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
