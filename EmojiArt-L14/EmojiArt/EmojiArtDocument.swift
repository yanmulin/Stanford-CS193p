//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument {
    var emojiArt: EmojiArt?
    
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
    }
}
