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
    
    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    var postViewController: PostingViewController!
    
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
        
        pickerController = DKImagePickerController()
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
        //menuButtonFrame.origin.y = (self.view.bounds.height - menuButtonFrame.height) - 12
        menuButtonFrame.origin.y = -30
        menuButtonFrame.origin.x = self.view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = Colors.darkRed
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        
        menuButton.setImage(#imageLiteral(resourceName: "Add"), for: UIControlState())
        menuButton.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(CustomTabBarController.menuButtonAction(_:)), for: UIControlEvents.touchUpInside)
        menuButton.tintColor = Colors.lightGrey
        
        self.tabBar.addSubview(menuButton)
        self.tabBar.layoutIfNeeded()
    }
    
    
    // MARK: - Actions
    func menuButtonAction(_ sender: UIButton) {
        
        sender.tintColor = Colors.white
        
        //        pickerController.UIDelegate = CustomCameraUIDelegate()
        //        pickerController.modalPresentationStyle = .overCurrentContext
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
            
            //  MARK:   Remove the assets
            self.pickerController.deselectAllAssets()
            self.assets = []
            
            //  MARK:   Clear the variable
            self.postViewController = nil
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
            
            print("postviewnil:\(self.postViewController == nil)")
            if self.postViewController == nil {
                let navigationController = UIStoryboard(name: "NewItem", bundle: nil).instantiateViewController(withIdentifier: "newItemDetailNavigationController") as! CustomNavigationViewController
                let controller = navigationController.topViewController as! PostingViewController
                
                controller.assets = assets
                controller.customTabBarController = self
                
                self.present(navigationController, animated: false, completion: nil)
            } else {
                
                //  MARK:  This is if the user reselect more assets
                self.postViewController.assets = assets
            }
            
            
            //  MARK:   Chnage menubutton to not active color
            self.menuButton.tintColor = Colors.lightGrey
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        UIApplication.topViewController()?.present(self.pickerController, animated: true, completion: nil)
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
