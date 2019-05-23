//
//  ImageCell.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            spinningWheel.isHidden = (newValue != nil)
            imageView.image = newValue
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var spinningWheel: UIActivityIndicatorView!
    
}
