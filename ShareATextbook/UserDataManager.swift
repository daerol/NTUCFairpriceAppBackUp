//
//  UserDataManager.swift
//  ntucTest
//
//  Created by Chia Li Yun on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
    
    
    static func getUserById (id: String, token: String, onComplete:((_:User) -> Void)?) {
        
        let getUserURL = DatabaseAPI.url + "user/get"
        let getUserJSON: JSON = [
            "id": id,
            "token": token
        ]
        
        HTTP.postJSON(url: getUserURL, json: getUserJSON, onComplete: {
            json, response, error in
    
            let user = User(username: "", password: "", preferredloc: "", id: "", email: "", phoneNumber: "", photo: "")
            
            if json != nil {
                print(json!)
                if !DatabaseAPI.responseIsError(json: json!) {
                    print("no error \(json!.count)")
                    
                    print("user \(json)")
                    user.id = json!["id"].string!
                    user.username = json!["name"].string!
                    user.preferredloc = json!["preferredloc"] != JSON.null ? json!["preferredloc"].string! : ""
                    user.email = json!["email"] != JSON.null ? json!["email"].string! : ""
                    user.phoneNumber = json!["phone"] != JSON.null ? json!["phone"].string! : ""
                    user.photo = json!["photo"] != JSON.null ? json!["photo"].string! : ""
                    
                    onComplete?(user)
                }
            }else {
                print("nil")
            }
        })
    }

    static func editUser (token: String, name: String, email: String, phone: String, showemail: String, showphone: String, notifyviaemail: String, notifyviasms: String, photo: String ,onComplete:((_:Bool, _:String) -> Void)?) {
        
        let editUserURL = DatabaseAPI.url + "user/edit"
        var editUserJSON: JSON = [
            "token": token,
            "name": name,
            "email": email,
            "phone": phone,
            "showphone": showphone,
            "showemail": showemail,
            "notifyviaemail": notifyviaemail,
            "notifyviasms": notifyviasms,
            "photo": photo
        ]
        
        print("sendJ:\(editUserJSON)")
        HTTP.postJSON(url: editUserURL, json: editUserJSON, onComplete: {
            json, response, error in
            
            if json != nil {
                print(json!)
                
                let success = Bool(json!["success"].string!)
                let userId = json!["id"].string!
                
                onComplete!(success!, userId)
                
            }else {
                print("nil")
            }
        })
        
    }
}
