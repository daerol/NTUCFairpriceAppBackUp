//
//  HomepageDataManager.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 18/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class HomepageDataManager: NSObject {
    
    class func retrieveCategories(onComplete: @escaping ((_ : [Categories]) -> Void)) {
        
        
        let url = DatabaseAPI.url + "category/list"
        let json = JSON.init([
            "limit" : "200",
            "heading" : "Subject"
            ])
        
        HTTP.postJSON(url: url,
            json: json,
            onComplete: {
                json, response, error in
                
               
                var categoriesList : [Categories] = []
                
                if error != nil {
                    return
                    
                }
        
                
                
                
               // print(json!.count)
                
                
                
                for var i in 0..<json!.count {
                    
                    let cat = Categories(id: json![i]["id"].string!,
                                         displayOrder: json![i]["displayorder"].string!,
                                         heading: json![i]["heading"].string!,
                                         name: json![i]["name"].string!)
                    
                    
                    
                    categoriesList.append(cat)
                   // print(cat.name)
                }
                
                onComplete(categoriesList)
                
        })
        
        
    }
       

}
