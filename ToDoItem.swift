//
//  ToDoItem.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/2/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation

class ToDoItem {
  fileprivate var _toDoListItem: String!
  fileprivate var _completed: Bool!
  fileprivate var _itemID: String!
  var toDoListItem: String {
    return _toDoListItem
  }
  var completed: Bool {
    return _completed
  }
  var itemID: String {
    return _itemID
  }
  init(toDoListItem: String, completed: Bool, itemID: String) {
    self._toDoListItem = toDoListItem
    self._completed = completed
  }
  init(itemID: String, postData: [String: AnyObject]) {
    self._itemID = itemID
    if let toDoListItem = postData["item"] as? String {
      self._toDoListItem = toDoListItem
    }
    if let completed = postData["completed"] as? Bool {
      self._completed = completed
    }
  }
}
