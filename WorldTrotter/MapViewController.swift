//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Justin Weiss on 2/4/18.
//  Copyright © 2018 Justin Weiss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
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
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as *the* view of this view controller
        view = mapView
        
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
    
    func createLocationButton () {
        
        let locationButton = UIButton()
        let cornerRadius : CGFloat = 5.0
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false;
        locationButton.setTitle("My Location", for: .normal)
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        locationButton.layer.borderColor = UIColor.blue.cgColor
        locationButton.layer.cornerRadius = cornerRadius
        view.addSubview(locationButton)
        
        let buttonTopConstraint1 = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                 constant: -8)
        let margins = view.layoutMarginsGuide
        //let buttonLeadingConstraint1 = locationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let buttonTrailingConstraint1 = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        buttonTopConstraint1.isActive = true
        buttonTrailingConstraint1.isActive = true
        
        
        let button = UIButton();
        button.setTitle("Location", for: .normal)
        button.frame = CGRect(x: 0, y:0, width: 120, height: 60)
        button.translatesAutoresizingMaskIntoConstraints = false;
        let buttonTopConstraint = button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                  constant: -8)
        //let margins = view.layoutMarginsGuide
        let buttonLeadingConstraint = button.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        button.setTitleColor(UIColor.blue, for: .normal)
        //button.frame = CGSize(width: 100, height: 100)
        //button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        //button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        //button.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        //button.addTarget(self, action: "buttonPressed:", for: .touchUpInside)
        self.view.addSubview(button)
        buttonTopConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        buttonTrailingConstraint.isActive = true
    }
    /*
    func createLocationButton () {
        let button = UIButton();
        button.setTitle("Location", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGSize(width: 100, height: 100)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        //button.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        //button.addTarget(self, action: "buttonPressed:", for: .touchUpInside)
        self.view.addSubview(button)
    }
    /*
    func buttonPressed(sender: UIButton!) {
        let alertView = UIAlertView();
        alertView.addButton(withTitle: "OK");
        alertView.title = "Alert";
        alertView.message = "Button Pressed!!!";
        alertView.show();
    }
    */
    /*
    func createLocationButton() {
        let button = UIButton()
        button.frame = CGRect(x: (view.bounds.width/2), y:(view.bounds.height/2), width: 120, height: 60)
        button.center = self.view.center
        button.setTitle("Location", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 5
        
        self.view.addSubview(button)
        
    }
    */*/
    override func viewDidLoad() {
        super.viewDidLoad()
        createLocationButton()
        
        print("MapViewController loaded its view.")
    }
}
