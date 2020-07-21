//
//  HomeViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 27.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITabBarController {
    
    static var groupId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupId()
    }
    
    func setGroupId() {
        let db = Firestore.firestore()
        // Get group id from currently logged in user
        if let user = Auth.auth().currentUser {
            let userRef = db.collection("users").document(user.uid)
            userRef.getDocument { (document, err) in
                // Set group  id to static to contain during runtime
                if let document = document, document.exists {
                    let doc = document.data() as! [String: Any]
                    let groupId = doc["group"] as! String
                    HomeViewController.groupId = groupId
                }
            }
        }
    }
}

