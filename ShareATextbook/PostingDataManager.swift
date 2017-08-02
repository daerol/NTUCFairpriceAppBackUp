//
//  PostingDataManager.swift
//  ntucTest
//
//  Created by Chia Li Yun on 16/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PostingDataManager: NSObject {

//    onComplete: ((_: [Posting]) -> Void?)
    static func getPostingList(onComplete: ((_: [Posting]) -> Void)?) {
        let postListURL = DatabaseAPI.url + "posting/list"
        let postListReqJSON: JSON = [
            "limit": "50",
            "userid": SharedVariables.id,
            "isavailabile": "N"
        ]

        var post: Posting = Posting()
        
        HTTP.postJSON(url: postListURL, json: postListReqJSON, onComplete: {
            json, response, error in
            
            if json != nil {
                if !DatabaseAPI.responseIsError(json: json!) {
                    var postingList: [Posting] = []
                    print("no error \(json!.count)")
                    print("json \(json)")
                    for i in 0..<json!.count {
                        let post = Posting();
                        
                        post.preferredLocation = json![i]["preferredloc"] != JSON.null ? json![i]["preferredloc"].string! : ""
                        post.name = json![i]["name"].string!
                        post.author = json![i]["author"] != JSON.null ? json![i]["author"].string! : ""
                        post.isbn = json![i]["isbn"] != JSON.null ? json![i]["isbn"].string! : ""
                        post.publisher = json![i]["publisher"] != JSON.null ? json![i]["publisher"].string! : ""
                        post.edition = json![i]["edition"] != JSON.null ? json![i]["edition"].string! : ""
                        post.cateId = [json![i]["cateid"][0].string!, json![i]["cateid"][1].string!]
                        post.status = json![i]["status"] != JSON.null ? json![i]["status"].string! : ""
                        post.postDate =  Date(timeIntervalSince1970: json![i]["postdt"].double!)
                        post.by = json![i]["by"].string!
                        post.byId = json![i]["byid"].string!
                        post.id = json![i]["id"].string!
                        post.desc = json![i]["desc"].string!
                        
                        for j in 0..<json![i]["photos"].count {
                            post.photos.append(json![i]["photos"][j].string!)
                        }
                        
                        postingList.append(post)
                    }
                    
                    onComplete!(postingList)
                } else {
                    print("error la")
                }
            }
            
        })
    }
    
    static func addPost(post: Posting, postImageList: [UIImage] , onComplete:((_: Bool, _:Posting) -> Void)?) {
        let addPostingURL = DatabaseAPI.url + "posting/add"
        let url = DatabaseAPI.url + "photos/addp"
        
        print("numer pf iamge: \(postImageList.count)")
        uploadPhotos(url: url, postImageList: postImageList, onComplete: {
            photoList in
            
            let addPostingJSON: JSON = [
                "token": SharedVariables.token,
                "cateid": post.cateId,
                "name": post.name,
                "desc": post.desc,
                "photos": photoList,
                "publisher": post.publisher ?? "",
                "author": post.author ?? "",
                "edition": post.edition ?? "",
                "preferredloc": post.preferredLocation
            ]
            
            print("photholist \(photoList)")
            
            HTTP.postJSON(url: addPostingURL, json: addPostingJSON, onComplete: {
                json, response, error in
                
                if json != nil {
                    print(json!)
                    if !DatabaseAPI.responseIsError(json: json!) {
                        let success = Bool(json!["success"].string!)!
                        let id = json!["id"].string!
                        
                        post.id = id
                        onComplete?(success, post)
                    }
                }else {
                    print("nil")
                }
            })

        })
    }
    
    static func uploadPhotos(url: String, postImageList: [UIImage], onComplete:@escaping (_: [String]) -> Void) {
        
        var count = 0
        print("size \(postImageList.count)")
        var photos = [String](repeatElement("", count: postImageList.count))
        for i in 0..<postImageList.count {
            print("mimi \(i)")
            let image = postImageList[i]
            
            HTTP.postMultipartPhotos(url: url, token: SharedVariables.token, tag: i, image: image, onComplete: {
                json, response, error, tag in
                
                print("json \(json)")
                count += 1
                print(tag)
//                photos.append(json!["filepath"].string!)
//                photos.insert(json!["filepath"].string!, at: i)
                photos[tag!] = json!["filepath"].string!
                
                if count == postImageList.count {
                    onComplete(photos)
                }
            })
        }
        
    }
    
    static func editPost(post: Posting, postImageList: [UIImage] , onComplete:((_: Bool, _:Posting) -> Void)?) {
        let editPostingURL = DatabaseAPI.url + "posting/edit"
        
            let editPostingJSON: JSON = [
                "id": post.id,
                "token": SharedVariables.token,
                "cateid": post.cateId,
                "name": post.name,
                "desc": post.desc,
                "photos": ["0109722A4B13ABAB228900A68E3AA2BDF3F67535D1B92D98441281EDF5BAEE21_0eb9b4b26f8845cab32fb3f3a61f7340"],
                "publisher": post.publisher ?? "",
                "author": post.author ?? "",
                "edition": post.edition ?? "",
                "preferredloc": post.preferredLocation
            ]
        
            HTTP.postJSON(url: editPostingURL, json: editPostingJSON, onComplete: {
                json, response, error in
                
                if json != nil {
                    print(json!)
                    if !DatabaseAPI.responseIsError(json: json!) {
                        let success = Bool(json!["success"].string!)!
                        let id = json!["id"].string!
                        
                        post.id = id
                        onComplete?(success, post)
                    }
                }else {
                    print("nil")
                }
            })
    }
}
