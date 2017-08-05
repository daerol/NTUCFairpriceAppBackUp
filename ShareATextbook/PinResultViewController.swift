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
    
    var isNearbyPost: Bool = false
    
    var postList: [Posting] = [] {
        didSet {
            print("settla")
            
            DispatchQueue.main.async {
                self.tableResult.reloadData()
            }
        }
    }
    
    var distance: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.tableResult.reloadData()
            }
        }
    }
    
    @IBAction func moreInfoAction(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? MapResultTableViewCell {
            let indexPath = tableResult.indexPath(for: cell)
            print("clicked:\(indexPath?.row)")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
            
            //  Set the variables
            newViewController.post = self.postList[(indexPath?.row)!]
            newViewController.isOwner = false
            
            //  Push the view controller
            mapViewController?.navigationController?.pushViewController(newViewController, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Set image tint color
        swipeImageView.image?.withRenderingMode(.alwaysTemplate)
        swipeImageView.tintColor = Colors.shadowGrey
        
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
    
    override func viewWillLayoutSubviews() {
        addressLabel.sizeToFit()
    }
    
    func swipeUpAction() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame =  CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) - (100))
        })
    }
    
    func swipeDownAction() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height - 110, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) - (110))
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinResultCell", for: indexPath) as! MapResultTableViewCell
        
        cell.title.text = postList[indexPath.row].name
        print("nearbylaaaa\(isNearbyPost))")
        if isNearbyPost {
            let preferredLocValue: LocationValue = LocationValue.convertToLocationValue(locationDescription: postList[indexPath.row].preferredLocation)
            
            let dist = mapViewController?.currentLocation?.distance(from: preferredLocValue.location)
            let distKM = Formatter.formatDoubleToString(num: (dist!/1000), noOfDecimal: 1)
            
            cell.distance.text =  distKM + " KM"
            if (postList.count-1) == indexPath.row {
                isNearbyPost = false
            }
        } else {
            cell.distance.text = distance + " KM"
        }
        
        var categoryStr: String = ""
        DispatchQueue.global(qos: .userInitiated).async {
            CategoryDataManager.getCategoryById(id: self.postList[indexPath.row].cateId[0], onComplete: {
                cat1 in
                categoryStr += cat1.name
                CategoryDataManager.getCategoryById(id: self.postList[indexPath.row].cateId[1], onComplete: {
                    cat2 in
                    categoryStr += ", " + cat2.name
                    DispatchQueue.main.async {
                        cell.subtitle.text = " " + categoryStr
                    }
                })
            })
            
            let url = URL(string: DatabaseAPI.imageDownloadURL + self.postList[indexPath.row].photos[0] + DatabaseAPI.imageSizeR1000)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    cell.thumbnail.image = UIImage(data: data)
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
