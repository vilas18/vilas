//
//  AlbumDetailsViewController.swift
//  Active4PetsPMS
//
//  Created by Activ Doctors Online on 01/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var model: AlbumGalleryModel?
    var isFromVC: Bool = false
    
    @IBOutlet var albumsView: UICollectionView!
    var galleryId: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var leftItem: UIBarButtonItem?
        self.title = self.model?.albumTitle
        leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    func editAlbum(_ sender: Any)
    {
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.model?.photosList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        let dict: [String: String] = (self.model?.photosList[indexPath.row])!
        cell.selectPhoto.isHidden = true
        cell.selectPhoto.tag = Int(dict["GalleryId"]!)!
        let petImageUrl = dict["ImageURL"]
        cell.petImage.imageFromServerURL(urlString: petImageUrl!, defaultImage: "")
        //        if let url = NSURL(string: petImageUrl!)
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
        let cell: MainGalleryCell = collectionView.cellForItem(at: indexPath) as! MainGalleryCell
        cell.selectPhoto.isHidden = true
        self.galleryId = cell.selectPhoto.tag
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell: MainGalleryCell = collectionView.cellForItem(at: indexPath) as! MainGalleryCell
        cell.selectPhoto.isHidden = true
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
