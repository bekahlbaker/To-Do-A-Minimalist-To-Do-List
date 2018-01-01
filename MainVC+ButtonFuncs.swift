//
//  MainVC+ButtonFuncs.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 1/1/18.
//  Copyright © 2018 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit

extension MainVC {
  
  func handleCancelSettingsButton() {
    if isCreatingNewList {
      if self.currentPage > 1 {
        self.currentPage -= 1
        settingsView.alpha = 0
        self.setUpEachList(isDeletingList: false)
      }
    } else {
      UIView.animate(withDuration: 0.3) {
        self.settingsView.alpha = 0
      }
    }
    self.view.endEditing(true)

  }
  
  func handleSaveButton() {
    let newList = ListModel()
    newList.id = isCreatingNewList ? Int(NSDate().timeIntervalSince1970) : currentListID
    newList.title = titleTextField.text!
    newList.theme = selectedTheme
    do {
      try self.realm.write({
        self.realm.add(newList, update: true)
        self.isCreatingNewList = false
        self.lists = self.realm.objects(ListModel.self).sorted(byKeyPath: "id", ascending: true)
      })
    } catch let error {
      print(error)
    }
    UIView.animate(withDuration: 0.3) {
      self.settingsView.alpha = 0
    }
    self.view.endEditing(true)
    setUpEachList(isDeletingList: false)
  }

}
