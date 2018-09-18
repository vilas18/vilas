//
//  NewMedicalSummaryViewController.swift
//  Activ4Pets
//
//  Created by Activ Doctors Online on 12/09/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//

import UIKit
extension UIView
{
    func anchorToSuperview() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}

class NewMedicalSummaryViewController: UIViewController, UIDocumentInteractionControllerDelegate, UIScrollViewDelegate
{
    
    @IBOutlet var vitalConstraintView: UIView!
    @IBOutlet var labResultConstraintView: UIView!
    @IBOutlet var cbgheadercontainerheightView: UIView!
    @IBOutlet var hemoglobinheaderheightView: UIView!
    @IBOutlet var hemogramheaderheightView: UIView!
    @IBOutlet var serumheaderheightView: UIView!
    @IBOutlet var consultiontitleheightconstraintView: UIView!
    @IBOutlet var conditiontitleheightconstraintView: UIView!
    @IBOutlet var immunizationtitleheightconstraintView: UIView!
    @IBOutlet var surgeriestitleheightconstraintView: UIView!
    @IBOutlet var medicationtitleheightconstraintView: UIView!
    @IBOutlet var allgerytitleheightconstraintView: UIView!
    @IBOutlet var hospitalizationtitleheightconstraintView: UIView!
    @IBOutlet var foodplantitleheightconstraintView: UIView!
    @IBOutlet var documenttitleheightconstraintView: UIView!
    @IBOutlet var emergencytitleheightconstraintView: UIView!
    @IBOutlet var vetetinariantitleheightconstraintView: UIView!
    @IBOutlet var insurancetitleheightconstraintView: UIView!
    
    @IBOutlet weak var petTypeLbl: UILabel!
    @IBOutlet weak var petNameLbl: UILabel!
    @IBOutlet weak var petProfileImgVW: UIImageView!
    @IBOutlet weak var petBloodLbl: UILabel!
    @IBOutlet weak var petDobLbl: UILabel!
    @IBOutlet weak var petGenderLbl: UILabel!
    
    @IBOutlet weak var basicInfoViewContainer: UIView!
    @IBOutlet weak var breederDetailsViewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var hasViewLoaded: Bool = false
    var cbgChildVC: CBGListViewController?
    ////VIEW CONTROLLER CONTAINERS
    
    @IBOutlet weak var segmentControlConstraint: NSLayoutConstraint!
    @IBOutlet weak var basicHeight: NSLayoutConstraint!
    @IBOutlet weak var breederHeight: NSLayoutConstraint!
    @IBOutlet weak var smallContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var smallContainerWeightHeight: NSLayoutConstraint!
    @IBOutlet weak var smallContaintertempHeight: NSLayoutConstraint!
    @IBOutlet weak var smallCOntainerPluseHeight: NSLayoutConstraint!
    
    //@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeightConstriant;
    
    @IBOutlet weak var allgeryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allgeryTitleHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *allegeryTitleView;
    //@property (weak, nonatomic) IBOutlet UIView *consultionTitleView;
    @IBOutlet weak var consultionTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var consultionHeightConstraint: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *conditionTitleVIew;
    @IBOutlet weak var conditionTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var conditionHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *immunizationTitleVIew;
    @IBOutlet weak var immunizationTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var immunizationHeightConstriant: NSLayoutConstraint!
    
    //@property (weak, nonatomic) IBOutlet UIView *surgeriesTitleVIew;
    
    @IBOutlet weak var surgeriesTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var surgeriesHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *medicationTitleVIew;
    @IBOutlet weak var medicationTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var medicationHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *hospitalizationTitleVIew;
    @IBOutlet weak var hospitalizationTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var hospitalizationHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *foodPlanTitleVIew;
    @IBOutlet weak var foodPlanTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var foodPlanHeightConstriant: NSLayoutConstraint!
    
    //@property (weak, nonatomic) IBOutlet UIView *emergencyTitleVIew;
    
    @IBOutlet weak var emergencyTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var emergencyHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *vetetinarianTitleVIew;
    @IBOutlet weak var vetetinarianTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var vetetinarianHeightConstriant: NSLayoutConstraint!
    //@property (weak, nonatomic) IBOutlet UIView *insuranceTitleVIew;
    @IBOutlet weak var insuranceTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var insuranceHeightConstriant: NSLayoutConstraint!
    
    //@property (weak, nonatomic) IBOutlet UIView *documentTitleVIew;
    
    @IBOutlet weak var documentTitleHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var documentHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var heightGraphConstriant: NSLayoutConstraint!
    @IBOutlet weak var weightGarphConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempratureGarphConstraint: NSLayoutConstraint!
    @IBOutlet weak var pluseGraphConstriant: NSLayoutConstraint!
    @IBOutlet weak var labResultConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightMainView: UIView!
    @IBOutlet weak var weightMainView: UIView!
    @IBOutlet weak var tempratureMainView: UIView!
    @IBOutlet weak var pluseMainView: UIView!
    @IBOutlet weak var heightViewControllerContainer: UIView!
    @IBOutlet weak var weightViewControllerContainer: UIView!
    @IBOutlet weak var temperatureViewControllerContainer: UIView!
    @IBOutlet weak var pulseViewControllerContainer: UIView!
    @IBOutlet weak var pulseValueLbl: UILabel!
    @IBOutlet weak var pulseDateLbl: UILabel!
    @IBOutlet weak var temperatureValueLbl: UILabel!
    @IBOutlet weak var temperatureDateLbl: UILabel!
    
    @IBOutlet weak var weightValueLbl: UILabel!
    @IBOutlet weak var weightDateLbl: UILabel!
    @IBOutlet weak var heightValueLbl: UILabel!
    @IBOutlet weak var heightDateLbl: UILabel!
    @IBOutlet weak var cbgViewControllerContainer: UIView!
    @IBOutlet weak var hemoglobinViewControllerContainer: UIView!
    @IBOutlet weak var hemogramViewControllerContainer: UIView!
    @IBOutlet weak var serumElectrolyteViewControllerContainer: UIView!
    @IBOutlet weak var consultationViewControllerContainer: UIView!
    
    @IBOutlet weak var conditionViewControllerContainer: UIView!
    @IBOutlet weak var immunizationViewControllerContainer: UIView!
    @IBOutlet weak var surgeriesViewControllerContainer: UIView!
    @IBOutlet weak var medicationsViewControllerContainer: UIView!
    @IBOutlet weak var allergyViewControllerContainer: UIView!
    @IBOutlet weak var hospitalizationViewControllerContainer: UIView!
    @IBOutlet weak var foodPlanViewControllerContainer: UIView!
    @IBOutlet weak var documentViewControllerContainer: UIView!
    @IBOutlet weak var emergencyContactViewControllerContainer: UIView!
    @IBOutlet weak var veterinarianViewControllerContainer: UIView!
    @IBOutlet weak var insuranceViewControllerContainer: UIView!
    
    @IBOutlet weak var editVitalsSectionBtn: UIButton!
    @IBOutlet weak var vitalConstraint: NSLayoutConstraint!
    @IBOutlet weak var pdfBtn: UIButton!
    
    @IBAction func editVitalsSectionClk(_ sender: Any) {
    }
    
    
    
    //Container & Header Height Constraint
    
    // @IBOutlet weak var labResultHeightContainer: NSLayoutConstraint!
    @IBOutlet weak var cbgHeaderContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var cbgContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var hemoglobinHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var hemoglobinContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var hemogramHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var hemogramContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var serumHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var serumContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var infoSegC: UISegmentedControl!
    
    
    
    var petDetailcount: Int = 0
    var plusecount: Int = 0
    var tempcount: Int = 0
    var heightcount: Int = 0
    var weightcount: Int = 0
    var cbgcount: Int = 0
    var hemoglobincount: Int = 0
    var HemogramViewcount: Int = 0
    var serumViewcount: Int = 0
    var ConsultionViewcount: Int = 0
    var ConditionViewcount: Int = 0
    var ImmunizationViewcount: Int = 0
    var SurgeriesViewcount: Int = 0
    var MedicationViewcount: Int = 0
    var AllgeryViewcount: Int = 0
    var HospitalizationViewocunt: Int = 0
    var FoodPlanViewcount: Int = 0
    var DocumentViewcount: Int = 0
    var EmergencyViewocunt: Int = 0
    var VetetinarianViewcount: Int = 0
    var InsuranceViewcount: Int = 0
    
