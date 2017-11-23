//
//  ShowLocationViewController.swift
//  uptous
//
//  Created by Roshan on 10/7/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowLocationViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var locationView: UIView!
    
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    var calendarEvent: Event?
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: 28.52, longitude: 77.39, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: locationView.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        //view = mapView
        self.locationView.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.52, longitude: 77.39)
        marker.title = "Noida"
        marker.snippet = "India"
        marker.map = mapView
        mapView.selectedMarker = marker
        
        // Add a Custom marker
//        let markerSquirt = GMSMarker()
//        markerSquirt.position = CLLocationCoordinate2D(latitude: -33.88, longitude: 151.20)
//        markerSquirt.title = "Squirtle"
//        markerSquirt.snippet = "Squirtle lives here"
//        markerSquirt.appearAnimation = .pop
//        markerSquirt.map = mapView
        //mapView.selectedMarker = markerSquirt
        
        //markerSquirt.icon = UIImage(named: "007 Squirtle")
        
        
        // User Location
        //        locationManager.delegate = self
        //        locationManager.requestWhenInUseAuthorization()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.startUpdatingLocation()
        
        
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        locationManager.stopUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
