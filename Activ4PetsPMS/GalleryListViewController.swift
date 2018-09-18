//
//  GalleryListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 31/07/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class PhotoGalleryModel: NSObject
{
    var galleryId: String
    var photoUrl: String
    var thumbNailUrl: String?
    var ImageName: String
    
    init(galleryId: String, photoUrl: String, thumbNailUrl: String?, imageName: String)
    {
        self.galleryId = galleryId
        self.photoUrl = photoUrl
        self.thumbNailUrl = thumbNailUrl
        self.ImageName = imageName
    }
    
}

class GalleryListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    var galleryList = [Any]()
    var galleryModelList = [PhotoGalleryModel]()
    var noDataLbl: UILabel?
    var index: Int?
    @IBOutlet var photosView: UICollectionView!
    @IBOutlet var photosAlbum: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addPhoto))
        
        noDataLbl = UILabel(frame: CGRect(x: 100, y: 90, width: 250, height: 50))
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 2
        noDataLbl?.textAlignment = .center
        noDataLbl?.lineBreakMode = .byTruncatingTail
        view.addSubview(noDataLbl!)
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        let str : String = UserDefaults.standard.string(forKey: "SMO")!
        if str == "1"
        {
            navigationItem.rightBarButtonItem = rightItem1!
            noDataLbl?.text =  "No records found"
        }
        else{
            navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
            noDataLbl?.text =  "No photos found.\n Tap on '+' to add a Photo"
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func showPhotosAlbumList(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            print("self")
        }
        else
        {
            let Album: AlbumListViewController = storyboard?.instantiateViewController(withIdentifier: "albumList") as! AlbumListViewController
            self.navigationController?.pushViewController(Album, animated: true)
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @objc func addPhoto(_ sender: Any)
    {
        let addContact: AddEditPhotoGalleryViewController? = storyboard?.instantiateViewController(withIdentifier: "addEditPhoto") as! AddEditPhotoGalleryViewController?
        addContact?.isFromVC = false
        navigationController?.pushViewController(addContact!, animated: true)
    }
    
    @objc func showMenu(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.photosAlbum.selectedSegmentIndex = 0
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let modVet: Bool = UserDefaults.standard.bool(forKey: "ModifyGall")
            if modVet
            {
                
            }
            else
            {
                let rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
                navigationItem.rightBarButtonItem = rightItem1
            }
        }
        startAuthenticatingUser()
    }
    
    func startAuthenticatingUser() {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            self.galleryModelList = []
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
        let urlStr = String(format : "%@?petId=%@", API.PhotoGallery.GalleryList, petId)
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
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            self.photosView.reloadData()
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
                            self.noDataLbl?.isHidden = true
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
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
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.index = Int(indexPath.row)
        let model = galleryModelList[index!]
        self.performSegue(withIdentifier: "photoDetails", sender: model)
        print("Gallery Item index is in PHOTO LIST:\(String(describing: self.index))")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "photoDetails"
        {
            let photo: PhotoDetailsViewController = segue.destination as! PhotoDetailsViewController
            photo.galleryModelList = self.galleryModelList
            photo.model = sender as! PhotoGalleryModel?
            photo.index = self.index
            
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
