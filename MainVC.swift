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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBAction func reloadBtnTapped(_ sender: Any) {
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBAction func addBtnTapped(_ sender: Any) {
        if self.textField.text != "" {
            if let newItemString = self.textField.text {
                uploadNewToDoItem(item: newItemString)
            }
        } else {
            print("No item to upload")
        }
        self.textFieldIsNotSelected()
    }
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.tableView.setEditing(false, animated: true)
        if self.isSelectingToShare {
            self.isSelectingToShare = false
        }
        if self.isSelectingToDelete {
            self.isSelectingToDelete = false
        }
        self.shareBtn.setImage(UIImage(named: "more-dots"), for: .normal)
        self.shareBtn.setTitle(nil, for: .normal)
        self.cancelBtn.alpha = 0
    }
    var isSelectingToShare = false
    var isSelectingToDelete = false
    var stringToShare = ""
    @IBOutlet weak var shareBtn: UIButton!
    @IBAction func shareBtnTapped(_ sender: Any) {
        if !isSelectingToShare && !isSelectingToDelete {
            let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
            let share = UIAlertAction(title: "Share", style: .default, handler: { (_) -> Void in
                //share action
                self.cancelBtn.alpha = 1
                self.isSelectingToShare = true
                self.tableView.setEditing(true, animated: true)
                self.shareBtn.setTitle("Share", for: .normal)
                self.shareBtn.setImage(nil, for: .normal)
            })
            alert.addAction(share)
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) -> Void in
                //delete action
                self.cancelBtn.alpha = 1
                self.isSelectingToDelete = true
                self.tableView.setEditing(true, animated: true)
                self.shareBtn.setTitle("Delete", for: .normal)
                self.shareBtn.setImage(nil, for: .normal)
            })
            alert.addAction(delete)
            let  cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) -> Void in
            }
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else if isSelectingToShare {
            self.getItemsToShare { (successGettingItemsToShare) in
                if successGettingItemsToShare {
                    let controller = UIActivityViewController(activityItems: [self.stringToShare], applicationActivities: nil)
                    self.present(controller, animated: true, completion: nil)
                    self.tableView.setEditing(false, animated: true)
                    self.isSelectingToShare = false
                    self.shareBtn.setImage(UIImage(named: "more-dots"), for: .normal)
                    self.cancelBtn.alpha = 0
                } else {
                    print("Unable to get items to share")
                }
            }
        } else if isSelectingToDelete {
                let alert = UIAlertController(title: "Are you sure you want to delete these items?", message: "You will not be able to get these back once they are deleted.", preferredStyle: UIAlertControllerStyle.alert)
                let yes = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    self.getItemsToDelete { (successDeleting) in
                        if successDeleting {
                            self.tableView.reloadData()
                            self.tableView.setEditing(false, animated: true)
                            self.isSelectingToDelete = false
                            self.shareBtn.setImage(UIImage(named: "more-dots"), for: .normal)
                            self.cancelBtn.alpha = 0
                        } else {
                            print("Unable to delete data, try again")
                        }
                    }
                })
                let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }
    }
    var toDoList = [ToDoItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 45
        tableView.isEditing = false
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        addBtn.alpha = 0
        reloadBtn.alpha = 0
        activitySpinner.alpha = 0
        cancelBtn.alpha = 0
        anonymouslyLoginOrCreateUserInFirebase()
    }
}
