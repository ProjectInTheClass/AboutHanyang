//
//  MenuViewController.swift
//  MenuTest
//
//  Created by jjy on 05/06/2019.
//  Copyright © 2019 AboutHanyang. All rights reserved.
//

import UIKit


struct MenuData:Decodable{
    
    var placeName : String
    var menu : [String:[String:String]]
    
}

class MenuTableCell : UITableViewCell{
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var cost : UILabel!
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuData : [String:[String:String]] = ["":["":""]]
    var currentMenu : [String:String] = ["":""]
    var keys : [String] = [""]
    var values : [String] = [""]
    var placeName : String = "Blue Pot"
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as! MenuTableCell
        
        cell.name.text = keys[indexPath.row]
        cell.cost.text = values[indexPath.row]
        
        return (cell as UITableViewCell)    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            let url = Bundle.main.url(forResource:"menu", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            let data = try JSONDecoder().decode([MenuData].self, from: jsonData)
            
            for item in data{
                if(item.placeName == placeName){
                    menuData = item.menu
                }
            }
        }
            
        catch _ { print("some error") }
        addControl()
        let key = Array(menuData.keys)
        currentMenu = menuData[key[0]]!
        keys = Array(currentMenu.keys)
        values = Array(currentMenu.values)
        tableView.reloadData()
        self.tableView.reloadData()
    }
    
    func addControl()  {
        let items = Array(menuData.keys)
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 100, y: 100, width: 250, height: 50)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
    }

    
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            let key = Array(menuData.keys)
            currentMenu = menuData[key[0]]!
        break
        case 1:
            let key = Array(menuData.keys)
            currentMenu = menuData[key[1]]!
        break // Dos
        case 2:
            let key = Array(menuData.keys)
            currentMenu = menuData[key[2]]!
        break // Tres
        case 3:
            let key = Array(menuData.keys)
            currentMenu = menuData[key[3]]!
        break
        default:
            break
        }
        keys = Array(currentMenu.keys)
        values = Array(currentMenu.values)
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
