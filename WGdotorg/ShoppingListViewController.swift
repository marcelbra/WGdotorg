//
//  ShoppingListViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 26.08.19.
//  Copyright © 2019 Marcel Braasch. All rights reserved.
//

import UIKit
import Firebase

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let groupId = HomeViewController.groupId
            let groupRef = db.collection("groups").document(groupId).collection("messages").document("message1")

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Get amount of items from firebase
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListCell
        cell.setName(with: "Test")
        return cell
    }
    
    
}
