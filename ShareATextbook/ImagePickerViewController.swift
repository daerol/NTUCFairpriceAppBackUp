//
//  ImagePickerViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 26/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import AVKit
import Photos

class ImagePickerViewController: UIViewController, UITabBarDelegate {

    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    
    @IBAction func test(_ sender: Any) {
//        pickerController = DKImagePickerController()
//        pickerController.UIDelegate = CustomCameraUIDelegate()
//        pickerController.modalPresentationStyle = .overCurrentContext
//        pickerController.showsCancelButton = true
//        pickerController.assetType = .allPhotos
//        // Do any additional setup after loading the view.
//        showImagePicker()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController = DKImagePickerController()
        pickerController.UIDelegate = CustomCameraUIDelegate()
        pickerController.modalPresentationStyle = .overCurrentContext
        pickerController.showsCancelButton = true
        pickerController.assetType = .allPhotos
        // Do any additional setup after loading the view.
        showImagePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showImagePicker() {
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didCancel = { ()
            print("didCancel")
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
            
//            let storyboard = UIStoryboard(name: "NewItem", bundle: nil)
//            let newItemDetailNavigationController = storyboard.instantiateViewController(withIdentifier: "newItemDetailNavigationController") as! CustomNavigationViewController
//            
//            let newItemDetailViewController = newItemDetailNavigationController.topViewController as! BarcodeDisplayViewController
//            
//            newItemDetailViewController.assets = assets
//            
//            self.present(newItemDetailViewController, animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "NewItem", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "newItemDetailViewController") as! PostingViewController
            
            controller.assets = assets
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(self.pickerController, animated: true) {}
        })
    }
}
