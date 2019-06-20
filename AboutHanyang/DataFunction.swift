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

func addMarker(_ lat:CLLocationDegrees, _ long:CLLocationDegrees, _ title:String) {
    let marker:GMSMarker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
    marker.title = title
    marker.opacity = 0.8
    marker.icon = GMSMarker.markerImage(with: markerColor)
    marker.setImageSize(scaledToSize: CGSize(width: 14.625, height: 23.0625)) // original size: (26.0, 41.0)
    buildingMarkers[title] = marker
}

func initMarkers() {
    // [1] 애지문 및 한양플라자
    markerColor = .blue
    addMarker(37.556053, 127.044810, "역사관")              // 101
    addMarker(37.556706, 127.044445, "본관")               // 102
    addMarker(37.556034, 127.043903, "애지문")              // 104
    addMarker(37.556565, 127.043904, "한양플라자")           // 105
    addMarker(37.556910, 127.043909, "우체국")              // 106
    addMarker(37.557594, 127.044201, "학생회관")            // 107
    addMarker(37.555147, 127.044276, "국제관")              // 108
    addMarker(37.555289, 127.044740, "박물관")              // 109
    
    // [2] 공학관
    markerColor = .yellow
    addMarker(37.554524, 127.044142, "재성토목관")            // 201
    addMarker(37.554077, 127.044375, "건축관")               // 202
    addMarker(37.554320, 127.044716, "과학기술관")            // 203
    addMarker(37.554528, 127.045185, "신소재공학관")           // 204
    addMarker(37.554928, 127.046140, "공업센터 본관")          // 206
    addMarker(37.554732, 127.046537, "공업센터 별관")          // 207
    addMarker(37.554634, 127.047152, "퓨전테크센터")           // 208
    addMarker(37.555517, 127.045250, "노천극장")              // 209
    addMarker(37.555396, 127.044885, "정몽구 미래자동차연구센터")  // 210
    addMarker(37.555655, 127.046237, "제2공학관")             // 211
    addMarker(37.556650, 127.045534, "제1공학관")             // 212
    
    // [3] IT/BT관
    markerColor = .red
    addMarker(37.555549, 127.049246, "산학기술관")    // 304
    addMarker(37.555936, 127.049456, "IT/BT관")    // 305
    addMarker(37.556635, 127.049952, "올림픽체육관")  // 306
    
    // [4] 법학관 및 금융대학
    markerColor = .purple
    addMarker(37.556723, 127.046728, "생활과학대학")  // 401
    //addMarker(37.556618, 127.047430, "제1음악관")    // 402
    //addMarker(37.556782, 127.047200, "제2음악관")    // 403
    //addMarker(37.556344, 127.047066, "백남음악관")    // 405
    addMarker(37.556635, 127.047838, "제1법학관")    // 407
    addMarker(37.556325, 127.047838, "제2법학관")    // 408
    addMarker(37.556314, 127.048436, "제3법학관")    // 409
    addMarker(37.556635, 127.048495, "경제금융대학")  // 410
    
    // [5] 중앙도서관 및 자연과학대학
    markerColor = .init(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
    addMarker(37.557441, 127.045671, "백남학술정보관")      // 501
    addMarker(37.556582, 127.045924, "사자가 군것질 할 때")  // 503
    addMarker(37.557393, 127.044588, "사회과학관")         // 504
    addMarker(37.558213, 127.045077, "사범대학 본관")      // 505
    addMarker(37.558403, 127.044688, "사범대학 별관")      // 506
    addMarker(37.558849, 127.044167, "자연과학대학")       // 507
    addMarker(37.558432, 127.043435, "인문관")           // 508
    
    // [6] 의학관
    markerColor = .orange
    addMarker(37.558205, 127.042436, "제1의학관")     // 604
    addMarker(37.559027, 127.042114, "제2의학관")     // 605
    addMarker(37.558991, 127.042707, "의과대학 본관")  // 606
    addMarker(37.559557, 127.041583, "동문회관")      // 607
    addMarker(37.559746, 127.043354, "병원서관")      // 609
    addMarker(37.559725, 127.044107, "병원본관")      // 610
    addMarker(37.559903, 127.044874, "병원동관")      // 614
    
    
    // [7] 행원파크 및 사이버대학교
    markerColor = .init(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    addMarker(37.558585, 127.045718, "한양종합기술연구원")    // 701
    addMarker(37.557569, 127.047083, "한양사이버대학교 1관")  // 702
    addMarker(37.558222, 127.048319, "경영관")            // 706
    addMarker(37.557611, 127.048652, "행원파크")           // 707
    
    // [8] 기숙사
    markerColor = .green
    addMarker(37.559161, 127.046896, "제1생활관")   // 801
    addMarker(37.559699, 127.046765, "제3생활관")   // 802
    addMarker(37.559712, 127.046059, "제5생활관")   // 803
    addMarker(37.559758, 127.049822, "제2생활관")   // 804
    
    // 기타
    // markerColor = .black
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
                break
            }
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
