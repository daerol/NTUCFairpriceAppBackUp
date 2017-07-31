//
//  User.swift
//  ntucTest
//
//  Created by Chia Li Yun on 30/4/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var username : String
    var password : String
    var preferredloc: String
    var id: String
    var email: String
    var phoneNumber: String
    
    init(username: String, password: String, preferredloc: String, id: String, email: String, phoneNumber: String) {
        self.username = username
        self.password = password
        self.preferredloc = preferredloc
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        
        super.init()
    }

}
