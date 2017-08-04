//
//  LoginViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/4/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    //    private let LOGIN_SEGUE = "loginSegue"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var passwordTextfield : UITextField!
    
    var emailField : String = ""
    var passwordField : String = ""
    var loggedUserId : String = ""
    var loggedToken : String = ""
    
    let loginButton = FBSDKLoginButton()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // ViewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
        // Do any additional setup after loading the view.
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x:16, y: 400, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
    }
    // End viewDidLoad function
    
    // ViewDidAppear function
    override func viewDidAppear(_ animated: Bool) {
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if(!isUserLoggedIn){
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginHome") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! CustomTabBarController
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
    // End ViewDidAppear function
    
    // loginBtn function to call login functions within ViewController
    @IBAction func loginBtn(_ sender: Any) {
        emailLogin()
        //        self.performSegue(withIdentifier: LOGIN_SEGUE, sender: nil)
    }
    
    // START emailLogin func
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
                          
                            //  LI YUN ADDED
                            let user = User(username: "", password: "", token: "", preferredloc: "", id: "", email: "", phoneNumber: "", photo: "")
                          
                            if json != nil {
                                print(json!)
                                token = (json!["token"].string)
                                userId = (json!["userid"].string)
                                        print(token)
                                        print(userId)
                                self.loggedUserId = userId
                                self.loggedToken = token
                                print("LoggedUserId = \(userId)")
                                print("LoggedToken = \(token)")
                                //                            let saveToken: Bool = KeychainWrapper.standard.set(token, forKey: "sessionToken")
                                //                            let saveUserId: Bool = KeychainWrapper.standard.set(userId, value(forKey: "userid"))
                                
                                //  LI YUN ADDED
                            user.id = json!["userid"].string!
                            user.username = json!["name"].string!
                            user.preferredloc = json!["preferredloc"] != JSON.null ? json!["preferredloc"].string! : ""
                            user.email = json!["email"] != JSON.null ? json!["email"].string! : ""
                            user.phoneNumber = json!["phone"] != JSON.null ? json!["phone"].string! : ""
                            user.photo = json!["photo"] != JSON.null ? json!["photo"].string! : ""
                                
                                print(user.id)
                                print(user.username)
                                print(user.email)
                                print(user.token)
                                print(user.phoneNumber)
                            
                            //  UserDefaults
                            UserDefaults.standard.set(token, forKey: "Token")
                            UserDefaults.standard.set(password, forKey: "HashedPassword")
                            //  Encode user object
                            let encodedUserData = NSKeyedArchiver.archivedData(withRootObject: user)
                            UserDefaults.standard.set(encodedUserData, forKey: "User")

                              
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
                                        
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.synchronize()
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
    // END Email Login
    
    // FB Login and Logout functions
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self)
        { (result, error) in
            
            if error != nil {
                print("FB Login failed!", error!)
                return
            }
            
            let socialToken = result?.token.tokenString
            print(socialToken)
            
            loginDA.socialLogin(socialToken: socialToken!, onComplete: {
                (token, userId, isLogin) -> Void in
                
                self.loggedToken = token
                self.loggedUserId = userId
                
                if (isLogin) {
                    DispatchQueue.main.async() {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! CustomTabBarController
                            self.present(homeViewController, animated: true, completion: nil)
                            
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.synchronize()
                    }
                }
                
        print("Successfully logged in with facebook...")
                
            })
            
        }
    }
    // End FB Login / Logout functions
    
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
    
    func displayMyAlertMessage(userMessage:String)
    {
        
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    func checkAllFieldsRequired() -> Bool
    {
        var message = ""
        var usernameMsg = ""
        var passwordMsg = ""
        var validFormat = false
        
        if emailField.isEmpty == true || passwordField.isEmpty == true {
            
            if emailField.isEmpty == true {usernameMsg = "Email is required!\n"}
            else if passwordField.isEmpty == true {passwordMsg = "Invalid Password/Password is required!\n"}
        } else {validFormat = true}
        
        message = usernameMsg + passwordMsg
        
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