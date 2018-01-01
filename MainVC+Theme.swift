//
//  MainVC+Theme.swift
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 1/1/18.
//  Copyright © 2018 Rebekah Baker. All rights reserved.
//

import Foundation
import UIKit

extension MainVC {
  
  func setUpTheme(theme: String) {
    if theme == "light" {
      mainBackgroundView.backgroundColor = PINK
      settingsButton.setImage(UIImage(named: "settings-light"), for: .normal)
      thinLineView.backgroundColor = GOLD
      shareButton.setImage(UIImage(named: "share-light"), for: .normal)
      trashButton.setImage(UIImage(named: "trash-light"), for: .normal)
      paginationLabel.textColor = GOLD
      
    } else if theme == "dark" {
      mainBackgroundView.backgroundColor = GRAY
      settingsButton.setImage(UIImage(named: "settings-dark"), for: .normal)
      thinLineView.backgroundColor = NAVY
      shareButton.setImage(UIImage(named: "share-dark"), for: .normal)
      trashButton.setImage(UIImage(named: "trash-dark"), for: .normal)
      paginationLabel.textColor = NAVY
    }
  }
  
  func showThemeWasSelected(selectedButton: UIButton) {
    selectedButton.layer.borderColor = UIColor.black.cgColor
    selectedButton.layer.borderWidth = 1
  }
  
  func showThemeWasUnselected(unselectedButton: UIButton) {
    unselectedButton.layer.borderWidth = 0
  }
}
