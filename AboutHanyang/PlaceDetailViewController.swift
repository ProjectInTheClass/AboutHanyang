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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedPlace
        if let placeShowed = findPlace(place_name: selectedPlace){
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let doc = NSHomeDirectory() + "/Documents"
            let filepath = doc + "/history.json"
            // history.json file 이 있는지 확인
            let fileManager = FileManager.default
            let fileUrl = URL(fileURLWithPath: filepath)
            if fileManager.fileExists(atPath: filepath) {
                do {
                    let jsonData = try Data(contentsOf: fileUrl as URL)
                    recentQueue = try JSONDecoder().decode([Place].self, from: jsonData)
                }
                catch _ { print("some error") } }
            else {
                print("recent history doesn't exists")
            }
            var duplCheck : Bool = false
            var temp : Array<Place> = []
            for i in recentQueue{
                if i.p_name == placeShowed.p_name {
                    duplCheck = true
                    temp.insert(i, at: 0)
                }
                else{
                    temp.append(i)
                }
            }
            if (duplCheck == false){
                recentQueue.insert(placeShowed, at: 0)
                while (recentQueue.count > queueSize){
                    recentQueue = recentQueue.dropLast()
                }
            }
            else{
                recentQueue = temp
            }
            let myJson = try? encoder.encode(recentQueue)
            if let myJsonFile = myJson , let myString = String(data: myJsonFile, encoding: .utf8){
                do{
                    try myString.write(to: fileUrl, atomically: false, encoding: .utf8)
                    print(myString)
                }
                catch _ {
                    print("history.json file write failed")
                }
            }
        }
        //print(placeShowed.p_pos)
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
