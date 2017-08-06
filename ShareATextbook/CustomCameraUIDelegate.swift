//
//  CustomCameraUIDelegate.swift
//  ntucTest
//
//  Created by Chia Li Yun on 27/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class CustomCameraUIDelegate: DKImagePickerControllerDefaultUIDelegate {

    open override func imagePickerControllerCreateCamera(_ imagePickerController: DKImagePickerController) -> UIViewController {
        let picker = BarcodeReaderCaptureViewController()
        
        return picker
    }

    override open func prepareLayout(_ imagePickerController: DKImagePickerController, vc: UIViewController) {
        self.imagePickerController = imagePickerController
        
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                              target: imagePickerController,
                                                              action: #selector(imagePickerController.dismiss as (Void) -> Void))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.createDoneButtonIfNeeded())
        
        self.updateDoneButtonTitle(self.createDoneButtonIfNeeded())
    }

//    override open func updateDoneButtonTitle(_ button: UIButton) {
//        if self.imagePickerController.selectedAssets.count > 0 {
//            button.setTitle(String(format: "Send(%d)", self.imagePickerController.selectedAssets.count), for: .normal)
//            button.isEnabled = true
//        } else {
//            button.setTitle("Send", for: .normal)
//            button.isEnabled = false
//        }
//        
//        button.sizeToFit()
//    }
    
}
