//
//  WebServiceTaskManager.swift
//  Tastyspots
//
//  Created by Ajeesh T S on 28/12/15.
//  Copyright © 2015 Ajeesh T S. All rights reserved.
//

import UIKit


class WebServiceTaskManager: NSObject {

    var managerDelegate : WebServiceTaskManagerProtocol?

    deinit {
        self.managerDelegate = nil
    }
    

}
