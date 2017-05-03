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
    @IBOutlet weak var checkBtn: UIButton!
    @IBAction func checkBtnTapped(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(toDoItem: ToDoItem) {
        self.toDoLabel.text = toDoItem.toDoListItem;
        self.completed = toDoItem.completed;
        self.itemID = toDoItem.itemID;
        
        if !self.completed {
            self.checkBtn.setImage(UIImage(named: "Check-Empty"), for: .normal)
            self.roundedView.backgroundColor = UIColor.white
        } else {
            self.checkBtn.setImage(UIImage(named: "check"), for: .normal)
            self.roundedView.backgroundColor = UIColor.init(colorLiteralRed: 0.87, green: 0.84, blue: 0.82, alpha: 1.0)
        }
    }
}
