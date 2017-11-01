

//
//  ManagerHomeViewController.swift
//  GoValet
//
//  Created by Ajeesh T S on 24/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

//ValetMngrVC
let KValetMaangerRequestTimerTime : TimeInterval = 20

var parkingCount = ""

extension ManagerHomeViewController: WebServiceTaskManagerProtocol, RequestCellDelegate {
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
                self.parkingNumLbl.text = self.staffTextNumTxtFld.text
                self.popupConterView.isHidden = true
                if response.data?.successMessage != nil{
                    if response.data?.successMessage?.isBlank == false{
                        self.showUpdateCountMsgAlert(response.data?.successMessage)
                    }
                }
                self.showUpdateCountMsgAlert(response.data?.successMessage)
            }else if servicemanger.currentServiceType == .nonMember{
                self.fetchAllPendingRequest()
            }
            else if servicemanger.currentServiceType == .fetchPendingRequest{
                if let requestArray = response.data?.responseModel as? [ValetRequest] {
                    self.valetRequestList = requestArray
                    self.listTableView.reloadData()
                }

            }else{
                if response.data?.successMessage != nil{
                    if response.data?.successMessage?.isBlank == false{
                        self.showAlert(nil, message: response.data?.successMessage)
                    }
                }
            }

        }
    }
    
    func cancelButtonClicked(_ cell:RequestTableViewCell){
        if let iD = cell.request?.ID {
            let idStr : String = iD
            self.cancelRequest(idStr)
            self.valetRequestList.remove(at: cell.row)
            self.listTableView.reloadData()
        }
    
    }
    
    func callButtonClicked(_ cell:RequestTableViewCell){
        self.showCallButtonConfirmation("")
    }
    
    func readyButtonClicked(_ cell:RequestTableViewCell){
        if let iD = cell.request?.ID {
            let idStr : String = iD
            self.readyRequest(idStr)
        }
        self.valetRequestList.remove(at: cell.row)
        self.listTableView.reloadData()
    }
    
    func imageButtonClicked(_ cell:RequestTableViewCell){
        imageDetailedConterView.isHidden = false
        if let imageUrl = cell.request?.valet_image{
            detailedImageView.sd_setImage(with: URL(string:(imageUrl)))
        }

    }

    func showCallButtonConfirmation(_ number:String){
        let optionMenu = UIAlertController(title: number, message:"Do you want to call", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.callNumber(number)
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(yesAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

}

class ManagerHomeViewController: BaseViewController,UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var popupConterView : UIView!
    @IBOutlet weak var countLblView : UIView!

    @IBOutlet weak var homeMainViewContiner : UIView!
    @IBOutlet weak var staffTextNumTxtFld : CustomTextField!
    @IBOutlet weak var parkingNumTxtFld : CustomTextField!
    @IBOutlet weak var parkingNumLbl : UILabel!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var listTableView : UITableView!
    @IBOutlet weak var imageDetailedConterView : UIView!
    @IBOutlet weak var detailedImageView : UIImageView!


    
    var valetRequestList = [ValetRequest]()


    override func viewDidLoad() {
        self.showAppThemeNavigationBar = true
        super.viewDidLoad()
        self.addLogo()
        NotificationCenter.default.addObserver(self, selector: #selector(self.sideMenuOpen), name: NSNotification.Name(rawValue: "SideMenuOpenNotification"), object: nil)
        popupConterView.layer.cornerRadius = 5.0
        homeMainViewContiner.isHidden = false
        popupConterView.isHidden = false
        listTableView.tableFooterView = UIView()
        staffTextNumTxtFld.roundCornerValue(3.0)
        parkingNumTxtFld.roundCornerValue(3.0)
        countLblView.roundCornerValue(3.0)
        listTableView.roundCornerValue(3.0)
        listTableView.backgroundColor = UIColor.clear
        imageDetailedConterView.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parkingNumLbl.text = parkingCount
    }
    
    func sideMenuOpen(_ notification: Notification){
        //        addPush = true
        let dict = notification.object as! NSDictionary
        let receivednumber : String = dict["menu"] as! String
        let order :Int =  Int(receivednumber)!
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        switch order {
        case 1:
            let profiletVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            self.navigationController?.pushViewController(profiletVC, animated: false)
        case 2:
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "StaffCountVC") as! StaffCountUIViewController
            self.navigationController?.pushViewController(paymentVC, animated: true)
        case 3:
            let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HostoryVC") as! HistoryViewController
            self.navigationController?.pushViewController(historyVC, animated: true)
        default:
            break
        }
        
        
        //        self.presentViewController(viewController, animated: true, completion: nil)
        
        //        let receivedString = dict["mytext"]
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if valetRequestList.count > 0{
            return valetRequestList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestTableViewCell
        cell.delegate = self
        cell.row = indexPath.row
        cell.request = valetRequestList[indexPath.row]
        cell.showData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
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
            self.fetchAllPendingRequest()
            self.timerForGetAllRequest()
        }));
        present(alerController, animated: true, completion: nil)
    }
    
    func timerForGetAllRequest(){
        _ = Timer.scheduledTimer(timeInterval: KValetMaangerRequestTimerTime, target: self, selector: #selector(HomeViewController.callGetRequestApiDetailsAPI), userInfo: nil, repeats: true)
    }
    
    func callGetRequestApiDetailsAPI(){
        let serviceManager = ValetServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.fetchAllPendinRequest()
    }
    
    func fetchAllPendingRequest(){
        self.addLoaingIndicator()
        let serviceManager = ValetServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.fetchAllPendinRequest()
    }
    
    
    func cancelRequest(_ iD : String){
        self.addLoaingIndicator()
        let serviceManager = ValetServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.changeValetStatus(false,iD: iD)
    }
    
    func readyRequest(_ iD : String){
        self.addLoaingIndicator()
        let serviceManager = ValetServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.changeValetStatus(true, iD: iD)
    }
    
    
    @IBAction func nonMemberButtonClicked(){
        self.addLoaingIndicator()
        let serviceManager = ValetServiceManager()
        serviceManager.managerDelegate = self
        serviceManager.nonMemberRequest()
    }
    
    @IBAction func imageViewCloseBtnClicked(){
        self.imageDetailedConterView.isHidden = true
    }


}
