//
//  LoginWebService.swift
//  Priza
//
//  Created by Ajeesh T S on 11/10/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit

class LoginWebService: BaseWebService {
    
    func loginService(_ email:String, passwd:String){
        parameters = ["email":email as AnyObject,"password":passwd as AnyObject]
        self.url = "\(baseUrl)user/login"
        POST()
    }
    
    func signupService(){
        self.url = "\(baseUrl)user/signup"
//        url = "http://burjalsafacomputers.com/dev/fnb/api/rest/signup"
        POST()
    }
    
    func resendVerficationService(_ email:String){
        parameters = ["email":email as AnyObject]
        self.url = "\(baseUrl)user/resend_verification"
        POST()
    }
    
    func forgotyPasswordService(_ email:String){
        parameters = ["email":email as AnyObject]
        self.url = "\(baseUrl)forgotpassword"
        POST()
    }
    
    
    func loginOutService(){
        self.url = "\(baseUrl)user/logout"
        POST()
    }
    
    func sendDeviceTokenService(_ token:String,deviceId:String){
        parameters = ["gcm_ios_id":deviceId as AnyObject]
        self.url = "\(baseUrl)user/update_gcm_ios_id"
        POST()
    }
    
    

}
