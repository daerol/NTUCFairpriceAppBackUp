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
        let cameraVC = CameraViewController()
        self.present(cameraVC, animated: true, completion: {
            cameraVC.editProfileVC = self
        })
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
                
                var photo: UIImage? = nil
                if self.didChangePhoto {
                    //  Upload photo
                    photo = self.userProfileImg.image
                } else {
                    self.photoPath = (self.user?.photo)!
                }
                
                UserDataManager.editUser(token: UserDefaults.standard.object(forKey: "Token") as! String, name: self.username, email: self.email, phone: self.phoneNo, showemail: "Y", showphone: "Y", notifyviaemail: "Y", notifyviasms: "Y", photoPath: self.photoPath, photo: photo!, onComplete: {
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
            let url = URL(string: DatabaseAPI.userImageDownloadURL + (self.user?.userId)! + DatabaseAPI.userImageSizeC300)
//            let url = URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/08145DC01B7BD2D5B2611F4B063DC8FCF59DE8784421ACF38EEB8F8AFBC5FE8B_c150")
            //  TO BE REMOVED AND CHANGED TO ABOVE CODE
//            let url = URL(string: DatabaseAPI.imageDownloadURL + "08145DC01B7BD2D5B2611F4B063DC8FCF59DE8784421ACF38EEB8F8AFBC5FE8B_6c9687bf6913460d8b90d3a89154f557" + DatabaseAPI.imageSizeR600)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
