//
//  ToDoCell.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/2/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
var completed: Bool!
var itemID: String!
@IBOutlet weak var roundedView: RoundedView!
@IBOutlet weak var toDoLabel: UILabel!

override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}
func configureCell(toDoItem: ToDoModel) {
  self.toDoLabel.text = toDoItem.title;
  self.completed = toDoItem.completed;

  if !self.completed {
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.toDoLabel.text!)
    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
    self.toDoLabel.attributedText = attributeString
    self.roundedView.backgroundColor = UIColor.white
  } else {
    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.toDoLabel.text!)
    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    self.toDoLabel.attributedText = attributeString
    self.roundedView.backgroundColor = UIColor.init(red: 0.87, green: 0.84, blue: 0.82, alpha: 1.0)
    }
  }
  
  func configureCellWithToDoItem(toDoItem: ToDoItem) {
    self.toDoLabel.text = toDoItem.toDoListItem;
    self.completed = toDoItem.completed;
    self.itemID = toDoItem.itemID;
    
    if !self.completed {
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.toDoLabel.text!)
      attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
      self.toDoLabel.attributedText = attributeString
      self.roundedView.backgroundColor = UIColor.white
    } else {
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.toDoLabel.text!)
      attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
      self.toDoLabel.attributedText = attributeString
      self.roundedView.backgroundColor = UIColor.init(red: 0.87, green: 0.84, blue: 0.82, alpha: 1.0)
    }
  }
}
