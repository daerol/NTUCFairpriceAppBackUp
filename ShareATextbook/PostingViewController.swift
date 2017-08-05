//
//  BarcodeDisplayViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 25/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import AVFoundation

class PostingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //  MARK:   Content
    @IBOutlet weak var imageListCollectionView: UICollectionView!
    @IBOutlet weak var barcodeReaderButton: CustomUIButton!
    @IBOutlet weak var morePhotosButton: CustomUIButton!
    
    //  MARK:   Navigation bar button
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //  MARK:   Variables
    var barcode: String = ""
    var img: UIImage?
    var assets: [DKAsset]? {
        didSet {
            print("assetla\(assets?.count)")
            if self.imageListCollectionView != nil {
                print("assetlanil")
                self.imageList = [UIImage](repeatElement(UIImage(), count: (assets?.count)!))
                self.imageListCollectionView.reloadData()
            }
        }
    }
    var categoryList: [Category] = []
    var posting: Posting = Posting()
    var imageList: [UIImage] = []
    
    var isEdit: Bool? = false {
        didSet {
            if isEdit == true {
                self.imageList = [UIImage](repeatElement(UIImage(), count: posting.photos.count))
//                self.imageListCollectionView.reloadData()
            }
        }
    }
    var imageListCount = 0
    var errorMessage = ""
    
    //  MARK:   Table View
    var tableViewController: PostingDetailsFormTableViewController!
    
    //  MARK:   Tab bar controller
    var customTabBarController: CustomTabBarController?
    
    //  MARK:   IBAction
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        errorMessage = "Some of the details are required\n"
        
        print("done")
        
        if tableViewController.bookTitleTextField.text != "" {
            print("not nil \(String(describing: tableViewController.bookTitleTextField.text))")
            posting.name = tableViewController.bookTitleTextField.text!
        } else {
            errorMessage += "Book Name\n"
            tableViewController.bookTitleTextField.errorMessage = "Book Title"
        }
        if tableViewController.bookPublisherTextField.text != "" {
            posting.publisher = tableViewController.bookPublisherTextField.text
        }
        if tableViewController.bookEditionTextField.text != "" {
            posting.edition = tableViewController.bookEditionTextField.text
        }
        if tableViewController.bookDescriptionTextField.text != "" {
            posting.desc = tableViewController.bookDescriptionTextField.text!
        }
        if tableViewController.preferredLocationTextField.text != "" {
            //  TO BE REMOVED
            let decodeUser = UserDefaults.standard.object(forKey: "User") as! Data
            let user =  NSKeyedUnarchiver.unarchiveObject(with: decodeUser) as! User
            posting.preferredLocation = user.preferredloc!
            //  CHANGE BACK TO THIS
            //            posting.preferredLocation = tableViewController.preferredLocationTextField.text!
        }
        if tableViewController.educationLevel.text != Strings.choosePrompt {
            let selectedEducationLevel = tableViewController.selectedEducationLevel
            //            posting.cateId.append((selectedEducationLevel?.id)!)
            posting.cateId[0] = (selectedEducationLevel?.id)!
        } else {
            errorMessage += "Education Level\n"
            tableViewController.educationLevel.textColor = UIColor.red
        }
        if tableViewController.subject.text != Strings.choosePrompt {
            let selectedSubject = tableViewController.selectedSubject
            //            posting.cateId.append((selectedSubject?.id)!)
            posting.cateId[1] = (selectedSubject?.id)!
        } else {
            errorMessage += "Subject\n"
            tableViewController.subject.textColor = UIColor.red
        }
        
        print(posting.name)
        print(posting.publisher ?? "no p")
        print(posting.edition ?? "no ed")
        print(posting.desc)
        print(posting.preferredLocation)
        print(posting.cateId)
        
        //        dismiss(animated: true, completion: nil)
        if errorMessage != "Some of the details are required\n" {
            let alert = UIAlertController(title: "Whoops", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("before size \(imageList.count)")
            print("edit \(isEdit)")
            if isEdit == false {
                
                //  Post
                PostingDataManager.addPost(post: posting, postImageList: imageList, token: UserDefaults.standard.object(forKey: "Token") as! String, onComplete: {
                    success, post in
                    
                    print("success \(success)")
                    print("id \(post.id)")
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    //  MARK:   Clear postviewcontroller at tabbar
                    self.customTabBarController?.postViewController = nil
                })
            } else {
                print("enter edit")
                PostingDataManager.editPost(post: posting, postImageList: [], onComplete: {
                    success, post in
                    
                    print("success \(success)")
                    print("id \(post.id)")
                    
                    
                })
            }
            
            imageList.removeAll()
        }
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        if isEdit! {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        self.customTabBarController?.assets = []
        self.customTabBarController?.pickerController.deselectAllAssets()
        
        self.customTabBarController?.postViewController = nil
    }
    
    @IBAction func barcodeReaderAction(_ sender: UIButton) {
        
    }
    @IBAction func morePhotosAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.customTabBarController?.showImagePicker()
            self.customTabBarController?.postViewController = self
        })
    }
    
    //  MARK:   Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  MARK:   Set navigation title
        self.navigationItem.title = barcode
        
        if assets != nil {
            imageList = [UIImage](repeatElement(UIImage(), count: (assets?.count)!))
        } else {
            imageList = [UIImage](repeatElement(UIImage(), count: 0))
        }
        
        //  MARK:   Set the education level and subject base on barcode available
        if barcode == "" {
            tableViewController.educationLevel.text = Strings.choosePrompt
            tableViewController.subject.text = Strings.choosePrompt
            
            tableViewController.educationLevel.textColor = UIColor.lightGray
            tableViewController.subject.textColor = UIColor.lightGray
        }
        
        //  MARK:   Get all category
        CategoryDataManager.getCategoryList(limit: "50", onComplete: {
            list in
            
            self.categoryList = list
            
            //  MARK:   Set the category list in PostingDetailsFormTableViewController
            self.tableViewController.categoryList = list
            
            if self.posting != nil {
                DispatchQueue.main.async(execute: {
                    for cat in self.categoryList {
                        if cat.id == self.posting.cateId[0] {
                            self.tableViewController.selectedEducationLevel = cat
                            break
                        }
                    }
                    
                    for cat in self.categoryList {
                        if cat.id == self.posting.cateId[1] {
                            self.tableViewController.selectedSubject = cat
                            break
                        }
                    }
                })
                
            }
            
            print("inn")
            for i in 0..<self.categoryList.count {
                print(self.categoryList[i].name)
            }
        })
        
        if posting != nil {
            tableViewController.bookTitleTextField.text = posting.name
            tableViewController.bookPublisherTextField.text = posting.publisher
            tableViewController.bookEditionTextField.text = posting.edition
            tableViewController.bookDescriptionTextField.text = posting.desc
            tableViewController.preferredLocationTextField.text = posting.preferredLocation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "test" {
            let vc = segue.destination as! TestViewController
            
            for i in 0..<assets!.count {
                let indexpath = IndexPath(row: i, section: 0)
                
                let cell = imageListCollectionView.cellForItem(at: indexpath) as! PostingImageCollectionViewCell
                imageList.append(cell.image.image!)
            }
            
            vc.i1 = imageList[0]
            vc.i2 = imageList[1]
            vc.i3 = imageList[2]
            
        } else if segue.identifier == "barcodeReaderSegue" {
            let vc = segue.destination as! BarcodeReaderViewController
            vc.postViewController = self
        }
        else {
            let vc = segue.destination as! PostingDetailsFormTableViewController
            tableViewController = vc
        }
    }
    
    //  MARK: UICollectionViewDataSource, UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.assets![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostingImageCollectionViewCell
        
        print("indexpath \(indexPath.row)")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        asset.fetchImageWithSize(layout.itemSize.toPixel(), completeBlock: {
            image, info in
            //  MARK:   Set cell image
            cell.image.image = image
            
            print("set")
            //  MARK:   Add image to imageList
            self.imageList[indexPath.row] = image!
        })
        
        return cell
    }
    
}

