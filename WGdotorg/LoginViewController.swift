//
//  LoginViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 21.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import Foundation
import Firebase

//@objc(EmailViewController)
class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    
    @IBAction func didTapEmailLogin(_ sender: UIButton) {

        // Database connection
        let db = Firestore.firestore()

        // Check if empty
        guard emailField.text != nil, passwordField.text != nil else {
            return
        }

        // Try to log in
        let email = emailField.text!
        let password = passwordField.text!
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            guard error == nil, user != nil else {
                // There was an error.
                self.errorMessage.text = "Email/password incorrect"
                return
            }
            
            let userUid = Auth.auth().currentUser?.uid
            db.collection("users").document(userUid!).getDocument {
                (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
            
            self.performSegue(withIdentifier: "fromLoginToCreateJoinGroup", sender: self)

            self.performSegue(withIdentifier: "fromLoginToHome", sender: self)
        }
    }
    
}

//        showSpinner {
//            // [START headless_email_auth]
//            Auth.auth().signIn(withEmail: email, password: password) {
//                [weak self] user, error in
//                guard let strongSelf = self else { return }
//                // [START_EXCLUDE]
//                strongSelf.hideSpinner {
//                    if let error = error {
//                        strongSelf.showMessagePrompt(error.localizedDescription)
//                        return
//                    }
//                    strongSelf.navigationController?.popViewController(animated: true)
//                }
//                // [END_EXCLUDE]
//            }
//            // [END headless_email_auth]
//        }
//    }
