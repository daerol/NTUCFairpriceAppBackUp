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
    
    static func createUser(_ name: String, _ email: String, _ password: String, _ phone: String, _ showEmail: String, _ showPhone: String, _ type: String, onComplete: @escaping (String, String, Bool, String, String) -> Void) {
        
        var isCreated : Bool = false
        var token : String = ""
        var userId : String = ""
        var msg : String = ""
        var title : String = ""
        
        
        
        let json = JSON.init([
            "name" : name,
            "email" : email,
            "password" : password,
            "phone" : phone,
            "showemail" : showEmail,
            "showphone" : showPhone,
            "type" : type
            ])
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/add", json: json, onComplete: {
                json, response, error in
                
                if response != nil
                {
                    print(json!)
//                    if let token = (json?["token"].string!) {
//                          print(token)
//                    }
//                    if let userId = (json?["id"].string!) {
//                        print(userId)
//                    }
                    
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
        
        
    }
    
    
    
    
    
    
    func loginAndPost(_ email: String, _ password: String) -> Bool {
        
        var posted = false
        
        var nonce : String = ""
        let userType = "E"
        
        let json = JSON.init([
            "email" : email
            ])
        
        DispatchQueue.global(qos: .background).async{
            HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/getnonce", json: json, onComplete: {
                json, response, error in
                
                if response != nil
                {
                    print(json!)
                    let nonce = (json!["nonce"].string!)
                    print(nonce)
                    
                    let hashedPassword = self.sha512Hex(string: (self.sha512Hex(string: password).uppercased() + nonce )).uppercased()
                    
                    let loginJson = JSON.init([
                        "type" : userType,
                        "email" : email,
                        "password" : hashedPassword
                        ])
                    
                    HTTP.postJSON(url: "http://13.228.39.122/FP05_883458374658792/1.0/user/login", json: loginJson, onComplete: {
                        json, response, error in
                        
                        if response != nil
                        {
                            print(json!)
                            return
                        }
                        
                        
                    })
                    
                    posted = true
                    return
                }
                
            })
            
            
        } // End of Dispatch Queue
        
        print(posted)
        return posted
        
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
    

    
    
    
    
    func postMultiPart(token: String, url: String, image: UIImage) {
        
        var r  = URLRequest(url: URL(string: url)!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        let userToken = ["token" : token]
        
        //Now use image to create into NSData format
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        
        r.httpBody = createBody(parameters: userToken,
                                boundary: boundary,
                                data: UIImageJPEGRepresentation(image, 0.7)!,
                                mimeType: "image/jpg",
                                filename: "hello.jpg")
        
    }
    
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    
}


extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
