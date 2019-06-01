//
//  SearchViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 23/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class searchPlaceCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pos: UILabel!
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var place_list : Array<Place> = []
    
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData: Array<Place> = []
    var originData: Array<String> = []
    
    override func viewDidLoad() {
        do {
            let url = Bundle.main.url(forResource:"db_Place", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            place_list = try JSONDecoder().decode([Place].self, from: jsonData)
            
            /*
             for i in place_list{
             originData.append(i.p_name)
             }
             */
            
            filteredData = place_list
        }
        catch _ { print("some error") }
        
        self.searchTable.dataSource = self
        self.searchTable.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = "장소 이름을 입력해주세요"
        
        super.viewDidLoad()
    }
    
    //입력 텍스트 변경
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? place_list : place_list.filter({ (datastring : Place) -> Bool in
            return datastring.p_name.range(of : searchText, options: .caseInsensitive) != nil
        })
        searchTable.reloadData()
    }
    
    //입력 시작
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.becomeFirstResponder()
    }
    
    //취소버튼 클릭
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    //검색버튼, 완료버튼 클릭
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "showSearchList", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let limited = (filteredData.count < 4) ? filteredData.count : 4
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchPlaceCell
        let selected : Place = filteredData[indexPath.row]
        cell.name.text = selected.p_name
        cell.pos.text = selected.p_pos
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tapSearchedPlace", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tapSearchedPlace") {
            guard let destVC = segue.destination as? PlaceDetailViewController,
                  let selectedIndex = self.searchTable.indexPathForSelectedRow?.row
                  else { return }
            
            destVC.selectedPlace = filteredData[selectedIndex].p_name
        }
        
        if (segue.identifier == "showSearchList") {
            guard let destVC = segue.destination as? SelectedTableViewController
                  else { return }
            var tempList : Array<String> = []
            for i in filteredData{
                tempList.append(i.p_name)
            }
            destVC.placeList = tempList
        }
    }
    
}
