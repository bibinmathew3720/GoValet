//
//  HomeViewController.swift
//  GoValet
//
//  Created by Ajeesh T S on 17/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit
import CameraManager
import CameraEngine
import MessageUI

let KValetRequestTimerTime : TimeInterval = 20

extension HomeViewController: WebServiceTaskManagerProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:NSString?)){
        self.removeLoadingIndicator()
        
        if response.error != nil{
            let errmsg : String = response.error! as String
            self.showAlert("Warning!".localized, message: errmsg)
            return
        }
        if response.data == nil{
//            if response.error != nil{
//            let errmsg : String = response.error! as String
////            self.successView.hidden = false
//                self.showAlert("Warning!".localized, message: errmsg)
//            }
        }else{
            if let managerType = manager as? UserServiceTaskManager{
                if managerType.currentServiceType == UserServiceType.sentValetRequest{
                    self.successView.isHidden = false
                    self.requestType = 1
                    self.configureSuccesView(1)
                    valetSucessResult = response.data?.responseModel as? ValetResonse
                    if let waitingTime = valetSucessResult?.averageTime{
                        let strVal : String = waitingTime
                        self.count = Float(strVal)!
                        if valetSucessResult?.iD != nil{
                            let rId : String = (valetSucessResult?.iD)!
                            UserInfo.currentUser()?.currentRequestID = rId
                            UserInfo.currentUser()?.save()
                        }
                        self.requestType = 1
                        showTimerValue()
//                        self.configureSuccesView(1)
                    }
                }
                else if managerType.currentServiceType == .cancelValetRequest{
                    if let msg = response.data?.successMessage {
                        self.showAlert("GoValet", message: msg)
                    }
                }
                else if managerType.currentServiceType == UserServiceType.requestDetails{
                    valetSucessResult = response.data?.responseModel as? ValetResonse
                    if let status = valetSucessResult?.status{
                        let statusVal : String = status
                        if valetSucessResult?.iD != nil{
                            let rId : String = (valetSucessResult?.iD)!
                            UserInfo.currentUser()?.currentRequestID = rId
                            UserInfo.currentUser()?.save()
                        }
                        if statusVal == "cancelled"{
//                            cancelled , completed, pending
                            self.successView.isHidden = false
                            self.requestType = 2
                            self.configureSuccesView(2)
                        }
                        else if statusVal == "pending"{
                            self.successView.isHidden = false
                            self.requestType = 1
                            if managerType.isRepeatApi == false{
                                self.configureSuccesView(1)
                            }
                            if let waitingTime = valetSucessResult?.averageTime{
                                let strVal : String = waitingTime
                                if managerType.isRepeatApi == false{
                                    self.count = Float(strVal)!
                                }
                                if self.count > 0{
                                    if managerType.isRepeatApi == false{
                                        self.showTimerValue()
                                    }
                                }
                            }
                        }
                        else if statusVal == "completed"{
                            self.successView.isHidden = false
                            self.requestType = 3
                            self.configureSuccesView(3)
                        }
                    }
                }
                else{
                    if let hotelsArray = response.data?.responseModel as? [Hotel] {
                        self.hotelList = hotelsArray
                      //  hotelListTable.hidden = false
                        selectedHotel = hotelList.first
                        self.showSelectedHotelData()
                        self.hotelListTable.reloadData()
                    }
                }
            }
           
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion: nil)
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.scanImageView.image = tempImage
        isSelectedImage = true
    }
}

class HomeViewController: BaseViewController ,MFMessageComposeViewControllerDelegate{

    var manager: OneShotLocationManager?
    var selectedHotel :  Hotel?
    var valetSucessResult :  ValetResonse?

    @IBOutlet weak var hotelListTable : UITableView!
    @IBOutlet weak var selectedHotelImageView : UIImageView!
    @IBOutlet weak var distacneLbl : UILabel!
    @IBOutlet weak var hotelNameLbl : UILabel!
    @IBOutlet weak var selectedHotelContainer : UIView!

    @IBOutlet weak var typeCodeTxtFld : CustomTextField!
    @IBOutlet weak var scanCodeImageContainer : UIView!
    @IBOutlet weak var scanCodeBtn : UIButton!
    @IBOutlet weak var scanImageView : UIImageView!
    @IBOutlet weak var imagePreviewcloseBtn : UIButton!


