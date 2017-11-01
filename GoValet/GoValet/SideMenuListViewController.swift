//
//  SideMenuListViewController.swift
//  Priza
//
//  Created by Ajeesh T S on 10/10/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

extension SideMenuListViewController :WebServiceTaskManagerProtocol{
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:NSString?)){
        if response.data == nil{
        }else{
//            if let products = response.data?.responseModel as? [Product] {
//                productList = products
//                self.productCollectionView.reloadData()
//            }
        }
    }
}

class SideMenuListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listTableVew : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableVew.tableFooterView = UIView()
//        self.getCatageoryList()

        // Do any additional setup after loading the view.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserInfo.currentUser()?.userType == "valet_manager"{
            return 4
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0{
            let userProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! UserProfileCell
            userProfileCell.userNameLbl?.font = UIFont.systemFont(ofSize: 13.0)
            if UserInfo.currentUser()?.userType == "valet_manager"{
                userProfileCell.userNameLbl.text = "Manager"
            }else{
                userProfileCell.showUserInfo()
            }
            userProfileCell.showUserInfo()
            cell = userProfileCell
        }else{
           let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! SideMenuCell
            menuCell.menuTitleLbl?.font = UIFont.systemFont(ofSize: 16.0)

            switch indexPath.row {
            case 1:
                if UserInfo.currentUser()?.userType == "valet_manager"{
                    menuCell.menuTitleLbl.text = "Shift Staff Number".localized
                    menuCell.menuImageView.image = UIImage(named:"ShiftSetting")
                }else{
                    menuCell.menuTitleLbl.text = "Payment".localized
                    menuCell.menuImageView.image = UIImage(named:"Payments")
                }
            case 2:
                if UserInfo.currentUser()?.userType == "valet_manager"{
                    menuCell.menuTitleLbl.text  = "Settings".localized
                    menuCell.menuImageView.image = UIImage(named:"Settings")
                }else{
                    menuCell.menuTitleLbl.text  = "History".localized
                    menuCell.menuImageView.image = UIImage(named:"History")
                }

            case 3:
                if UserInfo.currentUser()?.userType == "valet_manager"{
                    menuCell.menuTitleLbl.text  = "Help".localized
                    menuCell.menuImageView.image = UIImage(named:"Help")
                }else{
                    menuCell.menuTitleLbl.text  = "Help".localized
                    menuCell.menuImageView.image = UIImage(named:"Help")
                }

            case 4:
                menuCell.menuTitleLbl.text  = "Settings".localized
                menuCell.menuImageView.image = UIImage(named:"Settings")

            default: break
            }
            cell = menuCell
        }
        
       
//        if indexPath.row != 0 {
//            cell.textLabel?.text = titleStr
//            cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        showCategoryView()
        DispatchQueue.main.async(execute: { () -> Void in
            var titleStr = ""
            switch indexPath.row {
            case 0: break
                
            case 1:
                if UserInfo.currentUser()?.userType == "valet_manager"{
                    let myDict = ["menu": "2"]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "SideMenuOpenNotification"), object:myDict);
                    self.closeMenu()
                }else{
                    self.showPasswordConfirmAlert()
                }
            case 2:
                var myDict = ["menu": "3"]
                if UserInfo.currentUser()?.userType == "valet_manager"{
                    myDict = ["menu": "1"]
                }

//                self.dismissViewControllerAnimated(true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SideMenuOpenNotification"), object:myDict);
                self.closeMenu()
            case 3:
                UIApplication.shared.openURL(URL(string: "https://www.google.com")!)
//                let myDict = ["menu": "4"]
//                self.dismissViewControllerAnimated(true, completion: nil)
//                NSNotificationCenter.defaultCenter().postNotificationName("SideMenuOpenNotification", object:myDict);
            case 4:
                let myDict = ["menu": "1"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SideMenuOpenNotification"), object:myDict);
                self.closeMenu()

//                titleStr = "FAQ"
            case 5:
                titleStr = "Logout".localized
                self.showLogoutConfirmAlert()
            case 6:
                titleStr = "About Us"
            case 7:
                titleStr = "Contact Us"
            case 8:
                titleStr = "Logout".localized
                self.showLogoutConfirmAlert()
            default:
                titleStr = ""
            }
            
        })

    }
    
    func closeMenu(){
        let currentLanguage = Locale.preferredLanguages[0]
        if currentLanguage == "ar-US"{
            self.slideMenuController()?.closeRight()
        }else{
            self.slideMenuController()?.closeLeft()
        }
    }
    
    func showPasswordConfirmAlert(){
        let alertController = UIAlertController(title: "", message: "Please enter your Password", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field : UITextField = alertController.textFields![0] {
                if field.text?.isBlank == true {
                    UtilityMethods.showAlert("Wrong Password!", tilte: "Warning!".localized, presentVC: self)
                }else{
                    if UserInfo.currentUser()?.password != nil{
                        let passwd  : String = (UserInfo.currentUser()?.password)!
                        if field.text == passwd{
                            self.showPaymentScreen()
                        }else{
                            UtilityMethods.showAlert("Wrong Password!", tilte: "Warning!".localized, presentVC: self)
                        }
                    }
                }
            }else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPaymentScreen(){
        let myDict = ["menu": "2"]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SideMenuOpenNotification"), object:myDict);
        self.closeMenu()
    }
    
    
    func showLogoutConfirmAlert() {
        let alerController = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alerController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {(action:UIAlertAction) in
            self.logout()
        }));
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
    }
    
    func logout(){
        UserInfo.currentUser()?.clearSession()
        let loginManager = LoginServiceManager()
        loginManager.loginOut()
        self.dismiss(animated: false, completion: nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNav")
        UIApplication.shared.keyWindow?.rootViewController = viewController;
    }
    


}
