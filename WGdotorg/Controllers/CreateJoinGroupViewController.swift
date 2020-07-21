//
//  CreateJoinGroupViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 24.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit

let x = "xxx"

class CreateJoinGroupViewController: UIViewController {

    
    
    @IBAction func didTapCreateNewGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "createJoinGroupToCreate", sender: self)
    }
    
    @IBAction func didTapJoinGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "createJoinGroupToJoin", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