    var requestType = 1
    @IBOutlet weak var successView : UIView!
    @IBOutlet weak var successViewcloseBtn : UIButton!

    @IBOutlet weak var successViewContainer : UIView!
    @IBOutlet weak var avgTimeLbl : UILabel!
    @IBOutlet weak var hotelAvgTimeLbl : UILabel!

    var imagePicker: UIImagePickerController!

    var isSelectedImage = false
    var count : Float = 0.0

    var hotelList = [Hotel]()
    
    
    let cameraManager = CameraManager
    let cameraEngine = CameraEngine

    
    var isCameraShowingMode = true
    
    var recursiveApiCallingTImer = Timer()
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var cameraView: UIView!

    
    override func viewDidLoad() {
        self.showAppThemeNavigationBar = true
        imagePreviewcloseBtn.isHidden = true
        super.viewDidLoad()
        self.enablePushnotification()
        self.getValetRequestDetails()
        self.timerForGetRequestApiDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(self.sideMenuOpen), name: NSNotification.Name(rawValue: "SideMenuOpenNotification"), object: nil)
        hotelListTable.tableFooterView = UIView()
        hotelListTable.separatorColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        hotelListTable.isHidden = true
        selectedHotelContainer.roundCornerValue(3.0)
        scanCodeBtn.roundCornerValue(3.0)
        avgTimeLbl.roundCornerValue(3.0)
        scanCodeImageContainer.roundCornerValue(3.0)
        successViewContainer.roundCornerValue(3.0)
        hotelAvgTimeLbl.roundCornerValue(3.0)
        typeCodeTxtFld.roundCorner()
        let logo = UIImage(named: "logNav")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        getHotelListFromServer()
        self.cameraEngine.sessionPresset = .photo
        self.cameraEngine.startSession()
    }
    
    
    func enablePushnotification(){
        // Override point for customization after application launch.
        let application = UIApplication.shared
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        registerForPushNotifications(application)
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func showPasswordConfirmAlert(){
        let alertController = UIAlertController(title: "", message: "Please enter your Password", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "userEmail")
                UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func configureSuccesView(_ type: Int){
        if type == 1{
            successViewcloseBtn.setTitle("Cancel", for: UIControlState())
            if self.valetSucessResult?.averageTime != nil{
                let strVal : String = (self.valetSucessResult?.averageTime)!
                 let val = Float(strVal)!
                avgTimeLbl.text = "Average Time : \(val) Min"
                let currentLanguage = Locale.preferredLanguages[0]
                if currentLanguage == "ar-US"{
                    avgTimeLbl.text = "الـوقـت المتوقــع: \(val) دقائق"
                }
            }else{
                avgTimeLbl.text = "Average Time : "
                let currentLanguage = Locale.preferredLanguages[0]
                if currentLanguage == "ar-US"{
                    avgTimeLbl.text = "الـوقـت المتوقــع: دقائق"
                }
            }

        }
        else if type == 2{
            successViewcloseBtn.setTitle("Ok", for: UIControlState())
            avgTimeLbl.text = "Request has been cancelled"
        }
        else if type == 3{
            successViewcloseBtn.setTitle("Ok", for: UIControlState())
            avgTimeLbl.text = "Your car is ready"
        }

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        cameraManager.stopCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        let layer = self.cameraEngine.previewLayer
        layer.frame = self.scanCodeImageContainer.bounds
        self.scanCodeImageContainer.layer.insertSublayer(layer, at: 0)
        self.scanCodeImageContainer.layer.masksToBounds = true
    }
    
    func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(scanCodeImageContainer, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationBtnClicked(){
        if hotelList.count > 0{
            hotelListTable.isHidden = false
        }else{
            getHotelListFromServer()
        }
    }
    
    @IBAction func currentLocationBtnClicked(){
        self.getHotelBasedUserCurrentLocation()
    }
    
    
    func getHotelListFromServer(){
        self.getHotelBasedUserCurrentLocation()

//        if let lattiutde = NSUserDefaults.standardUserDefaults().objectForKey("lattiutde") as? String {
//            if let longitude = NSUserDefaults.standardUserDefaults().objectForKey("longitude") as? String {
//                self.getHotelListFromService(lattiutde, longitude: longitude)
//            }
//        }else{
//           self.getHotelBasedUserCurrentLocation()
//        }
    }
    
    func getHotelBasedUserCurrentLocation(){
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                print(location)
                let user_lat = String(format: "%f", loc.coordinate.latitude)
                let user_long = String(format: "%f", loc.coordinate.longitude)
                UserDefaults.standard.set(user_lat, forKey: "lattiutde")
                UserDefaults.standard.set(user_long, forKey: "longitude")
                self.getHotelListFromService(user_lat, longitude: user_long)
            } else if let err = error {
                //                self.showLocationPickerMapWithDefaultLocation()
                print(err.localizedDescription)
                if let lattiutde = UserDefaults.standard.object(forKey: "lattiutde") as? String {
                    if let longitude = UserDefaults.standard.object(forKey: "longitude") as? String {
                        self.getHotelListFromService(lattiutde, longitude: longitude)
                    }
                }
            }
            self.manager = nil
        }
    }
    
    @IBAction func contactBtnClicked(){
        let alerController = UIAlertController(title: "", message: "contact", preferredStyle: .actionSheet)
        alerController.addAction(UIAlertAction(title: "Call", style: .default, handler: {(action:UIAlertAction) in
            self.calltoNumber()
        }));
        alerController.addAction(UIAlertAction(title: "SMS", style: .default, handler: {(action:UIAlertAction) in
            self.openSMSview()
        }));
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
    }
    
    func openSMSview(){
        let messageVC = MFMessageComposeViewController.init()
        messageVC.body = " ";
        if valetSucessResult?.hotel?.phone != nil{
            let phone  : String = (valetSucessResult?.hotel?.phone)!
            messageVC.recipients = [phone]
        }
        messageVC.messageComposeDelegate = self;
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func calltoNumber(){
        if valetSucessResult?.hotel?.phone != nil{
            let phone  : String = (valetSucessResult?.hotel?.phone)!
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnClicked(){
        self.successView.isHidden = true
        scanImageView.image = nil
        typeCodeTxtFld.text = ""
        if self.requestType == 1{
            if valetSucessResult?.iD != nil{
                UserInfo.currentUser()?.currentRequestID = nil
                UserInfo.currentUser()?.save()
                self.cancelValetRequest((valetSucessResult?.iD)!)
            }
        }
        else if self.requestType == 3{
            UserInfo.currentUser()?.currentRequestID = nil
            UserInfo.currentUser()?.save()
        }
        self.resetImageCapturing()
        
    }
    
    @IBAction func imageCloseBtnClicked(){
        self.resetImageCapturing()
    }
    
    
    func resetImageCapturing(){
        self.scanCodeBtn.isUserInteractionEnabled = true
        imagePreviewcloseBtn.isHidden = true
        self.scanCodeImageContainer.sendSubview(toBack: self.scanImageView)
        self.scanImageView.isHidden = true
        self.scanImageView.image = nil
        self.isSelectedImage = false
        self.isCameraShowingMode = true
    }
    
    @IBAction func scanImageBtnClicked(){
        
        self.cameraEngine.capturePhoto { (image: UIImage?, error: NSError?) -> (Void) in
            self.scanImageView.isHidden = false
            self.scanCodeImageContainer.bringSubview(toFront: self.scanImageView)
            self.scanCodeImageContainer.bringSubview(toFront: self.imagePreviewcloseBtn)
            self.scanImageView.image = image
            self.isSelectedImage = true
            self.isCameraShowingMode = false
            self.imagePreviewcloseBtn.isHidden = false
            self.scanCodeBtn.isUserInteractionEnabled = false
        }
      
    }

    @IBAction func getItBtnClicked(){
        if isSelectedImage == false{
            if self.typeCodeTxtFld.text?.isBlank == true{
                self.showWarningAlert("Please Add Code")
                return
            }
        }
        if self.typeCodeTxtFld.text?.isBlank == true{
            if isSelectedImage == false{
                self.showWarningAlert("Please Add Code")
                return
            }
        }
        if self.selectedHotel == nil{
            self.showWarningAlert("Please Select the Hotel")
            return
        }
        self.addLoaingIndicator()
        let hotelListManager = UserServiceTaskManager()
        hotelListManager.managerDelegate = self
//        self.requestType = 1
        if self.typeCodeTxtFld.text?.isBlank == true{
            if scanImageView.image != nil{
                hotelListManager.sendValetRequest((selectedHotel?.hotelId!)!, valetCode:nil, scanImage: scanImageView.image!)
            }else{
                hotelListManager.sendValetRequest((selectedHotel?.hotelId!)!, valetCode:typeCodeTxtFld.text, scanImage: nil)
            }
        }else{
            hotelListManager.sendValetRequest((selectedHotel?.hotelId!)!, valetCode:typeCodeTxtFld.text, scanImage: nil)
        }
        
    }

    
    func getHotelListFromService(_ lattitude:String,longitude:String){
        self.addLoaingIndicator()
        let hotelListManager = UserServiceTaskManager()
        hotelListManager.managerDelegate = self
        hotelListManager.getHotelsList(lattitude, longitude: longitude)
    }
    
    func cancelValetRequest(_ requestID: String){
        self.addLoaingIndicator()
        let hotelListManager = UserServiceTaskManager()
        hotelListManager.managerDelegate = self
        hotelListManager.cancelRequest(requestID)
    }
    
    func getValetRequestDetails(){
        if UserInfo.currentUser()?.currentRequestID != nil{
            let requestID : String = (UserInfo.currentUser()?.currentRequestID)!
//            self.addLoaingIndicator()
            let hotelListManager = UserServiceTaskManager()
            hotelListManager.managerDelegate = self
            hotelListManager.requestDetailsRequest(requestID)
        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hotelList.count > 0{
            return hotelList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : HotelListCell = tableView.dequeueReusableCell(withIdentifier: "hotelListCell", for: indexPath) as! HotelListCell
        cell.showData(hotelList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        selectedHotel = hotelList[indexPath.row]
        tableView.isHidden = true
        self.showSelectedHotelData()
    }
    
    func showSelectedHotelData(){
        if let name = self.selectedHotel?.name{
            hotelNameLbl.text = name
        }
        if let distc = selectedHotel?.distance{
            distacneLbl.text = "Distance : \(distc)"
        }
        if let imageUrl = selectedHotel?.image{
            selectedHotelImageView.sd_setImage(with: URL(string:(imageUrl)))
        }
        if let avgTime = selectedHotel?.avgTime{
            hotelAvgTimeLbl.text = "Average Time : \(avgTime) Min"
            let currentLanguage = Locale.preferredLanguages[0]
            if currentLanguage == "ar-US"{
                hotelAvgTimeLbl.text = "الـوقـت المتوقــع: \(avgTime) دقائق"
            }
        }
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint.zero
        }
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
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
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

    
    func showTimerValue(){
        if self.valetSucessResult?.averageTime != nil{
            let strVal : String = (self.valetSucessResult?.averageTime)!
            count = Float(strVal)!
            count = count - 1
            avgTimeLbl.text = "Average Time : \(count) Min"
            let currentLanguage = Locale.preferredLanguages[0]
            if currentLanguage == "ar-US"{
                avgTimeLbl.text = "الـوقـت المتوقــع: \(count) دقائق"
            }
            _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(HomeViewController.update), userInfo: nil, repeats: true)
        }
    }
    
    func update() {
        if(count > 0) {
            count = count - 1
            if count > 0{
                avgTimeLbl.text = "Average Time : \(count) Min"
                let currentLanguage = Locale.preferredLanguages[0]
                if currentLanguage == "ar-US"{
                    avgTimeLbl.text = "الـوقـت المتوقــع: \(count) دقائق"
                }
            }else{
                self.requestType = 3
                self.configureSuccesView(3)
            }
        }
    }
    
    func timerForGetRequestApiDetails(){
        recursiveApiCallingTImer = Timer.scheduledTimer(timeInterval: KValetRequestTimerTime, target: self, selector: #selector(HomeViewController.callGetRequestApiDetailsAPI), userInfo: nil, repeats: true)
    }
    
    func callGetRequestApiDetailsAPI(){
        if UserInfo.currentUser()?.currentRequestID != nil{
            let requestID : String = (UserInfo.currentUser()?.currentRequestID)!
            //            self.addLoaingIndicator()
            let hotelListManager = UserServiceTaskManager()
            hotelListManager.managerDelegate = self
            hotelListManager.isRepeatApi = true
            hotelListManager.requestDetailsRequest(requestID)
        }
    }
    
    
}
