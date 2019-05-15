//
//  PlaceViewController.swift
//  AboutHanyang
//
//  Created by jjy on 2019. 5. 9..
//  Copyright © 2019년 AboutHanyang. All rights reserved.
//

import UIKit
import Firebase

struct Parse_Place : Decodable {
    var p_parse : [String:Place]
}

class PlaceViewController: UIViewController {

    @IBOutlet weak var MenuButton: UIButton!
   
    @IBOutlet weak var placeText: UILabel!
    
    @IBOutlet weak var review: UITextView!
    
    var placeName : String = ""
    
    var comment : String = ""
    var tendency : String = ""
    var score : String = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        ref.child("review").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? NSDictionary
        
            self.comment = dict?["comment"] as? String ?? "null"
            self.tendency = dict?["tendency"] as? String ?? ""
            self.score = dict?["score"] as? String ?? ""

        }) { (error) in
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.review.text = self.comment + "\n" + self.tendency + "\n" + self.score
        }
        
      /*  do {
            let url = Bundle.main.url(forResource:"db_Place", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            let placeDic = try JSONDecoder().decode([String:Place].self, from: jsonData)
            guard let place = placeDic[placeName] else {
                return
            }
            
            placeText.text = place.p_name + place.p_pos + place.p_phone + place.p_email + place.p_description
        }
            
        catch _{
            print("some error")
        } */
        
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
