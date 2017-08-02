//
//  CameraViewController.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 2/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes

class CameraViewController: RSCodeReaderViewController, DKImagePickerControllerCameraProtocol {

    var contentView = UIView()
    let bottomView = UIView()
    var captureButton: UIButton!
    var flashButton: UIButton = {
        let flashButton = UIButton()
        flashButton.addTarget(self, action: #selector(switchTorch(sender:)), for: .touchUpInside)
        return flashButton
    }()
    
    var cameraSwitchButton = UIButton()
    
    var barcode: String = ""
    var dispatched: Bool = false
    var img: UIImage?
    
    var didCancel: (() -> Void)?
    var didFinishCapturingImage: ((_ image: UIImage) -> Void)?
    var didFinishCapturingVideo: ((_ videoURL: URL) -> Void)?
    
    var editProfileVC : EditProfileViewController?
    
    public func setDidCancel(block: @escaping () -> Void) {
        self.didCancel = block
    }
    
    public func setDidFinishCapturingImage(block: @escaping (UIImage) -> Void) {
        self.didFinishCapturingImage = block
    }
    
    public func setDidFinishCapturingVideo(block: @escaping (URL) -> Void) {
        self.didFinishCapturingVideo = block
    }
    
    @IBOutlet var toggle: UIButton!
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
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
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        self.dispatched = false // reset the flag so user can do another scan
        
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
        }
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = false
        }
        
        if segue.identifier == "nextView" && !self.barcode.isEmpty {
            let destinationNavigationController = segue.destination as! CustomNavigationViewController
            let targetController = destinationNavigationController.topViewController as! PostingViewController
            
            targetController.barcode = self.barcode
            targetController.img = self.img
            
        }
    }
    
    func setupUI() {
        self.contentView.frame = self.view.bounds
        
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.frame = self.view.bounds
        
        let bottomViewHeight: CGFloat = 70
        bottomView.bounds.size = CGSize(width: contentView.bounds.width, height: bottomViewHeight)
        bottomView.frame.origin = CGPoint(x: 0, y: contentView.bounds.height - bottomViewHeight)
        bottomView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        contentView.addSubview(bottomView)
        
        // switch button
        let cameraSwitchButton: UIButton = {
            let cameraSwitchButton = UIButton()
            cameraSwitchButton.addTarget(self, action: #selector(self.switchCamera(sender:)), for: .touchUpInside)
            cameraSwitchButton.setImage(#imageLiteral(resourceName: "Camera_Icon"), for: .normal)
            cameraSwitchButton.sizeToFit()
            
            return cameraSwitchButton
        }()
        
        cameraSwitchButton.frame.origin = CGPoint(x: bottomView.bounds.width - cameraSwitchButton.bounds.width - 15,
                                                  y: (bottomView.bounds.height - cameraSwitchButton.bounds.height) / 2)
        cameraSwitchButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        bottomView.addSubview(cameraSwitchButton)
        self.cameraSwitchButton = cameraSwitchButton
        
        // capture button
        let captureButton: UIButton = {
            let captureButton = UIButton()
            captureButton.addTarget(self, action: #selector(self.capturePhoto(sender:)), for: .touchUpInside)
            captureButton.bounds.size = CGSize(width: bottomViewHeight,
                                               height: bottomViewHeight).applying(CGAffineTransform(scaleX: 0.9, y: 0.9))
            captureButton.layer.cornerRadius = captureButton.bounds.height / 2
            captureButton.layer.borderColor = UIColor.white.cgColor
            captureButton.layer.borderWidth = 2
            captureButton.layer.masksToBounds = true
            
            return captureButton
        }()
        
        captureButton.center = CGPoint(x: bottomView.bounds.width / 2, y: bottomView.bounds.height / 2)
        captureButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        bottomView.addSubview(captureButton)
        self.captureButton = captureButton
        
        // cancel button
        let cancelButton: UIButton = {
            let cancelButton = UIButton()
            cancelButton.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
            cancelButton.setImage(DKCameraResource.cameraCancelImage(), for: .normal)
            cancelButton.sizeToFit()
            
            return cancelButton
        }()
        
        cancelButton.frame.origin = CGPoint(x: contentView.bounds.width - cancelButton.bounds.width - 15, y: 25)
        cancelButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
        contentView.addSubview(cancelButton)
        
        self.flashButton.frame.origin = CGPoint(x: 15, y: 25)
        self.flashButton.setImage(#imageLiteral(resourceName: "Flash_Icon"), for: .normal)
        self.flashButton.sizeToFit()
        contentView.addSubview(self.flashButton)
        
        contentView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(DKCamera.handleZoom(_:))))
    }
    
    func switchTorch(sender: UIButton!) {
        let isTorchOn = self.toggleTorch()
        print(isTorchOn)
    }
    
    func capturePhoto(sender: UIButton!) {
        let connection = self.imageOutput.connection(withMediaType: AVMediaTypeVideo)
        self.imageOutput.captureStillImageAsynchronously (from: connection) {
            (sampleBuffer: CMSampleBuffer?, error: Error?) -> Void in
            if sampleBuffer != nil {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                self.img = UIImage(data: imageData!)
                
                //  Save to photo
                UIImageWriteToSavedPhotosAlbum(self.img!, nil, nil, nil)
                //  Dismiss viewcontroller
                self.dismiss(animated: true, completion: {
                    DispatchQueue.main.async() { () -> Void in
                        self.editProfileVC?.userProfileImg.image = self.img
                        self.editProfileVC?.didChangePhoto = true
                    }
                })
                
            } else {
                print("Error capturing photo: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func switchCamera(sender: UIButton!) {
        self.switchCamera()
    }
    
    func dismiss(sender: UIButton!) {
        self.dismiss(animated:true)
    }


}
