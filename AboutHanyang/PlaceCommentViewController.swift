//
//  PlaceCommentViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 24/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class Comment {
    
}

class PlaceCommentViewController: UIViewController {
    var selectedPlace:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "코멘트"
        self.navigationItem.backBarButtonItem?.title = self.selectedPlace
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
