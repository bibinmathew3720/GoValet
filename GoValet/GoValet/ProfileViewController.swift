

//
//  ProfileViewController.swift
//  GoValet
//
//  Created by Ajeesh T S on 05/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var editBtn : UIButton!
    @IBOutlet weak var languageBtn : UIButton!
    @IBOutlet weak var signoutBtn : UIButton!
    @IBOutlet  var languageBtnConstrain : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLogo()
        self.title = "SETTINGS".localized
        self.changeNavTitleColor()
        if UserInfo.currentUser()?.userType == "valet_manager"{
            editBtn.isHidden = true
            languageBtnConstrain.constant = 0
        }
        profileImageView.layer.cornerRadius = 50.0
        profileImageView.clipsToBounds = true
        editBtn.roundCornerValue(3.0)
        languageBtn.roundCornerValue(3.0)
        signoutBtn.roundCornerValue(3.0)
        self.showUserInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUserInfo(){
        if let userName = UserInfo.currentUser()?.userName{
            let uname : String = userName
            userNameLbl.text = uname
        }
        
        if let imageUrl = UserInfo.currentUser()?.profileImage{
//            profileImageView.sd_setImageWithURL(NSURL(string:(imageUrl)))
            profileImageView.sd_setImage(with: URL(string:(imageUrl)), placeholderImage: UIImage(named: "user"))
        }else{
            profileImageView.image = UIImage(named: "user")
        }
    }

    
    @IBAction func logoutBtnclicked(){
        showLogoutConfirmAlert()
    }
    
    @IBAction func editBtnclicked(){
        self.showPasswordConfirmAlert()
    }
    
    @IBAction func languageBtnclicked(){
        self.showLanguageOption()
//        let currentLanguage = NSLocale.preferredLanguages()[0]
//        
//        if currentLanguage == "ar-US"{
//            NSUserDefaults.standardUserDefaults().setObject(["en", "ar-US"], forKey: "AppleLanguages")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }else{
//            NSUserDefaults.standardUserDefaults().setObject(["ar-US", "en"], forKey: "AppleLanguages")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
//        self.showAlert("Language Change", message: "Please restart the app to change the language")

    }
    
    func showLanguageOption(){
        let alerController = UIAlertController(title: "", message: "Change Language", preferredStyle: .actionSheet)
        alerController.addAction(UIAlertAction(title: "English", style: .default, handler: {(action:UIAlertAction) in
            UserDefaults.standard.set(["en", "ar-US"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.showAlert("Language Change", message: "Please restart the app to change the language")

        }));
        alerController.addAction(UIAlertAction(title: "Arabic", style: .default, handler: {(action:UIAlertAction) in
            UserDefaults.standard.set(["ar-US", "en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.showAlert("Language Change", message: "Please restart the app to change the language")

        }));
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
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
                            let profilEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditVC") as! ProfileEditViewController
                            self.navigationController?.pushViewController(profilEditVC, animated: true)
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
