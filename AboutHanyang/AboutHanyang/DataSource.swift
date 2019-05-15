//
//  DataSource.swift
//  AboutHanyang
//
//  Created by jjy on 2019. 5. 9..
//  Copyright © 2019년 AboutHanyang. All rights reserved.
//

import Foundation

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

class Place : Decodable
{
    
    let p_name : String
    let p_pos : String
    let p_phone : String
    let p_email : String?
    let p_description : String
    let p_review : Array<review>
    
    init(_ name : String, _ pos : String, _ phone : String, _ description : String)
    {
        self.p_name = name
        self.p_pos = pos
        self.p_phone = phone
        self.p_description = description
        self.p_email = nil
        self.p_review = []
    }
    
    
}

class Place_cafe : Place{
    
    let non_coffee : Array<menu>
    let coffee : Array<menu>
    let other_menu : Array<menu>
    
    init(_ name : String, _ pos : String, _ phone : String, _ description : String,
         _ non_coffee : Array<menu>, _ coffee : Array<menu>, _ other_menu : Array<menu>)
    {
        self.non_coffee = non_coffee
        self.coffee = coffee
        self.other_menu = other_menu
        super.init(name,pos,phone,description)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

class Place_withMenu : Place{
    let p_menu : Array<menu>
    
    init(_ name : String, _ pos : String, _ phone : String, _ description : String, _ menu : Array<menu>)
    {
        self.p_menu = menu
        super.init(name, pos, phone, description)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
/*
class Category : Decodable{
    
    let c_name : String
    let place_list : Array<Place>
    
    init(_ name : String, _ place_list : Array<Place>){
        self.c_name = name
        self.place_list = place_list
    }
    
}
*/
