//
//  MainVC.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/2/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBAction func addBtnTapped(_ sender: Any) {
        if self.textField.text != nil {
            if let newItemString = self.textField.text {
                uploadNewToDoItem(item: newItemString)
            }
        } else {
            print("No item to upload")
        }
    }
    var toDoList = [ToDoItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 45
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
//        addBtn.alpha = 0
        checkIfHasTransferredDataToNewDatabaseOnce()
//     UserDefaults.standard.set(false, forKey: "hasTransferredDataToNewDatabaseOnce")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "toDo") as? ToDoCell {
            let toDoItem = self.toDoList[indexPath.row]
            cell.configureCell(toDoItem: toDoItem)
            return cell
        }
        return UITableViewCell()
    }
    func uploadNewToDoItem(item: String) {
        let newItem: [String: Any] = [
            "item": item as String,
            "completed": false
        ]
        DataService.ds.REF_CURRENT_USER.childByAutoId().setValue(newItem)
    }
}
