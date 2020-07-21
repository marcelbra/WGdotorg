//
//  AddTaskViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 13.04.20.
//  Copyright © 2020 Marcel Braasch. All rights reserved.
//
//  DateCell functionality Created by Kohei Hayakawa on 2/6/15.
//  Copyright © 2015 Kohei Hayakawa. All rights reserved.

import UIKit
import Firebase

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!

    let pickerAnimationDuration = 0.40 // duration for the animation to slide the date picker into view
    let datePickerTag           = 99   // view tag identifiying the date picker view
    
    let titleKey = "title" // key for obtaining the data source item's title
    let dateKey  = "date"  // key for obtaining the data source item's date value
    
    // keep track of which rows have date cells
    let dateStartRow = 1
    let dateEndRow   = 2
    
    let dateCellID       = "dateCell";       // the cells with the start or end date
    let datePickerCellID = "datePickerCell"; // the cell containing the date picker
    let otherCellID      = "otherCell";      // the remaining cells at the end

    var dataArray: [[String: AnyObject]] = []
    var dateFormatter = DateFormatter()
    
    // keep track which indexPath points to the cell with UIDatePicker
    var datePickerIndexPath: NSIndexPath?
    
    var pickerCellRowHeight: CGFloat = 216
    
    // MARK: - Locale
    /*! Responds to region format or locale changes.
    */
    @objc func localeChanged(notif: NSNotification) {
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup our data source
        let itemOne = [titleKey : "Tap a cell to change its date:"]
        let itemTwo = [titleKey : "Start Date", dateKey : NSDate()] as [String : Any]
        let itemThree = [titleKey : "End Date", dateKey : NSDate()] as [String : Any]
        let itemFour = [titleKey : "(other item1)"]
        let itemFive = [titleKey : "(other item2)"]
        dataArray = [itemOne as Dictionary<String, AnyObject>, itemTwo as Dictionary<String, AnyObject>, itemThree as Dictionary<String, AnyObject>, itemFour as Dictionary<String, AnyObject>, itemFive as Dictionary<String, AnyObject>]
        
        dateFormatter.dateStyle = .short // show short-style date format
        dateFormatter.timeStyle = .short
        
        // if the locale changes while in the background, we need to be notified so we can update the date
        // format in the table view cells
        //
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskViewController.localeChanged(notif:)), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
}
    
extension AddTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
          if hasInlineDatePicker() {
              // we have a date picker, so allow for it in the number of rows in this section
              return dataArray.count + 1;
          }
          
          return dataArray.count;
      }
    
    func hasInlineDatePicker() -> Bool {
        return datePickerIndexPath != nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getTitleCell()
        default:
            return getTitleCell()
        }
    }
    
    func getTitleCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! AddTitleCell
        cell.configCell()
        return cell
    }
    
    
}
    
    // OLD ADD TASK VC!
//
//    @IBOutlet weak var TaskNameTextField: UITextField!
//    @IBOutlet weak var DescriptionTextView: UITextView!
//
//
//    @IBAction func didTapeConfigure(_ sender: UIButton) {
//        saveToCloud()
//        // TODO Segue to task config
//        // Segue without saving the data and save as soon as configured. Else user might
//    }
//
//    @IBAction func didTapSaveTask(_ sender: UIBarButtonItem) {
//        saveToCloud()
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//    }
//
//    private func saveToCloud() {
//        let db = Firestore.firestore()
//        let uuid = UUID().uuidString
//        let data: [String: Any] = [
//            "name": TaskNameTextField.text ?? "",
//            "description": DescriptionTextView.text ?? "",
////            "days" : 0,
////            "endDate" : "",
////            "startEnd" : "",
////            "groupId" : "",
////            "owners": ["1","2","3"],
////            "periodNo": 0
//        ]
//        db.collection("tasks").document(uuid).setData(data) { err in
//            if err == nil {
//                // Succesful
//            }
//        }
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//
//}
