//
//  AddEditPetViewController.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 18/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit

class AddEditPetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var petInfo: MyPetsModel?
    
    var base64Data: Data?
    var patientID: String = ""
    var dataString: String = ""
    var base64PetImgString: String = ""
    var base64DefaultPetImgString: String = ""
    var base64CoverImgString: String = ""
    var base64DefaultCoverImgString: String = ""
    var stateID: String = ""
    var stateCountryID: String = ""
    var countryID: String = ""
    var colorID: String = ""
    var genderID: String = ""
    var bloodTypeID: String = ""
    var hairTypeID: String = ""
    var petTypeID: String = ""
    var sterileID: String = ""
    var secondaryColorID: String = ""
    var imgPkrCon: UIImagePickerController?
    var urlStr: String = ""
    var isFromVC = false
    var petId : String = ""
    var isFromMedical: Bool = false
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var coverImgVW: UIImageView!
    @IBOutlet weak var petImgVW: UIImageView!
    
    @IBOutlet weak var coverImgBtn: UIButton!
    @IBOutlet weak var petImgBtn: UIButton!
    
    @IBOutlet weak var petNameTxtF: UITextField!
    @IBOutlet weak var petTypeTxtF: UITextField!
    @IBOutlet weak var otherPetTypeTxtF: UITextField!
    @IBOutlet weak var petGenderTxtF: UITextField!
    @IBOutlet weak var petBloodTypeTxtF: UITextField!
    @IBOutlet weak var customBreedTxtF: UITextField!
    @IBOutlet weak var pedigreeTxtF: UITextField!
    @IBOutlet weak var chipNumberTxtF: UITextField!
    @IBOutlet weak var tatooNumTxtF: UITextField!
    @IBOutlet weak var dateOfBirthTxtF: UITextField!
    @IBOutlet weak var placeOfBirthTxtF: UITextField!
    @IBOutlet weak var stateTxtF: UITextField!
    @IBOutlet weak var countryTxtF: UITextField!
    @IBOutlet weak var zipCodeTxtF: UITextField!
    @IBOutlet weak var hairTypeTxtF: UITextField!
    @IBOutlet weak var otherHairTypeTxtF: UITextField!
    @IBOutlet weak var colorTxtF: UITextField!
    @IBOutlet weak var otherColorTypeTxtF: UITextField!
    @IBOutlet weak var secondaryColorTxtF: UITextField!
    @IBOutlet weak var otherSecondaryColorTypeTxtF: UITextField!
    @IBOutlet weak var adoptionDateTxtF: UITextField!
    @IBOutlet weak var secondaryBreedTxtF: UITextField!
    @IBOutlet weak var sterileTxtF: UITextField!
    var datePicker = UIDatePicker()
    
    
    @IBOutlet weak var mandatoryLbl: UILabel!
    @IBOutlet weak var coverImgHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgTopSpace: NSLayoutConstraint!
    @IBOutlet weak var profileImgWidth: NSLayoutConstraint!
    @IBOutlet weak var profileImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pasadenaView: UIView!
    @IBOutlet weak var tagNo: UITextField!
    @IBOutlet weak var tagType: UITextField!
    @IBOutlet weak var tagExp: UITextField!
    
    
    var listArr = [Any]()
    var langString: String = ""
    var dropDownString: String = ""
    var userDefaults: UserDefaults?
    var isRecordPetImage: Bool = false
    var isRecordCoverImage: Bool = false
    var isPetImageFlag: Bool = false
    var isPetCoverFlag: Bool = false
    var isSecondFlag: Bool = false
    
    @IBOutlet weak var mandatTopSpace: NSLayoutConstraint!
    var dropDownTbl: UIPickerView!
    var selectedTextFld: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.backImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "done_Share.png"), style: .done, target: self, action: #selector(self.rightClk))
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.hidesBackButton = true
        self.dropDownTbl = UIPickerView.init(frame: CGRect(x:0, y:0, width: 0, height: 220))
        dateOfBirthTxtF.isUserInteractionEnabled = true
        adoptionDateTxtF.isUserInteractionEnabled = true
        dropDownTbl.delegate = self
        dropDownTbl.dataSource = self
        
        navigationController?.navigationBar.isTranslucent = false
        let tapG = UITapGestureRecognizer(target: self, action: #selector(self.viewTouched))
        tapG.numberOfTapsRequired = 1
        tapG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapG)
        mandatoryLbl.isHidden = true
        let preferredLang: String = NSLocale.preferredLanguages[0]
        
        if (preferredLang == "en") {
            //English
            countryTxtF.text = "United States"
            self.countryID = "3"
        }
        else if (preferredLang == "fr") {
            //French
            countryTxtF.text = "ETATS-UNIS"
        }
        countryTxtF.text = "United States"
        self.countryID = "3"
        print(self.countryID)
        
        let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
        if centerId as? Int == 67
        {
            self.pasadenaView.isHidden = false
            self.mandatTopSpace.constant = 158
        }
        else{
            self.pasadenaView.isHidden = true
            self.mandatTopSpace.constant = 25
        }
        
        self.imgPkrCon = UIImagePickerController()
        self.imgPkrCon?.delegate = self
        self.imgPkrCon?.allowsEditing = true
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        self.tagExp.isUserInteractionEnabled = true
        petTypeTxtF.isUserInteractionEnabled = true
        petGenderTxtF.isUserInteractionEnabled = true
        petBloodTypeTxtF.isUserInteractionEnabled = true
        dateOfBirthTxtF.isUserInteractionEnabled = true
        hairTypeTxtF.isUserInteractionEnabled = true
        colorTxtF.isUserInteractionEnabled = true
        secondaryColorTxtF.isUserInteractionEnabled = true
        countryTxtF.isUserInteractionEnabled = true
        stateTxtF.isUserInteractionEnabled = true
        sterileTxtF.isUserInteractionEnabled = true
        adoptionDateTxtF.isUserInteractionEnabled = true
        otherHairTypeTxtF.isUserInteractionEnabled = false
        otherHairTypeTxtF.alpha = 0.5
        otherColorTypeTxtF.isUserInteractionEnabled = false
        otherColorTypeTxtF.alpha = 0.5
        otherSecondaryColorTypeTxtF.isUserInteractionEnabled = false
        otherSecondaryColorTypeTxtF.alpha = 0.5
        otherPetTypeTxtF.isUserInteractionEnabled = false
        otherPetTypeTxtF.alpha = 0.5
        
        petNameTxtF.layer.masksToBounds = true
        petNameTxtF.layer.borderWidth = 2
        petNameTxtF.layer.cornerRadius = 3.0
        petNameTxtF.layer.borderColor = UIColor.clear.cgColor
        
        petTypeTxtF.layer.masksToBounds = true
        petTypeTxtF.layer.borderWidth = 2
        petTypeTxtF.layer.cornerRadius = 3.0
        petTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        otherPetTypeTxtF.layer.masksToBounds = true
        otherPetTypeTxtF.layer.borderWidth = 2
        otherPetTypeTxtF.layer.cornerRadius = 3.0
        otherPetTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        petBloodTypeTxtF.layer.masksToBounds = true
        petBloodTypeTxtF.layer.borderWidth = 2
        petBloodTypeTxtF.layer.cornerRadius = 3.0
        petBloodTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        customBreedTxtF.layer.masksToBounds = true
        customBreedTxtF.layer.borderWidth = 2
        customBreedTxtF.layer.cornerRadius = 3.0
        customBreedTxtF.layer.borderColor = UIColor.clear.cgColor
        
        pedigreeTxtF.layer.masksToBounds = true
        pedigreeTxtF.layer.borderWidth = 2
        pedigreeTxtF.layer.cornerRadius = 3.0
        pedigreeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        chipNumberTxtF.layer.masksToBounds = true
        chipNumberTxtF.layer.borderWidth = 2
        chipNumberTxtF.layer.cornerRadius = 3.0
        chipNumberTxtF.layer.borderColor = UIColor.clear.cgColor
        
        tatooNumTxtF.layer.masksToBounds = true
        tatooNumTxtF.layer.borderWidth = 2
        tatooNumTxtF.layer.cornerRadius = 3.0
        tatooNumTxtF.layer.borderColor = UIColor.clear.cgColor
        
        dateOfBirthTxtF.layer.masksToBounds = true
        dateOfBirthTxtF.layer.borderWidth = 2
        dateOfBirthTxtF.layer.cornerRadius = 3.0
        dateOfBirthTxtF.layer.borderColor = UIColor.clear.cgColor
        
        placeOfBirthTxtF.layer.masksToBounds = true
        placeOfBirthTxtF.layer.borderWidth = 2
        placeOfBirthTxtF.layer.cornerRadius = 3.0
        placeOfBirthTxtF.layer.borderColor = UIColor.clear.cgColor
        
        stateTxtF.layer.masksToBounds = true
        stateTxtF.layer.borderWidth = 2
        stateTxtF.layer.cornerRadius = 3.0
        stateTxtF.layer.borderColor = UIColor.clear.cgColor
        
        countryTxtF.layer.masksToBounds = true
        countryTxtF.layer.borderWidth = 2
        countryTxtF.layer.cornerRadius = 3.0
        countryTxtF.layer.borderColor = UIColor.clear.cgColor
        
        zipCodeTxtF.layer.masksToBounds = true
        zipCodeTxtF.layer.borderWidth = 2
        zipCodeTxtF.layer.cornerRadius = 3.0
        zipCodeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        hairTypeTxtF.layer.masksToBounds = true
        hairTypeTxtF.layer.borderWidth = 2
        hairTypeTxtF.layer.cornerRadius = 3.0
        hairTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        secondaryBreedTxtF.layer.masksToBounds = true
        secondaryBreedTxtF.layer.borderWidth = 2
        secondaryBreedTxtF.layer.cornerRadius = 3.0
        secondaryBreedTxtF.layer.borderColor = UIColor.clear.cgColor
        
        colorTxtF.layer.masksToBounds = true
        colorTxtF.layer.borderWidth = 2
        colorTxtF.layer.cornerRadius = 3.0
        colorTxtF.layer.borderColor = UIColor.clear.cgColor
        
        secondaryColorTxtF.layer.masksToBounds = true
        secondaryColorTxtF.layer.borderWidth = 2
        secondaryColorTxtF.layer.cornerRadius = 3.0
        secondaryColorTxtF.layer.borderColor = UIColor.clear.cgColor
        
        adoptionDateTxtF.layer.masksToBounds = true
        adoptionDateTxtF.layer.borderWidth = 2
        adoptionDateTxtF.layer.cornerRadius = 3.0
        adoptionDateTxtF.layer.borderColor = UIColor.clear.cgColor
        
        otherHairTypeTxtF.layer.masksToBounds = true
        otherHairTypeTxtF.layer.borderWidth = 2
        otherHairTypeTxtF.layer.cornerRadius = 3.0
        otherHairTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        otherColorTypeTxtF.layer.masksToBounds = true
        otherColorTypeTxtF.layer.borderWidth = 2
        otherColorTypeTxtF.layer.cornerRadius = 3.0
        otherColorTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        otherSecondaryColorTypeTxtF.layer.masksToBounds = true
        otherSecondaryColorTypeTxtF.layer.borderWidth = 2
        otherSecondaryColorTypeTxtF.layer.cornerRadius = 3.0
        otherSecondaryColorTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        
        sterileTxtF.layer.masksToBounds = true
        sterileTxtF.layer.borderWidth = 2
        sterileTxtF.layer.cornerRadius = 3.0
        sterileTxtF.layer.borderColor = UIColor.clear.cgColor
        
        petImgVW.layer.masksToBounds = true
        petImgVW.clipsToBounds = true
        petImgVW.layer.cornerRadius = 30.0
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            coverImgHeight.constant = 200.0
            profileImgTopSpace.constant = 72.0
            profileImgWidth.constant = 130.0
            profileImgHeight.constant = 130.0
            petImgVW.layer.cornerRadius = 65.0
        }
        else if UIDevice.current.userInterfaceIdiom == .phone
        {
            coverImgHeight.constant = 80.0
            profileImgWidth.constant = 60.0
            profileImgHeight.constant = 60.0
            petImgVW.layer.cornerRadius = 30.0
        }
        self.title = "Add Pet"
        if self.isFromVC == true
        {
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            self.title = "Edit Pet"
            countryID = (petInfo?.countryId)!
            print(countryID)
            stateID = (petInfo?.stateId)!
            genderID = (petInfo?.genderId)!.stringValue
            colorID = (petInfo?.colorId)!
            hairTypeID = (petInfo?.hairTypeId)!
            secondaryColorID = (petInfo?.secColorId)!
            bloodTypeID = (petInfo?.bloodTypeId)!
            print(bloodTypeID)
            petNameTxtF.text = petInfo?.petName
            if self.petInfo?.petType == "Other"
            {
                petTypeTxtF.text = (petInfo?.petType)!
                self.otherPetTypeTxtF.text = (petInfo?.customPetType)!
                self.petTypeID = (petInfo?.petTypeId)!.stringValue
                otherPetTypeTxtF.alpha = 1.0
                otherPetTypeTxtF.isUserInteractionEnabled = true
            }
            else
            {
                petTypeTxtF.text = petInfo?.petType
                self.petTypeID = (petInfo?.petTypeId)!.stringValue
                otherPetTypeTxtF.alpha = 0.5
                otherPetTypeTxtF.isUserInteractionEnabled = false
            }
            if self.petInfo?.hairType == "Other"
            {
                hairTypeTxtF.text = (petInfo?.hairType)!
                self.otherHairTypeTxtF.text = (petInfo?.otherHairType)!
                self.hairTypeID = (petInfo?.hairTypeId)!
                otherHairTypeTxtF.alpha = 1.0
                otherHairTypeTxtF.isUserInteractionEnabled = true
                print(hairTypeTxtF.text)
                print(otherHairTypeTxtF.text)
            }
            else
            {
                hairTypeTxtF.text = (petInfo?.hairType)!
                self.hairTypeID = (petInfo?.hairTypeId)!
                otherHairTypeTxtF.alpha = 0.5
                otherHairTypeTxtF.isUserInteractionEnabled = false
            }
            if self.petInfo?.color == "Other"
            {
                colorTxtF.text = (petInfo?.color)!
                self.otherColorTypeTxtF.text = (petInfo?.otherColorType)!
                self.colorID = (petInfo?.colorId)!
                otherColorTypeTxtF.alpha = 1.0
                otherColorTypeTxtF.isUserInteractionEnabled = true
            }
            else
            {
                colorTxtF.text = (petInfo?.color)!
                self.colorID = (petInfo?.colorId)!
                otherColorTypeTxtF.alpha = 0.5
                otherColorTypeTxtF.isUserInteractionEnabled = false
            }
            if self.petInfo?.secColor == "Other"
            {
                secondaryColorTxtF.text = (petInfo?.secColor)!
                self.otherSecondaryColorTypeTxtF.text = (petInfo?.otherSecColorType)!
                self.secondaryColorID = (petInfo?.secColorId)!
                otherSecondaryColorTypeTxtF.alpha = 1.0
                otherSecondaryColorTypeTxtF.isUserInteractionEnabled = true
            }
            else
            {
                secondaryColorTxtF.text = (petInfo?.secColor)!
                self.secondaryColorID = (petInfo?.secColorId)!
                otherSecondaryColorTypeTxtF.alpha = 0.5
                otherSecondaryColorTypeTxtF.isUserInteractionEnabled = false
            }
            petGenderTxtF.text = petInfo?.gender
            petBloodTypeTxtF.text = petInfo?.bloodType
            customBreedTxtF.text = petInfo?.breed
            secondaryBreedTxtF.text = petInfo?.secBreed
            pedigreeTxtF.text = petInfo?.pedigree
            chipNumberTxtF.text = petInfo?.chipNo
            tatooNumTxtF.text = petInfo?.tattooNo
            dateOfBirthTxtF.text = petInfo?.dob
            placeOfBirthTxtF.text = petInfo?.pob
            stateTxtF.text = petInfo?.state
            countryTxtF.text = petInfo?.country
            zipCodeTxtF.text = petInfo?.zip
            adoptionDateTxtF.text = petInfo?.adoptDate
            if petInfo?.sterile == "Yes"
            {
                self.sterileTxtF.text = "Yes"
            }
            else if petInfo?.sterile == "No"
            {
                self.sterileTxtF.text = "No"
            }
            else
            {
                self.sterileTxtF.text = "Unknown"
            }
            self.tagNo.text = self.petInfo?.tagNo
            self.tagType.text = self.petInfo?.tagType
            if self.petInfo?.tagExp != nil && self.petInfo?.tagExp != ""
            {
                let strList: [String] = (self.petInfo?.tagExp?.components(separatedBy: " "))!
                self.tagExp.text = strList[0]
            }
            else
            {
                self.tagExp.text = self.petInfo?.tagExp
            }
            retrieveSavedPetImage()
            retrieveSavedPetCoverImage()
        }
    }
    func retrieveSavedPetImage()
    {
        petImgVW.layer.masksToBounds = true
        petImgVW.clipsToBounds = true
        petImgVW.layer.cornerRadius = 30.0
        petImgVW.layer.borderColor = UIColor.clear.cgColor
        let patientImageString: String = (petInfo?.imagePath)!
        DispatchQueue.main.async
            {
                if let url = URL(string: patientImageString)
                {
                    if let imgData = NSData(contentsOf: url)
                    {
                        if let image = UIImage(data: imgData as Data)
                        {
                            self.petImgVW.image = image
                        }
                        else {
                            self.petImgVW.image = UIImage(named: "petImage-default.png")
                        }
                    }
                    else {
                        self.petImgVW.image = UIImage(named: "petImage-default.png")
                    }
                    let image: UIImage = self.squareImage(with: self.petImgVW.image!, scaledTo: CGSize(width: 120, height: 120))
                    let imageData: Data? = UIImagePNGRepresentation(image)
                    self.base64PetImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
                    print(self.base64PetImgString)
                }
        }
    }
    func retrieveSavedPetCoverImage()
    {
        let patientImageString: String = (petInfo?.coverImage)!
        //[NSString stringWithFormat:@"%@/CoverPhoto.ashx?UserID=%@&PetID=%@", kAlternateServerURL, patientID, petID];
        DispatchQueue.main.async
            {
                if let url = URL(string: patientImageString)
                {
                    if let imgData = NSData(contentsOf: url)
                    {
                        if let image = UIImage(data: imgData as Data)
                        {
                            self.coverImgVW.image = image
                        }
                        else {
                            self.coverImgVW.image = UIImage(named: "petCoverImage-default.png")
                        }
                    }
                    else
                    {
                        self.coverImgVW.image = UIImage(named: "petCoverImage-default.png")
                    }
                    let newImage: UIImage = self.squareImage(with: self.coverImgVW.image!, scaledTo: CGSize(width: 160, height: 100))
                    let imageData: Data? = UIImagePNGRepresentation(newImage)
                    self.base64CoverImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
                    print(self.base64CoverImgString)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: 320, height: (1280))
        
        checkForDeviceLanguage()
    }
    
    @objc func leftClk(_ sender: Any)
    {
        if self.isFromVC
        {
            if self.isFromMedical
            {
                navigationController?.popViewController(animated: true)
            }
            else
            {
                for controller: UIViewController in (self.navigationController?.viewControllers)!
                {
                    if (controller is MyPetsViewController)
                    {
                        _ = self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func rightClk(_ sender: Any)
    {
        doValidationForAddPet()
    }
    func checkForDeviceLanguage()
    {
        userDefaults = UserDefaults.standard
        UserDefaults.standard.synchronize()
        langString = userDefaults?.object(forKey: "LanguageCode") as! String
        print("Language String is:\(langString)")
    }
    @objc func viewTouched(_ sender: Any)
    {
        print("Touched view...")
        
        petNameTxtF.resignFirstResponder()
        petTypeTxtF.resignFirstResponder()
        petGenderTxtF.resignFirstResponder()
        petBloodTypeTxtF.resignFirstResponder()
        customBreedTxtF.resignFirstResponder()
        secondaryBreedTxtF.resignFirstResponder()
        pedigreeTxtF.resignFirstResponder()
        chipNumberTxtF.resignFirstResponder()
        tatooNumTxtF.resignFirstResponder()
        placeOfBirthTxtF.resignFirstResponder()
        dateOfBirthTxtF.resignFirstResponder()
        countryTxtF.resignFirstResponder()
        stateTxtF.resignFirstResponder()
        zipCodeTxtF.resignFirstResponder()
        hairTypeTxtF.resignFirstResponder()
        otherHairTypeTxtF.resignFirstResponder()
        colorTxtF.resignFirstResponder()
        secondaryColorTxtF.resignFirstResponder()
        otherColorTypeTxtF.resignFirstResponder()
        adoptionDateTxtF.resignFirstResponder()
        sterileTxtF.resignFirstResponder()
        tagNo.resignFirstResponder()
        tagType.resignFirstResponder()
        
        tagExp.resignFirstResponder()
    }
    @IBAction func petImageClk(_ sender: Any)
    {
        petNameTxtF.resignFirstResponder()
        petTypeTxtF.resignFirstResponder()
        customBreedTxtF.resignFirstResponder()
        secondaryBreedTxtF.resignFirstResponder()
        pedigreeTxtF.resignFirstResponder()
        chipNumberTxtF.resignFirstResponder()
        tatooNumTxtF.resignFirstResponder()
        placeOfBirthTxtF.resignFirstResponder()
        zipCodeTxtF.resignFirstResponder()
        otherHairTypeTxtF.resignFirstResponder()
        otherColorTypeTxtF.resignFirstResponder()
        adoptionDateTxtF.resignFirstResponder()
        tagNo.resignFirstResponder()
        tagType.resignFirstResponder()
        tagExp.resignFirstResponder()
        
        isPetImageFlag = true
        isRecordPetImage = true
        //isRecordCoverImage = false
        
        let alertControl = UIAlertController(title: "Upload Photo", message: "Choose to upload from", preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .photoLibrary
            self.present(self.imgPkrCon!, animated: true)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .camera
            self.present(self.imgPkrCon!, animated: true)
        })
        let Cancel = UIAlertAction(title: "Cancel ", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.dismiss(animated: true)
        })
        alertControl.addAction(galary)
        alertControl.addAction(camera)
        alertControl.addAction(Cancel)
        alertControl.popoverPresentationController?.sourceView = self.view
        alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        navigationController?.present(alertControl , animated: true)
    }
    @IBAction func coverImageClk(_ sender: Any)
    {
        isPetCoverFlag = true
        isRecordCoverImage = true
        isRecordPetImage = false
        
        petNameTxtF.resignFirstResponder()
        petTypeTxtF.resignFirstResponder()
        customBreedTxtF.resignFirstResponder()
        secondaryBreedTxtF.resignFirstResponder()
        pedigreeTxtF.resignFirstResponder()
        chipNumberTxtF.resignFirstResponder()
        tatooNumTxtF.resignFirstResponder()
        placeOfBirthTxtF.resignFirstResponder()
        zipCodeTxtF.resignFirstResponder()
        otherHairTypeTxtF.resignFirstResponder()
        otherColorTypeTxtF.resignFirstResponder()
        adoptionDateTxtF.resignFirstResponder()
        tagNo.resignFirstResponder()
        tagType.resignFirstResponder()
        tagExp.resignFirstResponder()
        let alertControl = UIAlertController(title: "Upload Photo", message: "Choose to upload from", preferredStyle: .actionSheet)
        let galary = UIAlertAction(title: "Gallery", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .photoLibrary
            self.present(self.imgPkrCon!, animated: true)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.sourceType = .camera
            self.present(self.imgPkrCon!, animated: true)
        })
        let Cancel = UIAlertAction(title: "Cancel ", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imgPkrCon?.dismiss(animated: true)
        })
        alertControl.addAction(galary)
        alertControl.addAction(camera)
        alertControl.addAction(Cancel)
        alertControl.popoverPresentationController?.sourceView = self.view
        alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        navigationController?.present(alertControl , animated: true)
    }
    func getList()
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            MBProgressHUD.showAdded(to: self.view, animated: true).labelText = NSLocalizedString("Loading", comment: "")
            RestClient.getList(dropDownString, callBackHandler: {(response: Any, error: Error?) -> Void in
                self.listArr = [Any]()
                print("response", response)
                DispatchQueue.main.async
                    {
                        let detailsArr = response as! [[String:Any]]
                        
                        for dict in detailsArr
                        {
                            if (self.dropDownString == "Color") {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String 
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "SecondaryColor")
                            {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "Gender") {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "PetType")
                            {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "HairType")
                            {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String
                                
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "Country")
                            {
                                let model = CommonResponseModel()
                                model.paramID = (dict["Id"] as! NSNumber).stringValue
                                model.paramName = dict["Name"] as! String?
                                self.listArr.append(model)
                            }
                            else if (self.dropDownString == "State")
                            {
                                let model = CommonResponseModel()
                                print(self.countryID)
                                //                                print(dict["ConversationId"])
                                if self.countryID != "" && self.countryID == (dict["ConversationId"] as! NSString) as String
                                {
                                    model.paramID = (dict["Id"] as! NSNumber).stringValue
                                    model.paramName = dict["Name"] as! String?
                                    model.paramSubID = dict["ConversationId"] as! String?
                                    self.listArr.append(model)
                                }
                            }
                            else if (self.dropDownString == "BloodGroupType")
                            {
                                var list: [Any] = (dict["ConversationId"]! as AnyObject).components(separatedBy: ",")
                                for i in 0..<list.count
                                {
                                    let str: String = list[i] as? String ?? ""
                                    if CInt(self.petTypeID) == 1 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        print(model.paramID)
                                        model.paramName = dict["Name"] as! String?
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 2 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String?
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 3 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 4 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 5 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 6 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 7 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 8 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 9 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 10 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    if CInt(self.petTypeID) == 11 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 12 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 13 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 14 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 15 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 16 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 18 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 19 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 20 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 21 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 45 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 50 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 52 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 53 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 54 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 55 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 56 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 57 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 60 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 61 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 64 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 66 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 67 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 69 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 70 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 71 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                    else if CInt(self.petTypeID) == 72 && ("\(self.petTypeID)" == str) {
                                        let model = CommonResponseModel()
                                        model.paramID = (dict["Id"] as! NSNumber).stringValue
                                        model.paramName = dict["Name"] as! String
                                        self.listArr.append(model)
                                    }
                                }
                            }
                        }
                        self.dropDownTbl.reloadAllComponents()
                        MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
        }
    }
    // MARK: -
    // MARK: UITableView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.listArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let model = listArr[row] as? CommonResponseModel
        return model?.paramName
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int)
    {
        //        if listArr.count > 0
        //        {
        //            let model = listArr[row] as? CommonResponseModel
        //            if (dropDownString == "Country")
        //            {
        //                countryTxtF.text = model?.paramName
        //                countryID = (model?.paramID)!
        //                stateTxtF.text = ""
        //                stateID = ""
        //            }
        //            else if (dropDownString == "State")
        //            {
        //                stateTxtF.text = model?.paramName
        //                stateID = (model?.paramID)!
        //                stateCountryID = (model?.paramSubID)!
        //            }
        //            else if (dropDownString == "PetType")
        //            {
        //                petTypeTxtF.text = model?.paramName
        //                petTypeID = (model?.paramID)!
        //                petBloodTypeTxtF.text = ""
        //                if CInt(petTypeID) == 11 || (petTypeTxtF.text == "Other") {
        //                    otherPetTypeTxtF.alpha = 1.0
        //                    otherPetTypeTxtF.isUserInteractionEnabled = true
        //                }
        //                else {
        //                    otherPetTypeTxtF.alpha = 0.5
        //                    otherPetTypeTxtF.isUserInteractionEnabled = false
        //                }
        //            }
        //            if (dropDownString == "Gender")
        //            {
        //                petGenderTxtF.text = model?.paramName
        //                genderID = (model?.paramID)!
        //                //self.petGenderTxtF.resignFirstResponder()
        //            }
        //            else if (dropDownString == "BloodGroupType")
        //            {
        //                petBloodTypeTxtF.text = model?.paramName
        //                bloodTypeID = (model?.paramID)!
        //            }
        //            else if (dropDownString == "HairType")
        //            {
        //                hairTypeTxtF.text = model?.paramName
        //                hairTypeID = (model?.paramID)!
        //                if CInt(hairTypeID) == 4 || (hairTypeTxtF.text == "Other") {
        //                    otherHairTypeTxtF.alpha = 1.0
        //                    otherHairTypeTxtF.isUserInteractionEnabled = true
        //                }
        //                else {
        //                    otherHairTypeTxtF.alpha = 0.5
        //                    otherHairTypeTxtF.isUserInteractionEnabled = false
        //                }
        //            }
        //            else if (dropDownString == "Color")
        //            {
        //                colorTxtF.text = model?.paramName
        //                colorID = (model?.paramID)!
        //                if CInt(colorID) == 5 || (colorTxtF.text == "Other") {
        //                    otherColorTypeTxtF.alpha = 1.0
        //                    otherColorTypeTxtF.isUserInteractionEnabled = true
        //                }
        //                else {
        //                    otherColorTypeTxtF.alpha = 0.5
        //                    otherColorTypeTxtF.isUserInteractionEnabled = false
        //                }
        //            }
        //            else if (dropDownString == "SecondaryColor")
        //            {
        //                secondaryColorTxtF.text = model?.paramName
        //                secondaryColorID = (model?.paramID)!
        //                if CInt(secondaryColorID) == 5 || (secondaryColorTxtF.text == "Other") {
        //                    otherSecondaryColorTypeTxtF.alpha = 1.0
        //                    otherSecondaryColorTypeTxtF.isUserInteractionEnabled = true
        //                }
        //                else {
        //                    otherSecondaryColorTypeTxtF.alpha = 0.5
        //                    otherSecondaryColorTypeTxtF.isUserInteractionEnabled = false
        //                }
        //            }
        //        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == petNameTxtF {
            customBreedTxtF.becomeFirstResponder()
        }
        else if textField == customBreedTxtF {
            secondaryBreedTxtF.becomeFirstResponder()
        }
        else if textField == secondaryBreedTxtF {
            pedigreeTxtF.becomeFirstResponder()
        }
        else if textField == pedigreeTxtF {
            chipNumberTxtF.becomeFirstResponder()
        }
        else if textField == chipNumberTxtF {
            tatooNumTxtF.becomeFirstResponder()
        }
        else if textField == placeOfBirthTxtF {
            zipCodeTxtF.becomeFirstResponder()
        }
        else if textField == zipCodeTxtF {
            adoptionDateTxtF.becomeFirstResponder()
        }
        else if textField == adoptionDateTxtF {
            sterileTxtF.becomeFirstResponder()
        }
        else if textField == sterileTxtF {
            sterileTxtF.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == zipCodeTxtF {
            let cs = CharacterSet(charactersIn: API.Login.ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    
    // MARK: -
    // MARK: UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if isRecordPetImage
        {
            navigationController?.dismiss(animated: true)
            petImgVW.image =  info["UIImagePickerControllerEditedImage"] as? UIImage
            let newImage: UIImage? = squareImage(with: petImgVW.image!, scaledTo: CGSize(width: 120, height: 120))
            let imageData: Data? = UIImagePNGRepresentation(newImage!)
            base64PetImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
            print("Added Image base64 string for Pet Image:\(base64PetImgString)")
        }
        else if isRecordCoverImage
        {
            navigationController?.dismiss(animated: true)
            coverImgVW.image = info["UIImagePickerControllerEditedImage"] as? UIImage
            let newImage: UIImage? = squareImage(with: coverImgVW.image!, scaledTo: CGSize(width: 160, height: 100))
            let imageData: Data? = UIImagePNGRepresentation(newImage!)
            base64CoverImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
            print("Added Image base64 string for Cover Image:\(base64CoverImgString)")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.dismiss(animated: true)
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
    func doValidationForAddPet() {
        if petNameTxtF.text == nil && petTypeTxtF.text == nil && (petNameTxtF.text == "") && (petTypeTxtF.text == "") {
            petNameTxtF.layer.borderColor = UIColor.red.cgColor
            petTypeTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        if petNameTxtF.text == nil || petNameTxtF.text == ""
        {
            petNameTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            petNameTxtF.layer.borderColor = UIColor.clear.cgColor
        }
        if petTypeTxtF.text == nil || petTypeTxtF.text == ""
        {
            petTypeTxtF.layer.borderColor = UIColor.red.cgColor
            mandatoryLbl.isHidden = false
        }
        else
        {
            petTypeTxtF.layer.borderColor = UIColor.clear.cgColor
        }
        if self.petNameTxtF.text != nil && petTypeTxtF.text != nil && (petNameTxtF.text != "") && (petTypeTxtF.text != "")
        {
            self.mandatoryLbl.isHidden = true
            if doValidationForTextFields() {
                checkInternetConnection()
            }
        }
    }
    func doValidationForTextFields() -> Bool
    {
        if doValidationForOtherPet() {
            if doValidationForOtherColor() {
                if doValidationForOtherHair() {
                    if doValidationForCustomBreed() {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    func doValidationForOtherPet() -> Bool
    {
        if (petTypeTxtF.text == "Other") && CInt(petTypeID) == 11
        {
            if otherPetTypeTxtF.text?.count == 0 || otherPetTypeTxtF.text == nil || (otherPetTypeTxtF.text == "")
            {
                let alertControl = UIAlertController(title: "Warning", message: "Please enter other species type", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertControl.addAction(ok)
                present(alertControl, animated: true)
                otherPetTypeTxtF.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    func doValidationForOtherColor() -> Bool
    {
        if (colorTxtF.text == "Other") && CInt(colorID) == 5 {
            if otherColorTypeTxtF.text?.count == 0 || otherColorTypeTxtF.text == nil || (otherColorTypeTxtF.text! == "") {
                let alertControl = UIAlertController(title: "Warning", message: "Please enter other color type", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertControl.addAction(ok)
                present(alertControl, animated: true)
                otherColorTypeTxtF.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    func doValidationForOtherHair() -> Bool
    {
        if (hairTypeTxtF.text == "Other") && CInt(hairTypeID) == 4 {
            if otherHairTypeTxtF.text?.count == 0 || otherHairTypeTxtF.text == nil || (otherHairTypeTxtF.text! == "") {
                let alertControl = UIAlertController(title: "Warning", message: "Please enter other hair type", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertControl.addAction(ok)
                present(alertControl, animated: true)
                otherHairTypeTxtF.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    func doValidationForCustomBreed() -> Bool
    {
        if (petTypeTxtF.text == "Dog") && CInt(petTypeID) == 1
        {
            if customBreedTxtF.text?.count == 0 || customBreedTxtF.text == nil || (customBreedTxtF.text! == "") {
                let alertControl = UIAlertController(title: "Warning", message: "Please enter custom breed", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                alertControl.addAction(ok)
                present(alertControl, animated: true) 
                customBreedTxtF.layer.borderColor = UIColor.red.cgColor
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    
    // MARK: -
    // MARK: Webservices
    func checkInternetConnection()
    {
        //first check internet connectivity
        if CheckNetwork.isExistenceNetwork() {
            print("Internet connection")
            MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
            webServiceToAddPet()
        }
        else {
            print("No internet connection")
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    func petImageNotAdded() {
        petImgVW.image = UIImage(named: "petImage-default.png")
        let imageData: Data? = UIImagePNGRepresentation(petImgVW.image!)
        base64DefaultPetImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
    }
    
    func coverImageNotAdded() {
        coverImgVW.image = UIImage(named: "petCoverImage-default.png")
        let imageData: Data? = UIImagePNGRepresentation(coverImgVW.image!)
        base64DefaultCoverImgString = (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
    }
    func webServiceToAddPet()
    {
        let headers = [
            "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
            "content-type": "application/json"
        ]
        var petStr: String = ""
        var petCoverStr: String = ""
        if isPetImageFlag == true
        {
            petStr = self.base64PetImgString
            print(petStr)
        }
        else {
            petImageNotAdded()
            petStr = base64DefaultPetImgString
        }
        if isPetCoverFlag == true
        {
            petCoverStr = base64CoverImgString
            print(petCoverStr)
        }
        else
        {
            coverImageNotAdded()
            petCoverStr = base64DefaultCoverImgString
        }
        var str : String = ""
        var sterileStr: String = ""
        if self.sterileTxtF.text == "Unknown"
        {
            sterileStr = ""
        }
        else
        {
            sterileStr = self.sterileTxtF.text!
        }
        //var dict = [String: Any]()
        
        if self.isFromVC == true
        {
            
            let petId = UserDefaults.standard.object(forKey: "SelectedPet")
            urlStr = API.Pet.EditPet
            str = String(format: "PetId=%@&PetName=%@&PetTypeId=%@&CustomPetType=%@&Breed=%@&SecondaryBreed=%@&Pedigree=%@&BloodTypeId=%@&ChipNumber=%@&TattooNumber=%@&GenderId=%@&AdoptionDate=%@&BirthDate=%@&PlaceOfBirth=%@&CountryId=%@&StateId=%@&Zip=%@&HairTypeId=%@&HairTypeOther=%@&ColorId=%@&ColorOther=%@&SecondaryColorId=%@&SecondaryColorOther=%@&IsSterile=%@&Tag_No=%@&Tag_Type=%@&Tag_Exp=%@",petId as! CVarArg,(self.petNameTxtF?.text)!, self.petTypeID, (self.otherPetTypeTxtF?.text)!, (self.customBreedTxtF?.text)!, (self.secondaryBreedTxtF?.text)!, self.pedigreeTxtF.text!, self.bloodTypeID, self.chipNumberTxtF.text!, (self.tatooNumTxtF?.text)!,self.genderID, (self.adoptionDateTxtF?.text)!, self.dateOfBirthTxtF.text!, self.placeOfBirthTxtF.text!, self.countryID, self.stateID, (self.zipCodeTxtF?.text)!, self.hairTypeID, self.otherHairTypeTxtF.text!, self.colorID, self.otherColorTypeTxtF.text!, self.secondaryColorID, self.otherSecondaryColorTypeTxtF.text!,sterileStr, self.tagNo.text!, self.tagType.text!, self.tagExp.text!)
            
        }
        else
        {
            
            let userId: NSNumber = UserDefaults.standard.object(forKey: "userID") as! NSNumber
            urlStr = API.Pet.AddPet
            str = String(format: "PatientId=%@&PetName=%@&PetTypeId=%@&CustomPetType=%@&Breed=%@&SecondaryBreed=%@&Pedigree=%@&BloodTypeId=%@&ChipNumber=%@&TattooNumber=%@&GenderId=%@&AdoptionDate=%@&BirthDate=%@&PlaceOfBirth=%@&CountryId=%@&StateId=%@&Zip=%@&HairTypeId=%@&HairTypeOther=%@&ColorId=%@&ColorOther=%@&SecondaryColorId=%@&SecondaryColorOther=%@&IsSterile=%@&Tag_No=%@&Tag_Type=%@&Tag_Exp=%@",userId,(self.petNameTxtF?.text)!, self.petTypeID, (self.otherPetTypeTxtF?.text)!, (self.customBreedTxtF?.text)!, (self.secondaryBreedTxtF?.text)!, self.pedigreeTxtF.text!, self.bloodTypeID, self.chipNumberTxtF.text!, (self.tatooNumTxtF?.text)!,self.genderID, (self.adoptionDateTxtF?.text)!, self.dateOfBirthTxtF.text!, self.placeOfBirthTxtF.text!, self.countryID, self.stateID, (self.zipCodeTxtF?.text)!, self.hairTypeID, self.otherHairTypeTxtF.text!, self.colorID, self.otherColorTypeTxtF.text!, self.secondaryColorID, self.otherSecondaryColorTypeTxtF.text!, sterileStr,self.tagNo.text!, self.tagType.text!, self.tagExp.text!)
            
        }
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format : "%@?%@", self.urlStr, str)
        let requestUrl = URL(string: urlString)
        var request = URLRequest(url: requestUrl!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
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
                            if self.isFromVC == false
                            {
                                self.petId = (json?["Message"] as? String)!
                                if self.isPetImageFlag == true && petStr.count > 0 && petStr != ""
                                {
                                    self.webServiceToUplaodPetProfileImage(petStr)
                                }
                                else if self.isPetCoverFlag == true && petCoverStr.count > 0
                                {
                                    self.webServiceToUplaodPetCoverImage(petCoverStr)
                                }
                                else
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alertDel = UIAlertController(title: "Success", message: "Pet details has been added successfully", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is MyPetsViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    })
                                    alertDel.addAction(ok)
                                    self.present(alertDel, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                self.petId = (self.petInfo?.petId)!.stringValue
                                if self.isPetImageFlag == true && petStr.count > 0 && petStr != ""
                                {
                                    self.webServiceToUplaodPetProfileImage(petStr)
                                }
                                else if self.isPetCoverFlag == true && petCoverStr.count > 0
                                {
                                    self.webServiceToUplaodPetCoverImage(petCoverStr)
                                }
                                else
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alertDel = UIAlertController(title: "Success", message: "Pet details has been updated successfully", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is MyPetsViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                break
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
                            let alertDel = UIAlertController(title: "Error", message: json?["Message"] as? String, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
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
    func webServiceToUplaodPetProfileImage(_ image: String)
    {
        let reachability = Reachability.forInternetConnection
        let internetStatus: NetworkStatus = reachability().currentReachabilityStatus()
        if internetStatus != NotReachable
        {
            var petStr: String = ""
            var petCoverStr: String = ""
            if isPetImageFlag == true
            {
                petStr = self.base64PetImgString
                print(petStr)
            }
            else {
                petImageNotAdded()
                petStr = base64DefaultPetImgString
            }
            if isPetCoverFlag == true
            {
                petCoverStr = base64CoverImgString
                print(petCoverStr)
            }
            else
            {
                coverImageNotAdded()
                petCoverStr = base64DefaultCoverImgString
            }
            let headers = [
                "x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=",
                "content-type": "application/json",
                "cache-control": "no-cache"
            ]
            var str = [String: String]()
            
            str = ["PetId": self.petId, "PetImageName": "ProfilePic.png", "PetImageBase64String": image];
            self.urlStr = API.Pet.AddPetPhoto
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
                                if self.isPetCoverFlag
                                {
                                    self.webServiceToUplaodPetCoverImage(petCoverStr)
                                }
                                else
                                {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    var message: String = ""
                                    if self.isFromVC
                                    {
                                        message = "Pet details has been updated successfully"
                                        if self.isFromMedical
                                        {
                                            let alertDel = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                                
                                                _ = self.navigationController?.popViewController(animated: true)
                                            })
                                            alertDel.addAction(ok)
                                            self.present(alertDel, animated: true, completion: nil)
                                        }
                                    }
                                    else
                                    {
                                        message = "Pet details has been added successfully"
                                    }
                                    let alertDel = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        
                                        for controller: UIViewController in (self.navigationController?.viewControllers)!
                                        {
                                            if (controller is MyPetsViewController)
                                            {
                                                _ = self.navigationController?.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    })
                                    alertDel.addAction(ok)
                                    self.present(alertDel, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                    }
                    
                }
            }
            task.resume()
        }
    }
    func webServiceToUplaodPetCoverImage(_ image: String)
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
            str = ["PetId": self.petId, "CoverImage": "CoverImage.png", "CoverImageBase64String": image];
            self.urlStr = API.Pet.AddPetCoverPhoto
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
                                var message: String = ""
                                if self.isFromVC
                                {
                                    message = "Pet details has been updated successfully"
                                    if self.isFromMedical
                                    {
                                        let alertDel = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                            
                                            _ = self.navigationController?.popViewController(animated: true)
                                        })
                                        alertDel.addAction(ok)
                                        self.present(alertDel, animated: true, completion: nil)
                                    }
                                }
                                else
                                {
                                    message = "Pet details has been added successfully"
                                }
                                let alertDel = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    
                                    for controller: UIViewController in (self.navigationController?.viewControllers)!
                                    {
                                        if (controller is MyPetsViewController)
                                        {
                                            _ = self.navigationController?.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.petTypeTxtF || textField == self.petGenderTxtF || textField == self.petBloodTypeTxtF || textField == self.countryTxtF || textField == self.stateTxtF || textField == self.hairTypeTxtF || textField == self.colorTxtF || textField == self.secondaryColorTxtF || textField == self.sterileTxtF
        {
            let view1 = UIView()
            textField.inputView = view1
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.dateOfBirthTxtF
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.selectedTextFld = textField
            self.datePicker.maximumDate = Date()
            if textField.text != nil && textField.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: textField.text!)!
                self.datePicker.date = date
            }
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
        else if textField == self.adoptionDateTxtF || textField == self.tagExp
        {
            self.datePicker.datePickerMode = UIDatePickerMode.date
            self.selectedTextFld = textField
            if dateOfBirthTxtF.text != nil && dateOfBirthTxtF.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: self.dateOfBirthTxtF.text!)!
                self.datePicker.minimumDate = date
            }
            if textField.text != nil && textField.text != ""
            {
                let df = DateFormatter()
                df.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "")
                let date: Date = df.date(from: textField.text!)!
                self.datePicker.date = date
            }
            if textField == self.tagExp
            {
                self.datePicker.maximumDate = nil
            }
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
        else if textField == self.petTypeTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "PetType"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.petGenderTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "Gender"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.petBloodTypeTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "BloodGroupType"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.countryTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "Country"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.stateTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "State"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.hairTypeTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "HairType"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.colorTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "Color"
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.secondaryColorTxtF
        {
            self.selectedTextFld = textField
            dropDownString = "SecondaryColor"
            isSecondFlag = true
            self.listArr = []
            self.dropDownTbl.reloadAllComponents()
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
            textField.inputView = dropDownTbl
        }
        else if textField == self.sterileTxtF
        {
            let alertControl = UIAlertController(title: "Select Sterile", message: nil, preferredStyle: .actionSheet)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.sterileTxtF.text = NSLocalizedString("Yes", comment: "")
                self.sterileID = "1"
            })
            let no = UIAlertAction(title: "NO", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.sterileTxtF.text = NSLocalizedString("No", comment: "")
                self.sterileID = "0"
            })
            let unknown = UIAlertAction(title: "Unknown", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.sterileTxtF.text = NSLocalizedString("Unknown", comment: "")
                self.sterileID = ""
            })
            let Cancel = UIAlertAction(title: "Cancel ", style: .cancel, handler: nil)
            alertControl.addAction(yes)
            alertControl.addAction(no)
            alertControl.addAction(unknown)
            alertControl.addAction(Cancel)
            alertControl.popoverPresentationController?.sourceView = self.view
            alertControl.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            alertControl.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            navigationController?.present(alertControl, animated: true)
        }
    }
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.selectedTextFld?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker()
    {
        self.view.endEditing(true)
        self.selectedTextFld?.resignFirstResponder()
    }
    @objc func doneDropDownSelection()
    {
        if listArr.count > 0
        {
            let model = listArr[self.dropDownTbl.selectedRow(inComponent: 0)] as? CommonResponseModel
            if (dropDownString == "Country")
            {
                countryTxtF.text = model?.paramName
                countryID = (model?.paramID)!
                stateTxtF.text = ""
                stateID = ""
            }
            else if (dropDownString == "State")
            {
                stateTxtF.text = model?.paramName
                stateID = (model?.paramID)!
                stateCountryID = (model?.paramSubID)!
            }
            else if (dropDownString == "PetType")
            {
                petTypeTxtF.text = model?.paramName
                petTypeID = (model?.paramID)!
                petBloodTypeTxtF.text = ""
                if CInt(petTypeID) == 11 || (petTypeTxtF.text == "Other") {
                    otherPetTypeTxtF.alpha = 1.0
                    otherPetTypeTxtF.isUserInteractionEnabled = true
                }
                else {
                    otherPetTypeTxtF.alpha = 0.5
                    otherPetTypeTxtF.isUserInteractionEnabled = false
                }
            }
            if (dropDownString == "Gender")
            {
                petGenderTxtF.text = model?.paramName
                genderID = (model?.paramID)!
            }
            else if (dropDownString == "BloodGroupType")
            {
                petBloodTypeTxtF.text = model?.paramName
                bloodTypeID = (model?.paramID)!
                print(model?.paramID!)
            }
            else if (dropDownString == "HairType")
            {
                hairTypeTxtF.text = model?.paramName
                hairTypeID = (model?.paramID)!
                if CInt(hairTypeID) == 4 || (hairTypeTxtF.text == "Other") {
                    otherHairTypeTxtF.alpha = 1.0
                    otherHairTypeTxtF.isUserInteractionEnabled = true
                }
                else {
                    otherHairTypeTxtF.alpha = 0.5
                    otherHairTypeTxtF.isUserInteractionEnabled = false
                }
            }
            else if (dropDownString == "Color")
            {
                colorTxtF.text = model?.paramName
                colorID = (model?.paramID)!
                if CInt(colorID) == 5 || (colorTxtF.text == "Other") {
                    otherColorTypeTxtF.alpha = 1.0
                    otherColorTypeTxtF.isUserInteractionEnabled = true
                }
                else {
                    otherColorTypeTxtF.alpha = 0.5
                    otherColorTypeTxtF.isUserInteractionEnabled = false
                }
            }
            else if (dropDownString == "SecondaryColor")
            {
                secondaryColorTxtF.text = model?.paramName
                secondaryColorID = (model?.paramID)!
                if CInt(secondaryColorID) == 5 || (secondaryColorTxtF.text == "Other") {
                    otherSecondaryColorTypeTxtF.alpha = 1.0
                    otherSecondaryColorTypeTxtF.isUserInteractionEnabled = true
                }
                else {
                    otherSecondaryColorTypeTxtF.alpha = 0.5
                    otherSecondaryColorTypeTxtF.isUserInteractionEnabled = false
                }
            }
            self.selectedTextFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
        else
        {
            self.selectedTextFld?.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    @objc func cancelDropDownSelection()
    {
        self.view.endEditing(true)
        self.selectedTextFld?.resignFirstResponder()
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
