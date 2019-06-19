//
//  CategoryViewController.swift
//  aboutHanyang
//
//  Created by Team aboutHanyang on 17/05/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class categoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
}

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedIndex:IndexPath? = nil
    var categoryList = [Category]()
    
    @IBOutlet weak var categoryView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let url = Bundle.main.url(forResource:"db_Category", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            categoryList = try JSONDecoder().decode([Category].self, from: jsonData)
        }
            
        catch _ { print("json error: failed to load category info") }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCollectionViewCell
        cell.name.text = categoryList[indexPath.item].c_name
        cell.icon.image = UIImage(named: categoryList[indexPath.item].c_icon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        if (showCategoryAsMap) {
            performSegue(withIdentifier: "showCategoryAsMap", sender: nil)
        }
        else {
            performSegue(withIdentifier: "showCategoryAsList", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showCategoryAsMap") {
            guard let destVC = segue.destination as? CategoryMapViewController,
                  let selectedIndex = self.categoryView.indexPathsForSelectedItems?.first
                  else { return }
            destVC.selectedCategory = categoryList[selectedIndex.row]
            // category_list[selectedIndex.row].place_list
        }
        
        if (segue.identifier == "showCategoryAsList") {
            guard let destVC = segue.destination as? SelectedTableViewController,
                let selectedIndex = self.categoryView.indexPathsForSelectedItems?.first
                else { return }
            destVC.placeList = categoryList[selectedIndex.row].c_place_list
            destVC.selectedCategory = categoryList[selectedIndex.row].c_name
            // category_list[selectedIndex.row].place_list
        }
    }
    
}
