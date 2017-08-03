//
//  MapViewViewController.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 2/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var vc = PinResultViewController()
    
    var tap = UITapGestureRecognizer()
    
    var postingList: [Posting]?
    
    var postingDict: [String: [Posting]]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
//        mapView.addGestureRecognizer(tap)
        
        if (locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.distanceFilter = 5.0
        locationManager.startUpdatingLocation()
        
        //  Get all posting
        PostingDataManager.getPostingList(userId: "", isAvailable: "N", onComplete: {
            postList in
            
            self.postingList = postList
            print("posting:\(self.postingList?.count)")
            
            for p in postList {
                let post: Posting = p
                let loc = LocationValue.convertToLocationValue(locationDescription: post.preferredLocation)
                
                print(post.preferredLocation)
                let coordStr = String(loc.location.coordinate.latitude) + "," + String(loc.location.coordinate.longitude)
                if self.postingDict?[coordStr] != nil {
                    self.postingDict?[coordStr]!.append(post)
                } else {
                    self.postingDict?[coordStr] = [post]
                }
            }
            
            print(self.postingDict!)
            
            DispatchQueue.main.async {
                self.showMapPin()
            }
        })
        
        // I'm using a storyboard.
        let sb = UIStoryboard(name: "Map", bundle: nil)
        
        // I have identified the view inside my storyboard.
        vc = sb.instantiateViewController(withIdentifier: "PinResultViewController") as! PinResultViewController
        
        // These values can be played around with, depending on how much you want the view to show up when it starts.
        vc.view.frame = CGRect(x: 0, y: self.view.frame.height - 85, width: self.view.frame.width, height: 85)
        
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapAction() {
        UIView.animate(withDuration: 0.4, animations: {
            self.vc.view.frame = CGRect(x: 0, y: self.view.frame.height - 85, width: self.view.frame.width, height: 85)
        })
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
        let viewRegion = MKCoordinateRegionMakeWithDistance((currentLocation?.coordinate)!, 800, 800)
        mapView.setRegion(viewRegion, animated: false)
        
        locationManager.startUpdatingLocation()
        //  For loop through the posting to look for items within 800m
        
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation") as? MKPinAnnotationView
//        
//        if pin == nil {
//            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
//            
//        }
//        
//        return pin
//    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("moved")
        
        print("center\(mapView.centerCoordinate.latitude):\(mapView.centerCoordinate.longitude)")
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude), completionHandler: {
            placemarks, error in
            
            if error == nil && (placemarks?.count)! > 0 {
                var placeMark = placemarks?.last as? CLPlacemark
                var adressLabel = "\(placeMark!.thoroughfare)\n\(placeMark!.postalCode) \(placeMark!.locality)\n\(placeMark!.country)"
//                print("\(placeMark!.thoroughfare)\n\(placeMark!.postalCode) \(placeMark!.locality)\n\(placeMark!.country)\n\(placeMark?.subThoroughfare)")
                
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("sele-\(view.annotation?.coordinate.latitude):\(view.annotation?.coordinate.longitude)")
        let selectedCoordStr: String = Formatter.formatDoubleToString(num: (view.annotation?.coordinate.latitude)!, noOfDecimal: 4) + "," + Formatter.formatDoubleToString(num: (view.annotation?.coordinate.longitude)!, noOfDecimal: 4)
        
        if self.postingDict?[selectedCoordStr] != nil {
            print("jave")
            let selectPostList: [Posting] = (self.postingDict?[selectedCoordStr])!
            print(selectPostList)
            vc.postList = selectPostList
            
            if vc.postList.count < 4 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.vc.view.frame = CGRect(x: 0, y: self.view.frame.height - 250, width: self.view.frame.width, height: 250)
                    self.vc.swipeImageView.image = UIImage(named: "Down")
                })
            }
        } else {
            print("no")
        }
        print("lal\(selectedCoordStr)")
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!), completionHandler: {
            placemarks, error in
            
            if error == nil && (placemarks?.count)! > 0 {
                let placeMark = placemarks?.last
                let adressStr = "\(placeMark!.subThoroughfare != nil ? placeMark!.subThoroughfare! : "") \(placeMark!.thoroughfare!), \(placeMark!.country!) \(placeMark!.postalCode!) "
                DispatchQueue.main.async {
                    self.vc.addressLabel.text = adressStr
                }
            }
        })
    }
    
    func showMapPin() {
        for (key, value) in postingDict! {
            print("\(key):\(value)")
            let coordArr = key.components(separatedBy: ",")
            
            let locCoord = CLLocationCoordinate2D(latitude: Double(coordArr[0])!, longitude: Double(coordArr[1])!)
            let dropPin = MapAnnotation(coordinate: locCoord, title: "My Point", subtitle: "Lat: \(locCoord.latitude), Lng: \(locCoord.longitude)")
            self.mapView.addAnnotation(dropPin)
        }
    }

}
