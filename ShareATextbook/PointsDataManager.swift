//
//  PointsDataManager.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 2/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PointsDataManager: NSObject {
    
    static func getUserPoints(_ userId : String, onComplete: @escaping ((_ : [Points]) -> Void))  {
        
        let retrievePointsURL = DatabaseAPI.url + "/points/list"
        
        let retrievePointsJSON = JSON.init([
            "userId" : userId
            ])
        
        
        HTTP.postJSON(url: retrievePointsURL,
              json: retrievePointsJSON,
              onComplete: {
                json, response, error in
                
                
                var pointsList : [Points] = []
                
                if error != nil {
                    return
                    
                }
                
        
                for var i in 0..<json!.count {
                    
                    let allPoints = Points(postingid: json![i]["postingid"].string!,
                                           userid: json![i]["userid"].string!,
                                           type: json![i]["type"].string!,
                                           points: json![i]["points"].int!,
                                           message: json![i]["msg"].string!,
                                           joinddts: json![i]["pointsddts"].string!)
                    
                    pointsList.append(allPoints)
                    
        
                }
                
                onComplete(pointsList)
                
        })
        
        
    }

    
    static func addPostingPoints(_ postingID : String, _ userID : String,onComplete: @escaping (Bool) -> Void) {
        
        var isCreated = false
        let addPostingPointsURL = DatabaseAPI.url + "/points/add"
        let type = "donor_accept"
        
        let addPointsJSON = JSON.init([
            "postingid" : postingID,
            "userid" : userID,
            "type" : type
            ])
        
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: addPostingPointsURL, json: addPointsJSON, onComplete: {
                json, response, error in
                
                if response != nil
                {
                    print(json!)
                    return
                    
                }
                
                if json != nil {
                    print(json!)
                    
                }
                isCreated = true
            })
            
            
            print(isCreated)
        } // End of Dispatch Queue    
        
        onComplete(isCreated)
    }
    
    
    // Add new user 
    // return the method boolean
    static func addNewUserPoints (_ userID : String,onComplete: @escaping (Bool) -> Void) {
        
        var isCreated = false
        let addPostingPointsURL = DatabaseAPI.url + "/points/add"
        let type = "newUser"
        
        let addPointsJSON = JSON.init([
            "userid" : userID,
            "type" : type
            ])
        
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: addPostingPointsURL, json: addPointsJSON, onComplete: {
                json, response, error in
                
                if response != nil
                {
                    print(json!)
                    return
                    
                }
                
                if json != nil {
                    print(json!)
                    
                }
                isCreated = true
            })
            
            
            print(isCreated)
        } // End of Dispatch Queue
        
        onComplete(isCreated)
    }
    
    
    // Find out the users points
    // Return a string value
    
    static func findoutUserPoints(_ userId : String, onComplete: @escaping (Int) -> Void) {
        var totalPoints = 0
        let getPointsURL = DatabaseAPI.url + "points/list"
        var pointsList : [Points] = []
        
        let getPointsJSON = JSON.init([
            "userid" : userId,
            ])
        
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: getPointsURL, json: getPointsJSON, onComplete: {
                json, response, error in
                
                if response != nil
                {
                    print(json!)
                    return
                    
                }
                
                
                

                
                
                for var i in 0..<json!.count {
                    
                    if (json![i]["type"].string! == "newUser" || json![i]["type"].string! == "donor_accept") {
                        totalPoints += json![i]["points"].int!
                    }
                    
                    if (json![i]["type"].string! == "banUser") {
                        totalPoints -= json![i]["points"].int!
                    }
                    
                    
//                    let allPoints = Points(points : json![i]["points"].int!,
//                                           type: json![i]["type"].string!)
//                    
//                    pointsList.append(allPoints)
                    
                }
                
                
              
            })
            onComplete(totalPoints)
            
            print(totalPoints)
        } // End of Dispatch Queue
        
       
        
        
    }
    
    
}
