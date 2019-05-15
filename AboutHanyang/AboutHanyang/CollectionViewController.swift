//
//  CollectionViewController.swift
//  AboutHanyang
//
//  Created by jjy on 2019. 5. 9..
//  Copyright © 2019년 AboutHanyang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class Category : Decodable{
    
    let c_name : String
    let place_list : Array<String>
    
}

class CollectionViewController: UICollectionViewController {

    var category_list : Array<Category> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Detail"{
            guard let destination = segue.destination as? PlaceViewController , let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first else {
                return
            }
            
            destination.placeName = category_list[selectedIndex.row].place_list[0]
            
        }
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return category_list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category_cell", for: indexPath) as! CollectionViewCell
        
        cell.category_name.text = category_list[indexPath.item].c_name
        cell.placeList = category_list[indexPath.item].place_list
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
