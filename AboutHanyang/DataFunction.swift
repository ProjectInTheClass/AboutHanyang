//
//  DataFunction.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 11/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import Foundation
import GoogleMaps

func addMarker(_ position:CLLocationCoordinate2D, _ title:String) {
    let marker:GMSMarker = GMSMarker()
    marker.position = position
    marker.title = title
    marker.opacity = 0.8
    marker.icon = GMSMarker.markerImage(with: .green)
    buildingMarkers[title] = marker
}

func initMarkers() {
    addMarker(CLLocationCoordinate2D(latitude: 37.55575345, longitude: 127.04946946), "IT/BT관")
    addMarker(CLLocationCoordinate2D(latitude: 37.55639986, longitude: 127.04996567), "올림픽체육관")
    addMarker(CLLocationCoordinate2D(latitude: 37.55661249, longitude: 127.04390924), "한양플라자")
    addMarker(CLLocationCoordinate2D(latitude: 37.55750448, longitude: 127.04566843), "백남학술정보관")
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
