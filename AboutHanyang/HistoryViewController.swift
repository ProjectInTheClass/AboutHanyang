//
//  HistoryViewController.swift
//  aboutHanyang
//
//  Created by th on 08/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class HistoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "최근 검색기록"
        //recentQueue init
        let doc = NSHomeDirectory() + "/Documents"
        let filepath = doc + "/history.json"
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentQueue.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryViewCell
        // Configure the cell...
        cell.name.text = recentQueue[indexPath.row].p_name
        cell.pos.text = recentQueue[indexPath.row].p_pos
        return cell
        }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destVC = segue.destination as? PlaceDetailViewController,
            let selectedIndex = self.tableView.indexPathForSelectedRow?.row
            else { return }
        
        destVC.selectedPlace = recentQueue[selectedIndex].p_name
    }
 

}
