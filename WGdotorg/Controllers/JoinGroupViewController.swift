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
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var idField: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func didTapJoinGroup(_ sender: UIButton) {
        if let groupUuid = idField.text {
            if let currUser = Auth.auth().currentUser {
                verifyGroupUuid(with: groupUuid) { (isValid) in
                    if isValid {
                        let docRef = self.db.collection("users").document(currUser.uid)
                        docRef.updateData(["group": groupUuid])
                        self.performSegue(withIdentifier: "fromJoinGroupToHome", sender: self)
                    }
                }
            }
        }
    }
    
    func verifyGroupUuid(with requestedGroupUuid: String, completionHandler: @escaping (Bool) -> ()) {
        db.collection("groups").getDocuments { (documents, err) in
            var isValidUuid = false
            guard err == nil, documents != nil else {
                self.errorMessage.text = "An error occured."
                return
            }
            for document in documents!.documents {
                let currUuid = document.data()["uid"] as! String
                if requestedGroupUuid == currUuid {
                    isValidUuid = true
                }
            }
            completionHandler(isValidUuid)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
