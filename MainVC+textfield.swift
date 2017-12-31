//
//  MainVC+textfield.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/5/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit

extension MainVC {
  func textFieldIsNotSelected() {
    self.view.endEditing(true)
    self.textField.resignFirstResponder()
    self.textField.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    self.textField.text = "Add a to-do item..."
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.textField.text = ""
    self.textField.textColor = UIColor.black
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == self.textField {
      if self.textField.text != "" && self.textField.text != "Add a to-do item..." {
        if let newItemString = self.textField.text {
          let newItem = ToDoModel()
          newItem.title = newItemString
          newItem.id = Int(NSDate().timeIntervalSince1970 * 10000)
          newItem.list = currentPage
          do {
            try self.realm.write({
              self.realm.add(newItem, update: true)
            })
          }catch let error {
            print(error)
          }
          
          tableView.reloadData()
        }
      } else {
        print("No item to upload")
      }
    }
    self.textFieldIsNotSelected()
    return true
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      textFieldIsNotSelected()
  }
}
