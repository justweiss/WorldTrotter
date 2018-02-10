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
    var curLocation: CLLocationCoordinate2D? = nil
    let locationManger = CLLocationManager()
    var zoomedToUsersLocation: Bool = false
    var defaultRegion: MKCoordinateRegion?
    
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
        print("Mapview user location")
        //mapView.showAnnotations([userLocation], animated: true)
        //mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        if !zoomedToUsersLocation {
            zoomedToUsersLocation = true
            //mapView.showAnnotations([userLocation], animated: true)
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    @objc func showUserLocation (_ button: UIButton) {
        print("My Location clicked!")
        if self.mapView.showsUserLocation == true {
            zoomedToUsersLocation = false
            self.mapView.showsUserLocation = false
            let centerRegion: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 38.824378723542935, longitude: -95.785579999999968)
            let spanRegion: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 74.276568257016478, longitudeDelta: 55.355627271380087)
            //self.mapView.region.center = centerRegion
            //self.mapView.region.span = spanRegion
            self.mapView.setRegion(MKCoordinateRegion.init(center: centerRegion, span: spanRegion), animated: true)
            //let viewRegion = MKCoordinateRegionMakeWithDistance(200, 200, 200)
            //mapView.setRegion(viewRegion, animated: false)
        } else {
            print(self.mapView.region)
            self.mapView.showsUserLocation = true
        }
    }
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        defaultRegion = mapView.region
        
        print("\(self.mapView.region) First THEN SPAN: \(self.mapView.region.span)")
        
        //Set it as *the* view of this view controller
        view = mapView
        self.mapView.delegate = self
        
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
        
        let locationButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        
        locationManger.requestAlwaysAuthorization()
        
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false;
        locationButton.setTitle("My Location", for: .normal)
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.cornerRadius = cornerRadius
        view.addSubview(locationButton)
        
        let locationButtonTopConstraint = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        //let buttonLeadingConstraint1 = locationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        let locationButtonTrailingConstraint = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        locationButtonTopConstraint.isActive = true
        locationButtonTrailingConstraint.isActive = true
        
        locationButton.addTarget(self,
                                   action: #selector(MapViewController.showUserLocation(_:)),
                                   for: .touchUpInside)
        print("\(self.mapView.region) THEN SPAN: \(self.mapView.region.span)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
}
