

//
//  ValetManagerWebService.swift
//  GoValet
//
//  Created by Ajeesh T S on 24/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

class ValetManagerWebService: BaseWebService {

    func updateStaffCount(){
        self.url = "\(baseUrl)request/update_count"
        POST()
    }
    
    func getAllPendingRequest(){
        self.url = "\(baseUrl)request/pending_request"
        POST()
    }
    
    func updateValetRequestStatus(){
        self.url = "\(baseUrl)request/update_status"
        POST()
    }
    
    func nonMemberRequestService(){
        self.url = "\(baseUrl)request/outside_request"
        POST()
    }
    
}


