//
//  DataSource.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import Foundation
import GoogleMaps

var buildingMarkers:Dictionary<String, GMSMarker> = [:]
var placeMarkers:Dictionary<String, GMSMarker> = [:]

func addBuildingMarker(_ position:CLLocationCoordinate2D, _ title:String) {
    let marker:GMSMarker = GMSMarker()
    marker.position = position
    marker.title = title
    marker.opacity = 0.0
    buildingMarkers[title] = marker
}

func addPlaceMarker(_ position:CLLocationCoordinate2D, _ title:String, _ snippet:String?, _ color: UIColor?) {
    let marker:GMSMarker = GMSMarker()
    marker.position = position
    marker.title = title
    marker.snippet = snippet
    marker.icon = GMSMarker.markerImage(with: color)
    marker.opacity = 0.6
    placeMarkers[title] = marker
}

func initBuildingMarkers() {
    addBuildingMarker(CLLocationCoordinate2D(latitude: 37.55575345, longitude: 127.04946946), "정보통신관")
    addBuildingMarker(CLLocationCoordinate2D(latitude: 37.55639986, longitude: 127.04996567), "올림픽체육관")
}

func initPlaceMarkers() {
    addPlaceMarker(CLLocationCoordinate2D(latitude: 37.55575345, longitude: 127.04946946), "큐카페", "정보통신관 3F", .green)
    addPlaceMarker(CLLocationCoordinate2D(latitude: 37.55639986, longitude: 127.04996567), "매점", "올림픽체육관 3F", .blue)
}


//카테고리 타이틀, 아이콘 이미지
let category_titles : Array<String> = ["카페", "식당", "도서관", "인쇄실", "PC실", "샤워실", "자판기"]
let category_images : Array<String> = ["cafe.png", "restaurant.png", "library.png", "printer.png", "laptop.png", "shower.png", "beverage.png"]

func findPlace(place_name : String) -> Place {
    var placeList : Array<Place> = []
    
    do {
        let url = Bundle.main.url(forResource:"db_Place", withExtension:"json")
        let jsonData = try Data(contentsOf: url!)
        placeList = try JSONDecoder().decode([Place].self, from: jsonData)
    }
        
    catch _ { print("some error") }
    
    let matchList = placeList.filter{$0.p_name == place_name}
    return matchList[0]
}

func findPlace(place_list : Array<String>) -> Array<Place> {
    var placeList : Array<Place> = []
    
    do {
        let url = Bundle.main.url(forResource:"db_Place", withExtension:"json")
        let jsonData = try Data(contentsOf: url!)
        placeList = try JSONDecoder().decode([Place].self, from: jsonData)
        
    }
        
    catch _ { print("some error") }
    
    let resultPlace = placeList.filter{place_list.contains($0.p_name)}
    return resultPlace
}

class Category : Decodable{
    
    let c_name : String
    let place_list : Array<String>
    let category_icon : String
    /*
     init(_ name : String, _ place_list : Array<String>, _ category_icon : String){
     self.c_name = name
     self.place_list = place_list
     self.category_icon = category_icon
     }
     */
}

typealias menu = [String:Int]

class review : Decodable {
    
    var comment : String
    var tendency : String
    var score : String
    
    init(_ comment : String, _ tedency : String, _ score : String){
        self.comment = comment
        self.tendency = tedency
        self.score = score
    }
    
}

class Building : Decodable{
    let b_name : String
    let b_number : Int
    let b_description : String
    let place_list : Array<Place>
    let b_outsidePicture : String
    let b_majorInBuilding : Array<String>
    
}

class Place : Decodable
{
    
    let p_name : String
    let p_pos : String
    let p_phone : String
    let p_email : String
    let p_description : String
//  let p_review : Array<review>
    
//  init(_ name : String, _ pos : String, _ phone : String, _ description : String)
//   {
//       self.p_name = name
//       self.p_pos = pos
//      self.p_phone = phone
//      self.p_description = description
//      self.p_email = ""
//        self.p_review = []
//  }
}
