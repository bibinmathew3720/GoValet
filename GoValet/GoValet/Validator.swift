//
//  Validator.swift
//  Baqaala
//
//  Created by Ajeesh T S on 30/07/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit


//let color_theme = UIColor(red:0.2, green:0.4, blue:0.42, alpha:1)
let color_theme = UIColor(red:0.19, green:0.4, blue:0.42, alpha:1)

let color_navigationBar = color_theme

extension UITextField{
    
    func addCustomPlaceHolderColor(){
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSForegroundColorAttributeName:UIColor(red:0.28, green:0.53, blue:0.55, alpha:1)])
        }
    }
}


extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}



extension UIButton{
    func addRoundCornerColor(){
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
//if let placeholder = yourTextField.placeholder {
//    yourTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
//}



class Validator: NSObject {
    
    class func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
       /*
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
         */
    }
    
    class func validate(_ value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    class func isPwdLenth(_ password: String , confirmPassword : String) -> Bool {
        if password.characters.count >= 8 && confirmPassword.characters.count >= 8{
            return true
        }
        else{
            return false
        }
    }
    
    class func isValidPassword(_ password: String) -> Bool{
        let regularExpression = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}$"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: password)
    }
    
    

}
