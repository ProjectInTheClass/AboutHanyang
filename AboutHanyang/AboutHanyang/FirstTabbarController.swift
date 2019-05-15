//
//  FirstTabbarController.swift
//  AboutHanyang
//
//  Created by jjy on 2019. 5. 15..
//  Copyright © 2019년 AboutHanyang. All rights reserved.
//

import UIKit
import Firebase

class FirstTabbarController: UITabBarController {
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
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
