

//
//  CommonTaskManager.swift
//  GoValet
//
//  Created by Ajeesh T S on 19/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit



enum ServiceType {
    case history
    case profile
    case editProfile
    case addCar
}

extension CommonTaskManager : BaseServiceDelegates {
   
    func didSuccessfullyReceiveData(_ response:RestResponse?){
        let responseData = response!.response!
        if let errorMsg = responseData["error"].string{
            managerDelegate?.didFinishTask(from: self, response: (data: nil, error: errorMsg))
            return
        }
        if currentServiceType == .history{
            var historyList = [History]?()
            if let historyArray = responseData["data"].array {
                historyList = [History]()
                for history in historyArray {
                    let product = History.init(dict: history)
                    historyList?.append(product)
                }
                response?.responseModel = historyList
            }
        }
        else if currentServiceType == .addCar || currentServiceType == .editProfile{
            let token =  UserInfo.currentUser()!.token
            let password =  UserInfo.currentUser()!.password
            UserInfo.createSessionWith(responseData)
            if currentServiceType == .addCar{
                UserInfo.currentUser()?.token = token
            }
            UserInfo.currentUser()?.password = password
            UserInfo.currentUser()?.save()
            UserInfo.restoreSession()
            if UserInfo.currentUser()?.token != nil{
            
            }else{
            
            }
        }
        else{
            
        }
        managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
    }
    
    func didFailedToReceiveData(_ response:RestResponse?){
        managerDelegate?.didFinishTask(from: self, response: (data: nil, error: nil))
    }

}

class CommonTaskManager: WebServiceTaskManager {
    var currentServiceType = ServiceType.history

    func getHistoryList(){
        let historyService = CommonWebService()
        historyService.delegate = self
        historyService.getHistoryList()
    }
    
    func getProfile(){
        currentServiceType = ServiceType.profile
        let historyService = CommonWebService()
        historyService.delegate = self
        historyService.viewUSerProfile()
    }
    
    func addNewCar(_ title:String, carimage: UIImage?){
        currentServiceType = ServiceType.addCar
        let addCarService = CommonWebService()
        addCarService.delegate = self
        var params = [String: AnyObject]()
        params["title"] = title as AnyObject
        addCarService.parameters = params
        if let image = carimage {
            let data = UIImageJPEGRepresentation(image, 0.8)!
            let multipartData = MultipartData(data: data, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            addCarService.uploadData = [multipartData]
        }
        
        addCarService.addCar()
    }
    
    
    func updateProfile(_ email:String,fname:String, lname:String,mobile:String, profileImage: UIImage?){
        currentServiceType = ServiceType.editProfile
        let serviceManager = CommonWebService()
        serviceManager.delegate = self
        var params = [String: AnyObject]()
        params["first_name"] = fname as AnyObject
        params["last_name"] = lname as AnyObject
//        params["email"] = email
//        params["mobile"] = mobile
        serviceManager.parameters = params
        if let image = profileImage {
            let data = UIImageJPEGRepresentation(image, 0.8)!
            let multipartData = MultipartData(data: data, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            serviceManager.uploadData = [multipartData]
        }
        serviceManager.updateProfile()
    }
    
    func updateProfileInfoWithoutImage(_ email:String,fname:String, lname:String,mobile:String){
        currentServiceType = ServiceType.editProfile
        let serviceManager = CommonWebService()
        serviceManager.delegate = self
        var params = [String: AnyObject]()
        params["first_name"] = fname as AnyObject
        params["last_name"] = lname as AnyObject
//        params["email"] = email
//        params["mobile"] = mobile
        serviceManager.parameters = params
        serviceManager.updateProfile()
    }
    


    
}
