//
//  SubjectViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var subjectTableView: UITableView!
    
    weak var postDetailsFormViewController: PostingDetailsFormTableViewController?
    
    var selectedIndexPath: IndexPath?
    
    var subjectCategoryList: [Category] = []
    var selectedSubject: Category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Subject"
        // Do any additional setup after loading the view.
        
        //  MARK:   Remove the top spacing
        self.automaticallyAdjustsScrollViewInsets = false
        subjectTableView.contentInset = UIEdgeInsets.zero
        //  MARK:   If education level is set, select it
        if let index = subjectCategoryList.index(of: selectedSubject) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //  MARK:   If education level is set, select it
        if let index = subjectCategoryList.index(of: selectedSubject) {
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
        return subjectCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
        
        cell.textLabel?.text = subjectCategoryList[indexPath.row].name
        
        if self.selectedIndexPath?.row == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
        
        postDetailsFormViewController?.selectedSubject = subjectCategoryList[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}
