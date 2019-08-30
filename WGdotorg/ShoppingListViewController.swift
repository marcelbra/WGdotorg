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
    
    var items = [String]()
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        // Create alert controller
        let alertController = UIAlertController(title: "Add New Name", message: nil, preferredStyle: .alert)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            if let itemName = alertController.textFields?.first?.text {
                self.saveItemToDB(with: itemName)
                self.updateTableView(with: itemName)
            }
        }))
        
        // Create text field
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter an item"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveItemToDB(with itemName: String) {
        let db = Firestore.firestore()
        if let _ = Auth.auth().currentUser {
            let groupId = "A11C1F3A"//HomeViewController.groupId
            let groupRef = db.collection("groups").document(groupId).collection("ShoppingList" + groupId)
            
            // Check if the item already exists
            groupRef.document(itemName).getDocument { (document, err) in
                // If it does exist, give alert
                if let document = document, document.exists {
                    let alert = UIAlertController(title: "Item already exists!", message: "Please add an item with a different name.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else { // else add it to db
                    let data: [String: Any] = [
                        "name" : itemName
                    ]
                    groupRef.document(itemName).setData(data)
                }
            }
        }
    }
    
    func updateTableView(with newElement: String) {
        items.append(newElement)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func setItems(completionHandler: @escaping ([String]) -> ()) {
        let db = Firestore.firestore()
        let groupId = "A11C1F3A"//HomeViewController.groupId
        let itemsRef = db.collection("groups").document(groupId).collection("ShoppingList" + groupId)
        itemsRef.getDocuments { (querySnapshot, err) in
            guard err == nil, querySnapshot != nil else {
                completionHandler([String]())
                return
            }
            var items = [String]()
            for document in querySnapshot!.documents {
                let item = document.data()["name"] as Any as! String
                items.append(item)
            }
            completionHandler(items)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setItems(completionHandler: { (items) in
            self.items = items
            DispatchQueue.main.async { self.tableView.reloadData() }
        })
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListCell
        cell.setName(with: items[indexPath.row])
        return cell
    }
}
