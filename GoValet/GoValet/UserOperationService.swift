//
//  UserOperationService.swift
//  GoValet
//
//  Created by Ajeesh T S on 28/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit

class UserOperationService: BaseWebService {

    func getHotelsList(){
        self.url = "\(baseUrl)location/list_hotels"
        POST()
    }
    
    func valetRequest(){
        self.url = "\(baseUrl)request/valet_request"
        POST()
    }
    
    func cancelValetRequest(){
        self.url = "\(baseUrl)request/cancel_request"
        POST()
    }
    
    func valetRequestDetails(){
        self.url = "\(baseUrl)request/fetch_request_by_id"
        POST()
    }

}
