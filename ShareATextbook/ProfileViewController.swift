//
//  ProfileViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 11/5/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var profileInfoStackView: UIStackView!
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
    
    private let leftAndRightPadding: CGFloat = 16.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 80.0
    
    var postList: [Posting]?
    var user: User?
    
    var preferredLocationValue: LocationValue = LocationValue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Tap Gestures
        let pointStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPointStackView))
        pointStackView.addGestureRecognizer(pointStackViewTapGesture)
        
        let locationStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocationStackView))
        locationStackView.addGestureRecognizer(locationStackViewTapGesture)
        
        //  TO BE REMOVED
//        if user == nil {
//            user = SharedVariables.user
//            name.text = SharedVariables.user.username
//            preferredLocation.text = "Serangoon North Avenue 4"
//        } else {
//            //  If is owner
//            name.text = user!.username
//            preferredLocation.text = user!.preferredloc
//            
//        }
        //  If is profile
        if user == nil {
            let decodeUser = UserDefaults.standard.object(forKey: "User") as! Data
            user =  NSKeyedUnarchiver.unarchiveObject(with: decodeUser) as! User
        } else {
            //  If is others profile, remove edit profile view
            self.profileInfoStackView.removeArrangedSubview(editProfileView)
        }
        
        name.text = user?.username
        
        if user?.preferredloc != "" {
            let preferredLocArr = user?.preferredloc?.components(separatedBy: "|")
            let coordArr = preferredLocArr?[0].components(separatedBy: ",")
            
            if preferredLocArr?[1] != "-" {
                preferredLocation.text = preferredLocArr?[1]
            } else {
                preferredLocation.text = preferredLocArr?[2]
            }
        }
//        preferredLocation.text = user?.preferredloc
        
        
        //  If owner, remove the edit profile view
//        self.profileInfoStackView.removeArrangedSubview(editProfileView)
        
//        DispatchQueue.global(qos: .userInitiated).async {
            PostingDataManager.getPostingList(userId: (user?.id)!, isAvailable: "N", onComplete: {
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
                            self.numberOfPost.text = String(itemAvailable)
                            self.numberOfDonatedPost.text = String(itemDonated)
                        })
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.itemCollectionView.reloadData()
                })
            })
        
    }
    
    // SHAH ADDED
    func logOut() {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "User")
        if (isUserLoggedIn) {
            
            loginDA.logOut(onComplete: {
                (token, userId, isLoggedOut) -> Void in
                
                User.init(username: "", password: "", token: token, preferredloc: "", id: userId, email: "", phoneNumber: "", photo: "")
                
                UserDefaults.standard.removeObject(forKey: "User")
                
                DispatchQueue.main.async {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginHome") as! LoginViewController
                    self.navigationController?.pushViewController(loginViewController, animated: true)

                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetails" {
            
//            let barViewControllers = segue.destination as! UITabBarController
//            let itemDetailViewController = barViewControllers.viewControllers![0] as! PostDetailViewController
            
            let itemDetailViewController = segue.destination as! PostDetailViewController
            let indexPath = self.itemCollectionView.indexPathsForSelectedItems
            
            if indexPath != nil {
                let post = postList?[(indexPath?[0].row)!]
                
                //  MARK:   Set post variable
                itemDetailViewController.post = post
                
                //  MARK:   Set post ownership to allow editing of post
                if true {
                    itemDetailViewController.isOwner = true
                } else {
                    itemDetailViewController.isOwner = false
                }
            }
        } else if segue.identifier == "EditProfileSegue" {
            let editProfileViewController = segue.destination as! EditProfileViewController
            
            editProfileViewController.user = user
        }
    }
    
    func didTapPointStackView() {
//        pointLabel.text = "1000"
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "pointsystem", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProtectionPointsViewController") as! ProtectionPointsViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func didTapLocationStackView() {
        user?.preferredloc = "Serangoon North Avenue 4"
        
        if OpenPhoneApplication.openMap(url: "https://www.apple.com/ios/maps/") {
            let location = user?.preferredloc?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            UIApplication.shared.openURL(URL(string:
                "http://maps.apple.com/?daddr=" + location!)!)
        } else {
            //  Alert user that Apple Map does not exist
            let alert = UIAlertController(title: "Apple Map is not installed in your phone", message: "Please install from __", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    
    func settingsButtonClicked() {
        print("clicked!")
        let settingsStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsStoryboard") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
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
