//
//  JoinGroupViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 27.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import Firebase

class JoinGroupViewController: UIViewController {
    
    @IBOutlet weak var idField: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func didTapJoinGroup(_ sender: UIButton) {
        if let groupUuid = idField {
            if let currUser = Auth.auth().currentUser {
                let docRef = db.collection("users").document(currUser.uid)
                docRef.updateData(["group": groupUuid])
                self.performSegue(withIdentifier: "fromJoinGroupToHome", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
