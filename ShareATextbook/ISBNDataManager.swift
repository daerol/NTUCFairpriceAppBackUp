//
//  ISBNDataManager.swift
//  ntucTest
//
//  Created by Chia Li Yun on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ISBNDataManager: NSObject {

    static func getISBNById (id: String, onComplete:((_:ISBN) -> Void)?) {
        let getISBNURL = DatabaseAPI.url + "ISBN/get"
        let getISBNJSON: JSON = [
            "id": id
        ]
        
        
        HTTP.postJSON(url: getISBNURL, json: getISBNJSON, onComplete: {
            json, response, error in
            
            if json != nil {
                print(json!)
                if !DatabaseAPI.responseIsError(json: json!) {
                    
                    var isbn: ISBN = ISBN()
                    
                    print("user \(json)")
                    isbn.name = json!["name"].string!
                    isbn.publisher = json!["publisher"].string!
                    isbn.id = json!["id"].string!
                    isbn.author = json!["author"].string!
                    isbn.edition = json!["edition"].string!
                    isbn.cateId = [json!["cateid"][0].string!, json!["cateid"][1].string!]

                    onComplete?(isbn)
                }
            }else {
                print("nil")
            }
        })
    }
    
}
