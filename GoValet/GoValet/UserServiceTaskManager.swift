
//
//  UserServiceTaskManager.swift
//  GoValet
//
//  Created by Ajeesh T S on 28/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit

enum UserServiceType {
    case hotelList
    case sentValetRequest
    case cancelValetRequest
    case requestDetails
}

extension UserServiceTaskManager : BaseServiceDelegates  {
    
    func didSuccessfullyReceiveData(_ response:RestResponse?){
        let responseData = response!.response!
        if let errorMsg = responseData["error"].string{
            managerDelegate?.didFinishTask(from: self, response: (data: nil, error: errorMsg))
            return
        }
        if currentServiceType == .sentValetRequest{
            let sucessRepose = ValetResonse.init(json: responseData)
            response?.responseModel = sucessRepose
            response?.requestCode = 1001
        }
        else if currentServiceType == .cancelValetRequest{
            if let msg = responseData["data"].string {
                response?.successMessage = msg
            }
        }
        else if currentServiceType == .requestDetails{
            let sucessRepose = ValetResonse.init(json: responseData)
            response?.responseModel = sucessRepose
        }
        else{
            var hotelList = [Hotel]?()
            if let hotels = responseData["data"].array {
                hotelList = [Hotel]()
                for hotel in hotels {
                    let product = Hotel.init(dict: hotel)
                    hotelList?.append(product)
                }
                response?.responseModel = hotelList
            }
        }
        managerDelegate?.didFinishTask(from: self, response: (data: response, error: nil))
    }
    
    func didFailedToReceiveData(_ response:RestResponse?){
        managerDelegate?.didFinishTask(from: self, response: (data: nil, error: nil))
    }
    
}


class UserServiceTaskManager: WebServiceTaskManager {
    
    var currentServiceType = UserServiceType.hotelList
    var isRepeatApi = false
    
    func getHotelsList(_ lattitude:String,longitude:String){
        let userService = UserOperationService()
        userService.delegate = self
        var params = [String: AnyObject]()
        params["user_latitude"] = lattitude as AnyObject
        params["user_longitude"] = longitude as AnyObject
        userService.parameters = params
        userService.getHotelsList()
    }
    
    func sendValetRequest(_ hotelId:String, valetCode:String?,scanImage: UIImage?){
        currentServiceType = .sentValetRequest
        let userService = UserOperationService()
        userService.delegate = self
        var params = [String: AnyObject]()
        params["hotel_id"] = hotelId as AnyObject
        if valetCode != nil{
            params["valet_code"] = valetCode! as AnyObject
        }
        userService.parameters = params
        if scanImage != nil{
            let data = UIImageJPEGRepresentation(scanImage!, 0.5)!
            let multipartData = MultipartData(data: data, name: "code_image", fileName: "image.jpg", mimeType: "image/jpeg")
            userService.uploadData = [multipartData]
        }
        userService.valetRequest()
    }
    
    func cancelRequest(_ requestID:String){
        currentServiceType = .cancelValetRequest
        let userService = UserOperationService()
        userService.delegate = self
        var params = [String: AnyObject]()
        params["id"] = requestID as AnyObject
        userService.parameters = params
        userService.cancelValetRequest()
    }
    
    func requestDetailsRequest(_ requestID:String){
        currentServiceType = .requestDetails
        let userService = UserOperationService()
        userService.delegate = self
        var params = [String: AnyObject]()
        params["id"] = requestID as AnyObject
        userService.parameters = params
        userService.valetRequestDetails()
    }



}
