//
//  EmojiArt.swift
//  EmojiArt-L11
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

struct EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    struct EmojiInfo: Codable {
        var x: Int
        var y: Int
        var size: Int
        var text: String
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
