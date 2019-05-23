//
//  AddingEmojiTextFieldCell.swift
//  EmojiArt-L11
//
//  Created by 颜木林 on 2019/5/18.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class AddingEmojiTextFieldCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var resignationHandler: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
}
