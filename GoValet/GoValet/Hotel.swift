//
//  Hotel.swift
//  GoValet
//
//  Created by Ajeesh T S on 28/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit
import SwiftyJSON


class ValetResonse{
    var status: String?
    var iD: String?
    var averageTime: String?
    var createdDate: String?
    var updatedDate: String?
    var error: String?
    var hotel:Hotel?
    
    init(json: JSON) {
        if let dict = json["data"].dictionary{
            if let data = dict["id"]?.string {
                self.iD = data
            }
            if let data = dict["average_time"]?.string {
                self.averageTime = data
            }
            if let data = dict["created_dt"]?.string {
                self.createdDate = data
            }
            if let data = dict["updated_dt"]?.string {
                self.updatedDate = data
            }
            if let data = dict["status"]?.string {
                self.status = data
            }
            if dict["hotel"]?.dictionary != nil {
                self.hotel = Hotel(dict: dict["hotel"]!)
            }
        }
        if let data = json["error"].string {
            self.error = data
        }
//
    }
}

class Hotel: NSObject,NSCoding {

    var distance: String?
    var place: String?
    var name: String?
    var image: String?
    var longitude: String?
    var latitude: String?
    var hotelDescription: String?
    var phone: String?
    var hotelId: String?
    var avgTime : String?

    init(dict: JSON) {
        if let data = dict["id"].string {
            self.hotelId = data
        }
        if let data = dict["name"].string {
            self.name = data
        }
        if let data = dict["place"].string {
            self.place = data
        }
        if let data = dict["phone"].string {
            self.phone = data
        }
        if let data = dict["description"].string {
            self.hotelDescription = data
        }
        if let data = dict["latitude"].string {
            self.latitude = data
        }
        if let data = dict["longitude"].string {
            self.longitude = data
        }
        if let data = dict["average_time"].string {
            self.avgTime = data
        }

        if let data = dict["image"].string {
            self.image = data
        }
        if let data = dict["distance"].float {
            self.distance = NSString(format: "%.2f km", data) as String

        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        if let value = hotelId {
            aCoder.encode(value, forKey: "hotelId")
        }
        if let value = name {
            aCoder.encode(value, forKey: "name")
        }
        if let value = place {
            aCoder.encode(value, forKey: "place")
        }
        if let value = phone {
            aCoder.encode(value, forKey: "phone")
        }
        if let value = hotelDescription {
            aCoder.encode(value, forKey: "hotelDescription")
        }
        if let value = latitude {
            aCoder.encode(value, forKey: "latitude")
        }
        if let value = longitude {
            aCoder.encode(value, forKey: "longitude")
        }
        if let value = image {
            aCoder.encode(value, forKey: "image")
        }
        if let value = distance {
            aCoder.encode(value, forKey: "distance")
        }

    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        hotelId = aDecoder.decodeObject(forKey: "hotelId") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        place = aDecoder.decodeObject(forKey: "place") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        hotelDescription = aDecoder.decodeObject(forKey: "hotelDescription") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String

    }

}

class History: NSObject {
    
    var Id: String?
    var createdDate: String?
    var hotel: Hotel?
    init(dict: JSON) {
        if let data = dict["id"].string {
            self.Id = data
        }
        if let data = dict["created_dt"].string {
            self.createdDate = data
        }
        if dict["hotel"].dictionary != nil {
            self.hotel = Hotel(dict: dict["hotel"])
        }
    }
}
