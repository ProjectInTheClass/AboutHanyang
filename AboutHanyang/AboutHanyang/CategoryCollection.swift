//
//  CategoryCollectionController.swift
//  AboutHanyang
//
//  Created by th on 17/05/2019.
//  Copyright © 2019 AboutHanyang. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell{
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    var category_name : String?
    var category_cell : Category?
}

class CategoryCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collections: UICollectionView!
    var category_list = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collections.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        do {
            let url = Bundle.main.url(forResource:"db_Category", withExtension:"json")
            let jsonData = try Data(contentsOf: url!)
            category_list = try JSONDecoder().decode([Category].self, from: jsonData)
        }
            
        catch _{
            print("some error")
        }
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as? CategoryCollectionCell
        cell?.category_name = category_list[indexPath.item].c_name
        cell?.title.text = cell?.category_name
        cell?.icon.image = UIImage(named: category_list[indexPath.item].category_icon)
        return cell!
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SelectedService"{
            guard let destination = segue.destination as? PlaceViewController , let selectedIndex = self.collections.indexPathsForSelectedItems?.first else {
                return
            }
            
            destination.placeName = category_list[selectedIndex.row].place_list[0]
            
 
        }
    }*/
    

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "category_listService"{
            guard let destination = segue.destination as? SelectedTableViewController , let selectedIndex = self.collections.indexPathsForSelectedItems?.first else {
                return
            }
            destination.placeList = category_list[selectedIndex.row].place_list
            
        }
        
    }
    

}
