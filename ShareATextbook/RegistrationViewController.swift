//
//  RegistrationViewController.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 20/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController, BEMCheckBoxDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var createButton : UIButton!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var phoneTextField : UITextField!
    @IBOutlet weak var confirmPasswordField : UITextField!
    @IBOutlet weak var TOSBox: BEMCheckBox!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    var usernameField : String = ""
    var emailField : String = ""
    var phoneField : String = ""
    var passwordField : String = ""
    var confirmField : String = ""
    var agreeToTOS : Bool = false
    
    var regDA = registrationDA()
    var logDA = loginDA()
    var profileImage : UIImage! = #imageLiteral(resourceName: "dp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TOSBox.delegate = self
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        definesPresentationContext = true
        
        // Set up UI
        setupNavigationBar()
        setUpImageView()
        
        
    }
    
    
    
    
    
    // Function to create users
    @IBAction func createUser() {
        
        var userCreated = false
        let showEmail = "False"
        let showPhone = "False"
        let userType = "E"
        
        // Put text fields value into the variables
        usernameField = nameTextField.text!
        passwordField = passwordTextField.text!
        emailField = emailTextField.text!
        phoneField = phoneTextField.text!
        confirmField = confirmPasswordField.text!
        
        
        
        // Check if the userfields is filled
        if checkAllFieldsRequired() == true {
            
            // Check if password field matches confirm field
            if passwordField == confirmField {
                // Convert password to SHA512
                passwordField = maskPassword(passwordField).uppercased()
                confirmField = maskPassword(confirmField).uppercased()
            }
            
            
            // Passing data to the Data Manager Function
            registrationDA.createUser(usernameField, emailField, passwordField, phoneField, showEmail, showPhone, userType, profileImage, onComplete:  {
                (token, userId, isCreated, msg, title) -> Void in
                
                print(token)
                print(userId)
                print(isCreated)
                
                
                userCreated = isCreated
                
                // Set global token
                loginDA._loginToken = token
                loginDA._userId = userId
                
                print("Is user created = \(userCreated)")
                print("Message is : \(msg) ")
                
                
                DispatchQueue.main.async() {
                    [unowned self] in

                    
             // yet to fix
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! CustomTabBarController
                        self.present(homeViewController, animated: true, completion: nil)
                    
                    
                   
                    
                   
                }
                
                
               
                
                
            })
            
            
            // Print results
            print(userCreated)
            
            
            
            
        } // End of the if
        
       
        
    } // end of create user
    
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Choose a photo source", message: "pick one", preferredStyle: .actionSheet)
        
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
    
    
    // Create function for convert password
    // to SHA512 as an requirement
    func maskPassword(_ password: String) -> String {
        return sha512Hex(string: password)
    }
    
    
    
    
    // Create function to check if password match
    // If password is true, returns.
    func checkPasswordMatch() -> Bool {
        
        if passwordField == confirmField {
            return true
        } else {
            return false
        }
        
        
    }
    
    // Create function to check if the fields are filled
    // If fields are filled, return true.
    func checkAllFieldsRequired() -> Bool {
        
        
        
        var message = ""
        var usernameMsg = ""
        var validEmailMsg = ""
        var phoneFieldMsg = ""
        var passwordFieldMsg = ""
        var confirmPasswordFieldMsg = ""
        var notMatchMsg = ""
        var agreetoTOSMsg = ""
        var validFormat = false
        
      
        // Validate if any fields are unfilled with text/incorrect fields
        
        if usernameField.isEmpty == true || isValidEmail(emailField) != true || phoneField.isEmpty == true || passwordField.isEmpty == true || confirmField.isEmpty == true || passwordField != confirmField || TOSBox.on == false {
            
            
            // If textfields are unfilled, show messages.
            
                if usernameField.isEmpty == true { usernameMsg = "- Username cannot be blank\n" }
                if isValidEmail(emailField) != true { validEmailMsg = "- Email is invalid/blank\n" }
                if phoneField.isEmpty == true { phoneFieldMsg = "- Phone number is required\n"}
                if passwordField.isEmpty == true { passwordFieldMsg = "- Password must be at least 6 characters\n" }
                if confirmField.isEmpty == true { confirmPasswordFieldMsg = "- Confirm password cannot be blank\n" }
                if passwordField != confirmField { notMatchMsg = "- Password does not match\n" }
                if agreeToTOS == false { agreetoTOSMsg = "- Must agree to the terms\n" }
            
            
            // Combine all messages
                message = usernameMsg + validEmailMsg + phoneFieldMsg + passwordFieldMsg + confirmPasswordFieldMsg + notMatchMsg + agreetoTOSMsg
                
            // If the textfields are unfilled, show an alert message with the messages
            if (validFormat == false){
                let uiAlert = UIAlertController(
                    title: "Whoops!",
                    message: message,
                    preferredStyle: UIAlertControllerStyle.alert)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
                self.present(uiAlert, animated:true, completion: nil)
            }
            
            
        } else {
            // Else is a valid format, post
            validFormat = true
            
                    
        }
        
        
       
        return validFormat
        
    }
    
    func presentAlert(msg:String, title:String) {
        let uiAlert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: UIAlertControllerStyle.alert)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
        self.present(uiAlert, animated:true, completion: nil)
    }
   
    
    // Function to check if checkbox is checked.
    func didTap(_ checkBox: BEMCheckBox) {
        if(checkBox.on) {
            agreeToTOS = true
            print(agreeToTOS)
        } else {
            agreeToTOS = false
            print(agreeToTOS)
        }
    }
    
    // Function to convert String to SHA512
    func sha512Hex(string: String) -> String {
        let data = string.data(using: .utf8)!
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    // Set up the navigation bar
    func setupNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil )
        
        
        
    }
    
    
    // Override func for exit edit when on textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        return email.characters.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
    }
    
    func isValidField(_ fields: String) -> Bool {
        return fields.characters.count > 4 && fields.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }
    
    func setUpImageView() {
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(r: 104, g: 104, b: 104)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        profileImage = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
  
    
    
}




extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}




