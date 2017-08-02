//
//  RegistrationDataManager.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 28/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import Foundation

class registrationDA: NSObject {
    
    
    
    override init() {
        
    }
    
    
    // Need to fix the profile image
    static func createUser(_ name: String, _ email: String, _ password: String, _ phone: String, _ showEmail: String, _ showPhone: String, _ type: String,_ profileDP: UIImage, onComplete: @escaping (String, String, Bool, String, String) -> Void) {
        
        var isCreated : Bool = false
        var token : String = ""
        var userId : String = ""
        var msg : String = ""
        var title : String = ""
        
        let photoURL = DatabaseAPI.url + "photos/addu"
        let addUserURL = DatabaseAPI.url + "user/add"
        
        
        uploadProfileDP(photoURL, profileDP, onComplete: {
            photoP in
            
            
            let json = JSON.init([
                "name" : name,
                "photo" : photoP,
                "email" : email,
                "password" : password,
                "phone" : phone,
                "showemail" : showEmail,
                "showphone" : showPhone,
                "type" : type
                ])
            
            
            print("SHOW THE USER PHOTO URL \(photoP)")
            
            
            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: addUserURL, json: json, onComplete: {
                    json, response, error in
                    
                    if response != nil
                    {
                        print(json!)
                        
                        if (json?["error"].exists())! {
                            isCreated = false
                            token = "empty"
                            userId = "empty"
                            msg = (json!["msg"].string!)
                            title = "Failed!"
                            onComplete(token, userId, isCreated, msg, title)
                            
                        } else {
                            isCreated = true
                            token = (json!["token"].string!)
                            SharedVariables.token = (json!["token"].string!)
                            userId = (json!["userid"].string!)
                            msg = "You may login your account with email and password!"
                            title = "Success!"
                            onComplete(token, userId, isCreated, msg, title)
                            
                        }
                        
                        
                        
                        return
                        
                    }
                    
                    if json != nil {
                        print(json!)
                        
                    }
                    isCreated = true
                })
                
                
                print(isCreated)
            } // End of Dispatch Queue
            
            
        }) // End of uploadProfileDP
        
        
    }
    
    static func uploadProfileDP(_ url: String, _ profileImage: UIImage, onComplete: @escaping(_: String) -> Void) {
        
        var photoPath = ""
       
        HTTP.postMultipartPhotos(url: url, token: SharedVariables.token, tag: 0, image: profileImage, onComplete: {
            json, response, error, tag in
            
            print("json \(json)")
            photoPath = json!["filepath"].string!
            print("This is the user  \(photoPath)")
            
            onComplete(photoPath)
            
        })
        
        
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
    

    
    
   
    
    
}
