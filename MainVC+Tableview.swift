//
//  MainVC+Tableview.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension MainVC {
  
// Tableview Delegates
  func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "toDo") as? ToDoCell {
        cell.configureCell(toDoItem: self.items[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      try self.realm.write({
        self.items[indexPath.row].completed = !self.items[indexPath.row].completed
      })
    }catch let error {
      print(error)
    }
    tableView.reloadData()
    print(self.items[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      return 50.0
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }

  // Edit Actions
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let item: ToDoItem = self.toDoList[indexPath.row]
    let cell: ToDoCell = self.tableView.cellForRow(at: indexPath) as! ToDoCell
  
// Delete Action
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
        let alert = UIAlertController(title: "Are you sure you want to delete this item?", message: "You will not be able to get this back.", preferredStyle: UIAlertControllerStyle.alert)
        let yes = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
          do {
            try self.realm.write({
              self.realm.delete(self.items[indexPath.row])
            })
          }catch let error {
            print(error)
          }
            tableView.reloadData()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    delete.backgroundColor = UIColor(red: 0.91, green: 0.42, blue: 0.42, alpha: 1.0)
    
// Edit Action
    let edit = UITableViewRowAction(style: .destructive, title: "Edit") { (action, indexPath) in
        let description = cell.toDoLabel.text
        let alert = UIAlertController(title: "Edit your to-do description.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let edit = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let editingTextfield = alert.textFields![0] as UITextField
            if let stringToUpdate = editingTextfield.text {
                self.tableView.isEditing = false
              do {
                try self.realm.write({
                  self.items[indexPath.row].title = stringToUpdate
                })
              }catch let error {
                print(error)
              }

              tableView.reloadData()
            }
          
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(edit)
        alert.addAction(cancel)
        alert.addTextField(configurationHandler: { (editTextField : UITextField!) -> Void in
            editTextField.text = description
            editTextField.keyboardType = .default
            editTextField.returnKeyType = UIReturnKeyType.send
            editTextField.autocorrectionType = .yes
        })
        self.present(alert, animated: true, completion: nil)
    }
    edit.backgroundColor = UIColor(red: 0.69, green: 0.85, blue: 0.80, alpha: 1.0)

    return [delete, edit]
  }

  // Share Multiple ** CRASHES HAPPENING HERE**
//  func getItemsToShare(completionHandler:@escaping (Bool) -> Void) {
//      if let rows = tableView.indexPathsForSelectedRows.map({$0.map{$0.row}}) {
//        self.stringToShare = "To Do: \n"
//          for row in rows {
//              let toDoItem: ToDoItem = self.toDoList[row]
//              let item = toDoItem.toDoListItem
//              stringToShare += item + "\n"
//          }
//          completionHandler(true)
//      }
//  }
}
