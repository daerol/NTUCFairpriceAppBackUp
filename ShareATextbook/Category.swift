//
//  Category.swift
//  ntucTest
//
//  Created by Chia Li Yun on 29/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    private var _id: String = ""
    private var _displayOrder: Int = 0
    private var _heading: String = ""
    private var _name: String = ""
    
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var displayOrder: Int {
        get {
            return _displayOrder
        }
        set {
            _displayOrder = newValue
        }
    }
    
    var heading: String {
        get {
            return _heading
        }
        set {
            _heading = newValue
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
    

}
