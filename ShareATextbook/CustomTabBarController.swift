//
//  CustomTabBarController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 3/5/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    var menuButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.setupMiddleButton()
        
        self.tabBar.barTintColor = Colors.blue
        self.tabBar.tintColor = Colors.white
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = Colors.lightGrey
        } else {
            // Fallback on earlier versions
        }
        
        if self.tabBar.isHidden == true {
            menuButton.isHidden = true
        }
//        let borderTop = CALayer()
//        borderTop.borderColor = colors.darkRed.cgColor
//        borderTop.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
////        borderTop.borderWidth = 1.8
//        borderTop.shadowColor = colors.darkGrey.cgColor
//        self.tabBar.layer.addSublayer(borderTop)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        menuButton.tintColor = Colors.lightGrey
    }

    // MARK: - Setups
    func setupMiddleButton() {
//        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.height, height: self.tabBar.frame.height))
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = (self.view.bounds.height - menuButtonFrame.height) - 12
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = Colors.darkRed
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        
        menuButton.setImage(#imageLiteral(resourceName: "Add"), for: UIControlState())
        menuButton.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(CustomTabBarController.menuButtonAction(_:)), for: UIControlEvents.touchUpInside)
        menuButton.tintColor = Colors.lightGrey
        
        self.view.addSubview(menuButton)
        
        self.view.layoutIfNeeded()
    }
    
    var pickerController: DKImagePickerController = DKImagePickerController()
    var assets: [DKAsset]?
    
    // MARK: - Actions
    func menuButtonAction(_ sender: UIButton) {
        //self.selectedIndex = 1
        
        sender.tintColor = Colors.white
        
        pickerController.UIDelegate = CustomCameraUIDelegate()
        pickerController.modalPresentationStyle = .overCurrentContext
        pickerController.showsCancelButton = true
        pickerController.assetType = .allPhotos
        
        showImagePicker()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showImagePicker() {
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didCancel = { ()
            print("didCancel")
            
            //  MARK:   Chnage menubutton to not active color
            self.menuButton.tintColor = Colors.lightGrey
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
            
//            let viewController = BarcodeDisplayViewController()
//            
//            viewController.assets = assets
//            
//            self.navigationController?.popToViewController(viewController, animated: true)
            
            //            let storyboard = UIStoryboard(name: "NewItem", bundle: nil)
            //            let newItemDetailNavigationController = storyboard.instantiateViewController(withIdentifier: "newItemDetailNavigationController") as! CustomNavigationViewController
            //
            //            let newItemDetailViewController = newItemDetailNavigationController.topViewController as! BarcodeDisplayViewController
            //
            //            newItemDetailViewController.assets = assets
            //
            //            self.present(newItemDetailViewController, animated: true, completion: nil)
//            let storyboard = UIStoryboard(name: "NewItem", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "newItemDetailViewController") as! BarcodeDisplayViewController
//
            let navigationController = UIStoryboard(name: "NewItem", bundle: nil).instantiateViewController(withIdentifier: "newItemDetailNavigationController") as! CustomNavigationViewController
            let controller = navigationController.topViewController as! PostingViewController
            
            controller.assets = assets
            
            self.present(navigationController, animated: false, completion: nil)
            
//            performSegue(withIdentifier: "showSegue", sender: nil)
//            self.navigationController?.pushViewController(controller, animated: true)
//            self.present(controller, animated: true, completion: nil)
            
            print("lala")
            
            
            //  MARK:   Chnage menubutton to not active color
            self.menuButton.tintColor = Colors.lightGrey
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
//        DispatchQueue.main.async(execute: { () -> Void in
            self.present(self.pickerController, animated: true) {}
//        })
    }

}
