//
//  CategoryDataManager.swift
//  ntucTest
//
//  Created by Chia Li Yun on 29/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class CategoryDataManager: NSObject {

    
    /// Get list of categories
    ///
    /// - Parameter limit: Number of category
    /// - Returns: Array of Category
    static func getCategoryList(limit: String, onComplete:
        ((_: [Category]) -> Void)?) {
        let categoryListURL = DatabaseAPI.url + "category/list"
        let categoryListJSON: JSON = [
            "limit": limit
        ]
        
        var categoryList : [Category] = []
        
        HTTP.postJSON(url: categoryListURL, json: categoryListJSON, onComplete: {
            json, response, error in
            
            //            print(json!)
            if json != nil {
                print(json!)
                if !DatabaseAPI.responseIsError(json: json!) {
                    print("no error \(json!.count)")
                    
                    for i in 0..<json!.count {
                        let category = Category()
                        
                        category.id = json![i]["id"].string!
                        category.displayOrder = Int(json![i]["displayorder"].string!)!
                        category.heading = json![i]["heading"].string!
                        category.name = json![i]["name"].string!
                        
                        categoryList.append(category)
                        
                    }
                    
                    onComplete?(categoryList)
                }
            }else {
                print("nil")
            }
        })
        
    }
    
    static func getCategoryById (id: String, onComplete:((_:Category) -> Void)?) {
        
        let getCategoryURL = DatabaseAPI.url + "category/get"
        let getCategoryJSON: JSON = [
            "id": id
        ]
        
        HTTP.postJSON(url: getCategoryURL, json: getCategoryJSON, onComplete: {
            json, response, error in
            
            
            if json != nil {
                print(json!)
                if !DatabaseAPI.responseIsError(json: json!) {
                    
                    var category = Category()
                    
                    category.name = json!["name"].string!
                    category.heading = json!["heading"].string!
                    category.id = json!["id"].string!
                    category.displayOrder = Int(json!["displayorder"].string!)!
                    
                    onComplete?(category)
                }
            }else {
                print("nil")
            }
        })
        
    }
}
