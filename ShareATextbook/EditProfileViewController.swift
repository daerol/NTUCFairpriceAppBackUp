//
//  EditProfileViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 12/5/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import CoreImage
import RSBarcodes

class EditProfileViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var username: String = ""
    var phoneNo: String = ""
    var email: String = ""
    var location: LocationValue? = LocationValue()
    var photoPath: String = ""
    
    @IBOutlet weak var userProfileImg: UIImageView!
    
    var user: User?
    
    var didChangePhoto: Bool = false
    
    var isEmailValid: Bool = false
    var isPhoneValid: Bool = false
    
    var missingFieldMsg: String = ""
    var invalidFieldMsg: String = ""
    var errorMsg: String = ""
    
    @IBAction func changePasswordAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changeProfileImageAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Choose a photo source", message: "Pick one", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:  { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler:  { (action: UIAlertAction) in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  nil ))
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        //  Refresh variables
        missingFieldMsg = Strings.profileMissingFieldErrorMsg
        invalidFieldMsg = Strings.invalidFieldMsg
        errorMsg = ""
        
        //  Validation
        if username == "" {
            missingFieldMsg += "Username\n"
        }
        if phoneNo == "" {
            missingFieldMsg += "Phone Number\n"
        }
        if email == "" {
            missingFieldMsg += "Email\n"
        }
        
        if missingFieldMsg == Strings.profileMissingFieldErrorMsg && isPhoneValid && isEmailValid {
            //  Proceed to edit
            
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to edit your profile?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
                action in
                
                var photo: UIImage? = UIImage()
                if self.didChangePhoto {
                    //  Upload photo
                    photo = self.userProfileImg.image
                } else {
                    self.photoPath = (self.user?.photo)!
                }
                
                UserDataManager.editUser(token: UserDefaults.standard.object(forKey: "Token") as! String, name: self.username, email: self.email, phone: self.phoneNo, showemail: "Y", showphone: "Y", notifyviaemail: "Y", notifyviasms: "Y", photoPath: self.photoPath, photo: photo!, didChangePhoto: self.didChangePhoto, preferredloc: (self.location?.description)!, onComplete: {
                    result, userId in
                    
                    print(result)
                    
                    if result {
                        DispatchQueue.main.async() { () -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        //  Reassign user in userdefaults
                        UserDataManager.getUserById(id: userId, token: UserDefaults.standard.object(forKey: "Token") as! String, onComplete: {
                            user in
                            
                            let encodedUserData = NSKeyedArchiver.archivedData(withRootObject: user)
                            UserDefaults.standard.set(encodedUserData, forKey: "User")
                            
                            self.didChangePhoto = false
                        })
                    }
                })

            }))
            present(alert, animated: true, completion: nil)
        } else {
            
            //  Missing Field
            if missingFieldMsg != Strings.profileMissingFieldErrorMsg {
                errorMsg += missingFieldMsg
            }
            
            //  Invalid Field
            if !isEmailValid {
                invalidFieldMsg += "Email: a@b.com\n"
            }
            if !isPhoneValid {
                invalidFieldMsg += "Phone No: 91234567\n"
            }
            if invalidFieldMsg != Strings.invalidFieldMsg {
                errorMsg += invalidFieldMsg
            }
            
            let errorAlert = UIAlertController(title: "Whoops", message: errorMsg, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decodeUser = UserDefaults.standard.object(forKey: "User") as! Data
        user =  NSKeyedUnarchiver.unarchiveObject(with: decodeUser) as! User

        if user?.preferredloc != "" {
            print(user?.preferredloc)
            let preferredLocArr = user?.preferredloc?.components(separatedBy: "|")
            let coordArr = preferredLocArr?[0].components(separatedBy: ",")
            
            location?.location = CLLocation(latitude: CLLocationDegrees(string: (coordArr?[0])!)!, longitude: CLLocationDegrees(string: (coordArr?[1])!)!)
            location?.descriptionName = (preferredLocArr?[1])!
            location?.address = (preferredLocArr?[2])!
            
            print("\(location?.location.coordinate.latitude):\(location?.location.coordinate.longitude)")
        }
        
        username = (user?.username)!
        phoneNo = (user?.phoneNumber)!
        email = (user?.email)!
        photoPath = (user?.photo)!
        
        //  Download Profile Image
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: DatabaseAPI.userImageDownloadURL + (self.user?.id)! + DatabaseAPI.userImageSizeC150)
            print(url?.absoluteString)
            ImageDownload.downloadImage(url: url!, onComplete: {
                data in
                
                DispatchQueue.main.async() { () -> Void in
                    self.userProfileImg.contentMode = .scaleAspectFill
                    self.userProfileImg.image = UIImage(data: data)
                }
            })
        }
        
        //  Create form table
        tableView.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 300)
        
        NameRow.defaultCellUpdate = {   cell, row in
            cell.textField.textColor = .black
            cell.textLabel?.textColor = .gray
        }
        EmailRow.defaultCellUpdate = {   cell, row in
            cell.textField.textColor = .black
            cell.textLabel?.textColor = .gray
        }
        PhoneRow.defaultCellUpdate = {   cell, row in
            cell.textField.textColor = .black
            cell.textLabel?.textColor = .gray
        }
        LocationRow.defaultCellUpdate = {   cell, row in
//            cell.textField.textColor = .black
            cell.textLabel?.textColor = .gray
        }
        
        form +++
            
            Section("Basic Details")
            
            <<< NameRow() { row in
                row.title = "Username"
                row.placeholder = "Name"
                row.tag = "usernameTag"
                row.value = user?.username
                row.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({
                    row in
                    
                    self.username = row.value != nil ? row.value! : ""
                })
            
            <<< EmailRow() {
                $0.title = "Email"
                $0.placeholder = "a@b.com"
                $0.tag = "emailTag"
                $0.value = user?.email
                $0.add(rule: RuleEmail())
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isEmailValid = false
                    } else {
                        self.isEmailValid = true
                    }
                }.onChange({
                    row in
                    
                    self.email = row.value != nil ? row.value! : ""
                })
            
            <<< PhoneRow() {
                $0.title = "Phone No"
                $0.placeholder = "98983510"
                $0.tag = "phoneTag"
                $0.value = user?.phoneNumber
                $0.add(rule: RuleMaxLength(maxLength: 8))
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        self.isPhoneValid = false
                    } else {
                        if row.value?.characters.count != 8 {
                            self.isPhoneValid = false
                        } else {
                            self.isPhoneValid = true
                        }
                    }
                }.onChange({
                    row in
                    self.phoneNo = row.value != nil ? row.value! : ""
                })
            
            <<< LocationRow(){ row in
                row.title = "Preferred Location"
                row.tag = "locationTag"
                row.value = location
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }.onChange({
                    row in
                    self.location = row.value
                    self.tableView.reloadData()
                })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        DispatchQueue.main.async() { () -> Void in
            if image.imageOrientation.rawValue != 0 {
                let imageFixedOrientation = image.fixedOrientation()
                self.userProfileImg.image = imageFixedOrientation
            } else {
                
                self.userProfileImg.image = image
            }
        }
        didChangePhoto = true
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    func fixedOrientation() -> UIImage
    {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        return UIImage(cgImage: ctx.makeImage()!)
    }
}
