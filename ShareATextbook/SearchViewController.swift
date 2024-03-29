//
//  SearchViewController.swift
//  ShareATextbook
//
//  Created by Cheryl Heng on 4/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var user:User?
    var postList: [Posting]?
    private let leftAndRightPadding: CGFloat = 16.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 80.0
    
    @IBOutlet weak var searchCollectionView: UICollectionView!

    var category: Categories!
    var mathList: [Posting]?
//    var catList: [Category]!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        CategoryDataManager.getCategoryList(limit: "") {
//            categories in
//            self.catList = categories
//            DispatchQueue.main.async {
//                print(self.category.id)
//            }
//        }
//        
//        for var i in (0..<catList.count) {
//            var name = catList[i].name
//            if name == "Humanities"
//            
//        }
        
        
        
        PostingDataManager.getPostingList(userId: "", isAvailable: "N", catId: "", onComplete: {
            postingList in
            
            print("enter 1")
            
            self.postList = postingList
            
            
            DispatchQueue.main.async(execute: {
                self.searchCollectionView.reloadData()
                for var i in (0..<self.postList!.count){
                print(self.postList![i].cateId)
                }
            }
            )
        })
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            for var i in (0..<self.postList!.count){
//            CategoryDataManager.getCategoryById(id: (self.postList![i].cateId[0]), onComplete: {
//                cat1 in
//                DispatchQueue.main.async {
//                    var subject = cat1.name
//                    
//                    if(cat1.name == "Mathematics"){
//                         self.mathList!.append(self.postList![i])
//                    }
//                }
//            })
//            }
//            for var i in (0..<self.mathList!.count){
//            print(self.mathList![i])
//            }
// 
//        
//        
//        }
        
   }// end of view did load
    

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
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! SearchCollectionViewCell
        
        print(postList![indexPath.row].status)
        
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
        
        let width = (searchCollectionView.bounds.width - leftAndRightPadding) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width + heightAdjustment)
    }

    

}

