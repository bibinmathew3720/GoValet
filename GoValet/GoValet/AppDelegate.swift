//
//  AppDelegate.swift
//  GoValet
//
//  Created by Ajeesh T S on 14/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SlideMenuControllerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
//        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
//
//        registerForPushNotifications(application)
        application.applicationIconBadgeNumber = 0
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            // If your app wasn’t running and the user launches it by tapping the push notification, the push notification is passed to your app in the launchOptions
        }

        self.setupAppSettings(application)
        return true
    }
    
    
//    func registerForPushNotifications(application: UIApplication) {
//        
//        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
//    }
    
//    @available(iOS 10.0, *)
//    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
//    {
//        //Handle the notification
//        completionHandler(
//            [UNNotificationPresentationOptions.Alert,
//                UNNotificationPresentationOptions.Sound,
//                UNNotificationPresentationOptions.Badge])
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken)")
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Device Token:", tokenString)
        NSLog("Device Token:")

        NSLog(tokenString)
        UserDefaults.standard.set(tokenString, forKey: "DeviceToken")

        let serviceManger = LoginServiceManager()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString

        serviceManger.sendDeviceToken(tokenString,deviceId:tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let serviceManger = LoginServiceManager()
       // serviceManger.sendDeviceToken("asd",deviceId:"123456")
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        print(userInfo)
    }
    
    func setupAppSettings(_ application:UIApplication){
        IQKeyboardManager.sharedManager().enable = true
        application.isStatusBarHidden = false
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor =  UIColor.white
        navigationBarAppearace.barTintColor = UIColor(red:0.13, green:0.14, blue:0.14, alpha:1)
         navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.isTranslucent = true
        navigationBarAppearace.shadowImage =  UIImage()
        application.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        navigationBarAppearace.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 17)
        ]
        self.loadIntailView()
    }
    
    func loadIntailView(){
        UserInfo.restoreSession()
        if UserInfo.currentUser()?.token != nil{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
            let leftSideMenuVC = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuListViewController
            let currentLanguage = Locale.preferredLanguages[0]
            if currentLanguage == "ar-US"{
                let slideMenuController = SlideMenuController(mainViewController: navViewController, rightMenuViewController: leftSideMenuVC)
                self.window?.rootViewController = slideMenuController
            }else{
                let slideMenuController = SlideMenuController(mainViewController: navViewController, leftMenuViewController: leftSideMenuVC)
                self.window?.rootViewController = slideMenuController
            }
            self.window?.makeKeyAndVisible()
        }else{
            
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

