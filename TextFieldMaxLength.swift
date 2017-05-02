//
//  TextFieldMaxLengths.swift
//  PetApp
//
//  Created by Rebekah Baker on 11/18/16.
//  Copyright © 2016 Rebekah Baker. All rights reserved.
//
// swiftlint:disable line_length
//www.globalnerdy.com/2016/05/18/ios-programming-trick-how-to-use-xcode-to-set-a-text-fields-maximum-length-visual-studio-style/

import UIKit

private var maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    func limitLength(_ textField: UITextField) {
        guard let prospectiveText = textField.text,
            prospectiveText.characters.count > maxLength
            else {
                return
        }
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}
