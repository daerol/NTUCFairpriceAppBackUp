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
    private let leftAndRightPadding: CGFloat = 16.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 80.0
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
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
                self.itemCollectionView.reloadData()
            })
        })
        
    }

        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("enter 2")
        //        return postList!.count
        
        if postList != nil {
            return postList!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        
        let postStatus = postList![indexPath.row].status
        
        cell.itemImage.image = #imageLiteral(resourceName: "textbook")
        cell.itemTitle.text = postList![indexPath.row].name
        cell.itemDetail.text = postList![indexPath.row].publisher! + " " + postList![indexPath.row].edition!
        
        if postList![indexPath.row].status == "" {
            cell.itemTag.isHidden = true
        } else {
            if postStatus == "D" {
                cell.itemTag.text = "Donated"
                cell.itemTitle.textColor = Colors.white
                cell.itemDetail.textColor = Colors.white
                cell.bookmarkButton.tintColor = Colors.white
                cell.chatButton.tintColor = Colors.white
                cell.backgroundColor = Colors.blue
            } else if postStatus == "R" {
                cell.itemTag.text = "Reserved"
                cell.itemTitle.textColor = Colors.white
                cell.itemDetail.textColor = Colors.white
                cell.bookmarkButton.tintColor = Colors.white
                cell.chatButton.tintColor = Colors.white
                cell.backgroundColor = Colors.darkRed
            }
        }
        let filePath = postList![indexPath.row].photos[0]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: DatabaseAPI.imageDownloadURL + filePath + DatabaseAPI.imageSizeR1000)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    //                    cell.itemImage.contentMode = .scaleAspectFit
                    cell.itemImage.image = UIImage(data: data)
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (itemCollectionView.bounds.width - leftAndRightPadding) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width + heightAdjustment)
    }

    

}

