//
//  Posting.swift
//  ntucTest
//
//  Created by Chia Li Yun on 16/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class Posting: NSObject {
//    
//    private var _name : String = ""
//    var name : String
//    {
//        get { return _name }
//        set {
//            _name = newValue
//        }
//    }
    
    private var _id: String = ""
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    private var _cateId: [String] = [String](repeatElement("", count: 2))
    var cateId: [String]{
        get {
            return _cateId
        }
        set {
            _cateId = newValue
        }
    }
    
    private var _by: String = ""
    var by: String {
        get {
            return _by
        }
        set {
            _by = newValue
        }
    }
    
    
    private var _byId: String = ""
    var byId : String{
        get {
            return _byId
        }
        set {
            _byId = newValue
            
        }
    }
    
    private var _name: String = ""
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    private var _isbn: String? = ""
    var isbn: String {
        get{
            return _isbn!
        }
        set {
            _isbn = newValue
        }
    }
    
    private var _preferredLocation: String? = ""
    var preferredLocation: String{
        get {
            return _preferredLocation!
        }
        set {
            _preferredLocation = newValue
        }
    }
    
    private var _desc: String = ""
    var desc: String {
        get {
            return _desc
        }
        set {
            _desc = newValue
        }
    }
    
    private var _publisher: String?
    var publisher: String? {
        get {
            return _publisher
        }
        set {
            _publisher = newValue
        }
    }
    
    private var _author: String?
    var author: String? {
        get {
            return _author
        }
        set {
            _author = newValue
        }
    }
    private var _edition: String?
    var edition: String? {
        get {
            return _edition
        }
        set {
            _edition = newValue
        }
    }
    private var _tags: String? 
    var tags: String? {
        get {
            return _tags
        }
        set {
            _tags = newValue
        }
    }
    private var _postDate: Date = Date()
    var postDate: Date {
        get {
            return _postDate
        }
        set {
            _postDate = newValue
        }
    }
    private var _status: String = ""
    var status: String {
        get{
            return _status
        }
        set {
            _status = newValue
        }
    }
    
    private var _photos: [String] = []
    var photos: [String] {
        get {
            return _photos
        }
        set {
            _photos = newValue
        }
    }

    private var _deleted: String? = ""
    var deleted: String {
        get {
            return _deleted!
        }
        set {
            _deleted = newValue
        }
    }
    /*
    func getStatusText() -> String{
        switch status
    }*/
    
}
