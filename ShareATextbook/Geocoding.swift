//
//  Geocoding.swift
//  Example
//
//  Created by Chia Li Yun on 31/7/17.
//  Copyright © 2017 Xmartlabs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Geocoding {

    
    /// Convert address to coordinates
    ///
    /// - Parameters:
    ///   - address: Address in String
    ///   - onComplete: return coordinate value
    class func geocode(address: String, onComplete:((_: CLLocationCoordinate2D) -> Void)?) {
        CLGeocoder().geocodeAddressString(address, completionHandler: {
            placemarks, error in
            
            if let placemark = placemarks?.first {
                let coordinate :CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                
                
                onComplete!(coordinate)
            }
        })
    }

    class func reverseGeocode(coordinate: CLLocation, onComplete:((_: CLPlacemark) -> Void)?){
        CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {
            placemarks, error in
            
            if let placemark = placemarks?.first {
                
                print("re:\(placemark.name)")
                 onComplete!(placemark)
            }

        })
    }
    
    /// Convert MKPlacemark to Address
    ///
    /// - Parameter selectedItem: MKPlacemark
    /// - Returns: Address in String
    class func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        print("add \(addressLine)")
        return addressLine
    }
}
