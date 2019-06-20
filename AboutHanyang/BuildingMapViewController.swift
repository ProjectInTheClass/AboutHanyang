//
//  BuildingMapViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 05/04/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class BuildingMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var tappedMarker:GMSMarker?
    var originCamera:GMSCameraPosition?
    var mapView:GMSMapView?
    // var customInfoWindow: CustomInfoWindow?
    
    var locationManager:CLLocationManager!
    var locations:[CLLocation] = []
    var currentPos:CLLocationCoordinate2D?
    var currentZoom:Float = 17.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.tappedMarker = GMSMarker()
        // self.customInfoWindow = CustomInfoWindow().loadView()
        
        originCamera = GMSCameraPosition.camera(
            withLatitude: 37.55636158, longitude: 127.04535227, zoom: currentZoom)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: originCamera!)
        mapView!.delegate = self
        self.view = mapView
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        initMarkers()
        for b in buildingMarkers {
            b.value.map = mapView
        }
    }
    
    // You don't need to modify the default init(nibName:bundle:) method.
    override func loadView() {
        
    }
    
    @IBAction func tapRestore(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        locationManager(locationManager, didUpdateLocations: locations)
        locationManager.stopUpdatingLocation() // 위치 업데이트 종료
        
        // 현재 학교 영역 밖에 있을 경우 애지문 근처를 중심으로 지도 표시
        if !isCurrentPosInSchool() {
            mapView!.camera = originCamera!
        }
        else {
            mapView!.camera = GMSCameraPosition(
                latitude: currentPos!.latitude, longitude: currentPos!.longitude, zoom: currentZoom)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentPos = manager.location?.coordinate
        print(currentPos)
    }
    
    func isCurrentPosInSchool() -> Bool {
        if let long:Double = currentPos?.longitude, let lat:Double = currentPos!.latitude{
            if long < 37.55451165 || long > 37.56000071 { return false }
            if lat < 127.04073015 || lat > 127.05096311 { return false }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let title = self.tappedMarker!.title else { return }
        let destVC = segue.destination as! SelectedTableViewController
        if let selectedBuilding:Building = findBuilding(building_name: title) {
            destVC.placeList = selectedBuilding.b_place_list
        }
        destVC.selectedBuilding = title
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
