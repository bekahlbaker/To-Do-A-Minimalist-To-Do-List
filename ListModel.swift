//
//  ListModel.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 12/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import RealmSwift

class ListModel: Object {
  
  @objc dynamic var title = "New List"
  @objc dynamic var id = 1
  @objc dynamic var theme = "light"
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  
}
