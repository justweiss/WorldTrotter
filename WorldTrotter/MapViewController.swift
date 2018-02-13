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
    let locationManger = CLLocationManager()
    var zoomedToUsersLocation: Bool = false
    var defaultRegion: MKCoordinateRegion?
    var centerRegion: CLLocationCoordinate2D? = nil
    var spanRegion: MKCoordinateSpan? = nil
    
    //Struct to store pin locations
    struct location {
        var name: String
        var latitude: Double
        var longitude: Double
        var latitudeDelta: Double
        var longitudeDelta: Double
        
    }
    
    //Array of struct location for pins
    var pinLocation: [location] = []
    var pinCount: Int = 0
    var savedUsersLocationBeforePin: Bool = false
    
    //Function to create all the pin on the map during start up
    func createPins() {
        //Loop through pinlocation array
        for i in 0..<pinLocation.count {
            //Initializes
            let newPin = MKPointAnnotation()
            let location = CLLocationCoordinate2D.init(latitude: pinLocation[i].latitude, longitude: pinLocation[i].longitude)
            newPin.coordinate = location
            //Adds pins to map view
            mapView.addAnnotation(newPin)
        }
    }
    
    //Called when user location changed
    func mapView (_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Sets user tracking mode to follow only once
        if !zoomedToUsersLocation {
            zoomedToUsersLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
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
    
    //Function called when user clicks "My Location" button
    @objc func showUserLocation (_ button: UIButton) {
        NSLog("My Location clicked!")
        
        //Checks if the users location is showing
        if self.mapView.showsUserLocation == true {
            
            //If users location is showing it sets it back to false
            self.mapView.showsUserLocation = false
            zoomedToUsersLocation = false
        } else {
            //If Users location not showing then set it to true
            self.mapView.showsUserLocation = true
        }
    }
    
    //Function called when user clicks "Pin" button
    @objc func mapPins (_ button: UIButton) {
        NSLog("PIN button")
        
        //Saves the location on the map
        if !savedUsersLocationBeforePin {
            centerRegion = self.mapView.region.center
            spanRegion = self.mapView.region.span
            savedUsersLocationBeforePin = true
        }
        
        //Keeps track and checks what pin number its on
        if pinCount <= 3 {
            
            //Checks if user clicked button 4 times
            if pinCount == 3 {
                
                //Checks if user location is showing and if so then moves to current location
                if self.mapView.showsUserLocation == true {
                    NSLog("Showing users location")
                    mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
                } else {
                    //If not retures to previous location before clicking pin button
                    self.mapView.setRegion(MKCoordinateRegion.init(center: centerRegion!, span: spanRegion!), animated: true)
                    NSLog("NOT Showing users location")
                }
                
                //Sets count and saved location back to defaults
                NSLog("%i, count at ==3", pinCount)
                pinCount = 0
                savedUsersLocationBeforePin = false
            } else {
                
                //Moves to the next pin and updates pinCount
                self.mapView.setRegion(MKCoordinateRegion.init(
                    center: CLLocationCoordinate2D.init(latitude: pinLocation[pinCount].latitude, longitude: pinLocation[pinCount].longitude),
                    span: MKCoordinateSpan.init(latitudeDelta: pinLocation[pinCount].latitudeDelta, longitudeDelta: pinLocation[pinCount].longitudeDelta)),
                    animated: true)
                NSLog("Location number: %i", pinCount)
                pinCount += 1
            }
        }
    }
    
    func mapTypeButtons () {
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
    }
    
    //Function that creates "My Location" button
    func createButtonMyLocation() {
        let locationButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        
        //Sets properties and appearance
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false;
        locationButton.setTitle(" My Location ", for: .normal)
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.cornerRadius = cornerRadius
        view.addSubview(locationButton)
        
        //Sets contraints
        let locationButtonTopConstraint = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        let locationButtonTrailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        
        //Activates contraints
        locationButtonTopConstraint.isActive = true
        locationButtonTrailingConstraint.isActive = true
        
        //Calls the showUserLocation function if user clicks on button
        locationButton.addTarget(self,
                                 action: #selector(MapViewController.showUserLocation(_:)),
                                 for: .touchUpInside)
    }
    
    //Function that creates "Pin" button
    func createPinButton() {
        let pinButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        
        //Sets properties and appearance
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.translatesAutoresizingMaskIntoConstraints = false;
        pinButton.setTitle(" Pin ", for: .normal)
        pinButton.setTitleColor(UIColor.blue, for: .normal)
        pinButton.layer.borderColor = UIColor.blue.cgColor
        pinButton.layer.cornerRadius = cornerRadius
        view.addSubview(pinButton)
        
        //Sets contraints
        let locationTopConstraint = pinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        let buttonLeadingConstraint = pinButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
        
        //Activates contraints
        locationTopConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        
        //Calls mapPins function if user clicks on button
        pinButton.addTarget(self, action: #selector(MapViewController.mapPins(_:)), for: .touchUpInside)
    }
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        defaultRegion = mapView.region
        
        //Set it as *the* view of this view controller
        view = mapView
        self.mapView.delegate = self
        
        //Asks user to user their location
        locationManger.requestAlwaysAuthorization()
        
        //Sets and adds pin locations to array pinLocation
        pinLocation.append(MapViewController.location(name: "New York", latitude: 40.712775000022305, longitude: -74.005972999999955, latitudeDelta: 0.021697083288067631, longitudeDelta: 0.016050341136121915))
        pinLocation.append(MapViewController.location(name: "Current Location", latitude: 35.972384000023808, longitude: -79.99530799999998, latitudeDelta: 0.023165845127650186, longitudeDelta: 0.016050341136136126))
        pinLocation.append(MapViewController.location(name: "St. Thomas", latitude: 18.331090300027924, longitude: -64.918728399999978, latitudeDelta: 0.027171985141809074, longitudeDelta: 0.016050341136121915))
        
        //Creates pins on mapView
        createPins()
        
        //Creates map type buttons on the top of mapView
        mapTypeButtons()
        
        //Creates "My Location" button
        createButtonMyLocation()
        
        //Creats "Pin" button
        createPinButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
}
