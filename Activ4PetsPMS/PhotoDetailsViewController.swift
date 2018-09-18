//
//  PhotoDetailsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 01/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    
    var model: PhotoGalleryModel?
    var galleryModelList = [PhotoGalleryModel]()
    var index: Int?
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var photoName: UILabel!
    @IBOutlet var like: UIButton!
    @IBOutlet var share: UIButton!
    @IBOutlet var comment: UIButton!
    @IBOutlet var commentFiled: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let edit = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .done, target: self, action: #selector(self.editPhoto))
        let del = UIBarButtonItem(image: UIImage(named: "trash.png"), style: .done, target: self, action: #selector(self.deletePhoto))
        navigationItem.rightBarButtonItems = [del, edit]
        self.title = "Photo Gallery"
        
        self.photoName.text = model?.ImageName
        let petImageUrl = model?.photoUrl
        if let url = NSURL(string: petImageUrl!)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                self.photoImage.image=UIImage(data: data as Data)
            }
        }
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let modVet: Bool = UserDefaults.standard.bool(forKey: "ModifyMedi")
            if modVet
            {
                
            }
            else
            {
                navigationItem.rightBarButtonItem = nil
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = nil
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func editPhoto(_ sender: Any)
    {
        performSegue(withIdentifier: "editPhoto", sender: model)
    }
    
    @objc func deletePhoto(_ sender: Any)
    {
        let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
            self.callPhotoDelMethod(self.model!)
        })
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true) 
    }
    func callPhotoDelMethod(_ model: PhotoGalleryModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            let urlStr = String(format : "%@?PhotoGalleryId=%@&PetId=%@",API.PhotoGallery.PhotoGalleryDelete, model.galleryId, petId)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let status = json?["Status"] as? Int
                {
                    DispatchQueue.main.async
                        {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if status == 1
                            {
                                let alertDel = UIAlertController(title: nil, message: "Photo has been deleted successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    _ = self.navigationController?.popViewController(animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "editPhoto"
        {
            let photo: AddEditPhotoGalleryViewController = segue.destination as! AddEditPhotoGalleryViewController
            photo.model = sender as! PhotoGalleryModel?
            photo.isFromVC = true
            
        }
    }
    @IBAction func showPhotosScroll(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            var index: Int = self.index!
            if index == 0
            {
                
            }
            else if index > 0
            {
                index = index - 1
                self.index = index
                self.model = self.galleryModelList[index]
                self.photoName.text = model?.ImageName
                let petImageUrl = model?.photoUrl
                if let url = NSURL(string: petImageUrl!)
                {
                    if let data = NSData(contentsOf: url as URL)
                    {
                        self.photoImage.image=UIImage(data: data as Data)
                    }
                }
            }
        }
        else if sender.tag == 2
        {
            var index: Int = self.index!
            if index == self.galleryModelList.count
            {
                
            }
            else if index < self.galleryModelList.count
            {
                index = index + 1
                self.index = index
                if index <  self.galleryModelList.count{
                    self.model = self.galleryModelList[index]
                    self.photoName.text = model?.ImageName
                    let petImageUrl = model?.photoUrl
                    if let url = NSURL(string: petImageUrl!)
                    {
                        if let data = NSData(contentsOf: url as URL)
                        {
                            self.photoImage.image=UIImage(data: data as Data)
                        }
                    }
                }
                
                
            }
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
