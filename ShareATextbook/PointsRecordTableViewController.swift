//
//  PointsRecordTableViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 3/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PointsRecordTableViewController: UITableViewController {
    
    var pointsList : [Points] = []
    var refreshControl2 : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPoints()
        loadRefresh()
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func loadPoints() {
        let usersList = UserDefaults.standard.object(forKey: "User") as! Data?
        let user =  NSKeyedUnarchiver.unarchiveObject(with: usersList!) as! User

        
        
        
        PointsDataManager.getUserPoints(user.id, onComplete: {
            pointsListFromServer in
            
            
            self.pointsList = pointsListFromServer
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pointsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointsCell", for: indexPath) as! PointsRecordsTableViewCell
        
        

        DispatchQueue.main.async() {
            
            let ttPoints = self.pointsList[indexPath.row]
            
            let index = ttPoints.joinddts.index(ttPoints.joinddts.startIndex, offsetBy: 11)
           // cell.nameLabel?.text = bookCat.name
            cell.typeMessage?.text = ttPoints.message
            cell.pointsDate?.text = ttPoints.joinddts.substring(to: index)
            cell.totalPoints?.text = "Protection Points +" + String(describing: ttPoints.points)
            
            
            self.refreshControl?.endRefreshing()
        }
        

        return cell
    }
 
    func loadRefresh() {
        refreshControl2 = UIRefreshControl()
        refreshControl2.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl2.addTarget(self, action: #selector(loadPoints), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl2)
    }


    

}
