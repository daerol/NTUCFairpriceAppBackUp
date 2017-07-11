//
//  ProtectionPointsViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 10/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ProtectionPointsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        setupNavigationBar()
    }

    
    
    // Set up the navigation bar
    func setupNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil )
        
        
        
    }
    
}
