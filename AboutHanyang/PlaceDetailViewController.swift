//
//  PlaceDetailViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class PlaceDetailViewController: UIViewController, UITableViewDataSource{
    @IBOutlet weak var place_name : UILabel!
    @IBOutlet weak var place_image : UIImageView!
    @IBOutlet weak var place_exp : UITextView!
    @IBOutlet weak var place_oper_table: UITableView!
    
    @IBOutlet weak var menuButton : UIButton!
    
    var iconArray = ["clock","phone", "email"]
    var phone : String = ""
    var email : String = ""
    var selectedPlace:String = ""
    var selectedBuilding:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedPlace
        self.place_oper_table.dataSource = self
        
        if let placeShowed = findPlace(place_name: selectedPlace) {
            //page 구성
            phone = placeShowed.p_phone
            email = placeShowed.p_email
            place_name.text = placeShowed.p_name
            place_image.image = UIImage(named: placeShowed.p_name)
            place_exp.text = placeShowed.p_description
            
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
                catch _ { print("json error: failed to load place info") } }
            else { print("recent history doesn't exists") }
            
            var duplCheck : Bool = false
            var temp : Array<Place> = []
            
            for i in recentQueue {
                if i.p_name == placeShowed.p_name {
                    duplCheck = true
                    temp.insert(i, at: 0)
                }
                else {
                    temp.append(i)
                }
            }
            
            if (duplCheck == false) {
                recentQueue.insert(placeShowed, at: 0)
                while (recentQueue.count > queueSize) {
                    recentQueue = recentQueue.dropLast()
                }
            }
            else {
                recentQueue = temp
            }
            
            let myJson = try? encoder.encode(recentQueue)
            if let myJsonFile = myJson , let myString = String(data: myJsonFile, encoding: .utf8){
                do {
                    try myString.write(to: fileUrl, atomically: false, encoding: .utf8)
                    // print(myString)
                }
                catch _ { print("history.json file write failed") }
            }
        }
        
        menuButton.isHidden = false
        
        do {
            let url = Bundle.main.url(forResource:"db_Menu", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            let data = try JSONDecoder().decode([MenuData].self, from: jsonData)
            
            for item in data {
                print(item.placeName)
                if(item.placeName == selectedPlace) {
                    return
                }
            }
            menuButton.isHidden = true
        }
        catch _ { menuButton.isHidden = true
            print("db_Menu json parsing failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oper", for: indexPath) as! DetailCell
        
        cell.icon.image = UIImage(named: iconArray[indexPath.row])
        switch indexPath.row {
        case 0:
            cell.content.text = "Open 09:00 am ~ 06:00 pm" //임시
        case 1:
            cell.content.text = phone
        case 2:
            cell.content.text = email
        default:
            print("default")
        }
        return cell
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
