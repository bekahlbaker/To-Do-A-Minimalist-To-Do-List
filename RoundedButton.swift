//
//  RoundedButton.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 12/8/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 8
  }

}
