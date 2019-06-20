//
//  CategoryMapViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class CategoryMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var selectedCategory:Category?
    var placeList:Array<Place> = []
    var buildingList:Array<Building> = []
    var filteredPlaceList:Array<String> = []
    
    var tappedMarker:GMSMarker?
    var originCamera:GMSCameraPosition?
    var mapView:GMSMapView?
    
    var locationManager:CLLocationManager!
    var locations:[CLLocation] = []
    var currentPos:CLLocationCoordinate2D?
    var currentZoom:Float = 17.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedCategory!.c_name
        placeList = findPlace(place_list: selectedCategory!.c_place_list)
        
        originCamera = GMSCameraPosition.camera(withLatitude: 37.55636158, longitude: 127.04535227, zoom: currentZoom)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: originCamera!)
        mapView!.delegate = self
        self.view = mapView

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        initMarkers()
        buildingList = findBuilding(category: selectedCategory!)
        for b in buildingList {
            buildingMarkers[b.b_name]?.map = mapView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
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
        let long:Double = currentPos!.longitude
        let lat:Double = currentPos!.latitude
        
        if long < 37.55451165 || long > 37.56000071 { return false }
        if lat < 127.04073015 || lat > 127.05096311 { return false }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tapMarkerToList" {
            let destVC = segue.destination as! SelectedTableViewController
            destVC.selectedCategory = self.selectedCategory!.c_name
            destVC.selectedBuilding = tappedMarker!.title!
            destVC.placeList = filteredPlaceList
        }
    
        else if segue.identifier == "tapMarkerToDetail" {
            let destVC = segue.destination as! PlaceDetailViewController
            destVC.selectedBuilding = tappedMarker!.title!
            destVC.selectedPlace = filteredPlaceList[0]
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.tappedMarker = marker
        
        filteredPlaceList = []
        for p in placeList {
            if p.p_building == tappedMarker!.title {
                filteredPlaceList.append(p.p_name)
            }
        }
        
        // 표시할 장소가 하나뿐이면 곧바로 장소 상세 정보 화면 진입
        if filteredPlaceList.count == 1 {
            performSegue(withIdentifier: "tapMarkerToDetail", sender: nil)
        }
        else {
            performSegue(withIdentifier: "tapMarkerToList", sender: nil)
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped Pos: (\(coordinate.latitude), \(coordinate.longitude))")
    }
    
}
