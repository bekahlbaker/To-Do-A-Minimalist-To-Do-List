//
//  MainVC+LoginUser.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/3/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

extension MainVC {
  
  func transferItemsFromFirebaseToRealm() {
    if UserDefaults.standard.bool(forKey: "hasTransferredFromFirebaseToRealm") {
        print("NOT first launch")
      self.onboardingView.alpha = 0
      setUpEachList(isDeletingList: false)
    } else {
      print("FIRST launch")
  //1. Login User and Download Data
  //2. Save to Realm
      self.onboardingView.alpha = 1
      self.anonymouslyLoginOrCreateUserInFirebase()
    }
  }
  
  func anonymouslyLoginOrCreateUserInFirebase() {
    if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
      downloadData { (successDownloadingData) in
        if successDownloadingData {
        self.tableView.reloadData()
        print("Reload Table for login")
    } else {
        print("Unable to download data, try again")
    }
  }
  } else {
  FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
    if error != nil {
        print("There was an error logging in anonymously")
        print(error as Any)
    } else {
        print("We are now logged in")
        let uid = user!.uid
        let userData = ["provider": user?.providerID]
        DataService.ds.completeSignIn(uid, userData: (userData as? [String: String])!)
        self.downloadData { (successDownloadingData) in
            if successDownloadingData {
                self.tableView.reloadData()
                print("Reload Table for Sign up new user")
            } else {
                print("Unable to download data, try again")
            }
          }
        }
      })
    }
  }
  
  func downloadData(completionHandler:@escaping (Bool) -> Void) {
    print("DOWNLOADING DATA")
    self.toDoList = []
    DataService.ds.REF_CURRENT_USER.keepSynced(true)
      DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
          print("SNAPSHOT", snapshot)
          let newList = ListModel()
          do {
            try self.realm.write({
              self.realm.add(newList, update: true)
              print("NEW LIST", newList)
            })
          }catch let error {
            print(error)
          }
          for snap in snapshot {
            if let dict = snap.value as? [String: AnyObject] {
              let newItem = ToDoModel()
              newItem.title = dict["item"] as! String
              let completed: Int = (dict["completed"] as! Int)
              if completed == 0 {
                newItem.completed = false
              } else {
                newItem.completed = true
              }
              newItem.id = Int(NSDate().timeIntervalSince1970 * 10000)
              do {
                try self.realm.write({
                  self.realm.add(newItem, update: true)
                  print(newItem)
                })
              }catch let error {
                print(error)
                 self.anonymouslyLoginOrCreateUserInFirebase()
              }
            }
        }
          UserDefaults.standard.set(true, forKey: "hasTransferredFromFirebaseToRealm")
          UserDefaults.standard.synchronize()
          self.setUpEachList(isDeletingList: false)
      }
      })
  }
}
