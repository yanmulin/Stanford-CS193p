//
//  GalleryTableViewCell.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/20.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var cellText: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var renameHandler: ((String?)->Void)?

    @IBOutlet private weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
        textField.delegate = self
        textField.isEnabled = false
    }
    
    @objc func tap(_ gr: UITapGestureRecognizer) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        if let renameHandler = renameHandler {
            renameHandler(cellText)
        }
    }

}
