//
//  PlaceMenuViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 23/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit
    
class MenuTableCell : UITableViewCell{
        @IBOutlet weak var name : UILabel!
        @IBOutlet weak var cost :UILabel!
}
    
class PlaceMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        @IBOutlet weak var tableView: UITableView!

        var menuData : Array<TagUnit> = []
        var currentMenu : Array<[String]> = []
        var keys : [String] = []
        var values : [String] = []
        var selectedPlace : String = ""
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currentMenu.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as! MenuTableCell
            
            if(keys.count > 0){
                cell.name.text = keys[indexPath.row]
                cell.cost.text = values[indexPath.row]
            }
            return (cell as UITableViewCell)    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "메뉴"
            self.navigationItem.backBarButtonItem?.title = self.selectedPlace
        }
        
        override func viewWillAppear(_ animated: Bool) {
            do{
                let url = Bundle.main.url(forResource:"db_Menu", withExtension:"json")
                let jsonData = try Data(contentsOf: url!)
                let data = try JSONDecoder().decode([MenuData].self, from: jsonData)
                
                for item in data{
                    if(item.placeName == selectedPlace){
                        menuData = item.menu
                    }
                }
            }
            catch _ { print("json error: failed to load menu info") }
            
            addControl()
            var key : [String] = []
            for i in menuData{
                key.append(i.tagName)
            }
            currentMenu = menuData[0].priceUnits
            for i in currentMenu{
                keys.append(i[0])
                values.append(i[1])
            }
            tableView.reloadData()
            self.tableView.reloadData()
        }
        
        func addControl()  {
            var items : [String] = []
            for i in menuData{
                items.append(i.tagName)
            }
            let segmentedControl = UISegmentedControl(items: items)
            segmentedControl.frame = CGRect(x: 25, y: 100, width: 350, height: 50)
            segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
            segmentedControl.selectedSegmentIndex = 0
            view.addSubview(segmentedControl)
        }
        
        @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
            var items : [String] = [""]
            for i in menuData{
                items.append(i.tagName)
            }
            switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                currentMenu = menuData[0].priceUnits
                break
            case 1:
                currentMenu = menuData[1].priceUnits
            break // Dos
            case 2:
                currentMenu = menuData[2].priceUnits
            break // Tres
            case 3:
                currentMenu = menuData[3].priceUnits
                break
            case 4:
                currentMenu = menuData[4].priceUnits
                break
            default:
                return
            }
            keys = []
            values = []
            for i in currentMenu{
                keys.append(i[0])
                values.append(i[1])
            }
            tableView.reloadData()
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
