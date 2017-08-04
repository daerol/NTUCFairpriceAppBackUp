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
    let usersList = UserDefaults.standard.object(forKey: "User") as! Data?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadPoints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

//    func loadPoints() {
//        
//        let userId = usersList.
//    
//        PointsDataManager.getUserPoints(userId!, onComplete: {
//            pointsListFromServer in
//            
//            
//            self.pointsList = pointsListFromServer
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointsCell", for: indexPath)

        // Configure the cell...

        return cell
    }
 

    

}
