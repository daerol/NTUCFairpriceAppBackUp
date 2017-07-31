//
//  ISBN.swift
//  ntucTest
//
//  Created by Chia Li Yun on 4/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ISBN: NSObject {

    private var _id: String = ""
    private var _name: String = ""
    private var _cateId: [String] = [String](repeatElement("", count: 2))
    private var _publisher: String = ""
    private var _author: String = ""
    private var _edition: String = ""
    
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    var cateId: [String] {
        get {
            return _cateId
        }
        set {
            _cateId = newValue
        }
    }
    
    var publisher: String {
        get {
            return _publisher
        }
        set {
            _publisher = newValue
        }
    }
    
    var author: String {
        get {
            return _author
        }
        set {
            _author = newValue
        }
    }
    
    var edition: String {
        get {
            return _edition
        }
        set {
            _edition = newValue
        }
    }
    
}
