//
//  BarcodeReaderViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes

class BarcodeReaderViewController: RSCodeReaderViewController {

    var barcode: String = ""
    var dispatched: Bool = false
    
    var postViewController: PostingViewController?
    
    var isbn: ISBN?
    var educationCategory: Category?
    var subjectCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: NOTE: Uncomment the following line to enable crazy mode
        // self.isCrazyMode = true
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        // MARK: NOTE: If you want to detect specific barcode types, you should update the types
        let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        // MARK: NOTE: Uncomment the following line remove QRCode scanning capability
        // types.removeObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        // MARK: NOTE: If you layout views in storyboard, you should these 3 lines
        for subview in self.view.subviews {
            self.view.bringSubview(toFront: subview)
        }
        
        //        self.toggle.isEnabled = self.hasTorch()
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched { // triggers for only once
                self.dispatched = true
                for barcode in barcodes {
                    self.barcode = barcode.stringValue
                    print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                    
                    
                    // Do something on background thread
                    DispatchQueue.global(qos: .userInitiated).async {

                        ISBNDataManager.getISBNById(id: barcode.stringValue, onComplete: {
                            isbn in
                            
                            self.isbn = isbn
                            
                            let educationLevelCategoryId = isbn.cateId[0]
                            let subjectCategoryId = isbn.cateId[1]
                            
                            print("la ")
                            print("id \(educationLevelCategoryId)")
                            CategoryDataManager.getCategoryById(id: educationLevelCategoryId, onComplete: {
                                category in
                                DispatchQueue.main.async(execute: {
                                    print("aysnc")
                                    
                                    self.postViewController?.tableViewController.selectedEducationLevel = category
                                })
                            })
                            CategoryDataManager.getCategoryById(id: subjectCategoryId, onComplete: {
                                category in
                                DispatchQueue.main.async(execute: {
                                    print("aysnc")
                                    
                                    self.postViewController?.tableViewController.selectedSubject = category
                                })
                            })
                            
                            DispatchQueue.main.async(execute: {
                                print("aysnc")
                                
                                self.postViewController?.tableViewController.bookTitleTextField.text = isbn.name
                                self.postViewController?.tableViewController.bookPublisherTextField.text = isbn.publisher
                                self.postViewController?.tableViewController.bookEditionTextField.text = isbn.edition
                            })
                        })
                        DispatchQueue.main.async(execute: {
                        print("aysnc")
                            self.navigationController?.isNavigationBarHidden = false
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                    // MARK: NOTE: break here to only handle the first barcode object
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dispatched = false // reset the flag so user can do another scan
        
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
        }
    }
}
