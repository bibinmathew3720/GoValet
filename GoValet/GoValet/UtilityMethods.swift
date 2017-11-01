
//
//  UtilityMethods.swift
//  Tastyspots
//
//  Created by Ajeesh T S on 21/12/15.
//  Copyright © 2015 Ajeesh T S. All rights reserved.
//

import UIKit

let internetAalertMsg = "The Internet connection appears to be offline."
let serviceError = "failed Operation!!!"


extension UIButton{
    func roundCorner(){
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
    
    func roundCornerTheme(){
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red:0, green:0.51, blue:0.58, alpha:1).cgColor
        self.layer.borderWidth = 2.0
    }
}

extension UITextField{
    func roundCorner(){
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red:0, green:0.51, blue:0.58, alpha:1).cgColor
        self.layer.borderWidth = 2.0
    }
    
    func roundCornerWithvalue(_ val:CGFloat){
        self.roundCorner()
        self.layer.cornerRadius = val
    }
}

extension UIView{
    func roundCornerValue(_ val:CGFloat){
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red:0, green:0.51, blue:0.58, alpha:1).cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = val
    }
    
}

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension String {
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 15)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}
extension String {
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
}

extension String {
    func trimSpace() -> String? {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

class UtilityMethods: NSObject {

    class func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    class func themeBorderColor() -> UIColor {
        return UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
    }
    
    class func themeColor() -> UIColor {
       return UIColor(red:0.10, green:0.10, blue:0.10, alpha:1)
    }
    
    class func themeRedColor() -> UIColor {
        return UIColor(red:0.97, green:0.28, blue:0.28, alpha:1)
    }

    class func themeBlackColor() -> UIColor {
        return UIColor(red: 0.48, green: 0.48, blue: 0.49, alpha: 1)
    }
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func getAttributedTextwithDiffColor(_ fulltext:String, subString:String ) -> NSMutableAttributedString{
        
        let competeString: NSString = fulltext as NSString
        let range : NSRange = competeString.range(of: subString , options:NSString.CompareOptions.backwards)
        let myMutableString = NSMutableAttributedString(
            string: fulltext,
            attributes: [NSFontAttributeName:UIFont(
                name: "CenturyGothic",
                size: 14.0)!])
        myMutableString.addAttribute(NSFontAttributeName,
            value: UIFont(
                name: "CenturyGothic-Bold",
                size: 14.0)!,
            range:range )
        myMutableString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor(red: 0.34, green: 0.34, blue: 0.35, alpha: 1),
            range: range)
        return myMutableString
        
    }
    
    class func getAttributedTextwithDiffColor(_ fulltext:String, subString:String, secondSubStr: String) -> NSMutableAttributedString{
        
        let competeString: NSString = fulltext as NSString
        let range : NSRange = competeString.range(of: subString , options:NSString.CompareOptions.backwards)
        let range2 : NSRange = competeString.range(of: secondSubStr , options:NSString.CompareOptions.backwards)

        let myMutableString = NSMutableAttributedString(
            string: fulltext,
            attributes: [NSFontAttributeName:UIFont(
                name: "CenturyGothic",
                size: 14.0)!])
        myMutableString.addAttribute(NSFontAttributeName,
            value: UIFont(
                name: "CenturyGothic-Bold",
                size: 14.0)!,
            range:range )
        myMutableString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.black,
            range: range)
        myMutableString.addAttribute(NSFontAttributeName,
            value: UIFont(
                name: "CenturyGothic-Bold",
                size: 14.0)!,
            range:range2 )
        myMutableString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.black,
            range: range2)

