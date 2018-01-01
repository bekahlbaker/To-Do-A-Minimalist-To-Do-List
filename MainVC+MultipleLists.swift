//
//  MainVC+MultipleLists.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 12/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension MainVC {
 
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    textFieldIsNotSelected()
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.right:
        if currentPage > 1 {
          currentPage -= 1
          setUpEachList(isDeletingList: false)
        }
      case UISwipeGestureRecognizerDirection.left:
        currentPage += 1
        setUpEachList(isDeletingList: false)
      default:
        break
      }
    }
  }
  
  @objc func setUpEachList(isDeletingList: Bool) {
    self.pages = []
    self.lists = self.realm.objects(ListModel.self).sorted(byKeyPath: "id", ascending: true)
    print("LISTS", self.lists)
    if lists.count >= currentPage {
      currentListID = lists[currentPage - 1].id
      self.items = self.realm.objects(ToDoModel.self).filter("list = %@", currentListID).sorted(byKeyPath: "id", ascending: true)
    }
    
    var x = 1
    for list in lists {
      self.pages.append(x)
      x += 1
      print(list)
    }
    
    let pagesString = self.pages.map { String($0) }.joined(separator: "  ")
    let substring = "\(currentPage)"

    if pagesString.contains(substring) {
      let range = (pagesString as NSString).range(of: substring)
      let attributeString = NSMutableAttributedString(string: pagesString)
      attributeString.addAttribute(NSAttributedStringKey.font,
                                   value: UIFont(
                                    name: "AmericanTypewriter-Bold",
                                    size: 17.0)!, range: range)
      self.pageLabel.attributedText = attributeString
    }

    tableView.reloadData()
    
      if lists.count >= currentPage {
        titleLabel.text = lists[currentPage - 1].title
        titleTextField.text = lists[currentPage - 1].title
      } else {
        if !isDeletingList {
          titleLabel.text = ""
          titleTextField.text = ""
          
          UIView.animate(withDuration: 0.3) {
            self.settingsContentView.alpha = 0
            self.settingsView.alpha = 1
          }
          
          let alert = UIAlertController(title: "Do you want to create a new list?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
          let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.isCreatingNewList = true
            UIView.animate(withDuration: 0.3) {
              self.settingsContentView.alpha = 1
            }
          })
          let no = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.isCreatingNewList = false
            if self.currentPage > 1 {
              self.currentPage -= 1
              self.settingsView.alpha = 0
              self.setUpEachList(isDeletingList: false)
            }
          })
          alert.addAction(yes)
          alert.addAction(no)
          alert.popoverPresentationController?.sourceView = self.view
          
          self.present(alert, animated: true, completion: nil)
      }
    }
  }
}
