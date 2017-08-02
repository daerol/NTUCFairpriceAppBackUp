//
//  Categories.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 18/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import Foundation

class Categories: NSObject {
    
    var id : String = ""
    var displayOrder : String = ""
    var heading : String = ""
    var name : String = ""
    
    init(id : String, displayOrder : String, heading : String, name : String) {
        self.id = id
        self.displayOrder = displayOrder
        self.heading = heading
        self.name = name
    }
    
   
    
    
    
}
