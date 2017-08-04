//
//  PinResultViewController.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 3/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PinResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableResult: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var swipeImageView: UIImageView!
    
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    
    var mapViewController: MapViewViewController?
    
    var postList: [Posting] = [] {
        didSet {
            print("settla")
            
            DispatchQueue.main.async {
                self.tableResult.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Gestures
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUpAction))
        swipeUp.direction = .up
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownAction))
        swipeDown.direction = .down
        
        topView.addGestureRecognizer(swipeUp)
        topView.addGestureRecognizer(swipeDown)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeUpAction() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame =  CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) - (100))
            self.swipeImageView.image = UIImage(named: "Down")
        })
    }
    
    func swipeDownAction() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height - 85, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) - (85))
            self.swipeImageView.image = UIImage(named: "Up")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinResultCell", for: indexPath)
        
        cell.textLabel?.text = postList[indexPath.row].name
        
        var categoryStr: String = ""
        DispatchQueue.global(qos: .userInitiated).async {
            CategoryDataManager.getCategoryById(id: self.postList[indexPath.row].cateId[0], onComplete: {
                cat1 in
                categoryStr += cat1.name
                CategoryDataManager.getCategoryById(id: self.postList[indexPath.row].cateId[1], onComplete: {
                    cat2 in
                    categoryStr += ", " + cat2.name
                    DispatchQueue.main.async {
                        cell.detailTextLabel?.text = categoryStr
                    }
                })
            })
            
            let url = URL(string: DatabaseAPI.imageDownloadURL + self.postList[indexPath.row].photos[0] + DatabaseAPI.imageSizeR1000)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    cell.imageView?.image = UIImage(data: data)
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        //  Set the variables
        newViewController.post = self.postList[indexPath.row]
        newViewController.isOwner = false
        
        //  Push the view controller
        mapViewController?.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
}
