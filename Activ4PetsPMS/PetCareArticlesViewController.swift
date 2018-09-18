//
//  PetCareArticlesViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 12/04/18.
//  Copyright © 2018 Activ Doctors Online. All rights reserved.
//

import UIKit
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
class petCareModel: NSObject
{
    var Id: String?
    var headTitle: String?
    var shortDescript: String?
    var fullDescript: String?
    var imageName: String?
    var imageUrl: String?
    var catgeId: String?
    var catgeName: String?
    var petType: String?
    var createDate: String?
    init?(Id: String?,headTitle: String?, shortDescript: String?,fullDescript: String?,imageName: String?,imageUrl: String?,catgeId: String?,catgeName: String?,petType: String?,createDate: String?)
    {
        self.Id = Id
        self.headTitle = headTitle
        self.shortDescript = shortDescript
        self.fullDescript = fullDescript
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.catgeId = catgeId
        self.catgeName = catgeName
        self.petType = petType
        self.createDate = createDate
    }
}
class PetCareArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var dogType: UIButton!
    @IBOutlet weak var catType: UIButton!
    @IBOutlet weak var otherType: UIButton!
    @IBOutlet weak var dogView: UIView!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherArticlesView: UICollectionView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var shortDescript: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var readFull: UIButton!
    @IBOutlet weak var explore: UILabel!
    @IBOutlet weak var moreArticles: UIButton!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var searchArticle: UISearchBar!
    @IBOutlet weak var searchListTbl: UITableView!
     @IBOutlet weak var searchPopUpView: UIView!
    
    var searchList:[petCareModel] = []
    var otherArticleSelected: Bool = false
    var noDataLbl: UILabel?
    var showMore: Bool = false
    var postId : String = ""
    var petType: String = ""
    var comingPetType: String = ""
    var firstArticleModel: petCareModel?
    var otherArticleList:[petCareModel] = []
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.petType = "dog"
        self.searchPopUpView.isHidden = true
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        self.title = "Pet Care"
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: 250, height: 60))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont.systemFont(ofSize: 15.0)
        noDataLbl?.numberOfLines = 3
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.text =  "No blogs found"
        
        view.addSubview(noDataLbl!)
        
        noDataLbl?.isHidden = true
        noDataLbl?.center = self.view.center
        // Do any additional setup after loading the view.
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        if self.comingPetType == "dog"
        {
            self.petType = comingPetType
            dogType.isSelected = true
            catType.isSelected = false
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.white
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.clear
        }
        else if self.comingPetType == "cat"
        {
            self.petType = comingPetType
            dogType.isSelected = false
            catType.isSelected = true
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.white
            otherView.backgroundColor = UIColor.clear
        }
        else if self.comingPetType == "others"
        {
            self.petType = comingPetType
            dogType.isSelected = false
            catType.isSelected = false
            otherType.isSelected = true
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.white
        }
        
        checkInternetConnection()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.searchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! CommonTableViewCell
        let model = self.searchList[indexPath.row]
        cell.firstLabel.text = model.headTitle
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = self.searchList[indexPath.row]
        print(model.headTitle!)
        self.searchPopUpView.isHidden = true
        self.otherArticleSelected = true
        self.postId = model.Id!
        self.searchArticle.text = nil
        self.checkInternetConnection()
    }
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork()
        {
            print("Internet connection")
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = "Loading"
            self.otherArticleList = []
            self.firstArticleModel = nil
            self.webServiceToGetPetArticlesList()
        }
        else
        {
            print("No internet connection")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func webServiceToGetPetArticlesList()
    {
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        var urlStr: String = ""
        if self.otherArticleSelected
        {
            urlStr = String(format : "%@?petType=%@&postId=%@", API.PetCare.petArticles, self.petType, self.postId)
        }
        else{
            urlStr = String(format : "%@?petType=%@", API.PetCare.petArticles, self.petType)
        }
        
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
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
                        if status == 1
                        {
                            self.noDataLbl?.isHidden = true
                            self.headImage.isHidden = false
                            self.headTitle.isHidden = false
                            self.shortDescript.isHidden = false
                            self.readFull.isHidden = false
                            self.explore.isHidden = false
                            
                            if !(json?["FirstArticle"]  is NSNull)
                            {
                                let dict:[String:String] = (json?["FirstArticle"] as? [String:String])!
                                let model = petCareModel(Id: dict["Id"],headTitle: dict["HeadingTitle"], shortDescript: dict["ShortDescription"],fullDescript: dict["Description"],imageName: dict["ImageName"],imageUrl: dict["ImageURL"], catgeId: dict["CategoryId"], catgeName: dict["CategoryName"], petType: dict["PetType"],createDate: dict["CreationDate"])
                                self.firstArticleModel = model
                                self.headTitle.text = self.firstArticleModel?.headTitle?.html2String
                                self.shortDescript.text = self.firstArticleModel?.shortDescript?.html2String
                                self.headImage.imageFromServerURL(urlString: (self.firstArticleModel?.imageUrl)!, defaultImage: "petCoverImage-default")
                                
                            }
                            let list:[[String:String]] = (json?["OtherArticles"] as? [[String:String]])!
                            if list.count > 0
                            {
                                for dict in list
                                {
                                    
                                    let model = petCareModel(Id: dict["Id"],headTitle: dict["HeadingTitle"], shortDescript: dict["ShortDescription"],fullDescript: dict["Description"],imageName: dict["ImageName"],imageUrl: dict["ImageURL"], catgeId: dict["CategoryId"], catgeName: dict["CategoryName"], petType: dict["PetType"],createDate: dict["CreationDate"])
                                    self.otherArticleList.append(model!)
                                    
                                }
                                if self.otherArticleList.count > 4
                                {
                                    self.moreArticles.isHidden = false
                                    self.heightConstant.constant = 333
                                }
                                else if self.otherArticleList.count <= 4
                                {
                                    self.moreArticles.isHidden = true
                                    self.heightConstant.constant = 333
                                }
                                
                                self.otherArticlesView.reloadData()
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        else
                        {
                            self.otherArticlesView.reloadData()
                            self.headImage.isHidden = true
                            self.headTitle.isHidden = true
                            self.shortDescript.isHidden = true
                            self.readFull.isHidden = true
                            self.explore.isHidden = true
                            self.noDataLbl?.isHidden = false
                            self.moreArticles.isHidden = true
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
         searchBar.resignFirstResponder()
        searchList = []
        for srchArt: petCareModel in self.otherArticleList
        {
            
            let tmp1: NSString = srchArt.headTitle! as NSString
            let range = tmp1.range(of: searchBar.text!, options: NSString.CompareOptions.caseInsensitive)
            
            if range.location != NSNotFound
            {
                self.searchList.append(srchArt)
            }
            if self.searchList.count > 0
            {
                self.searchPopUpView.isHidden = false
                searchListTbl.reloadData()
            }
            else
            {
                self.searchPopUpView.isHidden = false
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String)
    {
        if (text.count ) == 0
        {
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        else
        {
            searchList = []
            if text.count > 5
            {
                searchBar.resignFirstResponder()
            }
            for srchArt: petCareModel in self.otherArticleList
            {
                
                let tmp1: NSString = srchArt.headTitle! as NSString
                let range = tmp1.range(of: text, options: NSString.CompareOptions.caseInsensitive)
                
                if range.location != NSNotFound
                {
                    self.searchList.append(srchArt)
                }
            }
            if self.searchList.count > 0
            {
                self.searchPopUpView.isHidden = false
                searchListTbl.reloadData()
            }
            else
            {
                self.searchPopUpView.isHidden = false
            }
        }
        
    }
    @IBAction func closeSearchTable(_ sender: UIButton)
    {
        self.searchPopUpView.isHidden = true
        self.searchArticle.text = nil
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.otherArticleList.count > 4 && self.showMore == false
        {
            return 4
        }
        else if self.otherArticleList.count > 4 && self.showMore == true
        {
            return self.otherArticleList.count
        }
        
        return self.otherArticleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: MainGalleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainGalleryCell", for: indexPath) as! MainGalleryCell
        let model = self.otherArticleList[indexPath.row]
        cell.albumName.text = model.headTitle?.html2String
        cell.petImage.imageFromServerURL(urlString: (model.imageUrl)!, defaultImage: "petCoverImage-default")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let model = self.otherArticleList[indexPath.row]
        self.otherArticleSelected = true
        self.postId = model.Id!
        self.checkInternetConnection()
        
    }
    
    override func didReceiveMemoryWarning()
    {
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
            self.showMore = false
            self.otherArticleSelected = false
            dogType.isSelected = true
            catType.isSelected = false
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.white
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.clear
        }
        else if sender.tag == 2
        {
            self.petType = "cat"
            self.showMore = false
            self.otherArticleSelected = false
            dogType.isSelected = false
            catType.isSelected = true
            otherType.isSelected = false
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.white
            otherView.backgroundColor = UIColor.clear
        }
        else if sender.tag == 3
        {
            self.petType = "others"
            self.showMore = false
            self.otherArticleSelected = false
            dogType.isSelected = false
            catType.isSelected = false
            otherType.isSelected = true
            dogView.backgroundColor = UIColor.clear
            catView.backgroundColor = UIColor.clear
            otherView.backgroundColor = UIColor.white
        }
        self.checkInternetConnection()
    }
    @IBAction func readFullArticle(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "details", sender: self.firstArticleModel)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "details"
        {
            let fullArticle = segue.destination as! ArticleDetailsViewController
            fullArticle.model = sender as? petCareModel
            fullArticle.list = self.otherArticleList
            fullArticle.petType = self.petType
        }
        else
        {
            
        }
        
        
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
