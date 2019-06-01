//
//  SearchSelectedTableViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 24/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class SelectedTableViewController: UITableViewController {

    var placeList : Array<String> = []
    var resultList : Array<Place> = []
    var selectedBuilding : String = ""
    
    override func viewDidLoad() {
        if (selectedBuilding.count == 0){
            self.navigationItem.title = "검색 결과"
        }
        else { // tab 2 로 접근
            self.navigationItem.title = selectedBuilding
        }
        super.viewDidLoad()
        //print(placeList , "selected table view controller")
        
        //resultList = findPlace(place_list: placeList)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        resultList = findPlace(place_list: placeList)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? SelectedCell else{ return UITableViewCell()}
        // Configure the cell...
        //cell.textLabel?.text = placeList[indexPath.row]
        cell.name.text = resultList[indexPath.row].p_name
        cell.pos.text = resultList[indexPath.row].p_pos
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tapSearchedPlace", sender: nil)
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
        
        if (segue.identifier == "tapSearchedPlace") {
            guard let destVC = segue.destination as? PlaceDetailViewController,
                  let selectedIndex = self.tableView.indexPathForSelectedRow?.row
                  else { return }
            
            destVC.selectedPlace = placeList[selectedIndex]
        }
    }

}
