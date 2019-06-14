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
