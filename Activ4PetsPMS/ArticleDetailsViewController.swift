//
//  ArticleDetailsViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 13/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var otherArticlesView: UICollectionView!
    @IBOutlet weak var dogType: UIButton!
    @IBOutlet weak var catType: UIButton!
    @IBOutlet weak var otherType: UIButton!
    @IBOutlet weak var dogView: UIView!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moreArticles: UIButton!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    
    var petType: String = ""
    var model: petCareModel?
    var list: [petCareModel]?
    var showMore: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showMore = false
        self.detailsLabel.text = self.model?.fullDescript?.html2String
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        self.imageView.imageFromServerURL(urlString: (self.model?.imageUrl)!, defaultImage: "petCoverImage-default")
        self.title = "Article Details"
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.showMore = false
        if (self.list?.count)! > 4
        {
            self.moreArticles.isHidden = false
        }
        else
        {
            self.moreArticles.isHidden = true
        }
        if self.petType == "dog"
        {
            dogType.isSelected = true
            catType.isSelected = false
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.white
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.clear
        }
        else if self.petType == "cat"
        {
            dogType.isSelected = false
            catType.isSelected = true
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.white
            otherView.backgroundColor = UIColor.clear
        }
        else if self.petType == "others"
        {
            dogType.isSelected = false
            catType.isSelected = false
            otherType.isSelected = true
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.white
        }
       // var height: CGFloat
//        let lastView = self.scroll.subviews[0].subviews.last!
//        print(lastView.debugDescription) // should be what you expect
//
//        let lastViewYPos = lastView.convert(lastView.frame.origin, to: nil).y  // this is absolute positioning, not relative
//        let lastViewHeight = lastView.frame.size.height
//
//        // sanity check on these
//        print(lastViewYPos)
//        print(lastViewHeight)
//        height = self.otherArticlesView.frame.size.height + self.detailsLabel.frame.size.height
//
//        print("setting scroll height: \(height)")
//
//        scroll.contentSize.height = height + 150
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showMoreArticles(_ sender: UIButton)
    {
        self.showMore = true
        self.heightConstant.constant = 500
        self.otherArticlesView.reloadData()
        self.moreArticles.isHidden = true
    }
    @IBAction func showArticles(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            self.petType = "dog"
        }
        else if sender.tag == 2
        {
            self.petType = "cat"
        }
        else if sender.tag == 3
        {
            self.petType = "others"
        }
        let petCareMain = self.storyboard?.instantiateViewController(withIdentifier: "PetCareMain") as! PetCareArticlesViewController
        petCareMain.comingPetType = petType
        self.navigationController?.pushViewController(petCareMain, animated: true)
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (self.list?.count)! > 4 && self.showMore == false
        {
            return 4
        }
        else if (self.list?.count)! > 4 && self.showMore == true
        {
            return self.list!.count
        }
        
        return self.list!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        
        let model = self.list![indexPath.row]
        cell.albumName.text = model.headTitle?.html2String
        cell.petImage.imageFromServerURL(urlString: (model.imageUrl)!, defaultImage: "petCoverImage-default")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let model = self.list![indexPath.row]
        let petCareMain = self.storyboard?.instantiateViewController(withIdentifier: "PetCareMain") as! PetCareArticlesViewController
        petCareMain.comingPetType = petType
        petCareMain.otherArticleSelected = true
        petCareMain.postId = model.Id!
        self.navigationController?.pushViewController(petCareMain, animated: true)
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
