//
//  BuildingDetailViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class BuildingDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let places = ["큐카페", "열람실", "복사실", "오픈허브"]
    
    var selectedBuilding:String = ""
    var selectedPlace:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedBuilding
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        cell.name.text = places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = places[indexPath.row]
        performSegue(withIdentifier: "tapPlaceInBuilding", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! PlaceDetailViewController
        destVC.selectedBuilding = self.selectedBuilding
        destVC.selectedPlace = self.selectedPlace
        
        if (segue.identifier == "tapPlaceInBuilding") {
            print("id confirm!")
        }
    }

}
