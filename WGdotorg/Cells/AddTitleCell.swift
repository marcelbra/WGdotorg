//
//  AddTitleCell.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 15.04.20.
//  Copyright © 2020 Marcel Braasch. All rights reserved.
//

import UIKit

class AddTitleCell: UITableViewCell {

    
    @IBOutlet weak var TitleTextField: UITextField!
    
    func configCell() {
        TitleTextField.placeholder = "Title"
        TitleTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    } 
}
