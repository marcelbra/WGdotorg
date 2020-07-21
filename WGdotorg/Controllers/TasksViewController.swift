//
//  TasksViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 13.04.20.
//  Copyright © 2020 Marcel Braasch. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {


    
    @IBAction func didTapAddTask(_ sender: Any) {
        self.performSegue(withIdentifier: "FromTasksToAddTask", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
