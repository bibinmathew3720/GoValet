//
//  LoginServiceManager.swift
//  Priza
//
//  Created by Ajeesh T S on 11/10/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit

enum LoginServiceType {
    case login
    case signup
    case `default`
}

extension LoginServiceManager : BaseServiceDelegates  {
    
    
    func didSuccessfullyReceiveData(_ response:RestResponse?){
        let responseData = response!.response!
        if let errorMsg = responseData["error"].string{
            managerDelegate?.didFinishTask(from: self, response: (data: response, error: errorMsg))
            return
        }
        if currentServiceType == .login || currentServiceType == .signup{
            UserInfo.createSessionWith(responseData)
            if isRemberMe == true{
                if UserInfo.currentUser()?.userType != "valet_manager"{
                    UserInfo.currentUser()?.save()
                }
            }
        }
        managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
    }

    func didFailedToReceiveData(_ response:RestResponse?){
        managerDelegate?.didFinishTask(from: self, response: (data: nil, error: nil))
    }

}
        

class LoginServiceManager: WebServiceTaskManager {
    
    var currentServiceType = LoginServiceType.default
    func login(_ email:String, passwd:String){
        currentServiceType = .login
        let loginService = LoginWebService()
        loginService.delegate = self
        loginService.loginService(email,passwd:passwd)
    }
    
    func resendVerfication(_ email:String){
        let loginService = LoginWebService()
        loginService.delegate = self
        loginService.resendVerficationService(email)
    }
    
    func forgotPassword(_ email:String){
        let loginService = LoginWebService()
        loginService.delegate = self
        loginService.forgotyPasswordService(email)
    }
    
    func sendDeviceToken(_ deviceToken:String,deviceId:String){
        let loginService = LoginWebService()
//        loginService.delegate = self
        loginService.sendDeviceTokenService(deviceToken,deviceId:deviceId)
    }
    
    func signUp(_ email:String, passwd:String,fname:String, lname:String,mobile:String, countryCode:String,dob:String,profileImage: UIImage?){
        currentServiceType = .signup
        let loginService = LoginWebService()
        loginService.delegate = self
        var params = [String: AnyObject]()
        params["first_name"] = fname as AnyObject
        params["last_name"] = lname as AnyObject
        params["email"] = email as AnyObject
        params["country_code"] = countryCode as AnyObject
        params["mobile"] = mobile as AnyObject
        params["password"] = passwd as AnyObject
        if dob.isBlank == false{
            params["dob"] = dob as AnyObject
        }
        loginService.parameters = params
        if let image = profileImage {
            let data = UIImageJPEGRepresentation(image, 0.8)!
            let multipartData = MultipartData(data: data, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            loginService.uploadData = [multipartData]
        }

        loginService.signupService()
    }
    
    func signUpTest(_ email:String, passwd:String,fname:String, lname:String,mobile:String, countryCode:String,dob:String,profileImage: UIImage?){
        currentServiceType = .signup
        let loginService = LoginWebService()
        loginService.delegate = self
        var params = [String: AnyObject]()
        params["planId"] = "1" as AnyObject
        params["custType"] = "0" as AnyObject
        params["prefix"] = "Mr" as AnyObject
        params["firstName"] = "Test" as AnyObject
        params["lastName"] = "User" as AnyObject
        params["email"] = "ajeeshts.sm@gmail.com" as AnyObject
        params["password"] = "sim123" as AnyObject
        params["country"] = "IN" as AnyObject
        params["displayName"] = "TESTUSER" as AnyObject
        params["contactNumber"] = "8086644704" as AnyObject
        params["company"] = "company1" as AnyObject
        params["companyAddress"] = "companyadd" as AnyObject
        params["deviceType"] = "1" as AnyObject
        params["deviceToken"] = "12434324" as AnyObject
        loginService.parameters = params
        if let image = profileImage {
            let data = UIImageJPEGRepresentation(image, 0.8)!
            let multipartData = MultipartData(data: data, name: "trade_certificate", fileName: "image.jpg", mimeType: "image/jpeg")
            let multipartData2 = MultipartData(data: data, name: "identity_proof", fileName: "image.jpg", mimeType: "image/jpeg")
            let multipartData3 = MultipartData(data: data, name: "address_proof", fileName: "image.jpg", mimeType: "image/jpeg")
            loginService.uploadData = [multipartData,multipartData2,multipartData3]
        }
        
        loginService.signupService()
    }

    
    
    func loginOut(){
        let loginService = LoginWebService()
        loginService.delegate = self
        var params = [String: AnyObject]()
        if let token = UserInfo.currentUser()?.token{
            params["token"] = token as AnyObject
        }else{
        }
        loginService.parameters = params
        loginService.loginOutService()
    }


}
