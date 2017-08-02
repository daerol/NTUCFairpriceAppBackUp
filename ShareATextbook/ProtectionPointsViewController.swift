//
//  ProtectionPointsViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 10/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ProtectionPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let categories = [["title" : "Positive Records", "img" : "smiley"], ["title" : "Negative Records", "img" : "sad"]]
    
    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        setupNavigationBar()
        
        
        
        
    }

    
    
    // Set up the navigation bar
    func setupNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil )
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PointsTableViewCell
        
        
        let pp = categories[indexPath.row]
        let s = pp["img"]!
        cell.imageCell.image = UIImage(named: s)
        cell.titleCell.text = pp["title"]
        
//        cell.titleCell?.text = "Reward Points"
//        cell.imageCell?.image = #imageLiteral(resourceName: "smiley")
        
        
        return cell
    }
    

    
    
}
