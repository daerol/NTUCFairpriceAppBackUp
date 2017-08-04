//
//  ChatDataManager.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 4/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ChatDataManager: NSObject {
    
    static func postRequest(token: String, postId: String, onComplete: ((_ success: Bool, _ messagingId:String, _ error: String) -> Void)?) {
        let requestBookURL = DatabaseAPI.url + "chat/request"
        
        var requestBookJSON: JSON = [
            "token": token,
            "id": postId
        ]
        HTTP.postJSON(url: requestBookURL, json: requestBookJSON, onComplete: {
            json, response, error in
            print(json)
            
            let success = json!["success"] != JSON.null ? json!["success"].string : "false"
            let id = json!["id"] != JSON.null ? json!["id"].string : ""
            let error = json!["error"] != JSON.null ? json!["error"].string : ""

            onComplete!(Bool(success!)!, id!, error!)
        })
        
    }
    
}