        return myMutableString
        
    }
    
    
    class func showAlert(_ msg: String , tilte: String, presentVC:AnyObject){
        
        let alert = UIAlertController(title: tilte, message:msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ action in
            switch action.style{
            case .default: break
//                print("default")
                
            case .cancel: break
//                print("cancel")
                
            case .destructive: break
//                print("destructive")
            }
        }))
        presentVC.present(alert, animated: true, completion: nil)
    }
    
    class func showNoInternetAlert(_ presentVC:AnyObject){
        self.showAlert(internetAalertMsg, tilte: "Tastyspots", presentVC: presentVC)
    }
    
    class func showServiceFailAlert(_ presentVC:AnyObject){
        self.showAlert(serviceError, tilte: "Tastyspots", presentVC: presentVC)
    }
    
    
    class func stringFromDate(_ date:Date?) -> String{
        if date == nil {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return  dateFormatter.string(from: date!)
    }
    
    class func formatFoodieStatus(_ foodieTypeString:String,foodieCompleteString : String) -> NSMutableAttributedString {
       
        let length = foodieTypeString.characters.count
        var foodieType = String()
        var foodieColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
        if length == 0 {
            foodieType = "Foodie"
        }
        else if length == 1 {
            foodieType = "Fooodie"
            foodieColor = UtilityMethods.themeColor()
        }
        else if length == 2 {
            foodieType = "Foooodie"
            foodieColor = UIColor(red: 0.98, green: 0.41, blue: 0.42, alpha: 1.0)
        }
        else if length == 3 {
            foodieType = "Fooooodie"
            foodieColor = UIColor(red: 0.25, green: 0.56, blue: 0.26, alpha: 1.0)
        }
        else if length == 4 {
            foodieType = foodieCompleteString
        }else{
            foodieType = foodieCompleteString
        }
//        if let _ = UIFont(name: "CenturyGothic-Bold", size: 13){
        var foodieStr  = NSString()
        foodieStr = foodieType as NSString
        let colortextRange : NSRange = foodieStr.range(of: foodieTypeString, options:NSString.CompareOptions.backwards)
        let myMutableString = NSMutableAttributedString(string: foodieStr as String, attributes: [NSFontAttributeName:UIFont(name: "CenturyGothic-Bold", size: 11.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: foodieColor, range: colortextRange)
        return myMutableString
//        }

    }
    
   class func checkLoginStatus()-> Bool{
        if AppSharedInfo.sharedInstance.isReachableInternet == true{
            if let _ = UserDefaults.standard.object(forKey: "UserToken") as? String {
                return true
            }else{
                return false
            }
        }else{
            
            if let topController = UIApplication.topViewController() {
                UtilityMethods.showNoInternetAlert(topController)
            }
            return false
        }
    }
    
    class func getTimeFrom24HourFormat(_ time:String?) -> String{
        if time == nil {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: time!)
        dateFormatter.dateFormat = "hh:mm a"
        let timeStr = dateFormatter.string(from: date!)
        return timeStr
    }
    
    
    class func monthAndDayFromDate(_ dateStr:String?) -> String{
        if dateStr == nil {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr!)
        let calendar = Calendar.current
        if date != nil{
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date!)
            let month = components.month
            let day = components.day
            let dateFormatter: DateFormatter = DateFormatter()
            let months = dateFormatter.shortMonthSymbols
            let monthSymbol = months?[month!-1] // month - from your date components
            return "\(monthSymbol) \(day)"
        }else{
            return ""
        }
        
    }
    
    class func dateFromString(_ dateStr:String?) -> String{
        if dateStr == nil {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr!)
        let calendar = Calendar.current
        if date != nil{
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date!)
            let month = components.month
            let day = components.day
            let year = components.year

//            let dateFormatter: NSDateFormatter = NSDateFormatter()
//            let months = dateFormatter.shortMonthSymbols
//            let monthSymbol = months[month-1] // month - from your date components
            return "\(day)- \(month) - \(year)"
        }else{
            return ""
        }
    }
    
    class func gettimeFromDateString(_ dateStr:String?) -> String{
        if dateStr == nil {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr!)
        if date != nil{
            dateFormatter.dateFormat = "hh:mm a"
            let timeStr = dateFormatter.string(from: date!)
            return timeStr
        }else{
            return ""
        }
    }

    
    
  

}
