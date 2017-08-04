//
//  HomeViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//



// Remarks: Add spinner before loading data

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet weak var sliderScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var featureViewControl: UIPageControl!
    
    // HAVEN'T FIX THE CATEGORIES IMAGE
    
    

    let feature1 = ["img" : "slider_1"]
    let feature2 = ["img" : "slider_1"]
    let feature3 = ["img" : "slider_1"]
    
    
    var featureArray = [Dictionary<String, String>]()
    var categoriesList : [Categories] = []
    var refreshControl : UIRefreshControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featureArray = [feature1, feature2, feature3]
        sliderScrollView.isPagingEnabled = true
        sliderScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        sliderScrollView.showsHorizontalScrollIndicator = false
        
        
        // delegates and data source
        sliderScrollView.delegate = self
        
        
        
        
        // Load datas
        loadFeatures()
        loadCategories()
        loadRefresh()
       
        
    }
    
   
    
    func loadFeatures() {
        for (index, feature) in featureArray.enumerated() {
            if let featureView = Bundle.main.loadNibNamed("feature", owner: self, options: nil)?.first as? FeatureView {
//                featureView.titleLabel.text = feature["title"]
//                featureView.descriptionLabel.text = feature["description"]
                featureView.featureImageView.image = UIImage(named: feature["img"]!)
                
                
                
                sliderScrollView.addSubview(featureView)
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
        
    }
    
    

    func loadCategories() {
        HomepageDataManager.retrieveCategories(onComplete: {
            categoriesListFromServer in
            
            
            self.categoriesList = categoriesListFromServer
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    func loadRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(loadCategories), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    
  
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        featureViewControl.currentPage = Int(page)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        //self.performSegue(withIdentifier: "pptSys", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeContentTableViewCell
//        
//        let bookCat = categories[indexPath.row]
//        
//        let s = bookCat["img"]!
//        cell.backgroundImage.image = UIImage(named: s)
//        cell.nameLabel.text = bookCat["name"]
        
        DispatchQueue.main.async() {
            
            let bookCat = self.categoriesList[indexPath.row]
            cell.backgroundImage?.image = #imageLiteral(resourceName: "cells")
            cell.nameLabel?.text = bookCat.name
            
            self.refreshControl?.endRefreshing()
        }
        
        

        return cell
    }
    
    
}
