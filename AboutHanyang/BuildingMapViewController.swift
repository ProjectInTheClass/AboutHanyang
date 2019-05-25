//
//  BuildingMapViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 05/04/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import GoogleMaps

class BuildingMapViewController: UIViewController, GMSMapViewDelegate {
    
    var tappedMarker:GMSMarker?
    var originCamera:GMSCameraPosition?
    var mapView:GMSMapView?
    // var customInfoWindow: CustomInfoWindow?
    
    // Restore camera position into origin
    @IBAction func tapRestore(_ sender: UIButton) {
        mapView!.camera = originCamera!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tappedMarker = GMSMarker()
        // self.customInfoWindow = CustomInfoWindow().loadView()
        
        originCamera = settings.restorePointInMap
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: originCamera!)
        mapView!.delegate = self
        self.view = mapView
        
        initBuildingMarkers()
        for m in buildingMarkers {
            m.value.map = mapView
        }
        
        // marker.icon = GMSMarker.markerImage(with: .green) // set color for marker
        // marker.icon = UIImage(named: "name")
    }
    
    // You don't need to modify the default init(nibName:bundle:) method.
    override func loadView() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! BuildingDetailViewController
        destVC.selectedBuilding = self.tappedMarker!.title!
    }
    
    // detail view for places by tapping marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.tappedMarker = marker
        performSegue(withIdentifier: "tapMarker", sender: nil)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped Pos: (\(coordinate.latitude), \(coordinate.longitude))")
        // customInfoWindow?.removeFromSuperview()
    }
    
    /*
    // detail view for places by tapping InfoWindow
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "tapInfoWindow", sender: nil)
    }
    */
    
    /*
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tappedMarker = marker
        
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        customInfoWindow?.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 130
        mapView.addSubview(customInfoWindow!)
        
        return false
    }
     */
    
    /*
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
     */
    
    /*
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 130
    }
     */
    
}
