//
//  LoginViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 21.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import Foundation
import Firebase

//@objc(LoginViewController)
class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func didTapEmailLogin(_ sender: UIButton) {

        // Check if empty
        guard emailField.text != nil, passwordField.text != nil else {
            self.errorMessage.text = "Fields can't be empty."
            return
        }

        let email = emailField.text!
        let password = passwordField.text!

        loginAsync(with: email, with: password) { (loginSuccesful) in
            if loginSuccesful {
                self.userHasGroupAsync(completionHandler: { (hasGroup) in
                    if hasGroup {
                        self.performSegue(withIdentifier: "fromLoginToHome", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "fromLoginToCreateJoinGroup", sender: self)
                    }
                })
            }
        }
    }
    
    func loginAsync(with email: String, with password: String, completionHandler: @escaping (Bool) -> ()) {
        var succesful = true
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            guard error == nil, user != nil else {
                // There was an error.
                self.errorMessage.text = "Email/password incorrect."
                succesful = false
                return
            }
            completionHandler(succesful)
        }
    }
    
    func userHasGroupAsync(completionHandler: @escaping (Bool) -> ()) {
        var hasGroup = false
        let db = Firestore.firestore()
        let userUid = Auth.auth().currentUser?.uid
        let docRef = db.collection("users").document(userUid!)
        docRef.getDocument { (document, _) in
            if let document = document, document.exists {
                let data: [String: Any] = document.data()!
                let group = data["group"] as! String
                if group != "" { hasGroup = true }
            }
            completionHandler(hasGroup)
        }
    }
}
