//
//  UserInfo.swift
//  CSC Staff
//
//  Created by Johnykutty Mathew on 27/06/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Car :NSObject,NSCoding{
    var carImage: String?
    var name: String?
    var carId: String?
    init(json: JSON) {
        if let data = json["id"].string {
            self.carId = data
        }
        if let data = json["title"].string {
            self.name = data
        }
        if let data = json["image"].string {
            self.carImage = data
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        if let value = carImage {
            aCoder.encode(value, forKey: "carImage")
        }
        if let value = name {
            aCoder.encode(value, forKey: "name")
        }
        if let value = carId {
            aCoder.encode(value, forKey: "carId")
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        carImage = aDecoder.decodeObject(forKey: "carImage") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        carId = aDecoder.decodeObject(forKey: "carId") as? String
    }
}

class UserInfo: NSObject, NSCoding {
    
    var status: String?
    var messge: String?
    var token: String?
    var userName: String?
    var userFirstName: String?
    var userLastName: String?
    var dob: String?
    var countrycode: String?
    var email: String?
    var password: String?
    var currentRequestID : String?

    var phone: String?

    var profileImage: String?
    var userId: String?
    var address1: String?
    var address2: String?
    var street: String?
    var city: String?

    var cars : [Car]?
    var hotels : [Hotel]?
    
    var userType : String = "Customer"
    
    fileprivate static var __currentUser: UserInfo? = nil
    class func createSessionWith(_ json: JSON) {
        __currentUser = UserInfo(json: json)
    }
    
    class func currentUser() -> UserInfo? {
        return __currentUser
    }
    
    init(json: JSON) {
        if let data = json["message"].string {
            self.messge = data
        }
         
        if let dict = json["data"].dictionary {
            
            
            if let data = dict["user_type"]?.string {
                self.userType = data
            }
            if let data = dict["token"]?.string {
                self.token = data
            }
            if let data = dict["first_name"]?.string {
                self.userFirstName = data
                self.userName = data
            }
            if let data = dict["last_name"]?.string {
                self.userLastName = data
                let fname : String = self.userName!
                self.userName =  "\(fname) \(data)"
            }
            if let data = dict["email"]?.string {
                self.email = data
            }
            if let data = dict["mobile"]?.string {
                self.phone = data
            }
            if let data = dict["country_code"]?.string {
                self.countrycode = data
            }
            if let data = dict["dob"]?.string {
                self.dob = data
            }
            if let data = dict["image"]?.string {
                self.profileImage = data
            }
            if let carArray = dict["car"]?.array {
                cars = [Car]()
                for car in carArray {
                    let carObj = Car.init(json: car)
                    cars?.append(carObj)
                }
            }
            if let carArray = dict["hotel"]?.array {
                hotels = [Hotel]()
                for car in carArray {
                    let carObj = Hotel.init(dict: car)
                    hotels?.append(carObj)
                }
            }

            
            
        }
        
        
    }
//    
    func save() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        saveData(encodedData)
    }
    
    func clearSession() {
        saveData(nil)
    }
    
    class func restoreSession() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "userSession") as? Data {
            __currentUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserInfo
        }
        return (__currentUser != nil)
    }
    
    fileprivate func saveData(_ data: Data?) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userSession")
        userDefaults.set(data, forKey: "userSession")
        userDefaults.removeObject(forKey: "lattiutde")
        userDefaults.removeObject(forKey: "longitude")
        userDefaults.synchronize()
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(cars, forKey: "cars")
        if let value = cars {
            aCoder.encode(value, forKey: "cars")
        }
        
        aCoder.encode(userType, forKey: "userType")
        if let value = status {
            aCoder.encode(value, forKey: "status")
        }
        
        if let value = token {
            aCoder.encode(value, forKey: "token")
        }
        
        if let value = password {
            aCoder.encode(value, forKey: "password")
        }
        if let value = currentRequestID {
            aCoder.encode(value, forKey: "currentRequestID")
        }
        
        
        if let value = messge {
            aCoder.encode(value, forKey: "messge")
        }
        if let value = userName {
            aCoder.encode(value, forKey: "userName")
        }
        if let value = userId {
            aCoder.encode(value, forKey: "userId")
        }
        if let value = email {
            aCoder.encode(value, forKey: "email")
        }
        if let value = phone {
            aCoder.encode(value, forKey: "phone")
        }
        if let value = profileImage {
            aCoder.encode(value, forKey: "profileImage")
        }
        if let value = address1 {
            aCoder.encode(value, forKey: "address1")
        }
        if let value = address2 {
            aCoder.encode(value, forKey: "address2")
        }
        if let value = street {
            aCoder.encode(value, forKey: "street")
        }
        if let value = city {
            aCoder.encode(value, forKey: "city")
        }
        if let value = userFirstName {
            aCoder.encode(value, forKey: "userFirstName")
        }
        if let value = userLastName {
            aCoder.encode(value, forKey: "userLastName")
        }
        if let value = countrycode {
            aCoder.encode(value, forKey: "countrycode")
        }
        if let value = dob {
            aCoder.encode(value, forKey: "dob")
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        cars = (aDecoder.decodeObject(forKey: "cars") as? [Car])!
        userType = (aDecoder.decodeObject(forKey: "userType") as? String)!
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        currentRequestID = aDecoder.decodeObject(forKey: "currentRequestID") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        messge = aDecoder.decodeObject(forKey: "messge") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        profileImage = aDecoder.decodeObject(forKey: "profileImage") as? String
        address1 = aDecoder.decodeObject(forKey: "address1") as? String
        address2 = aDecoder.decodeObject(forKey: "address2") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        userFirstName = aDecoder.decodeObject(forKey: "userFirstName") as? String
        userLastName = aDecoder.decodeObject(forKey: "userLastName") as? String
        countrycode = aDecoder.decodeObject(forKey: "countrycode") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
    }

}
