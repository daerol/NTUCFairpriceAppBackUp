//
//  MapAnnotation.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 3/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D,
         title: String,
         subtitle: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}
