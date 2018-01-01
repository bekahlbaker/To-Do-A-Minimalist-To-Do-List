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
  var currentListTheme = ""
  var isCreatingNewList = false
  var isTyping = false
  var selectedTheme = "light"
  
  // Setup for Themes
  let PINK = UIColor(red:0.98, green:0.89, blue:0.88, alpha:1.0)
  let GOLD = UIColor(red:0.69, green:0.58, blue:0.43, alpha:1.0)
  let GRAY = UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.0)
  let NAVY = UIColor(red:0.13, green:0.19, blue:0.25, alpha:1.0)
  
  @IBOutlet var mainBackgroundView: UIView!
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var thinLineView: UIView!
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var trashButton: UIButton!
  @IBOutlet weak var paginationLabel: UILabel!
  
  @IBOutlet weak var lightThemeButton: UIButton!
  @IBAction func lightThemeButtonTapped(_ sender: Any) {
    showThemeWasSelected(selectedButton: lightThemeButton)
    showThemeWasUnselected(unselectedButton: darkThemeButton)
    selectedTheme = "light"
  }
  
  @IBOutlet weak var darkThemeButton: UIButton!
  @IBAction func darkThemeButtonTapped(_ sender: Any) {
    showThemeWasSelected(selectedButton: darkThemeButton)
    showThemeWasUnselected(unselectedButton: lightThemeButton)
    selectedTheme = "dark"
  }
  
  // Onboarding
  @IBOutlet weak var onboardingView: UIVisualEffectView!
  @IBAction func gotItButtonTapped(_ sender: Any) {
    onboardingView.alpha = 0
  }
  
  // Settings
  @IBOutlet weak var settingsContentView: RoundedView!
  @IBOutlet weak var cancelSettingsView: UIButton!
  @IBAction func cancelSettingsButtonTapped(_ sender: Any) {
    handleCancelSettingsButton()
  }
  @IBOutlet weak var settingsView: UIVisualEffectView!
  @IBAction func settingsButtonTapped(_ sender: Any) {
    UIView.animate(withDuration: 0.3) {
      self.settingsView.alpha = 1
      self.settingsContentView.alpha = 1
    }
  }
  @IBAction func helpButtonTapped(_ sender: Any) {
    onboardingView.alpha = 1
  }
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBAction func saveButtonTapped(_ sender: Any) {
    handleSaveButton()
  }
  
  //Tableview Setup
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
