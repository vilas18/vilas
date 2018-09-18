//
//  SelectPhotosForAlbumViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 01/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

protocol sendDataBack: NSObjectProtocol
{
    func sendData(toAddAlbum array: [[String: String]])
}

class SelectPhotosForAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    var delegate: sendDataBack?
    var galleryList = [Any]()
    var galleryModelList = [PhotoGalleryModel]()
    var noDataLbl: UILabel?
    var selectedPhotos = [[String: String]]()
    var index: Int?
    @IBOutlet var photosView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: " "), style: .done, target: self, action: nil)
        leftItem.title = ""
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem=rightItem
        noDataLbl = UILabel(frame: CGRect(x: 100, y: 90, width: 250, height: 30))
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 1
        noDataLbl?.text="No photos found"
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        self.photosView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    func leftClk(_ sender: Any)
    {
        
        // _ = navigationController?.popViewController(animated: true)
    }
    @objc func submitDetails(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        delegate?.sendData(toAddAlbum: self.selectedPhotos)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        startAuthenticatingUser()
    }
    
    func startAuthenticatingUser() {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.galleryModelList = []
            self.selectedPhotos = []
            self.getList()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func getList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        let urlStr = String(format : "%@?petId=%@",API.PhotoGallery.GalleryList, petId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let queryDic = json?["photoGalleryList"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        for item in queryDic
                        {
                            var prunedDictionary = [String: Any]()
                            for key: String in item.keys
                            {
                                if !(item[key] is NSNull) {
                                    prunedDictionary[key] = item[key]
                                }
                                else {
                                    prunedDictionary[key] = ""
                                }
                            }
                            filtered.append(prunedDictionary)
                        }
                        //  self.vetModelList = [VetModel]()
                        for item in filtered
                        {
                            let Photo = PhotoGalleryModel (galleryId: item["GalleryId"] as! String, photoUrl: item["GalleryPhotoUrl"] as! String, thumbNailUrl: item["ThumbnailPhotoUrl"] as? String, imageName: item["ImageName"] as! String )
                            
                            self.galleryModelList.append(Photo)
                        }
                        
                        self.photosView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            else
            {
                self.noDataLbl?.isHidden = false
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        task.resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        let model = galleryModelList[indexPath.row]
        let petImageUrl = model.photoUrl
        cell.petImage.imageFromServerURL(urlString: petImageUrl, defaultImage: "")
        //        if let url = NSURL(string: petImageUrl)
        //        {
        //            if let data = NSData(contentsOf: url as URL)
        //            {
        //                cell.petImage.image=UIImage(data: data as Data)
        //            }
        //        }
        //
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let model = galleryModelList[indexPath.row]
        let cell: MainGalleryCell = collectionView.cellForItem(at: indexPath) as! MainGalleryCell
        cell.selectPhoto.isSelected = true
        cell.selectPhoto.setImage(UIImage(named: "check.png"), for: .selected)
        //        let arr: [String] = model.ImageName.components(separatedBy: "_")
        var dict: [String: String] = ["Id": model.galleryId, "ImageName": model.ImageName, "Title": model.ImageName, "ImageURL": model.photoUrl]
        self.selectedPhotos.append(dict)
        
        print("Gallery Item index is in PHOTO LIST:\(String(describing: self.selectedPhotos))")
    }
    @objc(collectionView:didDeselectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let model = galleryModelList[indexPath.row]
        let cell: MainGalleryCell = collectionView.cellForItem(at: indexPath) as! MainGalleryCell
        cell.selectPhoto.isSelected = false
        cell.selectPhoto.setImage(UIImage(named: "uncheck.png"), for: .normal)
        for i in 0..<self.selectedPhotos.count
        {
            let dict: [String: String] = self.selectedPhotos[i]
            if dict["Id"] == model.galleryId
            {
                self.selectedPhotos.remove(at: i)
            }
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 150.0, height: 150.0)
        }
        else {
            return CGSize(width: 90.0, height: 90.0)
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
