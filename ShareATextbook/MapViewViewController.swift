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
    var distDict: [String: String]? = [:]
    
    var selectedAnnotation: MKAnnotation!
    
    @IBAction func locateMeAction(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func directionAction(_ sender: Any) {
        if selectedAnnotation != nil {
            if OpenPhoneApplication.openMap(url: "https://www.apple.com/ios/maps/") {
                let location = selectedAnnotation.title??.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                UIApplication.shared.openURL(URL(string:
                    "http://maps.apple.com/?daddr=" + location!)!)
            } else {
                //  Alert user that Apple Map does not exist
                let alert = UIAlertController(title: "Apple Map is not installed in your phone", message: "Please install from __", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Please select 1 Pin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
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
                let dist = self.currentLocation?.distance(from: CLLocation(latitude: loc.location.coordinate.latitude, longitude: loc.location.coordinate.longitude))
                
                print(post.preferredLocation)
                let coordStr = String(loc.location.coordinate.latitude) + "," + String(loc.location.coordinate.longitude)
                if self.postingDict?[coordStr] != nil {
                    self.postingDict?[coordStr]!.append(post)
                } else {
                    self.postingDict?[coordStr] = [post]
                    self.distDict?[coordStr] = Formatter.formatDoubleToString(num: dist!/1000, noOfDecimal: 1)
                }
            }
            
            print(self.postingDict!)
            print("Distid:\(self.distDict)")
            
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
        
        //  Attach the vc to self
        vc.mapViewController = self
        
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
        
        UIView.animate(withDuration: 0.4, animations: {
            self.mapView.setRegion(viewRegion, animated: false)
        })
        
        locationManager.stopUpdatingLocation()
        
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
        let selectedCoordStr: String = Formatter.formatDoubleToString(num: (view.annotation?.coordinate.latitude)!, noOfDecimal: 4) + "," + Formatter.formatDoubleToString(num: (view.annotation?.coordinate.longitude)!, noOfDecimal: 4)
        
        //  Set the selected annotation
        selectedAnnotation = view.annotation
        
        //  Set center of map to pin point
        let viewRegion = MKCoordinateRegionMakeWithDistance((view.annotation?.coordinate)!, 1000, 1000)
        UIView.animate(withDuration: 0.4, animations: {
            self.mapView.setRegion(viewRegion, animated: false)
        })
        
        //  Swipe the table result view accordingly
        if self.postingDict?[selectedCoordStr] != nil {
            print("jave")
            let selectPostList: [Posting] = (self.postingDict?[selectedCoordStr])!
            print(selectPostList)
            vc.postList = selectPostList
            vc.distance = (self.distDict?[selectedCoordStr])!
            
            if vc.postList.count < 4 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.vc.view.frame = CGRect(x: 0, y: self.view.frame.height - 250, width: self.view.frame.width, height: 250)
                    self.vc.swipeImageView.image = UIImage(named: "Down")
                })
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    self.vc.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: (self.view.frame.height) - (100))
                    self.vc.swipeImageView.image = UIImage(named: "Down")
                })
            }
            
        } else {
            print("no")
        }
        
        
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!), completionHandler: {
            placemarks, error in
            
            if error == nil && (placemarks?.count)! > 0 {
                let placeMark = placemarks?.last
                let addressStr = "\(placeMark!.subThoroughfare != nil ? placeMark!.subThoroughfare! : "") \(placeMark!.thoroughfare!), \(placeMark!.country!) \(placeMark!.postalCode!) "
                DispatchQueue.main.async {
                    self.vc.addressLabel.text = addressStr
                }
            }
        })
    }
    
    func showMapPin() {
        for (key, value) in postingDict! {
            print("\(key):\(value)")
            let coordArr = key.components(separatedBy: ",")
            
            let locCoord = CLLocationCoordinate2D(latitude: Double(coordArr[0])!, longitude: Double(coordArr[1])!)
            
            let coordPostList: [Posting] = postingDict![key]!
            
            let pLocValue: LocationValue = LocationValue.convertToLocationValue(locationDescription: coordPostList[0].preferredLocation)
            
            if pLocValue.descriptionName != "-" {
                 let dropPin = MapAnnotation(coordinate: locCoord, title: pLocValue.descriptionName, subtitle: String(coordPostList.count) + " Post")
                
                mapView.addAnnotation(dropPin)
            } else {
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: locCoord.latitude, longitude: locCoord.longitude), completionHandler: {
                    placemarks, error in
                    
                    if error == nil && (placemarks?.count)! > 0 {
                        let placeMark = placemarks?.last
                        let addressStr = "\(placeMark!.subThoroughfare != nil ? placeMark!.subThoroughfare! : "") \(placeMark!.thoroughfare!), \(placeMark!.country!) \(placeMark!.postalCode!) "
                        DispatchQueue.main.async {
                            self.vc.addressLabel.text = addressStr
                            
                            let dropPin = MapAnnotation(coordinate: locCoord, title: addressStr, subtitle: String(coordPostList.count) + " Post")
                            
                            self.mapView.addAnnotation(dropPin)
                        }
                    }
                })
            }
            
            
            
            
            
        }
    }
    
}
