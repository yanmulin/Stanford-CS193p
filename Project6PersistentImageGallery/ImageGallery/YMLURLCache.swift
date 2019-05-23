//
//  YMLURLCache.swift
//  ImageGallery
//
//  Created by 颜木林 on 2019/5/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class YMLURLCache: URLCache {
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let response = super.cachedResponse(for: request)
        if response == nil {
            print("cachedResponse(for:): not cached \(request.url?.path ?? "")")
        } else {
            print("cachedResponse(for:): did cache \(request.url?.path ?? "")")
        }
        return response
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        super.storeCachedResponse(cachedResponse, for: request)
        print("storeCachedResponse(_:for:): \(request.url?.path ?? "")")
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask) {
        super.storeCachedResponse(cachedResponse, for: dataTask)
        print("storeCachedResponse(_:for:) dataTask")
    }
    
    static var cachePath: String {
        return "MyCache"
    }

}
