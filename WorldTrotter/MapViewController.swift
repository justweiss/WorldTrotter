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
        if !zoomedToUsersLocation {
            zoomedToUsersLocation = true
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    @objc func showUserLocation (_ button: UIButton) {
        print("My Location clicked!")
        if self.mapView.showsUserLocation == true {
            zoomedToUsersLocation = false
            self.mapView.showsUserLocation = false
            //if centerRegion != nil, spanRegion != nil ??????
            self.mapView.setRegion(MKCoordinateRegion.init(center: centerRegion!, span: spanRegion!), animated: true)
        } else {
            centerRegion = self.mapView.region.center
            spanRegion = self.mapView.region.span
            self.mapView.showsUserLocation = true
        }
    }
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        defaultRegion = mapView.region
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
    }
}
