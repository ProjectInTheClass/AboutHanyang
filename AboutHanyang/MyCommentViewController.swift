//
//  MyCommentViewController.swift
//  aboutHanyang
//
//  Created by jjy on 13/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
import Firebase

struct myComment : Codable{
    var comment : String
    let place_name : String
    let date : String
    
    
    init(_ comment : String, _ place_name : String, _ date : String) {
        self.comment = comment
        self.place_name = place_name
        self.date = date
    }
}

class myCommentCell : UITableViewCell{
    @IBOutlet weak var comment : UILabel?
    @IBOutlet weak var date : UILabel?
    @IBOutlet weak var placeName : UILabel?
}


class MyCommentViewController: UITableViewController {

    var myComments : [myComment] = []
    var ref: DatabaseReference!
    var uid : String  = ""
    var fileUrl : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSHomeDirectory())
        
        ref = Database.database().reference()
        let defaults = UserDefaults.standard
        if let getkey = defaults.string(forKey: "user_uid") {
            uid = getkey
        }
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let doc = NSHomeDirectory() + "/Documents"
            let filepath = doc + "/myComment.json"
            
            // myComment.json file 이 있는지 확인
        let fileManager = FileManager.default
            fileUrl = URL(fileURLWithPath: filepath)
            
            if fileManager.fileExists(atPath: filepath) {
                do {
                    let jsonData = try Data(contentsOf: fileUrl as URL)
                    myComments = try JSONDecoder().decode([myComment].self, from: jsonData)
                }
                catch _ { print("json error: failed to load place info") } }
            else { print("recent myComment doesn't exists") }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myComments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myComment", for: indexPath) as! myCommentCell

        let count = indexPath.row
        let dic : myComment = myComments[count]

        
        cell.comment?.text = dic.comment
        cell.date?.text = dic.date
        cell.placeName?.text = dic.place_name
        
        return (cell as UITableViewCell)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let cur_comment = myComments[indexPath.row]
            let alert = UIAlertController(title: "댓글 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.ref.child("review").child(cur_comment.place_name).child(self.uid).setValue(nil){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    }else{
                        self.myComments.remove(at: indexPath.row)
                        
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                        let myJson = try? encoder.encode(self.myComments)
                        if let myJsonFile = myJson , let myString = String(data: myJsonFile, encoding: .utf8){
                            do {
                                try myString.write(to: self.fileUrl, atomically: false, encoding: .utf8)
                                // print(myString)
                            }
                            catch _ { print("myComment.json file write failed") }
                        }
                        
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                alert.dismiss(animated: true, completion: nil)
            }
            
            let no = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(ok)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
            

            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
