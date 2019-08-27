//
//  WelcomeViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 22.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapCreateUser(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToCreateUser", sender: self)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToLogin", sender: self)
    }

}
