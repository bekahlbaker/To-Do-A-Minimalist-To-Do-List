//
//  MainVC+Tableview.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit

extension MainVC {
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
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(checkBtnTapped), for: .touchUpInside)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
            cell.selectedBackgroundView = backgroundView
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func checkBtnTapped(_ sender: UIButton) {
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: 0)
        let cell: ToDoCell = (self.tableView.cellForRow(at: indexPath) as? ToDoCell)!
        if cell.completed == true {
            editItem(isDone: false, itemID: cell.itemID, item: cell.toDoLabel.text!, sender: row)
        } else if cell.completed == false {
            editItem(isDone: true, itemID: cell.itemID, item: cell.toDoLabel.text!, sender: row)
        }
        
    }
    func downloadSingleItem(itemId: String, sender: Int) {
        DispatchQueue.global().async {
            DataService.ds.REF_CURRENT_USER.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let item = ToDoItem(itemID: itemId, postData: dict)
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: sender, section: 0)
                        let cell: ToDoCell = (self.tableView.cellForRow(at: indexPath) as? ToDoCell)!
                        cell.configureCell(toDoItem: item)
                    }
                }
            })
        }
    }
    func editItem(isDone: Bool, itemID: String, item: String, sender: Int) {
        let updateItem: [String: Any] = [
            "item": item as String,
            "completed": isDone
        ]
        DataService.ds.REF_CURRENT_USER.child(itemID).setValue(updateItem)
        self.downloadSingleItem(itemId: itemID, sender: sender)
    }
    func deleteItem(itemId: String, sender: Int) {
        self.toDoList.remove(at: sender)
        DataService.ds.REF_CURRENT_USER.child(itemId).removeValue()
        self.tableView.reloadData()
        downloadData { (successDownloadingData) in
            if successDownloadingData {
                self.tableView.reloadData()
                print("Reload Table")
            } else {
                print("Unable to download data, try again")
            }
        }
}
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //        let item: ToDoItem = self.toDoList[indexPath.row]
        let cell: ToDoCell = self.tableView.cellForRow(at: indexPath) as! ToDoCell
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: "You will not be able to get this back.", preferredStyle: UIAlertControllerStyle.alert)
            let yes = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                print("DELETE ITEM")
                //DELETE ITEM AT INDEX PATH
                self.deleteItem(itemId: cell.itemID, sender: indexPath.row)
            })
            let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor(colorLiteralRed: 0.91, green: 0.42, blue: 0.42, alpha: 1.0)
        let edit = UITableViewRowAction(style: .destructive, title: "Edit") { (action, indexPath) in
            let description = cell.toDoLabel.text
            let alert = UIAlertController(title: "Edit your to-do description.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let edit = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let editingTextfield = alert.textFields![0] as UITextField
                //EDIT ITEM AT INDEX PATH
                if let stringToUpdate = editingTextfield.text {
                    self.tableView.isEditing = false
                    self.editItem(isDone: cell.completed, itemID: cell.itemID, item: stringToUpdate, sender: indexPath.row)
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(edit)
            alert.addAction(cancel)
            alert.addTextField(configurationHandler: { (editTextField : UITextField!) -> Void in
                editTextField.text = description
                editTextField.keyboardType = .default
                editTextField.autocorrectionType = .yes
            })
            self.present(alert, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor(colorLiteralRed: 0.69, green: 0.85, blue: 0.80, alpha: 1.0)
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            if let description = cell.toDoLabel.text {
                let stringToShare = "To Do: " + description
                let controller = UIActivityViewController(activityItems: [stringToShare], applicationActivities: nil)
                self.present(controller, animated: true, completion: nil)
            }
        }
        share.backgroundColor = UIColor(colorLiteralRed: 0.69, green: 0.58, blue: 0.43, alpha: 1.0 )
        return [delete, edit, share]
    }
    func getItemsToShare(completionHandler:@escaping (Bool) -> Void) {
        if let rows = tableView.indexPathsForSelectedRows.map({$0.map{$0.row}}) {
            self.stringToShare = ""
            for row in rows {
                let toDoItem: ToDoItem = self.toDoList[row]
                let item = toDoItem.toDoListItem
                stringToShare += item + "\n"
            }
            completionHandler(true)
        }
    }
    func getItemsToDelete(completionHandler:@escaping (Bool) -> Void) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                let cell: ToDoCell = tableView.cellForRow(at: indexPath) as! ToDoCell
                self.toDoList.remove(at: indexPath.row)
                DataService.ds.REF_CURRENT_USER.child(cell.itemID).removeValue()
            }
            completionHandler(true)
        }
    }
}