    var isComingFromMedicalSummary: Bool = false
    var petID: String = ""
    var patientID: String = ""
    var petName: String = ""
    var petType: String = ""
    var ShareWithMe: String = ""
    var shareIDInformation: String = ""
    var shareMedicalRecords: String = ""
    var shareVeterinarians: String = ""
    var shareContacts: String = ""
    var shareGallery: String = ""
    var canmodifyIDInformation: String = ""
    var canmodifyMedicalRecords: String = ""
    var canmodifyVeterinarians: String = ""
    var canmodifyContacts: String = ""
    var canmodifyGallery: String = ""
    var idCardChildVC: PetDetailsViewController?
    var breederChildVC: AdoptionDetailsViewController?
    var docInteractionCon: UIDocumentInteractionController?
    var medicalSummaryIndex: Int = 0
    var vitalCount: Int = 0
    var labCount: Int = 0
    var xmlParser: XMLParser?
    var recordPDFList: Bool = false
    var smoProgress: String = ""
    var sharedDetails: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Medical Summary", comment: "")
        MBProgressHUD.showAdded(to: view, animated: true).labelText = ""
        infoSegC.addTarget(self, action: #selector(self.segClk), for: .valueChanged)
        //retrieveSavedPetCoverImage()
        // retrieveSavedPetImage()
        let pref = UserDefaults.standard
        petNameLbl.text = pref.string(forKey: "PetName")
        petBloodLbl.text = pref.string(forKey: "PetBlood")
        petGenderLbl.text = pref.string(forKey: "PetGender")
        petDobLbl.text = pref.string(forKey: "PetDob")
        petTypeLbl.text = pref.string(forKey: "PetType")
        if petTypeLbl.text == "Other"
        {
            petTypeLbl.text = (pref.string(forKey: "PetType") )! + String(format: "(%@)", (pref.string(forKey: "PetTypeOther"))!)
            
        }
        else
        {
            petTypeLbl.text = pref.string(forKey: "PetType")
        }
        
        let str = pref.string(forKey: "PetProfile")
        petProfileImgVW.sd_setImage(with: URL(string: str!), placeholderImage: UIImage(named: "petImage-default.png"), options: SDWebImageOptions(rawValue: 1))
        petNameLbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        petNameLbl.textColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1)
        petTypeLbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        petTypeLbl.textColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1)
        // [self.scrollView setContentSize:CGSizeMake(320, (580 *6))];
        let leftItem = UIBarButtonItem(image: UIImage(named: API.Login.NavigationBackImage), style: .done, target: self, action: #selector(self.leftClk))
        navigationItem.leftBarButtonItem = leftItem
        
        edgesForExtendedLayout = []
        // var viewWidth: CGFloat = scrollView.frame.width
        
        // Weight
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let shareMedi: Bool = UserDefaults.standard.bool(forKey: "ShareMedi")
            if shareMedi
            {
                let storyboard21 = UIStoryboard(name: "PHR", bundle: nil)
                let weightChildVC: VitalsGraphViewViewController? = storyboard21.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
                weightChildVC?.hmtTypeId = "2"
                weightChildVC?.hmtType = "Weight"
                weightChildVC?.isVitalsComingFromMedicalSummary = true
                self.addChildViewController(weightChildVC!)
                weightChildVC?.didMove(toParentViewController: self)
                weightChildVC?.view?.backgroundColor = UIColor.clear
                weightChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 370)
                weightViewControllerContainer.addSubview((weightChildVC?.view)!)
                let prefs = UserDefaults.standard
                UserDefaults.standard.synchronize()
                weightValueLbl.text = prefs.object(forKey:"WeightValue") as? String
                weightDateLbl.text = prefs.object(forKey: "WeightDate") as? String
                prefs.synchronize()
                
                let flag21: Bool = prefs.bool(forKey: "ZeroWeight")
                print("FLAGG value ZeroWeight :\(flag21)")
                weightGarphConstraint.constant = 0.0
                
                
                // Height
                
                let storyboard22 = UIStoryboard(name: "PHR", bundle: nil)
                let heightChildVC: VitalsGraphViewViewController? = storyboard22.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
                heightChildVC?.hmtType = "Height"
                heightChildVC?.hmtTypeId = "1"
                heightChildVC?.isVitalsComingFromMedicalSummary = true
                self.addChildViewController(heightChildVC!)
                heightChildVC?.didMove(toParentViewController: self)
                heightChildVC?.view?.backgroundColor = UIColor.clear
                heightChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 370)
                heightViewControllerContainer.addSubview((heightChildVC?.view)!)
                // NSUserDefaults *prefs2 = [NSUserDefaults standardUserDefaults];
                UserDefaults.standard.synchronize()
                heightValueLbl.text = prefs.object(forKey: "HeightValue") as? String
                heightDateLbl.text = prefs.object(forKey: "HeightDate") as? String
                prefs.synchronize()
                
                print("heightValueLbl \(String(describing: heightValueLbl.text))")
                let flag22: Bool = prefs.bool(forKey: "ZeroHeight")
                print("FLAGG value ZeroHeight :\(flag22)")
                heightGraphConstriant.constant = 0.0
                
                // Temperature
                
                let storyboard23 = UIStoryboard(name: "PHR", bundle: nil)
                let tempChildVC: VitalsGraphViewViewController? = storyboard23.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
                tempChildVC?.hmtType = "Temperature"
                tempChildVC?.hmtTypeId = "3"
                tempChildVC?.isVitalsComingFromMedicalSummary = true
                self.addChildViewController(tempChildVC!)
                tempChildVC?.didMove(toParentViewController: self)
                tempChildVC?.view?.backgroundColor = UIColor.clear
                tempChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 365)
                temperatureViewControllerContainer.addSubview((tempChildVC?.view)!)
                //    NSUserDefaults *prefs3 = [NSUserDefaults standardUserDefaults];
                UserDefaults.standard.synchronize()
                temperatureValueLbl.text = prefs.object(forKey: "TemperatureValue") as? String
                temperatureDateLbl.text = prefs.object(forKey: "TemperatureDate") as? String
                prefs.synchronize()
                
                print("temperatureValueLbl \(String(describing: temperatureValueLbl.text))")
                print("temperatureDateLbl \(String(describing: temperatureDateLbl.text))")
                let flag23: Bool = prefs.bool(forKey: "ZeroTemperature")
                print("FLAGG value ZeroTemperature :\(flag23)")
                tempratureGarphConstraint.constant = 0.0
                
                // Pulse
                
                let storyboard24 = UIStoryboard(name: "PHR", bundle: nil)
                let pulseChildVC: VitalsGraphViewViewController? = storyboard24.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
                pulseChildVC?.hmtType = "Pulse"
                pulseChildVC?.hmtTypeId = "4"
                pulseChildVC?.isVitalsComingFromMedicalSummary = true
                
                self.addChildViewController(pulseChildVC!)
                pulseChildVC?.didMove(toParentViewController: self)
                pulseChildVC?.view?.backgroundColor = UIColor.clear
                pulseChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                pulseViewControllerContainer.addSubview((pulseChildVC?.view)!)
                UserDefaults.standard.synchronize()
                pulseValueLbl.text = prefs.object(forKey: "PulseValue") as? String
                pulseDateLbl.text = prefs.object(forKey: "PulseDate") as? String
                prefs.synchronize()
                
                print("pulseValueLbl \(String(describing: pulseValueLbl.text))")
                print("pulseDateLbl \(String(describing: pulseDateLbl.text))")
                let flag24: Bool = prefs.bool(forKey: "ZeroPulse")
                print("FLAGG value ZeroPluse :\(flag24)")
                self.pluseGraphConstriant.constant = 0.0
                
                
                //CBG LIST
                
                let  storyboard1 = UIStoryboard(name: "PHR", bundle: nil)
                let cbgChildVC: CBGListViewController = storyboard1.instantiateViewController(withIdentifier: "CBGList") as! CBGListViewController
                
                cbgChildVC.isFromMedical = true
                
                self.addChildViewController(cbgChildVC)
                cbgChildVC.didMove(toParentViewController: self)
                cbgViewControllerContainer.addSubview(cbgChildVC.view)
                cbgChildVC.view.anchorToSuperview()
                let flag1: Bool = prefs.bool(forKey: "ZeroCBG")
                print("FLAGG value CBG:\(flag1)")
                cbgHeaderContainerHeight.constant = 0.0
                cbgContainerHeight.constant = 0.0
                
                //Hemoglobin List
                
                let storyboard2 = UIStoryboard(name: "PHR", bundle: nil)
                let hemoglobinChildVC: HemoglobinListViewController? = storyboard2.instantiateViewController(withIdentifier: "HemoglobinList") as? HemoglobinListViewController
                
                hemoglobinChildVC?.isFromMedical = true
                
                self.addChildViewController(hemoglobinChildVC!)
                hemoglobinChildVC?.didMove(toParentViewController: self)
                hemoglobinChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hemoglobinViewControllerContainer.frame.size.width, height: 150)
                hemoglobinViewControllerContainer.addSubview((hemoglobinChildVC?.view)!)
                hemoglobinChildVC?.view.anchorToSuperview()
                let flag2: Bool = prefs.bool(forKey: "ZeroHemoglobin")
                print("FLAGG value Hemoglobin:\(flag2)")
                hemoglobinContainerHeight.constant = 0.0
                hemoglobinHeaderHeight.constant = 0.0
                var newFrame: CGRect = hemoglobinheaderheightView.frame
                newFrame = CGRect(x: hemoglobinheaderheightView.frame.origin.x, y: hemoglobinheaderheightView.frame.origin.y, width: hemoglobinheaderheightView.frame.size.width, height: 0)
                hemoglobinheaderheightView.frame = newFrame
                
                //Hemogram List
                
                let storyboard3 = UIStoryboard(name: "PHR", bundle: nil)
                let hemogramChildVC: HemogramListViewController? = storyboard3.instantiateViewController(withIdentifier: "HemogramList") as? HemogramListViewController
                hemogramChildVC?.isFromMedical = true
                
                self.addChildViewController(hemogramChildVC!)
                hemogramChildVC?.didMove(toParentViewController: self)
                hemogramChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hemogramViewControllerContainer.frame.size.width, height: 150)
                hemogramViewControllerContainer.addSubview((hemogramChildVC?.view)!)
                hemogramChildVC?.view.anchorToSuperview()
                let flag3: Bool = prefs.bool(forKey: "ZeroHemogram")
                print("FLAGG value Hemogram:\(flag3)")
                hemogramContainerHeight.constant = 0.0
                hemogramHeaderHeight.constant = 0.0
                var newFramew: CGRect = hemogramheaderheightView.frame
                newFramew = CGRect(x: hemogramheaderheightView.frame.origin.x, y: hemogramheaderheightView.frame.origin.y, width: hemogramheaderheightView.frame.size.width, height: 0)
                hemogramheaderheightView.frame = newFramew
                
                // Serum
                
                let storyboard4 = UIStoryboard(name: "PHR", bundle: nil)
                let serumChildVC: SerumElectrolytesListViewController? = storyboard4.instantiateViewController(withIdentifier: "SerumElectrolytesList") as? SerumElectrolytesListViewController
                serumChildVC?.isFromMedical = true
                
                self.addChildViewController(serumChildVC!)
                serumChildVC?.didMove(toParentViewController: self)
                serumChildVC?.view?.frame = CGRect(x: 0, y: -10, width: serumElectrolyteViewControllerContainer.frame.size.width, height: 150)
                serumElectrolyteViewControllerContainer.addSubview((serumChildVC?.view)!)
                serumChildVC?.view.anchorToSuperview()
                let flag4: Bool = prefs.bool(forKey: "ZeroSerum")
                print("FLAGG value Serum:\(flag4)")
                serumContainerHeight.constant = 0.0
                serumHeaderHeight.constant = 0.0
                var newFrameb: CGRect = serumheaderheightView.frame
                newFrameb = CGRect(x: serumheaderheightView.frame.origin.x, y: serumheaderheightView.frame.origin.y, width: serumheaderheightView.frame.size.width, height: 0)
                serumheaderheightView.frame = newFrameb
                
                //Consultation
                
                let storyboard5 = UIStoryboard(name: "PHR", bundle: nil)
                let consultationChildVC: ConsultationListViewController? = storyboard5.instantiateViewController(withIdentifier: "ConsultationList") as? ConsultationListViewController
                consultationChildVC?.isFromMedical = true
                
                self.addChildViewController(consultationChildVC!)
                consultationChildVC?.didMove(toParentViewController: self)
                consultationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: consultationViewControllerContainer.frame.size.width, height: 150)
                consultationViewControllerContainer.addSubview((consultationChildVC?.view)!)
                consultationChildVC?.view.anchorToSuperview()
                let flag5: Bool = prefs.bool(forKey: "ZeroConsultation")
                print("FLAGG value flag5:\(flag5)")
                consultionTitleHeightConstriant.constant = 0.0
                consultionHeightConstraint.constant = 0.0
                var newFramec: CGRect = consultiontitleheightconstraintView.frame
                newFramec = CGRect(x: consultiontitleheightconstraintView.frame.origin.x, y: consultiontitleheightconstraintView.frame.origin.y, width: consultiontitleheightconstraintView.frame.size.width, height: 0)
                consultiontitleheightconstraintView.frame = newFramec
                
                // Conditions
                
                let storyboard6 = UIStoryboard(name: "PHR", bundle: nil)
                let conditionChildVC: ConditionListViewController? = storyboard6.instantiateViewController(withIdentifier: "ConditionList") as? ConditionListViewController
                conditionChildVC?.isFromMedical = true
                self.addChildViewController(conditionChildVC!)
                
                conditionChildVC?.didMove(toParentViewController: self)
                conditionChildVC?.view?.frame = CGRect(x: 0, y: -10, width: conditionViewControllerContainer.frame.size.width, height: 150)
                conditionViewControllerContainer.addSubview((conditionChildVC?.view)!)
                conditionChildVC?.view.anchorToSuperview()
                let flag6: Bool = prefs.bool(forKey: "ZeroCondition")
                print("FLAGG value flag6:\(flag6)")
                conditionTitleHeightConstriant.constant = 0.0
                conditionHeightConstriant.constant = 0.0
                var newFramed: CGRect = conditiontitleheightconstraintView.frame
                newFramed = CGRect(x: conditiontitleheightconstraintView.frame.origin.x, y: conditiontitleheightconstraintView.frame.origin.y, width: conditiontitleheightconstraintView.frame.size.width, height: 0)
                
                conditiontitleheightconstraintView.frame = newFramed
                
                // Immunization
                
                let storyboard7 = UIStoryboard(name: "PHR", bundle: nil)
                let immunizationChildVC: ImmunizationsListViewController? = storyboard7.instantiateViewController(withIdentifier: "ImmunizationsList") as? ImmunizationsListViewController
                immunizationChildVC?.isFromMedical = true
                self.addChildViewController(immunizationChildVC!)
                
                immunizationChildVC?.didMove(toParentViewController: self)
                immunizationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: immunizationViewControllerContainer.frame.size.width, height: 150)
                immunizationViewControllerContainer.addSubview((immunizationChildVC?.view)!)
                immunizationChildVC?.view.anchorToSuperview()
                let flag7: Bool = prefs.bool(forKey: "ZeroImmunization")
                print("FLAGG value flag7:\(flag7)")
                immunizationTitleHeightConstriant.constant = 0.0
                immunizationHeightConstriant.constant = 0.0
                var newFramee: CGRect = immunizationtitleheightconstraintView.frame
                newFramee = CGRect(x: immunizationtitleheightconstraintView.frame.origin.x, y: immunizationtitleheightconstraintView.frame.origin.y, width: immunizationtitleheightconstraintView.frame.size.width, height: 0)
                immunizationtitleheightconstraintView.frame = newFramee
                
                //Surgery List
                
                let storyboard8 = UIStoryboard(name: "PHR", bundle: nil)
                let surgeryChildVC: SurgeryListViewController? = storyboard8.instantiateViewController(withIdentifier: "SurgeriesList") as? SurgeryListViewController
                surgeryChildVC?.isFromMedical = true
                
                self.addChildViewController(surgeryChildVC!)
                surgeryChildVC?.didMove(toParentViewController: self)
                surgeryChildVC?.view?.frame = CGRect(x: 0, y: -10, width: surgeriesViewControllerContainer.frame.size.width, height: 150)
                surgeriesViewControllerContainer.addSubview((surgeryChildVC?.view)!)
                surgeryChildVC?.view.anchorToSuperview()
                let flag8 = prefs.bool(forKey: "ZeroSurgery")
                print("FLAGG value Surgery:\(String(describing: flag8))")
                surgeriesTitleHeightConstriant.constant = 0.0
                surgeriesHeightConstriant.constant = 0.0
                var newFramef: CGRect = surgeriestitleheightconstraintView.frame
                newFramef = CGRect(x: surgeriestitleheightconstraintView.frame.origin.x, y: surgeriestitleheightconstraintView.frame.origin.y, width: surgeriestitleheightconstraintView.frame.size.width, height: 0)
                surgeriestitleheightconstraintView.frame = newFramef
                
                //Medication List
                
                let storyboard9 = UIStoryboard(name: "PHR", bundle: nil)
                let medicationChildVC: MedicationListViewController? = storyboard9.instantiateViewController(withIdentifier: "MedicationsList") as? MedicationListViewController
                medicationChildVC?.isFromMedical = true
                
                self.addChildViewController(medicationChildVC!)
                
                medicationChildVC?.didMove(toParentViewController: self)
                medicationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: medicationsViewControllerContainer.frame.size.width, height: 150)
                medicationsViewControllerContainer.addSubview((medicationChildVC?.view)!)
                medicationChildVC?.view.anchorToSuperview()
                let flag9 = prefs.bool(forKey: "ZeroMedication")
                print("FLAGG value Medication:\(String(describing: flag9))")
                medicationTitleHeightConstriant.constant = 0.0
                medicationHeightConstriant.constant = 0.0
                var newFrameg: CGRect = medicationtitleheightconstraintView.frame
                newFrameg = CGRect(x: medicationtitleheightconstraintView.frame.origin.x, y: medicationtitleheightconstraintView.frame.origin.y, width: medicationtitleheightconstraintView.frame.size.width, height: 0)
                medicationtitleheightconstraintView.frame = newFrameg
                
                
                //Allergy List
                let storyboard10 = UIStoryboard(name: "PHR", bundle: nil)
                let allergyChildVC: AllergiesListViewController? = storyboard10.instantiateViewController(withIdentifier: "AllergiesList") as? AllergiesListViewController
                allergyChildVC?.isFromMedical = true
                
                self.addChildViewController(allergyChildVC!)
                
                allergyChildVC?.didMove(toParentViewController: self)
                allergyChildVC?.view?.frame = CGRect(x: 0, y: -10, width: allergyViewControllerContainer.frame.size.width, height: 150)
                allergyViewControllerContainer.addSubview((allergyChildVC?.view)!)
                allergyChildVC?.view.anchorToSuperview()
                let flag10: Bool = prefs.bool(forKey: "ZeroAllergy")
                print("FLAGG value Allergy:\(flag10)")
                allgeryHeightConstraint.constant = 0.0
                allgeryTitleHeightConstriant.constant = 0.0
                var newFrameh: CGRect = allgerytitleheightconstraintView.frame
                newFrameh = CGRect(x: allgerytitleheightconstraintView.frame.origin.x, y: allgerytitleheightconstraintView.frame.origin.y, width: allgerytitleheightconstraintView.frame.size.width, height: 0)
                allgerytitleheightconstraintView.frame = newFrameh
                
                //Hospitalization List
                
                let storyboard11 = UIStoryboard(name: "PHR", bundle: nil)
                let hospitalizationChildVC: HospitalizationsListViewController? = storyboard11.instantiateViewController(withIdentifier: "HospitalizationList") as? HospitalizationsListViewController
                hospitalizationChildVC?.isFromMedical = true
                
                self.addChildViewController(hospitalizationChildVC!)
                
                hospitalizationChildVC?.didMove(toParentViewController: self)
                hospitalizationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hospitalizationViewControllerContainer.frame.size.width, height: 150)
                hospitalizationViewControllerContainer.addSubview((hospitalizationChildVC?.view)!)
                hospitalizationChildVC?.view.anchorToSuperview()
                let flag11: Bool = prefs.bool(forKey: "ZeroHospitalization")
                print("FLAGG value Hospitalization:\(flag11)")
                hospitalizationTitleHeightConstriant.constant = 0.0
                hospitalizationHeightConstriant.constant = 0.0
                var newFramei: CGRect = hospitalizationtitleheightconstraintView.frame
                newFramei = CGRect(x: hospitalizationtitleheightconstraintView.frame.origin.x, y: hospitalizationtitleheightconstraintView.frame.origin.y, width: hospitalizationtitleheightconstraintView.frame.size.width, height: 0)
                hospitalizationtitleheightconstraintView.frame = newFramei
                
                //Food Plan List
                
                let storyboard12 = UIStoryboard(name: "PHR", bundle: nil)
                let foodPlanChildVC: FoodPlanListViewController? = storyboard12.instantiateViewController(withIdentifier: "FoodPlanList") as? FoodPlanListViewController
                foodPlanChildVC?.isFromMedical = true
                
                self.addChildViewController(foodPlanChildVC!)
                
                foodPlanChildVC?.didMove(toParentViewController: self)
                foodPlanChildVC?.view?.frame = CGRect(x: 0, y: -10, width: foodPlanViewControllerContainer.frame.size.width, height: 150)
                foodPlanViewControllerContainer.addSubview((foodPlanChildVC?.view)!)
                foodPlanChildVC?.view.anchorToSuperview()
                let flag12: Bool = prefs.bool(forKey: "ZeroFoodPlan")
                print("FLAGG value Food Plan:\(flag12)")
                foodPlanTitleHeightConstriant.constant = 0.0
                foodPlanHeightConstriant.constant = 0.0
                var newFramej: CGRect = foodplantitleheightconstraintView.frame
                newFramej = CGRect(x: foodplantitleheightconstraintView.frame.origin.x, y: foodplantitleheightconstraintView.frame.origin.y, width: foodplantitleheightconstraintView.frame.size.width, height: 0)
                foodplantitleheightconstraintView.frame = newFramej
                
                
                // Documents List
                
                let storyboard13 = UIStoryboard(name: "PHR", bundle: nil)
                let documentListChildVC: DocumentsListViewController = storyboard13.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController
                documentListChildVC.isFromMedical = true
                
                self.addChildViewController(documentListChildVC)
                
                documentListChildVC.didMove(toParentViewController: self)
                documentListChildVC.view.frame = CGRect(x: 0, y: -10, width:documentViewControllerContainer.frame.size.width, height: 150)
                documentViewControllerContainer.addSubview(documentListChildVC.view)
                documentListChildVC.view.anchorToSuperview()
                let flag13: Bool = prefs.bool(forKey: "ZeroDocument")
                print("FLAGG value Document:\(flag13)")
                documentTitleHeightConstriant.constant = 0.0
                documentHeightConstriant.constant = 0.0
                var newFramek: CGRect = documenttitleheightconstraintView.frame
                newFramek = CGRect(x: documenttitleheightconstraintView.frame.origin.x, y: documenttitleheightconstraintView.frame.origin.y, width: documenttitleheightconstraintView.frame.size.width, height: 0)
                documenttitleheightconstraintView.frame = newFramek
                
                weightViewControllerContainer.isHidden = false
                heightViewControllerContainer.isHidden = false
                temperatureViewControllerContainer.isHidden = false
                pulseViewControllerContainer.isHidden = false
                cbgViewControllerContainer.isHidden = false
                hemoglobinViewControllerContainer.isHidden = false
                hemogramViewControllerContainer.isHidden = false
                serumElectrolyteViewControllerContainer.isHidden = false
                consultationViewControllerContainer.isHidden = false
                conditionViewControllerContainer.isHidden = false
                immunizationViewControllerContainer.isHidden = false
                surgeriesViewControllerContainer.isHidden = false
                medicationsViewControllerContainer.isHidden = false
                allergyViewControllerContainer.isHidden = false
                hospitalizationViewControllerContainer.isHidden = false
                foodPlanViewControllerContainer.isHidden = false
                documentViewControllerContainer.isHidden = false
                foodPlanViewControllerContainer.isHidden = false
            }
            else
            {
                weightViewControllerContainer.isHidden = true
                heightViewControllerContainer.isHidden = true
                temperatureViewControllerContainer.isHidden = true
                pulseViewControllerContainer.isHidden = true
                cbgViewControllerContainer.isHidden = true
                hemoglobinViewControllerContainer.isHidden = true
                hemogramViewControllerContainer.isHidden = true
                serumElectrolyteViewControllerContainer.isHidden = true
                consultationViewControllerContainer.isHidden = true
                conditionViewControllerContainer.isHidden = true
                immunizationViewControllerContainer.isHidden = true
                surgeriesViewControllerContainer.isHidden = true
                medicationsViewControllerContainer.isHidden = true
                allergyViewControllerContainer.isHidden = true
                hospitalizationViewControllerContainer.isHidden = true
                foodPlanViewControllerContainer.isHidden = true
                documentViewControllerContainer.isHidden = true
                foodPlanViewControllerContainer.isHidden = true
            }
        }
        else
        {
            let storyboard21 = UIStoryboard(name: "PHR", bundle: nil)
            let weightChildVC: VitalsGraphViewViewController? = storyboard21.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
            weightChildVC?.hmtTypeId = "2"
            weightChildVC?.hmtType = "Weight"
            weightChildVC?.isVitalsComingFromMedicalSummary = true
            self.addChildViewController(weightChildVC!)
            weightChildVC?.didMove(toParentViewController: self)
            weightChildVC?.view?.backgroundColor = UIColor.clear
            weightChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 370)
            weightViewControllerContainer.addSubview((weightChildVC?.view)!)
            let prefs = UserDefaults.standard
            UserDefaults.standard.synchronize()
            weightValueLbl.text = prefs.object(forKey:"WeightValue") as? String
            weightDateLbl.text = prefs.object(forKey: "WeightDate") as? String
            prefs.synchronize()
            
            let flag21: Bool = prefs.bool(forKey: "ZeroWeight")
            print("FLAGG value ZeroWeight :\(flag21)")
            weightGarphConstraint.constant = 0.0
            
            
            // Height
            
            let storyboard22 = UIStoryboard(name: "PHR", bundle: nil)
            let heightChildVC: VitalsGraphViewViewController? = storyboard22.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
            heightChildVC?.hmtType = "Height"
            heightChildVC?.hmtTypeId = "1"
            heightChildVC?.isVitalsComingFromMedicalSummary = true
            self.addChildViewController(heightChildVC!)
            heightChildVC?.didMove(toParentViewController: self)
            heightChildVC?.view?.backgroundColor = UIColor.clear
            heightChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 370)
            heightViewControllerContainer.addSubview((heightChildVC?.view)!)
            // NSUserDefaults *prefs2 = [NSUserDefaults standardUserDefaults];
            UserDefaults.standard.synchronize()
            heightValueLbl.text = prefs.object(forKey: "HeightValue") as? String
            heightDateLbl.text = prefs.object(forKey: "HeightDate") as? String
            prefs.synchronize()
            
            print("heightValueLbl \(String(describing: heightValueLbl.text))")
            let flag22: Bool = prefs.bool(forKey: "ZeroHeight")
            print("FLAGG value ZeroHeight :\(flag22)")
            heightGraphConstriant.constant = 0.0
            
            // Temperature
            
            let storyboard23 = UIStoryboard(name: "PHR", bundle: nil)
            let tempChildVC: VitalsGraphViewViewController? = storyboard23.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
            tempChildVC?.hmtType = "Temperature"
            tempChildVC?.hmtTypeId = "3"
            tempChildVC?.isVitalsComingFromMedicalSummary = true
            self.addChildViewController(tempChildVC!)
            tempChildVC?.didMove(toParentViewController: self)
            tempChildVC?.view?.backgroundColor = UIColor.clear
            tempChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 365)
            temperatureViewControllerContainer.addSubview((tempChildVC?.view)!)
            //    NSUserDefaults *prefs3 = [NSUserDefaults standardUserDefaults];
            UserDefaults.standard.synchronize()
            temperatureValueLbl.text = prefs.object(forKey: "TemperatureValue") as? String
            temperatureDateLbl.text = prefs.object(forKey: "TemperatureDate") as? String
            prefs.synchronize()
            
            print("temperatureValueLbl \(String(describing: temperatureValueLbl.text))")
            print("temperatureDateLbl \(String(describing: temperatureDateLbl.text))")
            let flag23: Bool = prefs.bool(forKey: "ZeroTemperature")
            print("FLAGG value ZeroTemperature :\(flag23)")
            tempratureGarphConstraint.constant = 0.0
            
            // Pulse
            
            let storyboard24 = UIStoryboard(name: "PHR", bundle: nil)
            let pulseChildVC: VitalsGraphViewViewController? = storyboard24.instantiateViewController(withIdentifier: "VitalsGraph") as? VitalsGraphViewViewController
            pulseChildVC?.hmtType = "Pulse"
            pulseChildVC?.hmtTypeId = "4"
            pulseChildVC?.isVitalsComingFromMedicalSummary = true
            self.addChildViewController(pulseChildVC!)
            pulseChildVC?.didMove(toParentViewController: self)
            pulseChildVC?.view?.backgroundColor = UIColor.clear
            pulseChildVC?.view?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            pulseViewControllerContainer.addSubview((pulseChildVC?.view)!)
            UserDefaults.standard.synchronize()
            pulseValueLbl.text = prefs.object(forKey: "PulseValue") as? String
            pulseDateLbl.text = prefs.object(forKey: "PulseDate") as? String
            prefs.synchronize()
            
            print("pulseValueLbl \(String(describing: pulseValueLbl.text))")
            print("pulseDateLbl \(String(describing: pulseDateLbl.text))")
            let flag24: Bool = prefs.bool(forKey: "ZeroPulse")
            print("FLAGG value ZeroPluse :\(flag24)")
            self.pluseGraphConstriant.constant = 0.0
            
            
            
            //CBG LIST
            
            let  storyboard1 = UIStoryboard(name: "PHR", bundle: nil)
            let cbgChildVC: CBGListViewController = storyboard1.instantiateViewController(withIdentifier: "CBGList") as! CBGListViewController
            
            cbgChildVC.isFromMedical = true
            self.addChildViewController(cbgChildVC)
            cbgChildVC.didMove(toParentViewController: self)
            cbgViewControllerContainer.addSubview(cbgChildVC.view)
            cbgChildVC.view.anchorToSuperview()
            let flag1: Bool = prefs.bool(forKey: "ZeroCBG")
            print("FLAGG value CBG:\(flag1)")
            cbgHeaderContainerHeight.constant = 0.0
            cbgContainerHeight.constant = 0.0
            
            //Hemoglobin List
            
            let storyboard2 = UIStoryboard(name: "PHR", bundle: nil)
            let hemoglobinChildVC: HemoglobinListViewController? = storyboard2.instantiateViewController(withIdentifier: "HemoglobinList") as? HemoglobinListViewController
            
            hemoglobinChildVC?.isFromMedical = true
            self.addChildViewController(hemoglobinChildVC!)
            hemoglobinChildVC?.didMove(toParentViewController: self)
            hemoglobinChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hemoglobinViewControllerContainer.frame.size.width, height: 150)
            hemoglobinViewControllerContainer.addSubview((hemoglobinChildVC?.view)!)
            hemoglobinChildVC?.view.anchorToSuperview()
            let flag2: Bool = prefs.bool(forKey: "ZeroHemoglobin")
            print("FLAGG value Hemoglobin:\(flag2)")
            hemoglobinContainerHeight.constant = 0.0
            hemoglobinHeaderHeight.constant = 0.0
            var newFrame: CGRect = hemoglobinheaderheightView.frame
            newFrame = CGRect(x: hemoglobinheaderheightView.frame.origin.x, y: hemoglobinheaderheightView.frame.origin.y, width: hemoglobinheaderheightView.frame.size.width, height: 0)
            hemoglobinheaderheightView.frame = newFrame
            
            //Hemogram List
            
            let storyboard3 = UIStoryboard(name: "PHR", bundle: nil)
            let hemogramChildVC: HemogramListViewController? = storyboard3.instantiateViewController(withIdentifier: "HemogramList") as? HemogramListViewController
            hemogramChildVC?.isFromMedical = true
            self.addChildViewController(hemogramChildVC!)
            hemogramChildVC?.didMove(toParentViewController: self)
            hemogramChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hemogramViewControllerContainer.frame.size.width, height: 150)
            hemogramViewControllerContainer.addSubview((hemogramChildVC?.view)!)
            hemogramChildVC?.view.anchorToSuperview()
            let flag3: Bool = prefs.bool(forKey: "ZeroHemogram")
            print("FLAGG value Hemogram:\(flag3)")
            hemogramContainerHeight.constant = 0.0
            hemogramHeaderHeight.constant = 0.0
            var newFramew: CGRect = hemogramheaderheightView.frame
            newFramew = CGRect(x: hemogramheaderheightView.frame.origin.x, y: hemogramheaderheightView.frame.origin.y, width: hemogramheaderheightView.frame.size.width, height: 0)
            hemogramheaderheightView.frame = newFramew
            
            
            // Serum
            
            let storyboard4 = UIStoryboard(name: "PHR", bundle: nil)
            let serumChildVC: SerumElectrolytesListViewController? = storyboard4.instantiateViewController(withIdentifier: "SerumElectrolytesList") as? SerumElectrolytesListViewController
            serumChildVC?.isFromMedical = true
            self.addChildViewController(serumChildVC!)
            serumChildVC?.didMove(toParentViewController: self)
            serumChildVC?.view?.frame = CGRect(x: 0, y: -10, width: serumElectrolyteViewControllerContainer.frame.size.width, height: 150)
            serumElectrolyteViewControllerContainer.addSubview((serumChildVC?.view)!)
            serumChildVC?.view.anchorToSuperview()
            let flag4: Bool = prefs.bool(forKey: "ZeroSerum")
            print("FLAGG value Serum:\(flag4)")
            serumContainerHeight.constant = 0.0
            serumHeaderHeight.constant = 0.0
            var newFrameb: CGRect = serumheaderheightView.frame
            newFrameb = CGRect(x: serumheaderheightView.frame.origin.x, y: serumheaderheightView.frame.origin.y, width: serumheaderheightView.frame.size.width, height: 0)
            serumheaderheightView.frame = newFrameb
            
            //Consultation
            
            let storyboard5 = UIStoryboard(name: "PHR", bundle: nil)
            let consultationChildVC: ConsultationListViewController? = storyboard5.instantiateViewController(withIdentifier: "ConsultationList") as? ConsultationListViewController
            consultationChildVC?.isFromMedical = true
            
            self.addChildViewController(consultationChildVC!)
            
            consultationChildVC?.didMove(toParentViewController: self)
            consultationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: consultationViewControllerContainer.frame.size.width, height: 150)
            consultationViewControllerContainer.addSubview((consultationChildVC?.view)!)
            consultationChildVC?.view.anchorToSuperview()
            let flag5: Bool = prefs.bool(forKey: "ZeroConsultation")
            print("FLAGG value flag5:\(flag5)")
            consultionTitleHeightConstriant.constant = 0.0
            consultionHeightConstraint.constant = 0.0
            var newFramec: CGRect = consultiontitleheightconstraintView.frame
            newFramec = CGRect(x: consultiontitleheightconstraintView.frame.origin.x, y: consultiontitleheightconstraintView.frame.origin.y, width: consultiontitleheightconstraintView.frame.size.width, height: 0)
            consultiontitleheightconstraintView.frame = newFramec
            
            // condition List
            let storyboard6 = UIStoryboard(name: "PHR", bundle: nil)
            let conditionChildVC: ConditionListViewController? = storyboard6.instantiateViewController(withIdentifier: "ConditionList") as? ConditionListViewController
            conditionChildVC?.isFromMedical = true
            self.addChildViewController(conditionChildVC!)
            conditionChildVC?.view?.frame = CGRect(x: 0, y: -10, width: conditionViewControllerContainer.frame.size.width, height: 150)
            conditionViewControllerContainer.addSubview((conditionChildVC?.view)!)
            conditionChildVC?.view.anchorToSuperview()
            conditionChildVC?.didMove(toParentViewController: self)
            let flag6: Bool = prefs.bool(forKey: "ZeroCondition")
            print("FLAGG value flag6:\(flag6)")
            conditionTitleHeightConstriant.constant = 0.0
            conditionHeightConstriant.constant = 0.0
            var newFramed: CGRect = conditiontitleheightconstraintView.frame
            newFramed = CGRect(x: conditiontitleheightconstraintView.frame.origin.x, y: conditiontitleheightconstraintView.frame.origin.y, width: conditiontitleheightconstraintView.frame.size.width, height: 0)
            conditiontitleheightconstraintView.frame = newFramed
            
            // Immunization
            
            let storyboard7 = UIStoryboard(name: "PHR", bundle: nil)
            let immunizationChildVC: ImmunizationsListViewController? = storyboard7.instantiateViewController(withIdentifier: "ImmunizationsList") as? ImmunizationsListViewController
            immunizationChildVC?.isFromMedical = true
            
            self.addChildViewController(immunizationChildVC!)
            
            immunizationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: immunizationViewControllerContainer.frame.size.width, height: 150)
            immunizationViewControllerContainer.addSubview((immunizationChildVC?.view)!)
            immunizationChildVC?.view.anchorToSuperview()
            immunizationChildVC?.didMove(toParentViewController: self)
            let flag7: Bool = prefs.bool(forKey: "ZeroImmunization")
            print("FLAGG value flag7:\(flag7)")
            immunizationTitleHeightConstriant.constant = 0.0
            immunizationHeightConstriant.constant = 0.0
            var newFramee: CGRect = immunizationtitleheightconstraintView.frame
            newFramee = CGRect(x: immunizationtitleheightconstraintView.frame.origin.x, y: immunizationtitleheightconstraintView.frame.origin.y, width: immunizationtitleheightconstraintView.frame.size.width, height: 0)
            immunizationtitleheightconstraintView.frame = newFramee
            
            //Surgery List
            
            let storyboard8 = UIStoryboard(name: "PHR", bundle: nil)
            let surgeryChildVC: SurgeryListViewController? = storyboard8.instantiateViewController(withIdentifier: "SurgeriesList") as? SurgeryListViewController
            surgeryChildVC?.isFromMedical = true
            self.addChildViewController(surgeryChildVC!)
            
            surgeryChildVC?.didMove(toParentViewController: self)
            surgeryChildVC?.view?.frame = CGRect(x: 0, y: -10, width: surgeriesViewControllerContainer.frame.size.width, height: 150)
            surgeriesViewControllerContainer.addSubview((surgeryChildVC?.view)!)
            surgeryChildVC?.view.anchorToSuperview()
            let flag8 = prefs.bool(forKey: "ZeroSurgery")
            print("FLAGG value Surgery:\(String(describing: flag8))")
            surgeriesTitleHeightConstriant.constant = 0.0
            surgeriesHeightConstriant.constant = 0.0
            var newFramef: CGRect = surgeriestitleheightconstraintView.frame
            newFramef = CGRect(x: surgeriestitleheightconstraintView.frame.origin.x, y: surgeriestitleheightconstraintView.frame.origin.y, width: surgeriestitleheightconstraintView.frame.size.width, height: 0)
            surgeriestitleheightconstraintView.frame = newFramef
            
            //Medication List
            
            let storyboard9 = UIStoryboard(name: "PHR", bundle: nil)
            let medicationChildVC: MedicationListViewController? = storyboard9.instantiateViewController(withIdentifier: "MedicationsList") as? MedicationListViewController
            medicationChildVC?.isFromMedical = true
            
            self.addChildViewController(medicationChildVC!)
            medicationChildVC?.didMove(toParentViewController: self)
            medicationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: medicationsViewControllerContainer.frame.size.width, height: 150)
            medicationsViewControllerContainer.addSubview((medicationChildVC?.view)!)
            medicationChildVC?.view.anchorToSuperview()
            let flag9 = prefs.bool(forKey: "ZeroMedication")
            print("FLAGG value Medication:\(String(describing: flag9))")
            medicationTitleHeightConstriant.constant = 0.0
            medicationHeightConstriant.constant = 0.0
            var newFrameg: CGRect = medicationtitleheightconstraintView.frame
            newFrameg = CGRect(x: medicationtitleheightconstraintView.frame.origin.x, y: medicationtitleheightconstraintView.frame.origin.y, width: medicationtitleheightconstraintView.frame.size.width, height: 0)
            medicationtitleheightconstraintView.frame = newFrameg
            
            
            //Allergy List
            let storyboard10 = UIStoryboard(name: "PHR", bundle: nil)
            let allergyChildVC: AllergiesListViewController? = storyboard10.instantiateViewController(withIdentifier: "AllergiesList") as? AllergiesListViewController
            allergyChildVC?.isFromMedical = true
            
            self.addChildViewController(allergyChildVC!)
            allergyChildVC?.didMove(toParentViewController: self)
            allergyChildVC?.view?.frame = CGRect(x: 0, y: -10, width: allergyViewControllerContainer.frame.size.width, height: 150)
            allergyViewControllerContainer.addSubview((allergyChildVC?.view)!)
            allergyChildVC?.view.anchorToSuperview()
            let flag10: Bool = prefs.bool(forKey: "ZeroAllergy")
            print("FLAGG value Allergy:\(flag10)")
            allgeryHeightConstraint.constant = 0.0
            allgeryTitleHeightConstriant.constant = 0.0
            var newFrameh: CGRect = allgerytitleheightconstraintView.frame
            newFrameh = CGRect(x: allgerytitleheightconstraintView.frame.origin.x, y: allgerytitleheightconstraintView.frame.origin.y, width: allgerytitleheightconstraintView.frame.size.width, height: 0)
            allgerytitleheightconstraintView.frame = newFrameh
            
            //Hospitalization List
            
            let storyboard11 = UIStoryboard(name: "PHR", bundle: nil)
            let hospitalizationChildVC: HospitalizationsListViewController? = storyboard11.instantiateViewController(withIdentifier: "HospitalizationList") as? HospitalizationsListViewController
            hospitalizationChildVC?.isFromMedical = true
            
            self.addChildViewController(hospitalizationChildVC!)
            hospitalizationChildVC?.didMove(toParentViewController: self)
            hospitalizationChildVC?.view?.frame = CGRect(x: 0, y: -10, width: hospitalizationViewControllerContainer.frame.size.width, height: 150)
            hospitalizationViewControllerContainer.addSubview((hospitalizationChildVC?.view)!)
            hospitalizationChildVC?.view.anchorToSuperview()
            let flag11: Bool = prefs.bool(forKey: "ZeroHospitalization")
            print("FLAGG value Hospitalization:\(flag11)")
            hospitalizationTitleHeightConstriant.constant = 0.0
            hospitalizationHeightConstriant.constant = 0.0
            var newFramei: CGRect = hospitalizationtitleheightconstraintView.frame
            newFramei = CGRect(x: hospitalizationtitleheightconstraintView.frame.origin.x, y: hospitalizationtitleheightconstraintView.frame.origin.y, width: hospitalizationtitleheightconstraintView.frame.size.width, height: 0)
            hospitalizationtitleheightconstraintView.frame = newFramei
            hospitalizationViewControllerContainer.isHidden = false
            
            //Food Plan List
            
            let storyboard12 = UIStoryboard(name: "PHR", bundle: nil)
            let foodPlanChildVC: FoodPlanListViewController? = storyboard12.instantiateViewController(withIdentifier: "FoodPlanList") as? FoodPlanListViewController
            foodPlanChildVC?.isFromMedical = true
            
            self.addChildViewController(foodPlanChildVC!)
            foodPlanChildVC?.didMove(toParentViewController: self)
            foodPlanChildVC?.view?.frame = CGRect(x: 0, y: -10, width: foodPlanViewControllerContainer.frame.size.width, height: 150)
            foodPlanViewControllerContainer.addSubview((foodPlanChildVC?.view)!)
            foodPlanChildVC?.view.anchorToSuperview()
            let flag12: Bool = prefs.bool(forKey: "ZeroFoodPlan")
            print("FLAGG value Food Plan:\(flag12)")
            foodPlanTitleHeightConstriant.constant = 0.0
            foodPlanHeightConstriant.constant = 0.0
            var newFramej: CGRect = foodplantitleheightconstraintView.frame
            newFramej = CGRect(x: foodplantitleheightconstraintView.frame.origin.x, y: foodplantitleheightconstraintView.frame.origin.y, width: foodplantitleheightconstraintView.frame.size.width, height: 0)
            foodplantitleheightconstraintView.frame = newFramej
            foodPlanViewControllerContainer.isHidden = false
            
            // Documents List
            
            let storyboard13 = UIStoryboard(name: "PHR", bundle: nil)
            let documentListChildVC: DocumentsListViewController = storyboard13.instantiateViewController(withIdentifier: "DocumentsList") as! DocumentsListViewController
            documentListChildVC.isFromMedical = true
            
            self.addChildViewController(documentListChildVC)
            documentListChildVC.didMove(toParentViewController: self)
            documentListChildVC.view.frame = CGRect(x: 0, y: -10, width:documentViewControllerContainer.frame.size.width, height: 150)
            documentViewControllerContainer.addSubview(documentListChildVC.view)
            documentListChildVC.view.anchorToSuperview()
            let flag13: Bool = prefs.bool(forKey: "ZeroDocument")
            print("FLAGG value Document:\(flag13)")
            documentTitleHeightConstriant.constant = 0.0
            documentHeightConstriant.constant = 0.0
            var newFramek: CGRect = documenttitleheightconstraintView.frame
            newFramek = CGRect(x: documenttitleheightconstraintView.frame.origin.x, y: documenttitleheightconstraintView.frame.origin.y, width: documenttitleheightconstraintView.frame.size.width, height: 0)
            documenttitleheightconstraintView.frame = newFramek
        }
        if shared
        {
            let shareCont: Bool = UserDefaults.standard.bool(forKey: "ShareCont")
            if shareCont
            {
                let storyboard25 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let onlineEmrChildVC: EmergencyContactsListViewController? = storyboard25.instantiateViewController(withIdentifier: "EmergencyList") as? EmergencyContactsListViewController
                onlineEmrChildVC?.isFromMedical = true
                
                self.addChildViewController(onlineEmrChildVC!)
                onlineEmrChildVC?.didMove(toParentViewController: self)
                let prefs = UserDefaults.standard
                UserDefaults.standard.synchronize()
                onlineEmrChildVC?.view?.frame = CGRect(x: 0, y: -10, width: emergencyContactViewControllerContainer.frame.size.width, height: 120)
                emergencyContactViewControllerContainer.addSubview((onlineEmrChildVC?.view)!)
                onlineEmrChildVC?.view.anchorToSuperview()
                let flag14: Bool = prefs.bool(forKey: "ZeroEmergencyContact")
                print("FLAGG value Emergency Contact:\(flag14)")
                emergencyTitleHeightConstriant.constant = 0.0
                emergencyHeightConstriant.constant = 0.0
                let newFramel: CGRect = emergencytitleheightconstraintView.frame
                emergencytitleheightconstraintView.frame = newFramel
                emergencyContactViewControllerContainer.isHidden = false
            }
            else
            {
                emergencyContactViewControllerContainer.isHidden = true
            }
        }
        else
        {
            // Emergency contacts
            
            //Emergency Contact List
            
            let storyboard25 = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let onlineEmrChildVC: EmergencyContactsListViewController? = storyboard25.instantiateViewController(withIdentifier: "EmergencyList") as? EmergencyContactsListViewController
            onlineEmrChildVC?.isFromMedical = true
            
            self.addChildViewController(onlineEmrChildVC!)
            onlineEmrChildVC?.didMove(toParentViewController: self)
            onlineEmrChildVC?.view?.frame = CGRect(x: 0, y: -10, width: emergencyContactViewControllerContainer.frame.size.width, height: 120)
            let prefs = UserDefaults.standard
            UserDefaults.standard.synchronize()
            emergencyContactViewControllerContainer.addSubview((onlineEmrChildVC?.view)!)
            onlineEmrChildVC?.view.anchorToSuperview()
            let flag14: Bool = prefs.bool(forKey: "ZeroEmergencyContact")
            print("FLAGG value Emergency Contact:\(flag14)")
            emergencyTitleHeightConstriant.constant = 0.0
            emergencyHeightConstriant.constant = 0.0
            let newFramel: CGRect = emergencytitleheightconstraintView.frame
            emergencytitleheightconstraintView.frame = newFramel
            emergencyContactViewControllerContainer.isHidden = false
        }
        // Veterinarins
        if shared
        {
            let shareVet: Bool = UserDefaults.standard.bool(forKey: "ShareVets")
            if shareVet
            {
                let storyboard14 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let vetChildVC: VeterinarianListViewController? = storyboard14.instantiateViewController(withIdentifier: "vetList") as? VeterinarianListViewController
                vetChildVC?.isFromMedical = true
                
                self.addChildViewController(vetChildVC!)
                vetChildVC?.didMove(toParentViewController: self)
                vetChildVC?.view?.frame = CGRect(x: 0, y: -10, width: veterinarianViewControllerContainer.frame.size.width, height: 150)
                // [vetChildVC.view setBackgroundColor:[UIColor redColor]];
                let prefs = UserDefaults.standard
                UserDefaults.standard.synchronize()
                veterinarianViewControllerContainer.addSubview((vetChildVC?.view)!)
                vetChildVC?.view.anchorToSuperview()
                let flag15: Bool = prefs.bool(forKey: "ZeroVeterinarian")
                print("FLAGG value Vet:\(flag15)")
                vetetinarianTitleHeightConstriant.constant = 0.0
                vetetinarianHeightConstriant.constant = 0.0
                var newFramem: CGRect = vetetinariantitleheightconstraintView.frame
                newFramem = CGRect(x: vetetinariantitleheightconstraintView.frame.origin.x, y: vetetinariantitleheightconstraintView.frame.origin.y, width: vetetinariantitleheightconstraintView.frame.size.width, height: 0)
                vetetinariantitleheightconstraintView.frame = newFramem
                veterinarianViewControllerContainer.isHidden = false
            }
            else
            {
                veterinarianViewControllerContainer.isHidden = true
            }
        }
        else
        {
            let storyboard14 = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let vetChildVC: VeterinarianListViewController? = storyboard14.instantiateViewController(withIdentifier: "vetList") as? VeterinarianListViewController
            vetChildVC?.isFromMedical = true
            
            self.addChildViewController(vetChildVC!)
            vetChildVC?.didMove(toParentViewController: self)
            vetChildVC?.view?.frame = CGRect(x: 0, y: -10, width: veterinarianViewControllerContainer.frame.size.width, height: 150)
            // [vetChildVC.view setBackgroundColor:[UIColor redColor]];
            let prefs = UserDefaults.standard
            UserDefaults.standard.synchronize()
            veterinarianViewControllerContainer.addSubview((vetChildVC?.view)!)
            vetChildVC?.view.anchorToSuperview()
            let flag15: Bool = prefs.bool(forKey: "ZeroVeterinarian")
            print("FLAGG value Vet:\(flag15)")
            vetetinarianTitleHeightConstriant.constant = 0.0
            vetetinarianHeightConstriant.constant = 0.0
            var newFramem: CGRect = vetetinariantitleheightconstraintView.frame
            newFramem = CGRect(x: vetetinariantitleheightconstraintView.frame.origin.x, y: vetetinariantitleheightconstraintView.frame.origin.y, width: vetetinariantitleheightconstraintView.frame.size.width, height: 0)
            vetetinariantitleheightconstraintView.frame = newFramem
            veterinarianViewControllerContainer.isHidden = false
        }
        
        
        
        // Insurance List
        if shared
        {
            let shareId: Bool = UserDefaults.standard.bool(forKey: "ShareId")
            if shareId
            {
                let storyboard15 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let insuranceChildVC: PetInsuranceListViewController? = storyboard15.instantiateViewController(withIdentifier: "insurancelist") as? PetInsuranceListViewController
                insuranceChildVC?.isFromMedical = true
                
                self.addChildViewController(insuranceChildVC!)
                insuranceChildVC?.didMove(toParentViewController: self)
                insuranceChildVC?.view?.frame = CGRect(x: 0, y: -10, width: insuranceViewControllerContainer.frame.size.width, height: 150)
                insuranceViewControllerContainer.addSubview((insuranceChildVC?.view)!)
                insuranceChildVC?.view.anchorToSuperview()
                let prefs = UserDefaults.standard
                UserDefaults.standard.synchronize()
                let flag16: Bool = prefs.bool(forKey: "ZeroInsurance")
                print("FLAGG value Insurance:\(flag16)")
                insuranceTitleHeightConstriant.constant = 0.0
                insuranceHeightConstriant.constant = 0.0
                var newFramen: CGRect = insurancetitleheightconstraintView.frame
                newFramen = CGRect(x: insurancetitleheightconstraintView.frame.origin.x, y: insurancetitleheightconstraintView.frame.origin.y, width: insurancetitleheightconstraintView.frame.size.width, height: 0)
                insurancetitleheightconstraintView.frame = newFramen
                insuranceViewControllerContainer.isHidden = false
            }
            else
            {
                insuranceViewControllerContainer.isHidden = true
            }
        }
        else
        {
            let storyboard15 = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let insuranceChildVC: PetInsuranceListViewController? = storyboard15.instantiateViewController(withIdentifier: "insurancelist") as? PetInsuranceListViewController
            insuranceChildVC?.isFromMedical = true
            
            self.addChildViewController(insuranceChildVC!)
            insuranceChildVC?.didMove(toParentViewController: self)
            insuranceChildVC?.view?.frame = CGRect(x: 0, y: -10, width: insuranceViewControllerContainer.frame.size.width, height: 150)
            insuranceViewControllerContainer.addSubview((insuranceChildVC?.view)!)
            insuranceChildVC?.view.anchorToSuperview()
            let prefs = UserDefaults.standard
            UserDefaults.standard.synchronize()
            let flag16: Bool = prefs.bool(forKey: "ZeroInsurance")
            print("FLAGG value Insurance:\(flag16)")
            insuranceTitleHeightConstriant.constant = 0.0
            insuranceHeightConstriant.constant = 0.0
            var newFramen: CGRect = insurancetitleheightconstraintView.frame
            newFramen = CGRect(x: insurancetitleheightconstraintView.frame.origin.x, y: insurancetitleheightconstraintView.frame.origin.y, width: insurancetitleheightconstraintView.frame.size.width, height: 0)
            insurancetitleheightconstraintView.frame = newFramen
            insuranceViewControllerContainer.isHidden = false
        }
        
        pref.synchronize()
        
        MBProgressHUD.hide(for:self.view, animated: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // self.hasViewLoaded = false
        //        if hasViewLoaded == false
        //        {
        self.infoSegC.selectedSegmentIndex = 0
        let pref = UserDefaults.standard
        petNameLbl.text = pref.string(forKey: "PetName")
        petBloodLbl.text = pref.string(forKey: "PetBlood")
        petGenderLbl.text = pref.string(forKey: "PetGender")
        petDobLbl.text = pref.string(forKey: "PetDob")
        petTypeLbl.text = pref.string(forKey: "PetType")
        if petTypeLbl.text == "Other"
        {
            petTypeLbl.text = pref.string(forKey: "PetType")!  + String(format: "(%@)", pref.string(forKey: "PetTypeOther")! )
            
        }
        else
        {
            petTypeLbl.text = pref.value(forKey: "PetType") as? String
        }
        
        let str = pref.string(forKey: "PetProfile")
        petProfileImgVW.sd_setImage(with: URL(string: str!), placeholderImage: UIImage(named: "petImage-default.png"), options: SDWebImageOptions(rawValue: 1))
        petNameLbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        petNameLbl.textColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1)
        petTypeLbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        petTypeLbl.textColor = UIColor(red: 0, green: (108 / 255.0), blue: (176 / 255.0), alpha: 1)
        var contentRect = CGRect.zero
        for view: UIView in scrollView.subviews
        {
            contentRect = contentRect.union(view.frame)
        }
        
        scrollView.contentSize = contentRect.size
        weightcount = 0
        petDetailcount = 0
        petDetailcount = 0
        plusecount = 0
        tempcount = 0
        heightcount = 0
        weightcount = 0
        cbgcount = 0
        hemoglobincount = 0
        HemogramViewcount = 0
        serumViewcount = 0
        ConsultionViewcount = 0
        ConditionViewcount = 0
        ImmunizationViewcount = 0
        SurgeriesViewcount = 0
        MedicationViewcount = 0
        AllgeryViewcount = 0
        HospitalizationViewocunt = 0
        FoodPlanViewcount = 0
        DocumentViewcount = 0
        EmergencyViewocunt = 0
        VetetinarianViewcount = 0
        InsuranceViewcount = 0
        basicInfoViewContainer.isHidden = false
        breederDetailsViewContainer.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBasicDetail), name: NSNotification.Name(rawValue: "BasicDetailView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHeightGarph), name: NSNotification.Name(rawValue: "HeightGarphView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWeightGarph), name: NSNotification.Name(rawValue: "WeightGarphView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTemperatureGarph), name: NSNotification.Name(rawValue: "TemperatureGarphView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePluseGarph), name: NSNotification.Name(rawValue: "PulseGarphView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGarphLabelText), name: NSNotification.Name(rawValue: "HeightGarphLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGarphLabelText), name: NSNotification.Name(rawValue: "WeightGarphLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGarphLabelText), name: NSNotification.Name(rawValue: "TempGarphLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGarphLabelText), name: NSNotification.Name(rawValue: "PulseGarphLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCbgView), name: NSNotification.Name(rawValue: "CbgView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHemoglobinView), name: NSNotification.Name(rawValue: "HemoglobinView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHemogramView), name: NSNotification.Name(rawValue: "HemogramView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateserumView), name: NSNotification.Name(rawValue: "SerumView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateConsultionView), name: NSNotification.Name(rawValue: "ConsultionView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateConditionView), name: NSNotification.Name(rawValue: "ConditionView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateImmunizationView), name: NSNotification.Name(rawValue: "ImmunizationView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSurgeriesView), name: NSNotification.Name(rawValue: "SurgeriesView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMedicationView), name: NSNotification.Name(rawValue: "MedicationView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAllgeryView), name: NSNotification.Name(rawValue: "AllergyView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHospitalizationView), name: NSNotification.Name(rawValue: "HospitalizationView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFoodPlanView), name: NSNotification.Name(rawValue: "FoodPlanView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDocumentView), name: NSNotification.Name(rawValue: "DocumentView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateEmergencyView), name: NSNotification.Name(rawValue: "EmergencyView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVetetinarianView), name: NSNotification.Name(rawValue: "VeterinarianView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInsuranceView), name: NSNotification.Name(rawValue: "InsuranceView"), object: nil)
        
        vetetinarianTitleHeightConstriant.constant = 0.0
        vetetinarianHeightConstriant.constant = 0.0
        
        var newFramem: CGRect = vetetinariantitleheightconstraintView.frame
        newFramem = CGRect(x: vetetinariantitleheightconstraintView.frame.origin.x, y: vetetinariantitleheightconstraintView.frame.origin.y, width: vetetinariantitleheightconstraintView.frame.size.width, height: 0)
        vetetinariantitleheightconstraintView.frame = newFramem
        insuranceTitleHeightConstriant.constant = 0.0
        insuranceHeightConstriant.constant = 0.0
        var newFramen: CGRect = insurancetitleheightconstraintView.frame
        newFramen = CGRect(x: insurancetitleheightconstraintView.frame.origin.x, y: insurancetitleheightconstraintView.frame.origin.y, width: insurancetitleheightconstraintView.frame.size.width, height: 0)
        insurancetitleheightconstraintView.frame = newFramen
        emergencyTitleHeightConstriant.constant = 0.0
        emergencyHeightConstriant.constant = 0.0
        let newFramel: CGRect = emergencytitleheightconstraintView.frame
        
        emergencytitleheightconstraintView.frame = newFramel
        documentTitleHeightConstriant.constant = 0.0
        documentHeightConstriant.constant = 0.0
        var newFramek: CGRect = documenttitleheightconstraintView.frame
        newFramek = CGRect(x: documenttitleheightconstraintView.frame.origin.x, y: documenttitleheightconstraintView.frame.origin.y, width: documenttitleheightconstraintView.frame.size.width, height: 0)
        documenttitleheightconstraintView.frame = newFramek
        foodPlanTitleHeightConstriant.constant = 0.0
        foodPlanHeightConstriant.constant = 0.0
        var newFramej: CGRect = foodplantitleheightconstraintView.frame
        newFramej = CGRect(x: foodplantitleheightconstraintView.frame.origin.x, y: foodplantitleheightconstraintView.frame.origin.y, width: foodplantitleheightconstraintView.frame.size.width, height: 0)
        foodplantitleheightconstraintView.frame = newFramej
        hospitalizationTitleHeightConstriant.constant = 0.0
        var newFramei: CGRect = hospitalizationtitleheightconstraintView.frame
        newFramei = CGRect(x: hospitalizationtitleheightconstraintView.frame.origin.x, y: hospitalizationtitleheightconstraintView.frame.origin.y, width: hospitalizationtitleheightconstraintView.frame.size.width, height: 0)
        hospitalizationtitleheightconstraintView.frame = newFramei
        hospitalizationHeightConstriant.constant = 0.0
        allgeryTitleHeightConstriant.constant = 0.0
        var newFrameh: CGRect = allgerytitleheightconstraintView.frame
        newFrameh = CGRect(x: allgerytitleheightconstraintView.frame.origin.x, y: allgerytitleheightconstraintView.frame.origin.y, width: allgerytitleheightconstraintView.frame.size.width, height: 0)
        allgerytitleheightconstraintView.frame = newFrameh
        allgeryHeightConstraint.constant = 0.0
        medicationTitleHeightConstriant.constant = 0.0
        var newFrameg: CGRect = medicationtitleheightconstraintView.frame
        newFrameg = CGRect(x: medicationtitleheightconstraintView.frame.origin.x, y: medicationtitleheightconstraintView.frame.origin.y, width: medicationtitleheightconstraintView.frame.size.width, height: 0)
        medicationtitleheightconstraintView.frame = newFrameg
        medicationHeightConstriant.constant = 0.0
        surgeriesTitleHeightConstriant.constant = 0.0
        var newFramef: CGRect = surgeriestitleheightconstraintView.frame
        newFramef = CGRect(x: surgeriestitleheightconstraintView.frame.origin.x, y: surgeriestitleheightconstraintView.frame.origin.y, width: surgeriestitleheightconstraintView.frame.size.width, height: 0)
        surgeriestitleheightconstraintView.frame = newFramef
        
        surgeriesHeightConstriant.constant = 0.0
        immunizationTitleHeightConstriant.constant = 0.0
        var newFramee: CGRect = immunizationtitleheightconstraintView.frame
        newFramee = CGRect(x: immunizationtitleheightconstraintView.frame.origin.x, y: immunizationtitleheightconstraintView.frame.origin.y, width: immunizationtitleheightconstraintView.frame.size.width, height: 0)
        immunizationtitleheightconstraintView.frame = newFramee
        immunizationHeightConstriant.constant = 0.0
        conditionTitleHeightConstriant.constant = 0.0
        var newFramed: CGRect = conditiontitleheightconstraintView.frame
        newFramed = CGRect(x: conditiontitleheightconstraintView.frame.origin.x, y: conditiontitleheightconstraintView.frame.origin.y, width: conditiontitleheightconstraintView.frame.size.width, height: 0)
        conditiontitleheightconstraintView.frame = newFramed
        
        conditionHeightConstriant.constant = 0.0
        consultionTitleHeightConstriant.constant = 0.0
        var newFramec: CGRect = consultiontitleheightconstraintView.frame
        newFramec = CGRect(x: consultiontitleheightconstraintView.frame.origin.x, y: consultiontitleheightconstraintView.frame.origin.y, width: consultiontitleheightconstraintView.frame.size.width, height: 0)
        consultiontitleheightconstraintView.frame = newFramec
        consultionHeightConstraint.constant = 0.0
        serumContainerHeight.constant = 0.0
        serumHeaderHeight.constant = 0.0
        var newFrameb: CGRect = serumheaderheightView.frame
        newFrameb = CGRect(x: serumheaderheightView.frame.origin.x, y: serumheaderheightView.frame.origin.y, width: serumheaderheightView.frame.size.width, height: 0)
        serumheaderheightView.frame = newFrameb
        
        hemogramContainerHeight.constant = 0.0
        hemogramHeaderHeight.constant = 0.0
        var newFramea: CGRect = hemogramheaderheightView.frame
        newFramea = CGRect(x: hemogramheaderheightView.frame.origin.x, y: hemogramheaderheightView.frame.origin.y, width: hemogramheaderheightView.frame.size.width, height: 0)
        hemogramheaderheightView.frame = newFramea
        hemoglobinContainerHeight.constant = 0.0
        hemoglobinHeaderHeight.constant = 0.0
        var newFrameq: CGRect = hemoglobinheaderheightView.frame
        newFrameq = CGRect(x: hemoglobinheaderheightView.frame.origin.x, y: hemoglobinheaderheightView.frame.origin.y, width: hemoglobinheaderheightView.frame.size.width, height: 0)
        hemoglobinheaderheightView.frame = newFrameq
        cbgHeaderContainerHeight.constant = 0.0
        cbgContainerHeight.constant = 0.0
        pluseGraphConstriant.constant = 0.0
        tempratureGarphConstraint.constant = 0.0
        
        heightGraphConstriant.constant = 0.0
        weightGarphConstraint.constant = 0.0
        segmentControlConstraint.constant = 0.0
        
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        if shared
        {
            let shareId: Bool = UserDefaults.standard.bool(forKey: "ShareId")
            
            // Profile
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let idCardChildVC: PetDetailsViewController = storyboard.instantiateViewController(withIdentifier: "petdetails") as! PetDetailsViewController
            
            idCardChildVC.isFromMedical = true
            addChildViewController(idCardChildVC)
            self.view.clipsToBounds = true
            //    [idCardChildVC.view setBackgroundColor:[UIColor redColor]];
            idCardChildVC.didMove(toParentViewController: self)
            idCardChildVC.view.frame = CGRect(x: 0, y: 0, width: basicInfoViewContainer.frame.size.width, height: 380)
            basicInfoViewContainer.addSubview(idCardChildVC.view)
            //Breeder Details
            let storyboard20 = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let breederChildVC: AdoptionDetailsViewController = storyboard20.instantiateViewController(withIdentifier: "adoptiondetails") as! AdoptionDetailsViewController
            
            breederChildVC.isFromMedical = true
            self.addChildViewController(breederChildVC)
            breederChildVC.didMove(toParentViewController: self)
            
            breederChildVC.view.frame = CGRect(x: 0, y: 0, width: breederDetailsViewContainer.frame.size.width, height: 450)
            breederDetailsViewContainer.addSubview(breederChildVC.view)
            if shareId
            {
                self.infoSegC.isHidden = false
                self.segmentControlConstraint.constant = 28
                basicHeight.constant = 335.0
                breederHeight.constant = 335.0
                basicInfoViewContainer.isHidden = false
                breederDetailsViewContainer.isHidden = true
            }
            else
            {
                self.infoSegC.isHidden = true
                self.segmentControlConstraint.constant = 0
                basicHeight.constant = 0.0
                breederHeight.constant = 0.0
                basicInfoViewContainer.isHidden = true
                breederDetailsViewContainer.isHidden = true
            }
        }
        else
        {
            self.infoSegC.isHidden = false
            self.segmentControlConstraint.constant = 28
            basicHeight.constant = 335.0
            breederHeight.constant = 335.0
            basicInfoViewContainer.isHidden = false
            breederDetailsViewContainer.isHidden = true
            
            // Profile
            let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let idCardChildVC: PetDetailsViewController = storyboard.instantiateViewController(withIdentifier: "petdetails") as! PetDetailsViewController
            
            idCardChildVC.isFromMedical = true
            self.addChildViewController(idCardChildVC)
            self.view.clipsToBounds = true
            //    [idCardChildVC.view setBackgroundColor:[UIColor redColor]];
            idCardChildVC.didMove(toParentViewController: self)
            idCardChildVC.view.frame = CGRect(x: 0, y: 0, width: basicInfoViewContainer.frame.size.width, height: 380)
            basicInfoViewContainer.addSubview(idCardChildVC.view)
            //Breeder Details
            let storyboard20 = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let breederChildVC: AdoptionDetailsViewController = storyboard20.instantiateViewController(withIdentifier: "adoptiondetails") as! AdoptionDetailsViewController
            
            breederChildVC.isFromMedical = true
            self.addChildViewController(breederChildVC)
            breederChildVC.didMove(toParentViewController: self)
            
            breederChildVC.view.frame = CGRect(x: 0, y: 0, width: breederDetailsViewContainer.frame.size.width, height: 450)
            breederDetailsViewContainer.addSubview(breederChildVC.view)
        }
        
        vitalCount = 4
        labCount = 4
        
        if vitalCount == 4
        {
            var newFrame: CGRect = vitalConstraintView.frame
            newFrame = CGRect(x: vitalConstraintView.frame.origin.x, y: vitalConstraintView.frame.origin.y, width: vitalConstraintView.frame.size.width, height: 0)
            vitalConstraintView.frame = newFrame
            vitalConstraint.constant = 0.0
        }
        if labCount == 4
        {
            var newFrame: CGRect = labResultConstraintView.frame
            newFrame = CGRect(x: labResultConstraintView.frame.origin.x, y: labResultConstraintView.frame.origin.y, width: labResultConstraintView.frame.size.width, height: 0)
            labResultConstraintView.frame = newFrame
            labResultConstraint.constant = 0.0
        }
        tempratureMainView.isHidden = true
        pluseMainView.isHidden = true
        heightMainView.isHidden = true
        weightMainView.isHidden = true
        
        
        var newFrame: CGRect = heightMainView.frame
        heightGraphConstriant.constant = 0.0
        newFrame = CGRect(x: 10, y: breederDetailsViewContainer.frame.origin.y + breederDetailsViewContainer.frame.size.height, width: view.frame.size.width - 20, height: 0)
        heightMainView.frame = newFrame
        smallContainerHeight.constant = 0.0
        var newFrame11: CGRect = heightViewControllerContainer.frame
        newFrame11 = CGRect(x: 0, y: 0, width: heightViewControllerContainer.frame.size.width, height: 0)
        heightViewControllerContainer.frame = newFrame11
        
        /*************************************************************************/
        tempratureGarphConstraint.constant = 0.0
        smallContaintertempHeight.constant = 0.0
        var newFrame1: CGRect = tempratureMainView.frame
        newFrame1 = CGRect(x: 10, y: weightMainView.frame.origin.y + weightMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
        tempratureMainView.frame = newFrame1
        var newFrame12: CGRect = temperatureViewControllerContainer.frame
        newFrame12 = CGRect(x: 10, y: temperatureViewControllerContainer.frame.origin.y, width: temperatureViewControllerContainer.frame.size.width, height: 0)
        temperatureViewControllerContainer.frame = newFrame12
        /*************************************************************************/
        pluseGraphConstriant.constant = 0.0
        smallCOntainerPluseHeight.constant = 0.0
        var newFrame2: CGRect = pluseMainView.frame
        newFrame2 = CGRect(x: 10, y: tempratureMainView.frame.origin.y + tempratureMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
        pluseMainView.frame = newFrame2
        var newFrame13: CGRect = pulseViewControllerContainer.frame
        newFrame13 = CGRect(x: 10, y: pulseViewControllerContainer.frame.origin.y, width: pulseViewControllerContainer.frame.size.width, height: 0)
        pulseViewControllerContainer.frame = newFrame13
        /*************************************************************************/
        weightGarphConstraint.constant = 0.0
        var newFrame3: CGRect = weightMainView.frame
        newFrame3 = CGRect(x: 10, y: heightMainView.frame.origin.y + heightMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
        weightMainView.frame = newFrame3
        smallContainerWeightHeight.constant = 0.0
        var newFrame14: CGRect = weightViewControllerContainer.frame
        newFrame14 = CGRect(x: 10, y: weightViewControllerContainer.frame.origin.y, width: weightViewControllerContainer.frame.size.width, height: 0)
        weightViewControllerContainer.frame = newFrame14
        /*************************************************************************/
        var newFrame4: CGRect = cbgViewControllerContainer.frame
        newFrame4 = CGRect(x: 10, y: pluseMainView.frame.origin.y + pluseMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
        cbgViewControllerContainer.frame = newFrame4
        /*************************************************************************/
        var newFrame5: CGRect = hemoglobinViewControllerContainer.frame
        newFrame5 = CGRect(x: 10, y: cbgViewControllerContainer.frame.origin.y + cbgViewControllerContainer.frame.size.height, width: view.frame.size.width - 20, height: 0)
        hemoglobinViewControllerContainer.frame = newFrame5
        /*************************************************************************/
        var newFrame6: CGRect = hemogramViewControllerContainer.frame
        newFrame6 = CGRect(x: 10, y: hemoglobinViewControllerContainer.frame.origin.y + hemoglobinViewControllerContainer.frame.size.height, width: view.frame.size.width - 20, height: 0)
        hemogramViewControllerContainer.frame = newFrame6
        /*************************************************************************/
        var newFrame7: CGRect = serumElectrolyteViewControllerContainer.frame
        newFrame7 = CGRect(x: 10, y: hemogramViewControllerContainer.frame.origin.y + hemogramViewControllerContainer.frame.size.height, width: view.frame.size.width - 20, height: 0)
        serumElectrolyteViewControllerContainer.frame = newFrame7
        /*************************************************************************/
        MBProgressHUD.hide(for:self.view, animated: true)
        //            hasViewLoaded = true
        //        }
    }
    @objc func updateBasicDetail(_ notification: Notification)
    {
        petDetailcount += 1
        print("userInfo \(String(describing: notification.userInfo))")
        petNameLbl.text = notification.userInfo?["ZeroBasicDetail"] as? String
        petTypeLbl.text = notification.userInfo?["BasicDetailType"] as? String
        if petTypeLbl.text == "Other"
        {
            petTypeLbl.text = (UserDefaults.standard.string(forKey: "PetType"))! + String(format: "(%@)", (UserDefaults.standard.string(forKey: "PetTypeOther"))!)
            
        }
        else
        {
            petTypeLbl.text = UserDefaults.standard.string(forKey: "PetType")
        }
        print("petName123 :\(String(describing: petNameLbl.text))")
        if petDetailcount == 1
        {
            basicHeight.constant = 335.0
            breederHeight.constant = 335.0
            var contentRect = CGRect.zero
            for view: UIView in scrollView.subviews {
                contentRect = contentRect.union(view.frame)
            }
            scrollView.contentSize = contentRect.size
        }
    }
    
    @objc func updatePluseGarph(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag24: Bool = notification.userInfo!["ZeroPulse"] as! Bool
        print("FLAGG value ZeroPulse:\(flag24)")
        if !flag24
        {
            pluseGraphConstriant.constant = 400.0
            smallCOntainerPluseHeight.constant = 311.0
            plusecount += 1
            if plusecount == 1
            {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            pluseMainView.isHidden = false
            var newFrame2: CGRect = pluseMainView.frame
            newFrame2 = CGRect(x: 10, y: pluseMainView.frame.origin.y, width: view.frame.size.width - 20, height: 400)
            pluseMainView.frame = newFrame2
            vitalCount -= 1
            if vitalCount == 0 {
                
            }
            else {
                vitalConstraint.constant = 47.0
            }
        }
        else
        {
            pluseGraphConstriant.constant = 0.0
            smallCOntainerPluseHeight.constant = 0.0
            pluseMainView.isHidden = true
            var newFrame2: CGRect = pluseMainView.frame
            newFrame2 = CGRect(x: 10, y: tempratureMainView.frame.origin.y + tempratureMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
            pluseMainView.frame = newFrame2
            var newFrame13: CGRect = pulseViewControllerContainer.frame
            newFrame13 = CGRect(x: 10, y: pulseViewControllerContainer.frame.origin.y, width: pulseViewControllerContainer.frame.size.width, height: 0)
            pulseViewControllerContainer.frame = newFrame13
        }
    }
    @objc func updateTemperatureGarph(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag23: Bool = notification.userInfo!["ZeroTemperature"] as! Bool
        print("FLAGG value ZeroTemperature:\(flag23) ")
        if !flag23
        {
            tempratureGarphConstraint.constant = 480.0
            smallContaintertempHeight.constant = 361.0
            tempcount += 1
            if tempcount == 1
            {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
                tempratureMainView.isHidden = false
                var newFrame1: CGRect = tempratureMainView.frame
                newFrame1 = CGRect(x: 10, y: tempratureMainView.frame.origin.y, width: view.frame.size.width - 20, height: 480)
                tempratureMainView.frame = newFrame1
            }
            vitalCount -= 1
            if vitalCount == 0 {
                
            }
            else {
                vitalConstraint.constant = 47.0
            }
        }
        else
        {
            tempratureGarphConstraint.constant = 0.0
            smallContaintertempHeight.constant = 0.0
            tempratureMainView.isHidden = true
            var newFrame1: CGRect = tempratureMainView.frame
            newFrame1 = CGRect(x: 10, y: weightMainView.frame.origin.y + weightMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
            tempratureMainView.frame = newFrame1
            var newFrame12: CGRect = temperatureViewControllerContainer.frame
            newFrame12 = CGRect(x: 10, y: temperatureViewControllerContainer.frame.origin.y, width: temperatureViewControllerContainer.frame.size.width, height: 0)
            temperatureViewControllerContainer.frame = newFrame12
        }
    }
    @objc func updateHeightGarph(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag22: Bool = notification.userInfo!["ZeroHeight"] as! Bool
        print("FLAGG value ZeroHeight:\(flag22)")
        if !flag22
        {
            heightGraphConstriant.constant = 482.0
            heightcount += 1
            if heightcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            self.smallContainerHeight.constant = 371.0
            heightMainView.isHidden = false
            var newFrame: CGRect = heightMainView.frame
            newFrame = CGRect(x: 10, y: heightMainView.frame.origin.y, width: view.frame.size.width - 20, height: 482)
            heightMainView.frame = newFrame
            print("heightGraphConstriant \(heightGraphConstriant.constant)")
            vitalCount -= 1
            if vitalCount == 0 {
                
            }
            else {
                vitalConstraint.constant = 47.0
            }
        }
        else
        {
            heightGraphConstriant.constant = 0.0
            heightMainView.isHidden = true
            var newFrame: CGRect = heightMainView.frame
            newFrame = CGRect(x: 10, y: breederDetailsViewContainer.frame.origin.y + breederDetailsViewContainer.frame.size.height, width: view.frame.size.width - 20, height: 0)
            heightMainView.frame = newFrame
            smallContainerHeight.constant = 0.0
            var newFrame11: CGRect = heightViewControllerContainer.frame
            newFrame11 = CGRect(x: 0, y: 0, width: heightViewControllerContainer.frame.size.width, height: 0)
            heightViewControllerContainer.frame = newFrame11
        }
    }
    @objc func updateWeightGarph(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag21: Bool = notification.userInfo!["ZeroWeight"] as! Bool
        print("FLAGG value ZeroWeight:\(flag21)")
        if !flag21 {
            weightcount += 1
            weightGarphConstraint.constant = 470.0
            smallContainerWeightHeight.constant = 372.0
            print("weightcount \(weightcount)")
            if weightcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            weightMainView.isHidden = false
            var newFrame3: CGRect = weightMainView.frame
            newFrame3 = CGRect(x: 10, y: weightMainView.frame.origin.y, width: view.frame.size.width - 20, height: 490)
            weightMainView.frame = newFrame3
            vitalCount -= 1
            if vitalCount == 0 {
                
            }
            else {
                vitalConstraint.constant = 47.0
            }
        }
        else
        {
            weightGarphConstraint.constant = 0.0
            weightMainView.isHidden = true
            var newFrame3: CGRect = weightMainView.frame
            newFrame3 = CGRect(x: 10, y: heightMainView.frame.origin.y + heightMainView.frame.size.height, width: view.frame.size.width - 20, height: 0)
            weightMainView.frame = newFrame3
            smallContainerWeightHeight.constant = 0.0
            var newFrame14: CGRect = weightViewControllerContainer.frame
            newFrame14 = CGRect(x: 10, y: weightViewControllerContainer.frame.origin.y, width: weightViewControllerContainer.frame.size.width, height: 0)
            weightViewControllerContainer.frame = newFrame14
        }
    }
    @objc func updateCbgView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag1: Bool = notification.userInfo!["ZeroCBG"] as! Bool
        let ArrayCount = notification.userInfo!["ArrayCount"] as! Int
        print("FLAGG value Consultation:\(flag1) \(ArrayCount)")
        if !flag1
        {
            // ArrayCount=1;
            cbgHeaderContainerHeight.constant = 25.0
            cbgContainerHeight.constant = 150
            cbgChildVC?.view.frame = CGRect(x: 0, y: -10, width: cbgViewControllerContainer.frame.size.width, height: 150)
            cbgcount += 1
            if cbgcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            print("cbgContainerHeight  \(cbgContainerHeight.constant)")
            labCount -= 1
            if labCount == 0 {
                
            }
            else
            {
                labResultConstraint.constant = 47.0
            }
        }
        else
        {
            var newFrame: CGRect = cbgheadercontainerheightView.frame
            newFrame = CGRect(x: cbgheadercontainerheightView.frame.origin.x, y: cbgheadercontainerheightView.frame.origin.y, width: cbgheadercontainerheightView.frame.size.width, height: 0)
            cbgheadercontainerheightView.frame = newFrame
            cbgHeaderContainerHeight.constant = 0.0
            cbgContainerHeight.constant = 0.0
            var newFrame4: CGRect = cbgViewControllerContainer.frame
            newFrame4 = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 0)
            cbgViewControllerContainer.frame = newFrame4
        }
    }
    @objc func updateHemoglobinView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag2: Bool = notification.userInfo!["ZeroHemoglobin"] as! Bool
        print("FLAGG value Consultation:\(flag2)")
        if !flag2 {
            hemoglobinHeaderHeight.constant = 25.0
            hemoglobinContainerHeight.constant = 150
            hemoglobincount += 1
            if hemoglobincount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            labCount -= 1
            if labCount == 0 {
                
            }
            else {
                labResultConstraint.constant = 47.0
            }
        }
        else
        {
            hemoglobinHeaderHeight.constant = 0.0
            hemoglobinContainerHeight.constant = 0.0
            var newFrame: CGRect = hemoglobinheaderheightView.frame
            newFrame = CGRect(x: hemoglobinheaderheightView.frame.origin.x, y: hemoglobinheaderheightView.frame.origin.y, width: hemoglobinheaderheightView.frame.size.width, height: 0)
            hemoglobinheaderheightView.frame = newFrame
            /*************************************************************************/
            var newFrame5: CGRect = hemoglobinViewControllerContainer.frame
            newFrame5 = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 0)
            hemoglobinViewControllerContainer.frame = newFrame5
        }
    }
    @objc func updateHemogramView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag3: Bool = notification.userInfo!["ZeroHemogram"] as! Bool
        print("FLAGG value Consultation:\(flag3)")
        if !flag3 {
            hemogramHeaderHeight.constant = 25.0
            hemogramContainerHeight.constant = 150
            HemogramViewcount += 1
            if HemogramViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            labCount -= 1
            if labCount == 0 {
                
            }
            else {
                labResultConstraint.constant = 47.0
            }
        }
        else{
            hemogramHeaderHeight.constant = 0.0
            hemogramContainerHeight.constant = 0.0
            var newFramew: CGRect = hemogramheaderheightView.frame
            newFramew = CGRect(x: hemogramheaderheightView.frame.origin.x, y: hemogramheaderheightView.frame.origin.y, width: hemogramheaderheightView.frame.size.width, height: 0)
            hemogramheaderheightView.frame = newFramew
            /*************************************************************************/
            var newFrame6: CGRect = hemogramViewControllerContainer.frame
            newFrame6 = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 0)
            hemogramViewControllerContainer.frame = newFrame6
        }
    }
    @objc func updateserumView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag4: Bool = notification.userInfo!["ZeroSerum"] as! Bool
        print("FLAGG value Consultation:\(flag4)")
        if !flag4 {
            serumHeaderHeight.constant = 25.0
            serumContainerHeight.constant = 150.0
            serumViewcount += 1
            if serumViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
            labCount -= 1
            if labCount == 0 {
                
            }
            else {
                labResultConstraint.constant = 47.0
            }
        }
        else
        {
            serumHeaderHeight.constant = 0.0
            serumContainerHeight.constant = 0.0
            var newFrameb: CGRect = serumheaderheightView.frame
            newFrameb = CGRect(x: serumheaderheightView.frame.origin.x, y: serumheaderheightView.frame.origin.y, width: serumheaderheightView.frame.size.width, height: 0)
            serumheaderheightView.frame = newFrameb
            /*************************************************************************/
            var newFrame7: CGRect = serumElectrolyteViewControllerContainer.frame
            newFrame7 = CGRect(x: 10, y: 0, width: view.frame.size.width - 20, height: 0)
            serumElectrolyteViewControllerContainer.frame = newFrame7
        }
    }
    @objc func updateConsultionView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag5: Bool = notification.userInfo!["ZeroConsultation"] as! Bool
        print("FLAGG value Consultation:\(flag5)")
        if !flag5
        {
            consultionTitleHeightConstriant.constant = 47.0
            consultionHeightConstraint.constant = 110.0
            ConsultionViewcount += 1
            if ConsultionViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else{
            consultionTitleHeightConstriant.constant = 0.0
            consultionHeightConstraint.constant = 0.0
            var newFramec: CGRect = consultiontitleheightconstraintView.frame
            newFramec = CGRect(x: consultiontitleheightconstraintView.frame.origin.x, y: consultiontitleheightconstraintView.frame.origin.y, width: consultiontitleheightconstraintView.frame.size.width, height: 0)
            consultiontitleheightconstraintView.frame = newFramec
        }
    }
    @objc func updateConditionView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag6: Bool = notification.userInfo!["ZeroCondition"] as! Bool
        print("FLAGG value Condition flag6 :\(flag6)")
        if !flag6 {
            conditionTitleHeightConstriant.constant = 47.0
            conditionHeightConstriant.constant = 150.0
            ConditionViewcount += 1
            if ConditionViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else{
            conditionTitleHeightConstriant.constant = 0.0
            conditionHeightConstriant.constant = 0.0
            var newFramed: CGRect = conditiontitleheightconstraintView.frame
            newFramed = CGRect(x: conditiontitleheightconstraintView.frame.origin.x, y: conditiontitleheightconstraintView.frame.origin.y, width: conditiontitleheightconstraintView.frame.size.width, height: 0)
            conditiontitleheightconstraintView.frame = newFramed
        }
    }
    @objc func updateImmunizationView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag7: Bool = notification.userInfo!["ZeroImmunization"] as! Bool
        print("FLAGG value Condition flag7 :\(flag7)")
        if !flag7 {
            immunizationTitleHeightConstriant.constant = 47.0
            immunizationHeightConstriant.constant = 150.0
            ImmunizationViewcount += 1
            if ImmunizationViewcount == 1
            {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews
                {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else{
            immunizationTitleHeightConstriant.constant = 0.0
            immunizationHeightConstriant.constant = 0.0
            var newFramee: CGRect = immunizationtitleheightconstraintView.frame
            newFramee = CGRect(x: immunizationtitleheightconstraintView.frame.origin.x, y: immunizationtitleheightconstraintView.frame.origin.y, width: immunizationtitleheightconstraintView.frame.size.width, height: 0)
            immunizationtitleheightconstraintView.frame = newFramee
        }
    }
    @objc func updateSurgeriesView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag8: Bool = notification.userInfo!["ZeroSurgery"] as! Bool
        print("FLAGG value Condition flag8 :\(flag8)")
        if !flag8 {
            surgeriesTitleHeightConstriant.constant = 47.0
            surgeriesHeightConstriant.constant = 150.0
            SurgeriesViewcount += 1
            if SurgeriesViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else{
            surgeriesTitleHeightConstriant.constant = 0.0
            surgeriesHeightConstriant.constant = 0.0
            var newFramef: CGRect = surgeriestitleheightconstraintView.frame
            newFramef = CGRect(x: surgeriestitleheightconstraintView.frame.origin.x, y: surgeriestitleheightconstraintView.frame.origin.y, width: surgeriestitleheightconstraintView.frame.size.width, height: 0)
            surgeriestitleheightconstraintView.frame = newFramef
        }
    }
    @objc func updateMedicationView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag9: Bool = notification.userInfo!["ZeroMedication"] as! Bool
        print("FLAGG value Condition flag9 :\(flag9)")
        if !flag9 {
            medicationTitleHeightConstriant.constant = 47.0
            medicationHeightConstriant.constant = 150.0
            MedicationViewcount += 1
            if MedicationViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            medicationTitleHeightConstriant.constant = 0.0
            medicationHeightConstriant.constant = 0.0
            var newFrameg: CGRect = medicationtitleheightconstraintView.frame
            newFrameg = CGRect(x: medicationtitleheightconstraintView.frame.origin.x, y: medicationtitleheightconstraintView.frame.origin.y, width: medicationtitleheightconstraintView.frame.size.width, height: 0)
            medicationtitleheightconstraintView.frame = newFrameg
        }
    }
    @objc func updateAllgeryView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag10: Bool = notification.userInfo!["ZeroAllergy"] as! Bool
        print("FLAGG value Condition flag10 :\(flag10)")
        if !flag10 {
            allgeryTitleHeightConstriant.constant = 47.0
            allgeryHeightConstraint.constant = 150.0
            AllgeryViewcount += 1
            if AllgeryViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            allgeryTitleHeightConstriant.constant = 0.0
            allgeryHeightConstraint.constant = 0.0
            var newFrameh: CGRect = allgerytitleheightconstraintView.frame
            newFrameh = CGRect(x: allgerytitleheightconstraintView.frame.origin.x, y: allgerytitleheightconstraintView.frame.origin.y, width: allgerytitleheightconstraintView.frame.size.width, height: 0)
            allgerytitleheightconstraintView.frame = newFrameh
        }
    }
    
    @objc func updateHospitalizationView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag11: Bool = notification.userInfo!["ZeroHospitalization"] as! Bool
        print("FLAGG value Condition flag11 :\(flag11)")
        if !flag11 {
            hospitalizationTitleHeightConstriant.constant = 47.0
            hospitalizationHeightConstriant.constant = 150.0
            HospitalizationViewocunt += 1
            if HospitalizationViewocunt == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            hospitalizationTitleHeightConstriant.constant = 0.0
            hospitalizationHeightConstriant.constant = 0.0
            var newFramei: CGRect = hospitalizationtitleheightconstraintView.frame
            newFramei = CGRect(x: hospitalizationtitleheightconstraintView.frame.origin.x, y: hospitalizationtitleheightconstraintView.frame.origin.y, width: hospitalizationtitleheightconstraintView.frame.size.width, height: 0)
            hospitalizationtitleheightconstraintView.frame = newFramei
            
        }
    }
    
    @objc func updateFoodPlanView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag12: Bool = notification.userInfo!["ZeroFoodPlan"] as! Bool
        print("FLAGG value Condition flag12 :\(flag12)")
        if !flag12 {
            foodPlanTitleHeightConstriant.constant = 47.0
            foodPlanHeightConstriant.constant = 150.0
            FoodPlanViewcount += 1
            if FoodPlanViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            foodPlanTitleHeightConstriant.constant = 0.0
            foodPlanHeightConstriant.constant = 0.0
            var newFramej: CGRect = foodplantitleheightconstraintView.frame
            newFramej = CGRect(x: foodplantitleheightconstraintView.frame.origin.x, y: foodplantitleheightconstraintView.frame.origin.y, width: foodplantitleheightconstraintView.frame.size.width, height: 0)
            foodplantitleheightconstraintView.frame = newFramej
        }
    }
    @objc func updateDocumentView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag13: Bool = notification.userInfo!["ZeroDocument"] as! Bool
        print("FLAGG value Condition flag13 :\(flag13)")
        if !flag13 {
            documentTitleHeightConstriant.constant = 47.0
            documentHeightConstriant.constant = 150.0
            DocumentViewcount += 1
            if DocumentViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            documentTitleHeightConstriant.constant = 0.0
            documentHeightConstriant.constant = 0.0
            var newFramek: CGRect = documenttitleheightconstraintView.frame
            newFramek = CGRect(x: documenttitleheightconstraintView.frame.origin.x, y: documenttitleheightconstraintView.frame.origin.y, width: documenttitleheightconstraintView.frame.size.width, height: 0)
            documenttitleheightconstraintView.frame = newFramek
        }
    }
    @objc func updateEmergencyView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag14: Bool = notification.userInfo!["ZeroEmergencyContact"] as! Bool
        print("FLAGG value Condition flag14 :\(flag14)")
        if !flag14 {
            emergencyTitleHeightConstriant.constant = 47.0
            emergencyHeightConstriant.constant = 140.0
            EmergencyViewocunt += 1
            if EmergencyViewocunt == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            emergencyTitleHeightConstriant.constant = 0.0
            emergencyHeightConstriant.constant = 0.0
            var newFramel: CGRect = emergencytitleheightconstraintView.frame
            newFramel = CGRect(x: emergencytitleheightconstraintView.frame.origin.x, y: emergencytitleheightconstraintView.frame.origin.y, width: emergencytitleheightconstraintView.frame.size.width, height: 0)
            emergencytitleheightconstraintView.frame = newFramel
        }
    }
    @objc func updateVetetinarianView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag15: Bool = notification.userInfo!["ZeroVeterinarian"] as! Bool
        print("FLAGG value Condition flag11 :\(flag15)")
        if !flag15 {
            vetetinarianTitleHeightConstriant.constant = 47.0
            vetetinarianHeightConstriant.constant = 190
            VetetinarianViewcount += 1
            if VetetinarianViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else{
            vetetinarianTitleHeightConstriant.constant = 0.0
            vetetinarianHeightConstriant.constant = 0.0
            var newFramem: CGRect = vetetinariantitleheightconstraintView.frame
            newFramem = CGRect(x: vetetinariantitleheightconstraintView.frame.origin.x, y: vetetinariantitleheightconstraintView.frame.origin.y, width: vetetinariantitleheightconstraintView.frame.size.width, height: 0)
            vetetinariantitleheightconstraintView.frame = newFramem
        }
    }
    @objc func updateInsuranceView(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        let flag16: Bool = notification.userInfo!["ZeroInsurance"] as! Bool
        print("FLAGG value Condition flag16 :\(flag16)")
        if !flag16 {
            insuranceTitleHeightConstriant.constant = 47.0
            insuranceHeightConstriant.constant = 370.0
            InsuranceViewcount += 1
            if InsuranceViewcount == 1 {
                var contentRect = CGRect.zero
                for view: UIView in scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                scrollView.contentSize = contentRect.size
            }
        }
        else
        {
            insuranceTitleHeightConstriant.constant = 0.0
            insuranceHeightConstriant.constant = 0.0
            var newFramen: CGRect = insurancetitleheightconstraintView.frame
            newFramen = CGRect(x: insurancetitleheightconstraintView.frame.origin.x, y: insurancetitleheightconstraintView.frame.origin.y, width: insurancetitleheightconstraintView.frame.size.width, height: 0)
            insurancetitleheightconstraintView.frame = newFramen
            
        }
        var contentRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    @objc func updateGarphLabelText(_ notification: Notification) {
        print("userInfo \(String(describing: notification.userInfo))")
        heightValueLbl.text = notification.userInfo?["valueStr"] as? String
        heightDateLbl.text = notification.userInfo?["dateStr"] as? String
    }
    
    func updateWeightLabelText(_ notification: Notification) {
        print("userInfo \(String(describing: notification.userInfo))")
        weightValueLbl.text = notification.userInfo?["valueStr"] as? String
        weightDateLbl.text = notification.userInfo?["dateStr"] as? String
    }
    func updateTempLabelText(_ notification: Notification)
    {
        print("userInfo \(String(describing: notification.userInfo))")
        temperatureValueLbl.text = notification.userInfo?["valueStr"] as? String
        temperatureDateLbl.text = notification.userInfo?["dateStr"] as? String
    }
    
    func updatePluseLabelText(_ notification: Notification) {
        print("userInfo \(String(describing: notification.userInfo))")
        pulseValueLbl.text = notification.userInfo?["valueStr"] as? String
        pulseDateLbl.text = notification.userInfo?["dateStr"] as? String
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.x != 0
        {
            var offset: CGPoint = scrollView.contentOffset
            offset.x = 0
            scrollView.contentOffset = offset
        }
    }
    @objc func leftClk(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    //    override func viewWillDisappear(_ animated: Bool)
    //    {
    //        super.viewDidDisappear(animated)
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    @IBAction func pdfClk(_ sender: Any)
    {
        self.webserviceToGetMedicalSummaryPdf()
    }
    func webserviceToGetMedicalSummaryPdf()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true).labelText = ""
        let headers:[String:String]=["x-appapikey": "A4PPMSV001:9QxMhKNDHBabavdShJ6dSkL75qXwyKdhuqAWrLar1mo=","cache-control":"no-cache"]
        let shared: Bool = UserDefaults.standard.bool(forKey: "SharedPet")
        let petId:String = UserDefaults.standard.string(forKey: "SelectedPet")!
        var str: String = ""
        if shared
        {
            let userId = UserDefaults.standard.value(forKey: "OwnerId") as? Int
            str = String(format: "PetId=%@&PatientId=%d",petId, userId!)
        }
        else
        {
            let userId: String = UserDefaults.standard.string(forKey: "userID")!
            str = String(format: "PetId=%@&PatientId=%@",petId, userId)
        }
        
        str = str.trimmingCharacters(in: CharacterSet.whitespaces)
        str = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlStr = String(format : "%@?%@", API.Pet.MedicalSummaryPdf, str )
        var request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.allHTTPHeaderFields = headers
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
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let str: String = (json?["Url"] as? String)!
                            self.showPdf(str)
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
    func showPdf(_ sender: String)
    {
        let url = URL(string: sender)
        if let urlData = try? Data(contentsOf: url!) as? Data,
            let urlDataByte = urlData
        {
            if urlDataByte.count > 0
            {
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory: String = paths[0]
                let filePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("MedicalSummary.pdf").absoluteString
                DispatchQueue.main.async(execute: {() -> Void in
                    try? urlDataByte.write(to: URL(string: filePath)!, options: Data.WritingOptions(rawValue: 1))
                    print("File Saved !")
                    let fileURL = URL(string: filePath)
                    self.docInteractionCon = UIDocumentInteractionController(url: fileURL!)
                    self.docInteractionCon?.delegate = self
                    self.docInteractionCon?.name = "Medical Summary"
                    self.docInteractionCon?.presentPreview(animated: true)
                })
            }
        }
        
    }
    // MARK: -
    // MARK: Document Interaction Delegate Methods
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        var contentRect: CGRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController)
    {
        print("User has dismissed preview")
        var contentRect: CGRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    @objc func segClk(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            basicInfoViewContainer.isHidden = false
            breederDetailsViewContainer.isHidden = true
        }
        else if sender.selectedSegmentIndex == 1 {
            basicInfoViewContainer.isHidden = true
            breederDetailsViewContainer.isHidden = false
        }
    }
    override func didReceiveMemoryWarning()
    {
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

