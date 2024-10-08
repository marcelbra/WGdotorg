//
//  CreateUserViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 21.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateUserViewController: UIViewController {
    
    // Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameFIeld: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordFieldOne: UITextField!
    @IBOutlet weak var passwordFieldTwo: UITextField!
    
    // Labels
    @IBOutlet weak var enterFirstNameLabel: UILabel!
    @IBOutlet weak var enterLastNameLabel: UITextField!
    @IBOutlet weak var enterEmailAddressLAbel: UILabel!
    @IBOutlet weak var enterPasswordAgainLAbel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    
    // Error message label
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Checks several criteria before creating the user
    @IBAction func didTapCreateUser(_ sender: UIButton) {
        
        // Reset error message
        errorMessageLabel.text = ""
        
        // Check if all fields are filled, mark any field red that is not
        guard allFieldsFilledOut() else {
            errorMessageLabel.text! += "Not all field are filled out."
            return
        }
        
        // Check if email address is valid
        guard emailAddressValid() else {
            errorMessageLabel.text! += "This is not a valid email address."
            return
        }
        
        // Check if passwords are the same
        guard passwordFieldOne.text == passwordFieldTwo.text else {
            errorMessageLabel.text! += "Passwords dont match."
            return
        }
        
        // Check if password is valid
        guard passWordsAreValid() else {
            errorMessageLabel.text! += "Password must have at least 8 characters, contain at least one alphabatical and at least one special character ($,@,$,#,!,%,?,&)."
            return
        }
        
        createUser(email: emailField.text!, password: passwordFieldOne.text!)
    }
    
    // Checks if all fields are filled out and marks the ones that are not
    func allFieldsFilledOut() -> Bool {
        return ((emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") &&
            (firstNameFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") &&
            (lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") &&
            (passwordFieldOne.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "") &&
            (passwordFieldTwo.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""))
        }

    // Checks if passwords are valid
    func passWordsAreValid() -> Bool {
        return true
//        let password: String = passwordFieldOne.text!
//        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//        return passwordTest.evaluate(with: password)
    }
    
    // Checks if email address is valid
    func emailAddressValid() -> Bool {
        return true
//        let emailAddress = emailField.text!
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailTest.evaluate(with: emailAddress)
    }

    // Creates the user in the authentication list
    // Creates user data in firestore
    func createUser(email: String, password: String) {
        
        let db = Firestore.firestore()
        
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
             guard error == nil, user != nil else {
                self.errorMessageLabel.text! = "Something went wrong. Please try again later."
                return
            } // User created and loged in
    
            // Create data
            let uid = Auth.auth().currentUser?.uid as Any as! String
            let data: [String: Any] = [
                "age": 0,
                "email": email,
                "firstName": self.firstNameFIeld.text!,
                "lastName": self.lastNameField.text!,
                "sex": "blank",
                "uid": uid,
                "group": ""
                ]
            
            // Add user data to db
            db.collection("users").document(uid).setData(data) { err in
                if err == nil {
                    self.performSegue(withIdentifier: "fromCreateUserToGroup", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
