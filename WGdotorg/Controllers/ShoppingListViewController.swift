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
    
    var items = [ShoppingItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        // Create alert controller
        let alertController = UIAlertController(title: "Add New Name", message: nil, preferredStyle: .alert)
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            if let itemName = alertController.textFields?.first?.text {
                let item = ShoppingItem(name: itemName, uuid: UUID().uuidString)
                self.saveItemToDB(with: item)
                self.updateTableView(with: item)
            }
        }))
        
        // Create text field
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter an item"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveItemToDB(with item: ShoppingItem) {
        let db = Firestore.firestore()
        if let _ = Auth.auth().currentUser {
            let groupId = "A11C1F3A"//HomeViewController.groupId
            let groupRef = db.collection("groups").document(groupId).collection("ShoppingList" + groupId)
            // TODO: Implement serialize protocol to make this smoother
            let data: [String: Any] = [
                "name" : item.name,
                "id" : item.uuid
            ]
            groupRef.document(item.uuid).setData(data)
        }
    }
    
    func updateTableView(with item: ShoppingItem) {
        items.append(item)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func setItems(completionHandler: @escaping ([ShoppingItem]) -> ()) {
        
        // TODO: Make this static/available everywhere
        let db = Firestore.firestore()
        let groupId = "A11C1F3A" //HomeViewController.groupId //
        let itemsRef = db.collection("groups").document(groupId).collection("ShoppingList" + groupId)
        
        
        itemsRef.getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot != nil else {
                completionHandler([ShoppingItem]())
                return
            }
            
            var items = [ShoppingItem]()
            for document in querySnapshot!.documents {
                // Serialize fetched data into ShoppingItem object
                if let name = document.data()["name"],
                   let id = document.data()["id"] {
                    let item = ShoppingItem(name: name as! String, uuid: id as! String)
                    items += [item]
                }
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
        cell.setName(with: items[indexPath.row].name)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let db = Firestore.firestore()
            let groupId = "A11C1F3A" //HomeViewController.groupId //
            let itemsRef = db.collection("groups").document(groupId).collection("ShoppingList" + groupId)
            
            // Remove in db
            let deletedItem = items[indexPath.row]
            let documentId = deletedItem.uuid
            itemsRef.document(documentId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
            }
                
            // Remove in internal state
            self.items.remove(at: indexPath.row)
            
            // Remove in interface
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            }
        }
    }
}
