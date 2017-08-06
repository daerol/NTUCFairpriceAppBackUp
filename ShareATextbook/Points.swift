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
    var message : String =  ""
    var joinddts : String = ""
    var points: Int = 0
    
    
    init(postingid : String, userid : String, type : String, points : Int, message : String, joinddts : String) {
        self.postingid = postingid
        self.userid = userid
        self.type = type
        self.points = points
        self.message = message
        self.joinddts = joinddts
        
        super.init()
    }
    
    
    init(points: Int, type : String) {
        self.points = points
        self.type = type
    }
    

}
