//
//  UserDataManager.swift
//  ntucTest
//
//  Created by Chia Li Yun on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
    
    
    static func getUserById (id: String, onComplete:((_:User) -> Void)?) {
        
        let getUserURL = DatabaseAPI.url + "user/get"
        let getUserJSON: JSON = [
            "id": id
        ]
        
        HTTP.postJSON(url: getUserURL, json: getUserJSON, onComplete: {
            json, response, error in
    
            let user = User(username: "", password: "", preferredloc: "", id: "", email: "", phoneNumber: "")
            
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
                    
                    onComplete?(user)
                }
            }else {
                print("nil")
            }
        })
    }

}
