//
//  ShoppingListCell.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 26.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func setName(with itemName: String) {
        name.text = itemName
    }
}
