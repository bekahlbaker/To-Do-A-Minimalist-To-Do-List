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
        if self.textField.text != "" {
            if let newItemString = self.textField.text {
                uploadNewToDoItem(item: newItemString)
            }
        } else {
            print("No item to upload")
        }
        self.textFieldIsNotSelected()
    }
    var toDoList = [ToDoItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 45
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        addBtn.alpha = 0
        checkIfHasTransferredDataToNewDatabaseOnce()
//     UserDefaults.standard.set(false, forKey: "hasTransferredDataToNewDatabaseOnce")
    }
}
