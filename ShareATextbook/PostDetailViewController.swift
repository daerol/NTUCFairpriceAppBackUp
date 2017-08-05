//
//  ItemDetailViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 14/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var postImageSlideshow: ImageSlideshow!
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
    
//    var refreshControl: UIRefreshControl!
    
    var post: Posting?
    
    var isOwner: Bool?
    
    var postImageSourceList: [ImageSource]? = []
    
    @IBAction func requestPostAction(_ sender: Any) {
        ChatDataManager.postRequest(token: UserDefaults.standard.object(forKey: "Token") as! String, postId: (post?.id)!, onComplete: {
            success, messageId, error in
            
            let alert = UIAlertController(title: "You have successfully requested for the book", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  MARK:   Set navigation title
        self.navigationItem.title = post?.name
        
        postName?.text = post?.name
        postPublisherEdition?.text = (post?.publisher!)! + " " + (post?.edition!)!
        postDate?.text = (post?.postDate.toString(style: .short))! + " by "
        postBy.text = post?.by
        postDescription?.text = post?.desc
        
        let preferredLocationValue: LocationValue = LocationValue.convertToLocationValue(locationDescription: (post?.preferredLocation)!)
        if preferredLocationValue.description != "-" {
            DispatchQueue.main.async {
                self.postPreferredLocation?.text = preferredLocationValue.descriptionName
            }
        } else {
            DispatchQueue.main.async {
                self.postPreferredLocation?.text = preferredLocationValue.address
            }
        }
        
        //  Get category names
        DispatchQueue.global(qos: .userInitiated).async {
            CategoryDataManager.getCategoryById(id: (self.post?.cateId[0])!, onComplete: {
                cat1 in
                DispatchQueue.main.async {
                    self.postEducationLevel?.text = cat1.name
                }
            })
            CategoryDataManager.getCategoryById(id: (self.post?.cateId[1])!, onComplete: {
                cat2 in
                DispatchQueue.main.async {
                    self.postSubject?.text = cat2.name
                }
            })
        }
        
        //  Download post owner dp
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: DatabaseAPI.userImageDownloadURL + (self.post?.byId)! + DatabaseAPI.userImageSizeC150)
            print(url?.absoluteString)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    self.postByIcon.contentMode = .scaleAspectFill
                    self.postByIcon.image = UIImage(data: data)
                }
            })
        }
        
        //  MARK:   Add Tap Gestures
        let locationStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocationStackView))
        postPreferredLocationStackView.addGestureRecognizer(locationStackViewTapGesture)
        
        let userTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUser))
        postBy.addGestureRecognizer(userTapGesture)
        postByIcon.addGestureRecognizer(userTapGesture)
        
        if isOwner! {
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction))
            self.navigationItem.rightBarButtonItem  = editButton
        }
        
        //  Set image slide show
        postImageSlideshow.backgroundColor = UIColor.white
        postImageSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        postImageSlideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        postImageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        postImageSlideshow.activityIndicator = DefaultActivityIndicator()
        postImageSlideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        //  Download image
        for i in 0..<post!.photos.count {
            let url = URL(string: DatabaseAPI.imageDownloadURL + (post?.photos[i])! + DatabaseAPI.imageSizeR1000)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    let image = UIImage(data: data)
                    self.postImageSourceList?.append(ImageSource(image: image!))
                    self.postImageSlideshow.setImageInputs(self.postImageSourceList!)
                }
            })
            
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        postImageSlideshow.addGestureRecognizer(recognizer)
    }
    
//    func refreshAction() {
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(loadUserProfile), for: UIControlEvents.valueChanged)
//        self.view.addSubview(refreshControl)
//    }
    
    func loadUserProfile() {
        print("loadprofile")
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
    
    func didTapUser() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        UserDataManager.getUserById(id: (self.post?.byId)!, token: "", onComplete: {
            user in
            
            newViewController.user = user
            DispatchQueue.main.async(execute: {
                //  Push the view controller
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: DidTap function when user click on the imageslideshow
    func didTap() {
        let fullScreenController = postImageSlideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
