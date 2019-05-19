//
//  CommentViewController.swift
//  AboutHanyang
//
//  Created by th on 19/05/2019.
//  Copyright © 2019 AboutHanyang. All rights reserved.
//

import UIKit

struct CommentFormat{
    var user_comment : String
    var dateNtime : String
}

class CommentViewCell : UITableViewCell {
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
}

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var place_name : String?
    var comment_data : Array<CommentFormat> = []
    
    /*
    func addComment(_ userComment : String , _ uid : String) -> Bool {
        
    }
    
    func pullComment(_ placename : String) -> Array<CommentFormat> {
        
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell configure
        
        return UITableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
