//
//  ViewController.swift
//  Favourite places
//
//  Created by Jesper Poulsen on 21/02/16.
//  Copyright © 2016 krogpoulsen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!

    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if selectedLocation == -1 {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else {
            let lat = NSString(string:locations[selectedLocation]["lat"]!).doubleValue
            let long = NSString(string:locations[selectedLocation]["long"]!).doubleValue
            let coord = CLLocationCoordinate2DMake(lat, long)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(coord, span)

            self.map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = locations[selectedLocation]["name"]
            self.map.addAnnotation(annotation)
        }


        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        map.addGestureRecognizer(uilpgr)
    }


    func action(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.map)
            let newCoordinate:CLLocationCoordinate2D = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if error != nil {
                    print(error)
                }
                else {
                    if let p  = placemarks?[0] {
                        var title = ""
                        var subtitle = ""
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = newCoordinate
                        if p.thoroughfare != nil {
                            title = p.thoroughfare!
                        }
                        if p.subThoroughfare != nil {
                            subtitle = p.subThoroughfare!
                        }
                        if title == "" {
                            title = "Added \(NSDate())"
                        }
                        annotation.title = "\(self.title) \(subtitle)"
                        self.map.addAnnotation(annotation)
                        locations.append(["name":title, "lat":"\(newCoordinate.latitude)","long":"\(newCoordinate.longitude)"])
                        NSUserDefaults.standardUserDefaults().setObject(locations, forKey:"locations")
                    }
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

