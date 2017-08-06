//
//  ProtectionPointsViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 10/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ProtectionPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var pointsList : [Points] = []
    var totalPoints = 0
    
    let categories = [["title" : "Positive Records", "img" : "smiley"], ["title" : "Negative Records", "img" : "sad"]]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalPointsMessage: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        setupNavigationBar()
        
        loadPoints()
        
        
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
            didTapPositivePointsRecord()
            
//            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                print("\(key) = \(value) \n")
//            }
            
            
            
        } else {
            didTapNegativePointsRecord()
        }
        
    }
    
    
    func loadPoints() {
        let usersList = UserDefaults.standard.object(forKey: "User") as! Data?
        let user =  NSKeyedUnarchiver.unarchiveObject(with: usersList!) as! User
        
        
        // Problem lies here!
        
        
        
        
        PointsDataManager.getUserPoints(user.id, onComplete: {
            pointsListFromServer in
            self.pointsList = pointsListFromServer
        })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PointsTableViewCell
        
        
        for pointsGiven in pointsList {
        totalPoints += pointsGiven.points
        }
        
        
        
        
        
        let pp = categories[indexPath.row]
        let s = pp["img"]!
        
        print(totalPoints)
//        if totalPoints == 0 {
//            totalPoints = 100
//        }
      
        totalPointsMessage?.text = String(describing: totalPoints)
        cell.imageCell.image = UIImage(named: s)
        cell.titleCell.text = pp["title"]
        
        return cell
    }
    

    func didTapPositivePointsRecord() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "pointsystem", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PointsRecordTableViewController") as! UITableViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func didTapNegativePointsRecord() {
     
        let storyBoard: UIStoryboard = UIStoryboard(name: "pointsystem", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NegativePointsTableViewController") as! UITableViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
   
    
    
    
    
}
