//
//  SelectedCell.swift
//  aboutHanyang
//
//  Created by th on 01/06/2019.
//  Copyright © 2019 aboutHanyang. All rights reserved.
//

import UIKit

class SelectedCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
