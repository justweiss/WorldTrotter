//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Justin Weiss on 2/4/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    //var curLocation: CLLocationCoordinate2D? = nil
    let locationManger = CLLocationManager()
    var zoomedToUsersLocation: Bool = false
    var defaultRegion: MKCoordinateRegion?
    var centerRegion: CLLocationCoordinate2D? = nil
    var spanRegion: MKCoordinateSpan? = nil
    
    struct location {
        var name: String
        var latitude: Double
        var longitude: Double
        var latitudeDelta: Double
        var longitudeDelta: Double
        var pinCreated: Bool
        
    }
    
    var pinLocation: [location] = []
    var pinCount: Int = 0
    var savedUsersLocationBeforePin: Bool = false
    
    //Allows user to change the map type
    @objc func mapTypeChanged (_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func mapView (_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //print("Mapview user location")
        if !zoomedToUsersLocation {
            zoomedToUsersLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    @objc func showUserLocation (_ button: UIButton) {
        print("My Location clicked!")
        if self.mapView.showsUserLocation == true {
            self.mapView.showsUserLocation = false
            zoomedToUsersLocation = false
            //if centerRegion != nil, spanRegion != nil ??????
            //self.mapView.setRegion(MKCoordinateRegion.init(center: centerRegion!, span: spanRegion!), animated: true)
        } else {
            centerRegion = self.mapView.region.center
            spanRegion = self.mapView.region.span
            self.mapView.showsUserLocation = true
        }
    }
    
    @objc func mapPins (_ button: UIButton) {
        NSLog("PIN button")
        print(self.mapView.region)
        if !savedUsersLocationBeforePin {
            centerRegion = self.mapView.region.center
            spanRegion = self.mapView.region.span
            savedUsersLocationBeforePin = true
        }
        if pinCount <= 3 {
            if pinCount == 3 {
                if self.mapView.showsUserLocation == true {
                    NSLog("Showing users location")
                    mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
                } else {
                    self.mapView.setRegion(MKCoordinateRegion.init(center: centerRegion!, span: spanRegion!), animated: true)
                    NSLog("NOT Showing users location")
                }
                NSLog("\(pinCount), count at ==3")
                pinCount = 0
                savedUsersLocationBeforePin = false
            } else {
                self.mapView.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: pinLocation[pinCount].latitude, longitude: pinLocation[pinCount].longitude), span: MKCoordinateSpan.init(latitudeDelta: pinLocation[pinCount].latitudeDelta, longitudeDelta: pinLocation[pinCount].longitudeDelta)), animated: true)
                NSLog("Location number: \(pinCount)")
                pinCount += 1
            }
        }
        //let newPin = MKPointAnnotation()
        /*
        self.mapView.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: pinLocation[2].latitude, longitude: pinLocation[2].longitude), span: MKCoordinateSpan.init(latitudeDelta: pinLocation[2].latitudeDelta, longitudeDelta: pinLocation[2].longitudeDelta)), animated: true)
        let location = CLLocationCoordinate2D.init(latitude: pinLocation[2].latitude, longitude: pinLocation[2].longitude)
        newPin.coordinate = location
        mapView.addAnnotation(newPin)
 */
    }
    func createPins() {
        print(pinLocation[1].latitude)
        for i in 0..<pinLocation.count {
            let newPin = MKPointAnnotation()
            let location = CLLocationCoordinate2D.init(latitude: pinLocation[i].latitude, longitude: pinLocation[i].longitude)
            newPin.coordinate = location
            mapView.addAnnotation(newPin)
        }
    }
    
    func createButtonMyLocation() {
        let locationButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false;
        locationButton.setTitle(" My Location ", for: .normal)
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.cornerRadius = cornerRadius
        view.addSubview(locationButton)
        
        let locationButtonTopConstraint = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        let locationButtonTrailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        
        locationButtonTopConstraint.isActive = true
        locationButtonTrailingConstraint.isActive = true
        
        locationButton.addTarget(self,
                                 action: #selector(MapViewController.showUserLocation(_:)),
                                 for: .touchUpInside)
    }
    func createPinButton() {
        let pinButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.translatesAutoresizingMaskIntoConstraints = false;
        pinButton.setTitle(" Pin ", for: .normal)
        pinButton.setTitleColor(UIColor.blue, for: .normal)
        pinButton.layer.borderColor = UIColor.blue.cgColor
        pinButton.layer.cornerRadius = cornerRadius
        view.addSubview(pinButton)
        
        let locationTopConstraint = pinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        let buttonLeadingConstraint = pinButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        //let locationButtonTrailingConstraint = pinButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        
        locationTopConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        
        pinButton.addTarget(self, action: #selector(MapViewController.mapPins(_:)), for: .touchUpInside)
    }
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        defaultRegion = mapView.region
        
        //Set it as *the* view of this view controller
        view = mapView
        self.mapView.delegate = self
        
        pinLocation.append(MapViewController.location(name: "New York", latitude: 40.712775000022305, longitude: -74.005972999999955, latitudeDelta: 0.021697083288067631, longitudeDelta: 0.016050341136121915, pinCreated: false))
        pinLocation.append(MapViewController.location(name: "Current Location", latitude: 35.972384000023808, longitude: -79.99530799999998, latitudeDelta: 0.023165845127650186, longitudeDelta: 0.016050341136136126, pinCreated: false))
        pinLocation.append(MapViewController.location(name: "St. Thomas", latitude: 18.331090300027924, longitude: -64.918728399999978, latitudeDelta: 0.027171985141809074, longitudeDelta: 0.016050341136121915, pinCreated: false))
        
        createPins()
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        //Allow user to change the map type
        segmentedControl.addTarget(self,
            action: #selector(MapViewController.mapTypeChanged(_:)),
            for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //NSLayoutAnchors have a method that will create a constraint between two
        //anchors, in this case between segmentedControl and the superview
        //these are NSLayoutConstraints – top, leading, and trailing
        //Set up top margin/layout guides
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 8)
        
        //Set up side margins/layout guides
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //Activates margins
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        locationManger.requestAlwaysAuthorization()
        
        createButtonMyLocation()
        createPinButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
}
