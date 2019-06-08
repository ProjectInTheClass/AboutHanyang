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
    addPlaceMarker(CLLocationCoordinate2D(latitude: 37.55575345, longitude: 127.04946946), "Cafe Queue", "정보통신관 3F", .green)
    addPlaceMarker(CLLocationCoordinate2D(latitude: 37.55639986, longitude: 127.04996567), "올림픽체육관 매점", "올림픽체육관 3F", .blue)
}

func findPlace(place_name : String) -> Place? {
    var placeList : Array<Place> = []
    
    do {
        let url = Bundle.main.url(forResource:"db_Place", withExtension:"json")
        let jsonData = try Data(contentsOf: url!)
        placeList = try JSONDecoder().decode([Place].self, from: jsonData)
    }
        
    catch _ { print("some error") }
    
    for i in placeList{
        if (i.p_name == place_name){
            return i
        }
    }
    
    return nil
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
func findBuilding(building_name : String) -> Building? {
    var buildingList : Array<Building> = []
    
    do {
        let url = Bundle.main.url(forResource:"db_Building", withExtension:"json")
        let jsonData = try Data(contentsOf: url!)
        buildingList = try JSONDecoder().decode([Building].self, from: jsonData)
    }
        
    catch _ { print("some error") }
    
    for i in buildingList{
        if (i.b_name == building_name){
            return i
        }
    }
    return nil
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
    let place_list : Array<String>
    let b_outsidePicture : String
    let b_majorInBuilding : Array<String>
    
}

class Place : Decodable & Encodable
{
    
    let p_name : String
    let p_pos : String
    let p_phone : String
    let p_email : String
    let p_description : String
//  let p_review : Array<review>
    
    init(_ name : String, _ pos : String, _ phone : String, _ email : String, _ description : String)
     {
         self.p_name = name
         self.p_pos = pos
         self.p_phone = phone
         self.p_description = description
         self.p_email = email
         //self.p_review = []
    }
}

/// 크기에 제약이 없는 FIFO 큐
/// 복잡도: push O(1), pop O(`count`)
public struct Queue<T>: ExpressibleByArrayLiteral {
    /// 내부 배열 저장소
    public private(set) var elements: Array<T> = []
    
    /// 새로운 엘리먼트 추가. 소요 시간 = O(1)
    public mutating func push(value: T) { elements.append(value) }
    
    /// 가장 앞에 있는 엘리먼트를 꺼내오기. 소요시간 = O(`count`)
    public mutating func pop() -> T { return elements.removeFirst() }
    
    /// 큐가 비었는지 검사
    public var isEmpty: Bool { return elements.isEmpty }
    
    /// 큐의 크기, 연산 프로퍼티
    public var count: Int { return elements.count }
    
    /// ArrayLiteralConvertible 지원
    public init(arrayLiteral elements: T...) { self.elements = elements }
}

var recentQueue : Array<Place> = []
var queueSize : Int = 12
