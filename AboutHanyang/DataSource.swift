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
var recentQueue : Array<Place> = []
var queueSize : Int = 12

typealias menu = [String:Int]

class Category : Decodable {
    
    let c_name : String
    let c_place_list : Array<String>
    let c_icon : String
    
    /*
     init(_ name : String, _ place_list : Array<String>, _ icon : String){
     self.c_name = name
     self.c_place_list = place_list
     self.c_icon = icon
     }
     */
    
}

class review : Decodable {
    
    var comment : String
    var tendency : String
    var score : String
    
    init(_ comment : String, _ tedency : String, _ score : String) {
        self.comment = comment
        self.tendency = tedency
        self.score = score
    }
    
}

class Building : Decodable {
    
    let b_name : String
    let b_number : Int
    let b_description : String
    let b_place_list : Array<String>
    let b_outsidePicture : String
    let b_majorInBuilding : Array<String>
    
}

class Place : Decodable & Encodable {
    
    let p_name : String
    let p_building : String
    let p_pos : String
    let p_phone : String
    let p_email : String
    let p_description : String
//  let p_review : Array<review>
    
    init(_ name : String, _ building : String, _ pos : String, _ phone : String, _ email : String, _ description : String, _ image : String) {
        self.p_name = name
        self.p_building = building
        self.p_pos = pos
        self.p_phone = phone
        self.p_description = description
        self.p_email = email
        //self.p_review = []
    }
    
}

struct TagUnit : Decodable{
    var tagName:String
    var priceUnits : [[String]]
    
}
struct MenuData:Decodable{
    
    var placeName : String
    var menu : Array<TagUnit>
    
}
