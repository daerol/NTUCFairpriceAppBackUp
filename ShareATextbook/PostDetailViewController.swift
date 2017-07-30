//
//  ItemDetailViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 14/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var postName: UILabel?
    @IBOutlet var postPublisherEdition: UILabel?
    @IBOutlet var postEducationLevel: UILabel?
    @IBOutlet var postSubject: UILabel?
    @IBOutlet var postDate: UILabel?
    @IBOutlet var postPreferredLocation: UILabel?
    @IBOutlet weak var postBy: UILabel!
    @IBOutlet weak var postByIcon: UIImageView!
    @IBOutlet weak var postDescription: UILabel!
    
    @IBOutlet weak var postPreferredLocationStackView: UIStackView!
    
    var post: Posting?
    
    var isOwner: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        //  MARK:   Hide tab bar at the bottom
        let tabBar = self.tabBarController as! CustomTabBarController
        tabBar.menuButton.isHidden = true
        
        //  MARK:   Set navigation title
        self.navigationItem.title = post?.name
        
//        itemTitle.text = post?.name
        postName?.text = post?.name
        postPublisherEdition?.text = (post?.publisher!)! + " " + (post?.edition!)!
        postDate?.text = (post?.postDate.toString(style: .short))! + " by "
        postPreferredLocation?.text = post?.preferredLocation
        postBy.text = post?.by
        postDescription?.text = post?.desc
        
        print("post desc \(post?.desc)")
        
        //  MARK:   Add Tap Gestures
        let locationStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocationStackView))
        postPreferredLocationStackView.addGestureRecognizer(locationStackViewTapGesture)

        if isOwner! {
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction))
            self.navigationItem.rightBarButtonItem  = editButton
        }
        
        
    }
    
    func editButtonAction() {
        let postViewController = UIStoryboard(name: "NewItem", bundle: nil).instantiateViewController(withIdentifier: "postingViewController") as! PostingViewController
        postViewController.posting = post!
        postViewController.isEdit = true
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func didTapLocationStackView() {
        if OpenPhoneApplication.openMap(url: "https://www.apple.com/ios/maps/") {
            let location = postPreferredLocation?.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            UIApplication.shared.openURL(URL(string:
                "http://maps.apple.com/?daddr=" + location!)!)
        } else {
            //  Alert user that Apple Map does not exist
            let alert = UIAlertController(title: "Apple Map is not installed in your phone", message: "Please install from __", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
