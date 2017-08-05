//
//  SearchViewController.swift
//  ShareATextbook
//
//  Created by Cheryl Heng on 4/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController  {
    
    var user:User?
    var postList: [Posting]?
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var pointStackView: UIStackView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var editProfileButton: CustomUIButton!
    @IBOutlet weak var preferredLocation: UILabel!
    
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    
    @IBOutlet weak var numberOfPost: UILabel!
    @IBOutlet weak var numberOfDonatedPost: UILabel!
    
    var category: Categories!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PostingDataManager.getPostingList(userId: "", isAvailable: "N", catId: "", onComplete: {
            postingList in
            
            print("enter 1")
            
            self.postList = postingList
            
            var itemAvailable = 0
            var itemDonated = 0
            for post in postingList {
                let postItem: Posting = post
                if postItem.status == "" || postItem.status == "R" {
                    itemAvailable += 1
                } else {
                    itemDonated += 1
                }
                
                let total = itemAvailable + itemDonated
                
                if total == postingList.count {
                    DispatchQueue.main.async(execute: {
//                        self.numberOfPost.text = String(itemAvailable)
//                        self.numberOfDonatedPost.text = String(itemDonated)
                    })
                }
            }
            
            DispatchQueue.main.async(execute: {
//                self.itemCollectionView.reloadData()
            })
        })
        
    }

        // Do any additional setup after loading the view.
    

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
}

