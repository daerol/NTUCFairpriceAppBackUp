//
//  LoginViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/4/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var passwordTextfield : UITextField!
    
    var emailField : String = ""
    var passwordField : String = ""
    var loggedUserId : String = ""
    var loggedToken : String = ""
    
    
    @IBAction func loginBtn(_ sender: Any) {
        emailLogin()
    }
    
    
    
    func emailLogin()
    {
        emailField = emailTextField.text!
        passwordField = passwordTextfield.text!
        var password = ""
        print(emailField)
        print(passwordField)
        var token : String!
        var userId : String!
        
        let json = JSON.init([
            "email" : emailField
            ])
        if checkAllFieldsRequired() == true {
            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/getnonce", json: json, onComplete: {
                    json, response, error in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if response != nil
                    {
                        print(json!)
                        
                        let nonce = (json!["nonce"].string)
                        password = self.sha512Hex(string: (self.sha512Hex(string: self.passwordTextfield.text!).uppercased() + nonce!)).uppercased()
                        
                        let loginJson = JSON.init([
                            "type" : "E",
                            "email" : self.emailField,
                            "password" : password
                            ])
                        
                        HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/login", json: loginJson, onComplete: {
                            json, response, error in
                            
                            if json != nil {
                                print(json!)
                                token = (json!["token"].string)
                                userId = (json!["userid"].string)
                                //                                print(token)
                                //                                print(userId)
                                self.loggedUserId = userId
                                self.loggedToken = token
                                print("LoggedUserId = \(self.loggedUserId)")
                                print("LoggedToken = \(self.loggedToken)")
                                //                            let saveToken: Bool = KeychainWrapper.standard.set(token, forKey: "sessionToken")
                                //                            let saveUserId: Bool = KeychainWrapper.standard.set(userId, value(forKey: "userid"))
                                
                                if token == nil
                                {
                                    print(error!)
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        
                                        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! CustomTabBarController
                                        self.present(homeViewController, animated: true, completion: nil)
                                    }
                                    
                                }
                                return
                            }
                            
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                        })
                        return
                    }
                    
                })
            } // end of dispatcher
        } // end of if checkallfields
        return
        
        
    }
    
    func checkAllFieldsRequired() -> Bool
    {
        var message = ""
        var validFormat = false
        
        if emailField.isEmpty == true {message = "Email is required!"}
        else if passwordField.isEmpty == true {message = "Invalid Password/Password is required!"}
        else {validFormat = true}
        
        if (validFormat == false)
        {
            let uiAlert = UIAlertController(
                title: "Required Fields",
                message: message,
                preferredStyle: UIAlertControllerStyle.alert)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
            self.present(uiAlert, animated:true, completion: nil)
        }
        return validFormat
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
    } //END sha512Hex
    
    // Create function for convert password
    // to SHA512 as an requirement
    func maskPassword(_ password: String) -> String {
        return sha512Hex(string: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        TO-BE-REMOVED
        emailTextField.text = "Davidkwong@email.com"
        passwordTextfield.text = "davidPassword"
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
