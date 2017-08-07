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
        self.textField.resignFirstResponder()
        self.textField.text = "Add a to-do item..."
        self.addBtn.alpha = 0
    }
    func textFieldIsSelected() {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.text = ""
        self.addBtn.alpha = 1
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textField.text != "" && self.textField.text != "Add a to-do item..." {
            if let newItemString = self.textField.text {
                uploadNewToDoItem(item: newItemString)
            }
        } else {
            print("No item to upload")
        }
        if self.view.endEditing(true) {
            self.textFieldIsNotSelected()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldIsNotSelected()
    }
}
