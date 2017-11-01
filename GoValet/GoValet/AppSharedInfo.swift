//
//  AppSharedInfo.swift
//  Priza
//
//  Created by Ajeesh T S on 10/10/16.
//  Copyright © 2016 CSC. All rights reserved.
//


import UIKit
import ReachabilitySwift

class AppSharedInfo: NSObject {
    
    private static var __once: () = {
            Static.instance = AppSharedInfo()
        }()
    
    var reachability: Reachability?
    var isReachableInternet : Bool = false
    var selectedSort = ""
    var selectedFilter = ""

    
    class var sharedInstance : AppSharedInfo {
        struct Static {
            static var onceToken : Int = 0
            static var instance : AppSharedInfo? = nil
        }
        _ = AppSharedInfo.__once
        return Static.instance!
    }
    
    func stopRechabilityNotfication(){
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                            name: ReachabilityChangedNotification,
                                                            object: reachability)
    }
    
    func startReachabilityNotification(){
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: "reachabilityChanged:",name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            //            NSNotificationCenter.defaultCenter().postNotificationName("ReachabilityChangedNotificationInApp",
            //                object:nil,
            //                userInfo:nil)
            
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
                self.isReachableInternet = true
            } else {
                self.isReachableInternet = true
                print("Reachable via Cellular")
            }
            
        } else {
            self.isReachableInternet = false
            print("Network not reachable")
        }
    }
    
    
}

