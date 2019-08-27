//
//  CreateGroupViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 24.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    func createNewUuidAsync(completionHandler: @escaping (String?) -> ()) {
        var newUuid: String? = UUID().uuidString.components(separatedBy: "-")[0]
        let db = Firestore.firestore()
        var uuids = [String]()
        db.collection("groups").getDocuments() {
            (querySnapshot, err) in
            if err == nil {
                for document in querySnapshot!.documents {
                    let docUuid = document.data()["uid"] as! String
                    uuids.append(docUuid)
                }
                for uuid in uuids {
                    if uuid == newUuid {
                        newUuid = String(newUuid!.dropLast() + "!")
                    }
                }
            }
            else {
                newUuid = nil
            }
            completionHandler(newUuid)
        }
    }
    
    // Create user friendly UUID and check in database if it already exists
    @IBAction func didTapCreateGroup(_ sender: UIButton) {

        // Db connection
        let db = Firestore.firestore()
        
        // Check for nil
        if groupNameTextField.text == nil || groupNameTextField.text == "" {
            errorMessage.text! = "Field is empty."
            return
        }
        
        // Check if field empty
        if groupNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorMessage.text! = "Field is empty."
            return
        }
        
        // Create uuid for group
        createNewUuidAsync { (groupUuid) in
            
            // Create group in db if uuid creation was succesful
            if let groupUuid: String = groupUuid {
                let data: [String : Any] = [
                    "name": self.groupNameTextField.text!,
                    "uid": groupUuid
                ]
                db.collection("groups").addDocument(data: data)
                
                // Assign user to group
                if let currUser = Auth.auth().currentUser {
                    let docRef = db.collection("users").document(currUser.uid)
                    docRef.updateData([ "group": groupUuid])
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
