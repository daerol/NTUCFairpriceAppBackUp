//
//  ItemDetailsFormTableViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 28/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PostingDetailsFormTableViewController: UITableViewController {
    
    @IBOutlet weak var bookTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var bookPublisherTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var bookEditionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var bookDescriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var preferredLocationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var educationLevel: UILabel!
    @IBOutlet weak var subject: UILabel!
    
    var categoryList: [Category] = [] {
        didSet {
            educationLevelCategoryList.removeAll()
            subjectCategoryList.removeAll()
            
            for i in 0..<self.categoryList.count {
                let category = self.categoryList[i]
                
                if category.heading == "Education Level" {
                    self.educationLevelCategoryList.append(category)
                } else if category.heading == "Subject" {
                    self.subjectCategoryList.append(category)
                }
                
                print("cate list")
            }
        }
    }
    var educationLevelCategoryList: [Category] = []
    var subjectCategoryList: [Category] = []
    
    var selectedEducationLevel: Category? {
        didSet {
            educationLevel.text = selectedEducationLevel?.name
        }
    }
    var selectedSubject: Category? {
        didSet {
            subject.text = selectedSubject?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decodeUser = UserDefaults.standard.object(forKey: "User") as! Data
        let user =  NSKeyedUnarchiver.unarchiveObject(with: decodeUser) as! User
        DispatchQueue.main.async(execute: {
            
            let preferredLocationVal: LocationValue = LocationValue.convertToLocationValue(locationDescription: user.preferredloc!)
            
            if preferredLocationVal.descriptionName != "-" {
                self.preferredLocationTextField.text = preferredLocationVal.descriptionName
            } else {
                self.preferredLocationTextField.text = preferredLocationVal.address
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EducationLevelSegue" {
            let educationLevelViewController = segue.destination as? EducationLevelViewController
            educationLevelViewController?.postDetailsFormViewController = self
            educationLevelViewController?.educationLevelList = educationLevelCategoryList
            
            if selectedEducationLevel != nil {
                educationLevelViewController?.selectedEducationLevel = selectedEducationLevel!
            }
            
        } else if segue.identifier == "SubjectSegue" {
            let subjectViewController = segue.destination as? SubjectViewController
            subjectViewController?.postDetailsFormViewController = self
            subjectViewController?.subjectCategoryList = subjectCategoryList
            
            if selectedSubject != nil {
                subjectViewController?.selectedSubject = selectedSubject!
            }
        }
    }
    
}
