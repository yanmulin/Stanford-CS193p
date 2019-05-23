//
//  ImageGallery.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

struct ImageGallery: Codable {
    var name: String = ""
    var images: [Image] = []
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(_ name: String, _ images: [Image]) {
        self.name = name
        self.images = images
    }
    
    struct Image: Codable {
        var url: URL?
        var sizeRatio: Double?
    }
}
