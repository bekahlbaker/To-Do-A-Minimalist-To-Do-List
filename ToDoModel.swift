//
//  ToDoModel.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 12/7/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoModel: Object {
  
  @objc dynamic var title: String!
  @objc dynamic var completed = false
  @objc dynamic var id = 0
  @objc dynamic var list = 1
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
