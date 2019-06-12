//
//  DataFunction.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 11/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import Foundation
import GoogleMaps

var markerColor:UIColor = .blue

func addMarker(_ position:CLLocationCoordinate2D, _ title:String) {
    let marker:GMSMarker = GMSMarker()
    marker.position = position
    marker.title = title
    marker.opacity = 0.8
    marker.icon = GMSMarker.markerImage(with: markerColor)
    marker.setImageSize(scaledToSize: CGSize(width: 19.5, height: 30.75)) // original size: (26.0, 41.0)
    buildingMarkers[title] = marker
}

func initMarkers() {
    // [1] 애지문 및 한양플라자
    markerColor = .blue
    addMarker(CLLocationCoordinate2D(latitude: 37.556053, longitude: 127.044810), "역사관")      // 101
    addMarker(CLLocationCoordinate2D(latitude: 37.556569, longitude: 127.044657), "본관")       // 102
    addMarker(CLLocationCoordinate2D(latitude: 37.556008, longitude: 127.043823), "애지문")      // 104
    addMarker(CLLocationCoordinate2D(latitude: 37.556565, longitude: 127.043904), "한양플라자")   // 105
    addMarker(CLLocationCoordinate2D(latitude: 37.557594, longitude: 127.044201), "학생회관")    // 107
    addMarker(CLLocationCoordinate2D(latitude: 37.555147, longitude: 127.044276), "국제관")      // 108
    addMarker(CLLocationCoordinate2D(latitude: 37.555028, longitude: 127.044679), "박물관")      // 109
    
    // [2] 공학관
    markerColor = .yellow
    
    
    // [3] IT/BT관
    markerColor = .red
    addMarker(CLLocationCoordinate2D(latitude: 37.555936, longitude: 127.049456), "IT/BT관")    // 305
    addMarker(CLLocationCoordinate2D(latitude: 37.556635, longitude: 127.049952), "올림픽체육관")  // 306
    
    // [4] 법학관 및 금융대학
    markerColor = .purple
    
    
    // [5] 중앙도서관 및 자연과학대학
    markerColor = .init(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
    addMarker(CLLocationCoordinate2D(latitude: 37.557439, longitude: 127.045674), "백남학술정보관")  // 501
    
    
    // [6] 의학관
    markerColor = .orange
    
    
    // [7] 행원파크 및 사이버대학교
    markerColor = .init(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    
    
    // [8] 기숙사
    markerColor = .green
    
    
}

func findPlace(place_name : String) -> Place? {
    var placeList : Array<Place> = []
    
    do {
        let url = Bundle.main.url(forResource: "db_Place", withExtension: "json")
        let jsonData = try Data(contentsOf: url!)
        placeList = try JSONDecoder().decode([Place].self, from: jsonData)
    }
    catch _ { print("json error: failed to load place info") }
    
    for p in placeList {
        if (p.p_name == place_name) {
            return p
        }
    }
    
    return nil
}

func findPlace(place_list : Array<String>) -> Array<Place> {
    var placeList : Array<Place> = []
    
    do {
        let url = Bundle.main.url(forResource: "db_Place", withExtension: "json")
        let jsonData = try Data(contentsOf: url!)
        placeList = try JSONDecoder().decode([Place].self, from: jsonData)
    }
    catch _ { print("json error: failed to load place info") }
    
    return placeList.filter{ place_list.contains($0.p_name) }
}

func findBuilding(building_name : String) -> Building? {
    var buildingList : Array<Building> = []
    
    do {
        let url = Bundle.main.url(forResource: "db_Building", withExtension: "json")
        let jsonData = try Data(contentsOf: url!)
        buildingList = try JSONDecoder().decode([Building].self, from: jsonData)
    }
    catch _ { print("json error: failed to load building info") }
    
    for b in buildingList {
        if (b.b_name == building_name) {
            return b
        }
    }
    return nil
}

func findBuilding(category:Category) -> Array<Building> {
    let placeList:Array<Place> = findPlace(place_list: category.c_place_list)
    var buildingList:Array<Building> = []
    var filteredBuilding:Array<Building> = []
    
    do {
        let url = Bundle.main.url(forResource: "db_Building", withExtension: "json")
        let jsonData = try Data(contentsOf: url!)
        buildingList = try JSONDecoder().decode([Building].self, from: jsonData)
    }
    catch _ { print("json error: failed to load building info") }
    
    for b in buildingList {
        for p in placeList {
            if b.b_name == p.p_building {
                filteredBuilding.append(b)
            }
            break
        }
    }
    
    return filteredBuilding
}

extension GMSMarker {
    func setImageSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
