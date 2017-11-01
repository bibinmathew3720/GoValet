//
//  ExtensionMethods.swift
//  Baqaala
//
//  Created by Ajeesh T S on 30/07/16.
//  Copyright © 2016 CSC. All rights reserved.
//

import UIKit
import MBProgressHUD

extension String {
    var localized: String {
//        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
//        let bundle = NSBundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


class CustomTextField: UITextField {
    let inset: CGFloat = 10
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset , dy: inset)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset , dy: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
}

extension UIViewController {
    
    func showAlert(_ title: String?, message: String?) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
        
    }
    
    func showAlertwithTitle(_ title: String, message: String) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
    }
    
    func showWarningAlert(_ message: String){
        self.showAlertwithTitle("Warning!".localized, message: message)
    }
    
    func addLoaingIndicator(){
        DispatchQueue.main.async(execute: { () -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true)
        })

    }
    
    func removeLoadingIndicator(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showErrorAlert(_ message: String){
        self.showAlertwithTitle("Error!", message: message)
    }
    

    
//    func createProgressHUD() -> MBProgressHUD {
//        let hud = MBProgressHUD(view: view)
//        view.addSubview(hud)
//        hud.dimBackground = true
//        hud.labelText = "Loading..."
//        return hud
//    }
}

class ExtensionMethods: NSObject {

    
}

extension UIView {
    var cornerRadius:CGFloat! {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
    
    var borderWidth:CGFloat! {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    var borderColor:UIColor! {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
}

extension UIImage {
    func maskWithColor(_ color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext?.clip(to: bounds, mask: maskImage!)
        bitmapContext?.setFillColor(color.cgColor)
        bitmapContext?.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext?.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        } 
    }
}
