//
//  User.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/4/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    var username : String
    var password : String
    var token : String
    var preferredloc: String?
    var id: String
    var email: String
    var phoneNumber: String
    var photo: String
    
    init(username: String, password: String, token: String, preferredloc: String, id: String, email: String, phoneNumber: String, photo:String) {
        self.username = username
        self.password = password
        self.preferredloc = preferredloc
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.token = token
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.preferredloc = aDecoder.decodeObject(forKey: "preferredloc") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.photo = aDecoder.decodeObject(forKey: "photo") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "passsword")
        aCoder.encode(preferredloc, forKey: "preferredloc")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(photo, forKey: "photo")
    }

}
