//
//  PlaceDetailViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    var selectedPlace:String = ""
    var selectedBuilding:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedPlace
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
