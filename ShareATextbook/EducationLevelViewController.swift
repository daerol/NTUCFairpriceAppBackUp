//
//  EducationLevelViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class EducationLevelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var educationLevelTableView: UITableView!
    
    weak var postDetailsFormViewController: PostingDetailsFormTableViewController?
    
    var selectedIndexPath: IndexPath?
    
    var educationLevelList: [Category] = []
    var selectedEducationLevel: Category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Education Level"

        //  MARK:   Remove the top spacing
        self.automaticallyAdjustsScrollViewInsets = false
        educationLevelTableView.contentInset = UIEdgeInsets.zero
        //  MARK:   If education level is set, select it
        if let index = educationLevelList.index(of: selectedEducationLevel) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return educationLevelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "educationLevelCell", for: indexPath)
        
        cell.textLabel?.text = educationLevelList[indexPath.row].name
        
        if self.selectedIndexPath?.row == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(selectedEducationLevel.name)")
        selectedIndexPath = indexPath
        tableView.reloadData()
        
        postDetailsFormViewController?.selectedEducationLevel = educationLevelList[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    func UITableView_Auto_Height() {
        if(self.educationLevelTableView.contentSize.height < self.educationLevelTableView.frame.height){
            var frame: CGRect = self.educationLevelTableView.frame;
            frame.size.height = self.educationLevelTableView.contentSize.height;
            self.educationLevelTableView.frame = frame;
            print("enter")
        }
    }
    
}
