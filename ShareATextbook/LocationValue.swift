//
//  LocationValue.swift
//  Example
//
//  Created by Chia Li Yun on 1/8/17.
//  Copyright © 2017 Xmartlabs. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationValue: Equatable {

//    let value: Int
    var location: CLLocation
    var descriptionName: String
    var address: String
    
    var description: String {
        let coord = String(location.coordinate.longitude) + "," + String(location.coordinate.latitude)
        if descriptionName == "" {
            descriptionName = "-"
        }
        return coord + "|" + descriptionName + "|" + address
    }
    
    init(){
        location = CLLocation()
        descriptionName = ""
        address = ""
    }
    
    init(location: CLLocation, descriptionName: String, address: String) {
        self.location = location
        self.descriptionName = descriptionName
        self.address = address
    }
    
    public static func == (lhs: LocationValue, rhs: LocationValue) -> Bool {
        return
            lhs.location == rhs.location &&
                lhs.descriptionName == rhs.descriptionName &&
                lhs.address == rhs.address
    }
    
}
