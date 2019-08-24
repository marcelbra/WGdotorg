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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func test(_ sender: UIButton) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "age": 0,
            "email": "email",
            "firstName": "self.firstNameFIeld.text!",
            "lastName": "self.lastNameField.text!",
            "sex": "blank",
            "uid": "Auth.auth().currentUser?.uid",
            "group": "None"
            ])
    }
    
    @IBAction func didTapCreateUser(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToCreateUser", sender: self)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "fromWelcomeToLogin", sender: self)
    }

}
