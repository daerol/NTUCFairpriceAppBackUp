//
//  Points.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 2/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//


class Points: NSObject {
    
    var postingid : String = ""
    var userid : String = ""
    var type: String = ""
    var points: Int = 0
    
    
    init(postingid : String, userid : String, type : String, points : Int) {
        self.postingid = postingid
        self.userid = userid
        self.type = type
        self.points = points
        
        super.init()
    }
    
    

}
