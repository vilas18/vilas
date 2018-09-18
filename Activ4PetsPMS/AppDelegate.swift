
//
//  AppDelegate.swift
//  Activ4PetsPMS
//
//  Created by Activ Doctors Online on 16/08/17.
//  Copyright © 2017 Activ Doctors Online. All rights reserved.
//`

import UIKit
import CoreData
import UserNotifications
// ashwin.anc@gmail.com, India_01-- LIve
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    
    var window: UIWindow?
    var navigationControler: UINavigationController?
    var ipAddress : [String]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
       // RTCPeerConnectionFactory.initializeSSL()
        print(UIDevice.current.systemName)
        print(UIDevice.current.localizedModel)
        print(UIDevice.current.model)
        print(UIDevice.current.systemVersion)
        print(UIDevice.current.identifierForVendor!.uuidString)
        
        var publicIP: String? = nil
        if let aString = URL(string: "https://icanhazip.com/")
        {
            publicIP = try? String(contentsOf: aString, encoding: .utf8)
        }
        publicIP = publicIP?.trimmingCharacters(in: CharacterSet.newlines)
        let webView = UIWebView(frame: CGRect.zero)
        let secretAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        print(secretAgent!)
        UserDefaults.standard.set(publicIP, forKey: "PublicIP")
        UserDefaults.standard.set(secretAgent, forKey: "UserAgent")
        UserDefaults.standard.synchronize()
        
        //  InviteReferrals.setup(withBrandId: 21421, encryptedKey: "CCCE3725F01795C15487BF073C0DB52F")
        
        let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any] ?? [String: Any]()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if !notification.isEmpty
        {
            print("notification: in didFinishLaunchingWithOptions method\(notification)")
            showOfferNotification(notification)
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
            let isLoggedOut = UserDefaults.standard.bool(forKey: "LoggedOut")
            let isLoggedIn = UserDefaults.standard.bool(forKey: "IsUserLoggedIn")
            if isLoggedIn
            {
                if isLoggedOut
                {
                    navigationControler = (window?.rootViewController as? UINavigationController)
                    let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    let controller: SavedUserLoginViewController? = (mainStoryboard.instantiateViewController(withIdentifier: "SavedLogin") as? SavedUserLoginViewController)
                    navigationControler?.pushViewController(controller!, animated: false)
                }
                else
                {
                    navigationControler = (window?.rootViewController as? UINavigationController)
                    let accExp: Bool = UserDefaults.standard.bool(forKey: "AccountExpired")
                    let payDone: Bool = UserDefaults.standard.bool(forKey: "PaymentDone")
                    if payDone == true && accExp == false
                    {
                        let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                        let MyPets: MyPetsViewController = mainStoryboard.instantiateViewController(withIdentifier: "MyPets") as! MyPetsViewController
                        let centerId: Any = UserDefaults.standard.value(forKey: "CenterID") as Any
                        if centerId as? Int == 57
                        {
                            MyPets.isFromNS = true
                        }
                        else
                        {
                            MyPets.isFromNS = false
                        }
                        navigationControler?.pushViewController(MyPets, animated: false)
                    }
                    else
                    {
                        let storyboard13 = UIStoryboard(name: "Main_iPhone", bundle: nil)
                        let destViewController = storyboard13.instantiateViewController(withIdentifier: "MyPlan") as? MyPlanViewController
                        destViewController?.isFromVC = true
                        destViewController?.isFromAppDel = true
                        self.navigationControler?.pushViewController(destViewController!, animated: false)
                    }
                }
            }
            else
            {
                navigationControler = (window?.rootViewController as? UINavigationController)
                let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                let controller: LoginViewController? = (mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController)
                navigationControler?.pushViewController(controller!, animated: false)
            }
            
        }
        else
        {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "OpenSans-Light", size: 20) ?? UIFont.systemFont(ofSize: 13)]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor(red: (0.0 / 255.0), green: (128.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *)
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *)
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // InviteReferrals.application(application, open:url as URL?, sourceApplication:sourceApplication, annotation:annotation )
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        let defaults = UserDefaults.standard
        defaults.set(deviceTokenString, forKey: "deviceToken")
        defaults.synchronize()
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any])
    {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        let segueDictionary = data["aps"] as? [String: Any]
        
        let segueMsg = segueDictionary!["alert"] as! String
        let segueID = data["id"] as? NSNumber
        let segueDate = (data["date"] as? String)
        let segueTime = data["time"] as? String
        //        if application.applicationState == .inactive
        //        {
        if (segueID == 13)
        {
            let advertisingUrl: String = (data["advertisingUrl"] as? String)!
            let defaults = UserDefaults.standard
            defaults.set(segueMsg, forKey: "notificationMsg")
            defaults.set(segueDate, forKey: "notifcationdate")
            defaults.set(segueTime, forKey: "notifcationtime")
            defaults.set(advertisingUrl, forKey: "advertisingUrl")
            defaults.synchronize()
            navigationControler = (window?.rootViewController as? UINavigationController)
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let controller: offerViewController? = mainStoryboard.instantiateViewController(withIdentifier: "offerViewController") as? offerViewController
            navigationControler?.pushViewController(controller!, animated: true)
        }
        else if (segueID == 1)
        {
            let apptId: String = (data["aptid"] as? String)!
            let defaults = UserDefaults.standard
            defaults.set(segueMsg, forKey: "notificationMsg")
            defaults.set(segueDate, forKey: "notifcationdate")
            defaults.set(segueTime, forKey: "notifcationtime")
            defaults.set(apptId, forKey: "upcomingId")
            defaults.synchronize()
            navigationControler = (window?.rootViewController as? UINavigationController)
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "appointment", bundle: nil)
            let showDetails: UpcomingAppointmentNotificationsViewController? = mainStoryboard.instantiateViewController(withIdentifier: "upcomingDetails") as? UpcomingAppointmentNotificationsViewController
            navigationControler?.pushViewController(showDetails!, animated: true)
        }
        else if(segueID == 1234)
        {
            let userId = data["UserId"]
            let promoCode = data["PromocodeId"]
            let popUpId = data["PopupId"]
            let notDay = data["NotificationDay"]
            let defaults: UserDefaults? = UserDefaults.standard
            defaults?.set(userId, forKey: "NotificationUserId")
            defaults?.set(promoCode, forKey: "PromoCodeId")
            defaults?.set(popUpId, forKey: "PopupId")
            defaults?.set(notDay, forKey: "NotifyDay")
            defaults?.synchronize()
            navigationControler = window?.rootViewController as? UINavigationController
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let showDetails = mainStoryboard.instantiateViewController(withIdentifier: "ShowPopUp") as? ShowPopUpViewController
            navigationControler?.pushViewController(showDetails ?? UIViewController(), animated: true)
        }
        //        }
        //        else
        //        {
        //            if (segueID == 13)
        //            {
        //                let advertisingUrl: String = (data["advertisingUrl"] as? String)!
        //                let defaults = UserDefaults.standard
        //                defaults.set(segueMsg, forKey: "notificationMsg")
        //                defaults.set(segueDate, forKey: "notifcationdate")
        //                defaults.set(segueTime, forKey: "notifcationtime")
        //                defaults.set(advertisingUrl, forKey: "advertisingUrl")
        //                defaults.synchronize()
        //                let localNotification = UILocalNotification()
        //                localNotification.userInfo = data
        //                localNotification.soundName = UILocalNotificationDefaultSoundName
        //                localNotification.alertBody = segueMsg
        //                localNotification.fireDate = Date()
        //                UIApplication.shared.scheduleLocalNotification(localNotification)
        //            }
        //            else if (segueID == 1)
        //            {
        //                let apptId: String = (data["aptid"] as? String)!
        //                let defaults = UserDefaults.standard
        //                defaults.set(segueMsg, forKey: "notificationMsg")
        //                defaults.set(segueDate, forKey: "notifcationdate")
        //                defaults.set(segueTime, forKey: "notifcationtime")
        //                defaults.set(apptId, forKey: "upcomingId")
        //                defaults.synchronize()
        //                let localNotification = UILocalNotification()
        //                localNotification.userInfo = data
        //                localNotification.soundName = UILocalNotificationDefaultSoundName
        //                localNotification.alertBody = segueMsg
        //                localNotification.fireDate = Date()
        //                UIApplication.shared.scheduleLocalNotification(localNotification)
        //            }
        //            else if(segueID == 1234)
        //            {
        //                let userId = data["UserId"]
        //                let promoCode = data["PromocodeId"]
        //                let popUpId = data["PopupId"]
        //                let notDay = data["NotificationDay"]
        //                let defaults: UserDefaults? = UserDefaults.standard
        //                defaults?.set(userId, forKey: "NotificationUserId")
        //                defaults?.set(promoCode, forKey: "PromoCodeId")
        //                defaults?.set(popUpId, forKey: "PopupId")
        //                defaults?.set(notDay, forKey: "NotifyDay")
        //                defaults?.synchronize()
        //                let localNotification = UILocalNotification()
        //                localNotification.userInfo = data
        //                localNotification.soundName = UILocalNotificationDefaultSoundName
        //                localNotification.alertBody = segueMsg
        //                localNotification.fireDate = Date()
        //                UIApplication.shared.scheduleLocalNotification(localNotification)
        //            }
        //        }
        
    }
    
    //pragma mark - iOS 10.x above UNUserNotificationCenterDelegate methods
    
    
    @available(iOS 10.0, *)
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    //    {
    //        //Called when a notification is delivered to a foreground app.
    //        UIApplication.shared.registerForRemoteNotifications()
    //        print("Userinfo \(notification.request.content.userInfo)")
    //        completionHandler([.alert, .badge, .sound])
    //    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        //Called to let your app know which action was selected by the user for a given notification.
        print("Userinfo in userNotificationCenter \(response.notification.request.content.userInfo)")
        showOfferNotification((response.notification.request.content.userInfo as? [String: Any])!)
    }
    func showOfferNotification(_ offerNotificationDic: [String: Any])
    {
        let segueDictionary = offerNotificationDic["aps"] as? [String: Any]
        
        let segueMsg = segueDictionary!["alert"] as? String
        let segueID: NSNumber = offerNotificationDic["id"] as! NSNumber
        let segueDate = offerNotificationDic["date"] as? String
        let segueTime = offerNotificationDic["time"] as? String
        
        if (segueID == 13)
        {
            let advertisingUrl = offerNotificationDic["advertisingUrl"] as? String
            let defaults = UserDefaults.standard
            defaults.set(segueMsg, forKey: "notificationMsg")
            defaults.set(segueDate, forKey: "notifcationdate")
            defaults.set(segueTime, forKey: "notifcationtime")
            defaults.set(advertisingUrl, forKey: "advertisingUrl")
            defaults.synchronize()
            navigationControler = (window?.rootViewController as? UINavigationController)
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let controller: offerViewController? = mainStoryboard.instantiateViewController(withIdentifier: "offerViewController") as? offerViewController
            navigationControler?.pushViewController(controller!, animated: true)
        }
        else if (segueID == 1)
        {
            let apptId = offerNotificationDic["aptid"] as? String
            let defaults = UserDefaults.standard
            defaults.set(segueMsg, forKey: "notificationMsg")
            defaults.set(segueDate, forKey: "notifcationdate")
            defaults.set(segueTime, forKey: "notifcationtime")
            defaults.set(apptId, forKey: "upcomingId")
            defaults.synchronize()
            navigationControler = (window?.rootViewController as? UINavigationController)
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "appointment", bundle: nil)
            let showDetails: UpcomingAppointmentNotificationsViewController? = mainStoryboard.instantiateViewController(withIdentifier: "upcomingDetails") as? UpcomingAppointmentNotificationsViewController
            navigationControler?.pushViewController(showDetails!, animated: true)
        }
        else if(segueID == 1234)
        {
            let userId = offerNotificationDic["UserId"]
            let promoCode = offerNotificationDic["PromocodeId"]
            let popUpId = offerNotificationDic["PopupId"]
            let notDay = offerNotificationDic["NotificationDay"]
            let defaults: UserDefaults? = UserDefaults.standard
            defaults?.set(userId, forKey: "NotificationUserId")
            defaults?.set(promoCode, forKey: "PromoCodeId")
            defaults?.set(popUpId, forKey: "PopupId")
            defaults?.set(notDay, forKey: "NotifyDay")
            defaults?.synchronize()
            navigationControler = window?.rootViewController as? UINavigationController
            navigationControler?.isNavigationBarHidden = false
            let mainStoryboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            let showDetails = mainStoryboard.instantiateViewController(withIdentifier: "ShowPopUp") as? ShowPopUpViewController
            navigationControler?.pushViewController(showDetails ?? UIViewController(), animated: true)
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // RTCPeerConnectionFactory.deinitializeSSL()
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Activ4PetsPMS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

