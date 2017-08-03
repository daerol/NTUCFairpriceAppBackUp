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
        let coord = Formatter.formatDoubleToString(num: location.coordinate.latitude, noOfDecimal: 4) + "," + Formatter.formatDoubleToString(num: location.coordinate.longitude, noOfDecimal: 4)
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
    
    public static func convertToLocationValue(locationDescription: String) -> LocationValue {
        let preferredLocArr = locationDescription.components(separatedBy: "|")
        let coordArr = preferredLocArr[0].components(separatedBy: ",")
        
        var loc = LocationValue()
        
        loc.location = CLLocation(latitude: CLLocationDegrees(string: (coordArr[0]))!, longitude: CLLocationDegrees(string: (coordArr[1]))!)
        loc.descriptionName = (preferredLocArr[1])
        loc.address = (preferredLocArr[2])
        
        return loc
    }
    
}
