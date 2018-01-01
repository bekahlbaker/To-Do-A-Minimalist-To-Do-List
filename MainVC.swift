//
//  MainVC.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/2/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import RealmSwift

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
  let toDoItem = ToDoModel()
  var items: Results<ToDoModel>! = nil
  let realm = try! Realm()
  var currentPage = 1
  var list = ListModel()
  var lists: Results<ListModel>! = nil
  var currentListID = Int()
  var isCreatingNewList = false
  var isTyping = false

  @IBOutlet weak var settingsContentView: RoundedView!
  @IBOutlet weak var cancelSettingsView: UIButton!
  @IBAction func cancelSettingsButtonTapped(_ sender: Any) {
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
  @IBOutlet weak var settingsView: UIVisualEffectView!
  @IBAction func settingsButtonTapped(_ sender: Any) {
    UIView.animate(withDuration: 0.3) {
      self.settingsView.alpha = 1
      self.settingsContentView.alpha = 1
    }
  }
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonTapped(_ sender: Any) {
    let newList = ListModel()
    newList.id = Int(NSDate().timeIntervalSince1970)
    newList.title = titleTextField.text!
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
  

  @IBAction func deleteButtonTapped(_ sender: Any) {
    deleteButtonTapped()
  }
  
  
  @IBAction func shareButtonTapped(_ sender: Any) {
    shareButtonTapped()
  }
  

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var pageLabel: UILabel!
  var pages = [Int]()


  
// View Did Load
  var toDoList = [ToDoItem]()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 45
    tableView.isEditing = false
    textField.delegate = self
    titleTextField.delegate = self
    textField.returnKeyType = UIReturnKeyType.done
    titleTextField.returnKeyType = UIReturnKeyType.done
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    self.view.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    self.view.addGestureRecognizer(swipeRight)
    print("VIEW DID LOAD")
    transferItemsFromFirebaseToRealm()
    self.items = self.realm.objects(ToDoModel.self).filter("list = %@", currentPage).sorted(byKeyPath: "id", ascending: true)
//    UserDefaults.standard.set(false, forKey: "hasTransferredFromFirebaseToRealm")
  }
}
