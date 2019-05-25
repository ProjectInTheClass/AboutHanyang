//
//  PlaceListViewController.swift
//  aboutHanyang
//
//  Created by aboutHanyang on 25/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class PlaceListViewController: UIViewController {

    var selectedCategory:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = selectedCategory
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
