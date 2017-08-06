//
//  NegativePointsTableViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 5/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class NegativePointsTableViewController: UITableViewController {
    
    var negPointsList : [Points] = []
    var refreshControl3 : UIRefreshControl!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func loadPoints() {
        let usersList = UserDefaults.standard.object(forKey: "User") as! Data?
        let user =  NSKeyedUnarchiver.unarchiveObject(with: usersList!) as! User
        
        
        
        
        PointsDataManager.getUserPoints(user.id, onComplete: {
            pointsListFromServer in
            
            
            self.negPointsList = pointsListFromServer
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointsCell", for: indexPath) as! NegativePointsTableViewCell
        
        
        DispatchQueue.main.async() {
            cell.negPointsDate?.text = "31/07/2017"
            cell.negTotalPoints?.text = "Negative Points -" + String(describing: 0)
            cell.negTypeMessage?.text = "Deduction Points For Posts"
           
        }
        
        
        return cell
    }
    
    
    func loadRefresh() {
        refreshControl3 = UIRefreshControl()
        refreshControl3.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl3.addTarget(self, action: #selector(loadPoints), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl3)
    }

    
}
