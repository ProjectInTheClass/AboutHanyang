//
//  SearchViewController.swift
//  AboutHanyang
//
//  Created by th on 17/05/2019.
//  Copyright © 2019 AboutHanyang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
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
            
        catch _{
            print("some error")
        }
        
        self.searchTable.dataSource = self
        self.searchTable.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = "장소 이름을 입력해주세요"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //입력 텍스트 변경
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? place_list : place_list.filter({(datastring : Place) -> Bool in
            return datastring.p_name.range(of : searchText, options: .caseInsensitive) != nil
        })
        searchTable.reloadData()
    }
    //입력 시작
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    //취소버튼 클릭
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let limited = (filteredData.count < 4) ? filteredData.count : 4
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath)
        let selected : Place = filteredData[indexPath.row]
        cell.textLabel?.text = selected.p_name
        cell.detailTextLabel?.text = selected.p_pos
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "search_infoService"{
            guard let destination = segue.destination as? PlaceViewController , let selectedIndex = self.searchTable.indexPathForSelectedRow?.row else {
                return
            }
    
            destination.placeName = filteredData[selectedIndex].p_name
            print(filteredData[selectedIndex].p_name)
        }
        
    }
    

}
