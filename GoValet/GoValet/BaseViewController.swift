//
//  BaseViewController.swift
//  Tastyspots
//
//  Created by Ajeesh T S on 21/12/15.
//  Copyright © 2015 Ajeesh T S. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController  {
    var showAppThemeNavigationBar = false
    var locationButton:UIButton = UIButton()
    var downArrowImage:UIImageView!
    var needToAddLeftSideMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if showAppThemeNavigationBar == true {
            showCustomAppThemeNavigationBar()
        }
        if needToAddLeftSideMenu == true {
//            addRightSideMenu()
        }
       
    }

    func resetRightSideMenu(){
//        addRightSideMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func showCustomAppThemeNavigationBar(){
    
        let profileButton:UIButton = UIButton(type: UIButtonType.custom)  
        profileButton.addTarget(self, action: #selector(BaseViewController.profileButtonClicked), for: UIControlEvents.touchUpInside)
        let backBtnImg: UIImage = UIImage(named: "Menu")!
        profileButton.setImage(backBtnImg, for: UIControlState())
        profileButton.frame = CGRect(x: -30, y: 0, width: 25, height: 45)
        let profileButtonItem:UIBarButtonItem = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItems  = [profileButtonItem]
    }
    
    
 
    
    func changeLicationTitle(_ title : String){
        
        let width = title.heightWithConstrainedWidth(30, font: (locationButton.titleLabel?.font)!)
        locationButton.imageEdgeInsets = UIEdgeInsetsMake(3, width + 15, 0,0)

//        heightWithConstrainedWidth()
    }
    
    func profileButtonClicked(){
        let currentLanguage = Locale.preferredLanguages[0]
        if currentLanguage == "ar-US"{
            self.slideMenuController()?.openRight()
        }else{
            self.slideMenuController()?.openLeft()
        }
        

//        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("UserToken") as? String {
//            let profileVC  = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfVC") as! UserProfileViewController
//            SideMenuManager.menuRightNavigationController?.viewControllers = [profileVC]
//        }
//        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    
    func searchButtonClicked(){
    
    }
    
 
    
    func checkLoginStatus()-> Bool{
        if AppSharedInfo.sharedInstance.isReachableInternet == true{
            if let _ = UserDefaults.standard.object(forKey: "UserToken") as? String {
                return true
            }else{
                return false
            }
            
        }else{
            UtilityMethods.showNoInternetAlert(self)
            return false
        }
    }
    



}
