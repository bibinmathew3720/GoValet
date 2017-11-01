



//
//  StaffCountUIViewController.swift
//  GoValet
//
//  Created by Ajeesh T S on 17/02/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

extension StaffCountUIViewController: WebServiceTaskManagerProtocol {
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:NSString?)){
        self.removeLoadingIndicator()
        if response.error != nil{
            let errmsg : String = response.error! as String
            if errmsg.isBlank == false{
                self.showAlert("Warning!".localized, message: errmsg)
            }
        }else{
            let servicemanger : ValetServiceManager = manager as! ValetServiceManager
            if servicemanger.currentServiceType == .updateStaffCount{
                parkingCount = self.staffTextNumTxtFld.text!
                if response.data?.successMessage != nil{
                    if response.data?.successMessage?.isBlank == false{
                        self.showUpdateCountMsgAlert(response.data?.successMessage)
                    }
                }
                self.showUpdateCountMsgAlert(response.data?.successMessage)
            }else{
                if response.data?.successMessage != nil{
                    if response.data?.successMessage?.isBlank == false{
                        self.showAlert(nil, message: response.data?.successMessage)
                    }
                }
            }
            
        }
    }
}

class StaffCountUIViewController: UIViewController {

    @IBOutlet weak var popupConterView : UIView!
    @IBOutlet weak var staffTextNumTxtFld : CustomTextField!
    @IBOutlet weak var parkingNumTxtFld : CustomTextField!
    @IBOutlet weak var submitBtn : UIButton!

    override func viewDidLoad() {
//        self.showAppThemeNavigationBar = true
        super.viewDidLoad()
        self.addLogo()
        self.title = "Shift Staff Number".localized
        self.changeNavTitleColor()
        popupConterView.layer.cornerRadius = 5.0
        popupConterView.isHidden = false
        staffTextNumTxtFld.roundCornerValue(3.0)
        parkingNumTxtFld.roundCornerValue(3.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitButtonClicked(){
        if self.staffTextNumTxtFld.text?.isBlank == false{
            self.addLoaingIndicator()
            let serviceManager = ValetServiceManager()
            serviceManager.managerDelegate = self
            if self.parkingNumTxtFld.text?.isBlank == false{
                serviceManager.updateStaffCount(self.staffTextNumTxtFld.text!, parkingcount: self.parkingNumTxtFld.text!)
            }else{
                serviceManager.updateStaffCount(self.staffTextNumTxtFld.text!, parkingcount: nil)
            }
        }else{
            self.self.showWarningAlert("Please Enter Staff Count")
        }
    }
    
    func showUpdateCountMsgAlert(_ msg:String?){
        let alerController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alerController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alerController, animated: true, completion: nil)
    }


}
