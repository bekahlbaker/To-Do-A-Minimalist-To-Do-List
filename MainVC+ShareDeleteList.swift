//
//  MainVC+ShareDeleteList.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 12/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit

extension MainVC {

//Cancel Button
  
  func deleteButtonTapped() {
    let alert = UIAlertController(title: "Do you want to delete this list?", message: "You will not be able to get this list back after it is deleted.", preferredStyle: UIAlertControllerStyle.alert)
    let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
      do {
        try self.realm.write({
          self.realm.delete(self.lists[self.currentPage - 1])
        })
      }catch let error {
        print(error)
      }
      if self.currentPage != 1 {
        self.currentPage -= 1
      }
      self.setUpEachList(isDeletingList: true)
    })
    let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(yes)
    alert.addAction(no)
    alert.popoverPresentationController?.sourceView = self.view
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func shareButtonTapped() {
    var description = ["  " + lists[currentPage - 1].title]
    let itemsToShare = self.realm.objects(ToDoModel.self).filter("list = %@", currentPage).sorted(byKeyPath: "id", ascending: true)
    for item in itemsToShare {
      description.append(item.title)
    }
    let listToShare = description.joined(separator: "\n\u{2022} ")
    let controller = UIActivityViewController(activityItems: [listToShare], applicationActivities: [])
    present(controller, animated: true, completion: nil)
    if let popOver = controller.popoverPresentationController {
      popOver.sourceView = self.view
    }
  }
}
