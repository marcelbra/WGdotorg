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

    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    static var db = Firestore.firestore()
    
    // Create user friendly UUID and check in database if it already exists
    func createUuid() -> String {
//        var again = false
//        var uuid = UUID().uuidString
//        uuid = uuid.components(separatedBy: "-")[0]
//        uuid = "test"
        var test = [QueryDocumentSnapshot]()
        CreateGroupViewController.db.collection("groups").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    test += [document]
                }
            }
        }
        return ""
    }
        
//        CreateGroupViewController.db.collection("groups").getDocuments() { (querySnapshots, err) in
//            if let _ = err {
////                self.errorMessage.text = "An error occured."
//            } else {
//                // Check every document if uid already exisits
//                for doc in querySnapshots!.documents {
//                    // Get the uid from current group and cast it to string
//                    let docUid = doc.data()["uid"] as! String
//                    // If uids are equal start over
//                    if uuid == docUid {
//                        again = true
//                    }
//                }
//            }
//        }
    
//        if again {
//            return uuid
//        }
//        else {
//            return createUuid()
//        }
//    }

    @IBAction func didTapCreateGroup(_ sender: UIButton) {
        
        // Check for nil
        if groupNameTextField.text == nil || groupNameTextField.text == "" {
//            errorMessage.text! = "Field is empty."
            return
        }
        
        // Check if field empty
        if groupNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//            errorMessage.text! = "Field is empty."
            return
        }
        
        // Create db reference
        var ref: DocumentReference? = nil
        
        let uuid = createUuid()
        
        ref = CreateGroupViewController.db.collection("groups").addDocument(data: [
            "name": groupNameTextField.text!,
            "uid": uuid
            ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
