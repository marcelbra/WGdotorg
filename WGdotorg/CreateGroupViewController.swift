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
        
        let newUuid = UUID().uuidString.components(separatedBy: "-")[0]
        var uuids = [String]()
        
        CreateGroupViewController.db.collection("groups").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docUuid = document.data()["uid"] as! String
                    uuids += [docUuid]
                }
            }
        }
        
        // Check if uuid has been there before, if yes add "!"
        for uuid in uuids {
            if uuid == newUuid {
                return String(newUuid.dropLast() + "!")
            }
        }
        return newUuid
    }
    

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
        
        // Create group uuid
        let uuid = createUuid()
        
        // Create group
        ref = CreateGroupViewController.db.collection("groups").addDocument(data: [
            "name": groupNameTextField.text!,
            "uid": uuid
            ])
        
        var l = 0
        
        // assign group to user
//        CreateGroupViewController.db.collection("users").
        

        performSegue(withIdentifier: "fromCreateGroupToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
