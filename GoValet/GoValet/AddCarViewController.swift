
//
//  AddCarViewController.swift
//  GoValet
//
//  Created by Ajeesh T S on 22/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit
import TOCropViewController
import DKImagePickerController

protocol AddCarDelegate: class {
    func addedCar()
}

extension AddCarViewController: WebServiceTaskManagerProtocol {
    func didFinishTask(from manager:AnyObject, response:(data:RestResponse?,error:NSString?)){
        self.removeLoadingIndicator()
        if response.error != nil{
            let errmsg : String = response.error! as String
            if errmsg == "Please check your email"{
           
            }else{
                self.showAlert("Warning!".localized, message: errmsg)
            }
        }
        else{
            self.navigationController?.popViewController(animated: false)
            self.delegate?.addedCar()
        }
    }
}


class AddCarViewController: UIViewController,TOCropViewControllerDelegate {
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameTxtFld : CustomTextField!
    @IBOutlet weak var containerView : UIView!
    weak var delegate: AddCarDelegate?

    fileprivate var isImageChanged = false
    var assets: [DKAsset]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.roundCornerValue(3.0)
        nameTxtFld.roundCorner()
        self.addLogo()
        self.title = "ADD NEW CAR"
        self.changeNavTitleColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changePhotoBtnClicked(){
        showImagePicker()
    }
    
    func showImagePicker(){
        let pickerController = DKImagePickerController
        //        pickerController.maxSelectableCount = 1
        pickerController.singleSelect = true
        pickerController.showsEmptyAlbums = false
        pickerController.showsCancelButton = true
        self.assets = nil
        pickerController.defaultSelectedAssets = self.assets
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.assets = assets
            //            print("didSelectAssets")
            //            print(assets)
            let asset = self.assets![0]
            asset.fetchOriginalImageWithCompleteBlock({ (image, info) -> Void in
                self.showCropViewController(image!)
            })
        }
        self.present(pickerController, animated: true) {
            let navigationBarAppearace = UINavigationBar.appearance()
            navigationBarAppearace.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 16)
            ]
        }
    }
    
    func showCropViewController(_ image:UIImage){
        let cropViewController = TOCropViewController.init(image:image)
        cropViewController?.delegate = self
        cropViewController?.aspectRatioLockEnabled = true
        cropViewController?.resetAspectRatioEnabled = false
        cropViewController?.setAspectRatioPreset(.presetSquare, animated: true)
        self.present(cropViewController!, animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        cropViewController.dismiss(animated: true) { () -> Void in
            self.profileImageView.image = image
            self.isImageChanged = true
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController!, didFinishCancelled cancelled: Bool)
    {
        cropViewController.dismiss(animated: true) { () -> Void in  }
    }
    
    
  
    @IBAction func addNewCarBtnClicked(){
        if self.nameTxtFld.text?.isBlank == false{
            self.addLoaingIndicator()
            let serviceManager = CommonTaskManager()
            serviceManager.managerDelegate = self
            if  self.isImageChanged == true{
                serviceManager.addNewCar(nameTxtFld.text!, carimage: nil)
            }else{
                serviceManager.addNewCar(nameTxtFld.text!, carimage: profileImageView.image)
            }
        }else{
            self.showErrorAlert("Please Enter Car Name")
        }
    }


}
