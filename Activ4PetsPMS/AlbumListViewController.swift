//
//  AlbumListViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 01/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
class AlbumGalleryModel: NSObject
{
    var albumId: String
    var petId: String
    var albumTitle: String
    var coverImageUrl: String
    var creationDate: String
    var photosCount: String
    var photosList: [[String: String]]
    
    
    init(albumId: String, petId: String, albumTitle: String, coverImageUrl: String, creationDate: String, photosCount: String, photosList: [[String: String]])
    {
        self.albumId = albumId
        self.petId = petId
        self.albumTitle = albumTitle
        self.coverImageUrl = coverImageUrl
        self.creationDate = creationDate
        self.photosCount = photosCount
        self.photosList = photosList
    }
}

class AlbumListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    var galleryList = [Any]()
    var albumModelList = [AlbumGalleryModel]()
    var noDataLbl: UILabel?
    @IBOutlet var albumsView: UICollectionView!
    @IBOutlet var photosAlbum: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        var rightItem1: UIBarButtonItem?
        var rightItem2: UIBarButtonItem?
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        rightItem1 = UIBarButtonItem(image: UIImage(named: "ic_menu.png"), style: .done, target: self, action: #selector(self.showMenu))
        rightItem2 = UIBarButtonItem(image: UIImage(named: "plus"), style: .done, target: self, action: #selector(self.addAlbum))
        
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
            noDataLbl?.text =  "No photos found"
        }
        else
        {
            navigationItem.rightBarButtonItems = [rightItem1!, rightItem2!]
            noDataLbl?.text =  "No albums found.\n Tap on '+' to add an Album"
        }
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func showPhotosAlbumList(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
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
            print("self")
        }
    }
    
    
    
    @objc func addAlbum(_ sender: Any)
    {
        let newAlbum: AddNewAlbumViewController? = self.storyboard?.instantiateViewController(withIdentifier: "addAlbum") as! AddNewAlbumViewController?
        _ = self.navigationController?.pushViewController(newAlbum!, animated: true)
    }
    
    @objc func showMenu(_ sender: Any)
    {
        let menu:  MenuPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MenuPage") as! MenuPageViewController
        self.navigationController?.pushViewController(menu, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.photosAlbum.selectedSegmentIndex = 1
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
            self.albumModelList = []
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
        let urlStr = String(format : "%@?petId=%@", API.AlbumGallery.AlbumList, petId)
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
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
                let queryDic = json?["AlbumGallerylst"] as? [[String : Any]]
            {
                var filtered = [[String : Any]]()
                DispatchQueue.main.async
                    {
                        if queryDic.count == 0
                        {
                            self.noDataLbl?.isHidden = false
                            self.albumsView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                        else
                        {
                            for item in queryDic
                            {
                                var prunedDictionary = [String: Any]()
                                for key: String in item.keys
                                {
                                    if !(item[key] is NSNull)
                                    {
                                        prunedDictionary[key] = item[key]
                                    }
                                    else
                                    {
                                        prunedDictionary[key] = ""
                                    }
                                }
                                filtered.append(prunedDictionary)
                            }
                            //  self.vetModelList = [VetModel]()
                            
                            for item in filtered
                            {
                                var filtered1 = [[String : String]]()
                                let list:[[String : Any]] = item["lstPhoto"] as! [[String : Any]]
                                print(list)
                                for item1 in list
                                {
                                    var prunedDictionary = [String: String]()
                                    for key: String in item1.keys
                                    {
                                        if !(item1[key] is NSNull) {
                                            prunedDictionary[key] = item1[key] as? String
                                        }
                                        else {
                                            prunedDictionary[key] = ""
                                        }
                                    }
                                    filtered1.append(prunedDictionary)
                                }
                                let Album = AlbumGalleryModel (albumId: item["AlbumId"] as! String, petId: item["PetId"] as! String, albumTitle: item["Title"] as!  String, coverImageUrl: item["DefaultImageURL"] as! String, creationDate: item["CreationDate"] as! String, photosCount: item["PhotoCount"] as! String, photosList: filtered1 )
                                
                                self.albumModelList.append(Album)
                            }
                            
                            self.albumsView.reloadData()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        let model = albumModelList[indexPath.row]
        cell.albumName.text = model.albumTitle
        cell.photoCount.text = model.photosCount
        print(model.photosCount)
        print(model.photosList)
        var petImageUrl = model.coverImageUrl
        if petImageUrl == ""
        {
            petImageUrl = model.photosList[0]["ImageURL"]!
            cell.petImage.imageFromServerURL(urlString: petImageUrl, defaultImage: "")
        }
        else
        {
            cell.petImage.imageFromServerURL(urlString: petImageUrl, defaultImage: "")
        }
        
        //        if let url = NSURL(string: petImageUrl)
        //        {
        //            if let data = NSData(contentsOf: url as URL)
        //            {
        //                cell.petImage.image=UIImage(data: data as Data)
        //            }
        //            else
        //            {
        //                let petImageUrl = model.photosList[0]["ImageURL"]
        //
        //                if let url = NSURL(string: petImageUrl!)
        //                {
        //                    if let data = NSData(contentsOf: url as URL)
        //                    {
        //                        cell.petImage.image=UIImage(data: data as Data)
        //                    }
        //                }
        //            }
        //        }
        //        else
        //        {
        //            let petImageUrl = model.photosList[0]["ImageURL"]
        //
        //            if let url = NSURL(string: petImageUrl!)
        //            {
        //                if let data = NSData(contentsOf: url as URL)
        //                {
        //                    cell.petImage.image=UIImage(data: data as Data)
        //                }
        //            }
        //        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let galleryItemIndex: Int = Int(indexPath.row)
        let model = albumModelList[galleryItemIndex]
        print("Gallery Item index is in PHOTO LIST:\(galleryItemIndex)")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shared = UIAlertAction(title: "View Details", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "albumDetails", sender: model)
        })
        let medical = UIAlertAction(title: "Edit Photos", style: .default, handler: {(action: UIAlertAction) -> Void in
            let editAlbum: AddNewAlbumViewController? = self.storyboard?.instantiateViewController(withIdentifier: "addAlbum") as! AddNewAlbumViewController?
            editAlbum?.isFromVC = true
            editAlbum?.model = model
            _ = self.navigationController?.pushViewController(editAlbum!, animated: true)
            
        })
        let delete = UIAlertAction(title: "Remove", style: .default, handler: {(action: UIAlertAction) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are you sure, You want to delete the album ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Deleting.."
                self.callAlbumDelMethod(model)
            })
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true) 
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(shared)
        
        let sharedPet: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if sharedPet
        {
            let modGall: Bool = UserDefaults.standard.bool(forKey: "ModifyGall")
            if modGall
            {
                alert.addAction(medical)
                alert.addAction(delete)
            }
            else
            {
                
            }
        }
        else
        {
            let str : String = UserDefaults.standard.string(forKey: "SMO")!
            if str == "1"
            {
                
            }
            else
            {
                alert.addAction(medical)
                alert.addAction(delete)
            }
        }
        
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
    }
    func callAlbumDelMethod(_ model: AlbumGalleryModel)
    {
        if CheckNetwork.isExistenceNetwork()
        {
            let headers: [AnyHashable: Any] = ["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=", "cache-control": "no-cache"]
            let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
            let urlStr = String(format : "%@?AlbumId=%@",API.AlbumGallery.AlbumDelete, model.albumId)
            var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            request.allHTTPHeaderFields = headers as? [String : String] ?? [String : String]()
            let session = URLSession.shared
            let task = session.dataTask(with: request)
            {
                (data, response, error) in
                guard let data = data, error == nil else
                {                                                 // check for fundamental networking error
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
                                let alertDel = UIAlertController(title: nil, message: "Album has been deleted successfully", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    self.startAuthenticatingUser()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return CGSize(width: 150.0, height: 150.0)
        }
        else
        {
            return CGSize(width: 90.0, height: 90.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "albumDetails"
        {
            let photo: AlbumDetailsViewController = segue.destination as! AlbumDetailsViewController
            photo.isFromVC = false
            photo.model = sender as! AlbumGalleryModel?
            super.didReceiveMemoryWarning()
        }
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
