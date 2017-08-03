//
//  LoginDataManager.swift
//  ShareATextbook
//
//  Created by Shah on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import Foundation

class loginDA: NSObject {
    
   static var _loginToken : String = ""
   static var _userId : String = ""
    
    class func socialLogin(socialToken: String, onComplete: @escaping (String, String, Bool) -> Void) {
        
        var isLogin = false
        var token = ""
        var userId = ""
        
        let json = JSON.init([
            "type" : "F",
            "token" : socialToken
            ])
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/login", json: json, onComplete: {
                json, response, error in
                
                if json != nil {
                    print(json!)
                    isLogin = true
                    token = (json!["token"].string)!
                    userId = (json!["userid"].string)!
                    onComplete(token, userId, isLogin)
                }
            })
            
            return
            
        } // End of Dispatch Queue
    
    }
    
    class func logOut() -> Void {
        var isLoggedOut = false
        var token = ""
        var userId = ""
        
        let json = JSON.init([
            "token" : token,
            "userid" : userId
            ])
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/logout", json: json, onComplete: {
                json, response, error in
                
                if json != nil {
                    print(json!)
                    isLoggedOut = true
                    token = (json!["token"].string)!
                    userId = (json!["userid"].string)!
//                    onComplete(token, userId, isLoggedOut)
                }
            })
            
            return
        } // End of Dispatch Queue
    }
    
    
    
    override init() {
        
    }
    
    
    
    
    
    
    
}
