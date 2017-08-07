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
//    func checkIfHasTransferredDataToNewDatabaseOnce() {
//        if UserDefaults.standard.bool(forKey: "hasTransferredDataToNewDatabaseOnce") {
//            print("NOT first launch")
//            //Login to Firebase and download Data
//            anonymouslyLoginOrCreateUserInFirebase()
//        } else {
//            print("FIRST launch")
//            UserDefaults.standard.set(true, forKey: "hasTransferredDataToNewDatabaseOnce")
//            UserDefaults.standard.synchronize()
//            //1. Login user to Heroku and download Data (save all)
//            //2. Upload new user to FB with old UID and upload Data
//            //3. login user to FB and download Data
//            transferDataFromHerokuToFirebase()
//        }
//    }
//    func transferDataFromHerokuToFirebase() {
//        let httpServiceInstance: HTTPService = HTTPService()
//        //Login user to Heroku
//        if let UID = httpServiceInstance.anonymouslyLoginUser() {
//            print("UID FROM OLD DATABASE: \(UID)")
//            //Create new user in FB with UID from Heroku
//            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
//                print("AUTH IS RUNNING")
//                if error != nil {
//                    print("There was an error logging in anonymously")
//                    print(error as Any)
//                } else {
//                    print("We are now logged in")
//                    let uid = UID
//                    let userData = ["provider": user?.providerID]
//                    DataService.ds.completeSignIn(uid, userData: (userData as? [String: String])!)
//                }
//                //download data from FB and reload table
//                if httpServiceInstance.downloadDataFromHerokuAndUploadToFirebase() {
//                    self.downloadData(completionHandler: { (success) in
//                        if success {
//                            self.tableView.reloadData()
//                        } else {
//                            print("ERROR")
//                        }
//                    })
//                }
//            })
//        }
//    }
    func uploadNewToDoItem(item: String) {
        let newItem: [String: Any] = [
            "item": item as String,
            "completed": false
        ]
        DataService.ds.REF_CURRENT_USER.childByAutoId().setValue(newItem)
        self.downloadData { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    func anonymouslyLoginOrCreateUserInFirebase() {
        //        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        //        try! FIRAuth.auth()?.signOut()
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            let currentUser = KeychainWrapper.standard.string(forKey: KEY_UID)! as String
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
        self.toDoList = []
        DispatchQueue.global().async {
//            let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
//            connectedRef.observeSingleEvent(of: .value, with: { snapshot in
//                if let connected = snapshot.value as? Bool, connected {
//                    print("Connected")
//                    self.activitySpinner.stopAnimating()
                    DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            for snap in snapshot {
                                if let dict = snap.value as? [String: AnyObject] {
                                    let itemID = snap.key
                                    let item = ToDoItem(itemID: itemID, postData: dict)
                                    self.toDoList.insert(item, at: 0)
                                    if self.toDoList.count > 0 {
                                        completionHandler(true)
                                    }
                                }
                            }
                        }
                    })
//                } else {
//                    print("Not connected")
//                    
//                }
//            })
        }
    }
}
