//
//  ImageGallery.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

class ImageGallery {
    var name: String = ""
    var images: [Image] = []
    
    struct Image {
        var url: URL?
        var sizeRatio: Double?
    }
}
