//
//  PlaceDetailViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var menuButton : UIButton!
    
    var selectedPlace:String = ""
    var selectedBuilding:String = ""
    
    
    var jsonSetter_place_queue: JSON = JSON([
        "p_name": "default name",
        "p_pos": "default simple pos exp",
        "p_phone": "010-1234-4321",
        "p_email": "default email",
        "p_description": "some exp for place"
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedPlace
        if let placeShowed = findPlace(place_name: selectedPlace){
            jsonSetter_place_queue["p_name"].string = placeShowed.p_name
            jsonSetter_place_queue["p_pos"].string = placeShowed.p_pos
            jsonSetter_place_queue["p_phone"].string = placeShowed.p_phone
            jsonSetter_place_queue["p_email"].string = placeShowed.p_email
            jsonSetter_place_queue["p_description"].string = placeShowed.p_description
        }
        //print(placeShowed.p_pos)
        print(selectedPlace)
        menuButton.isHidden = false
        do{
            let url = Bundle.main.url(forResource:"db_Menu", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            let data = try JSONDecoder().decode([MenuData].self, from: jsonData)
            
            for item in data{
                if(item.placeName == selectedPlace){
                    return
                }
            }
            menuButton.isHidden = true
        }
            
        catch _ { menuButton.isHidden = true }
    }
    
    @IBAction func tapComment(_ sender: UIButton) {
        performSegue(withIdentifier: "tapComment", sender: nil)
    }
    
    @IBAction func tapMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "tapMenu", sender: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tapComment") {
            let destVC = segue.destination as! PlaceCommentViewController
            destVC.selectedPlace = self.selectedPlace
        }
        
        else if (segue.identifier == "tapMenu") {
            let destVC = segue.destination as! PlaceMenuViewController
            destVC.selectedPlace = self.selectedPlace
        }
    }
    
}
