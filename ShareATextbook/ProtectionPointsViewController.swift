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
    
    
    @IBOutlet weak var tableView: UITableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        setupNavigationBar()
        
        
        
        
    }

    
    
    // Set up the navigation bar
    func setupNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Points", style: .plain, target: nil, action: nil )
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You points cell number: \(indexPath.row)!")
        
        if indexPath.row == 0 {
            didTapPointsRecord()
            
//            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                print("\(key) = \(value) \n")
//            }
            
            
            
        } else {
            didTapPointsRecord()
        }
        
        
        
        //self.performSegue(withIdentifier: "pptSys", sender: self)
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
    

    func didTapPointsRecord() {
        //        pointLabel.text = "1000"
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "pointsystem", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PointsRecordTableViewController") as! UITableViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecords" {
            
    
            let showRecordsViewController = segue.destination as! PointsRecordTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
//            if indexPath != nil {
//                let post = postList?[(indexPath?[0].row)!]
//                
//                //  MARK:   Set post variable
//                itemDetailViewController.post = post
//                
//                //  MARK:   Set post ownership to allow editing of post
//                if true {
//                    itemDetailViewController.isOwner = true
//                } else {
//                    itemDetailViewController.isOwner = false
//                }
            }
//        } else if segue.identifier == "EditProfileSegue" {
//            let editProfileViewController = segue.destination as! EditProfileViewController
//            
//            editProfileViewController.user = user
//        }
    }
    
    
    
    
}
