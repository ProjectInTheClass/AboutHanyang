//
//  PlaceMapViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMapViewController: UIViewController, GMSMapViewDelegate {
    
    var selectedCategory:String = ""
    var tappedMarker:GMSMarker?
    var originCamera:GMSCameraPosition?
    var mapView:GMSMapView?
    
    // Restore camera position into origin
    @IBAction func tapRestore(_ sender: UIButton) {
        mapView!.camera = originCamera!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedCategory
        
        originCamera = settings.restorePointInMap
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: originCamera!)
        mapView!.delegate = self
        self.view = mapView
        
        initPlaceMarkers()
        for p in placeMarkers {
            // give some conditions to draw markers only we want
            // ex) if (p.value.type == "cafe")
            // but note that we have to decide where to check a type of the place
            p.value.map = mapView
        }
    }
    
    override func loadView() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! PlaceDetailViewController
        destVC.selectedPlace = self.tappedMarker!.title!
    }
    
    // detail view for places by tapping InfoWindow
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.tappedMarker = marker
        performSegue(withIdentifier: "tapInfoWindow", sender: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped Pos: (\(coordinate.latitude), \(coordinate.longitude))")
    }
    
}
