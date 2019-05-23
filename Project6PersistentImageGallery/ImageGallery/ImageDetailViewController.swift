//
//  ImageDetailViewController.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/20.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var imageUrl: URL? {
        didSet {
            if let url = imageUrl {
                spinningWheel?.isHidden = false
                fetchImage(with: url) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageView.sizeToFit()
                        self.scrollView.contentSize = image.size
                        self.scrollView.zoomScale = min(self.scrollView.bounds.width / image.size.width , self.scrollView.frame.height / image.size.height)
                        self.spinningWheel.isHidden = true
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var spinningWheel: UIActivityIndicatorView!
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.5
            scrollView.delegate = self
        }
    }
    private var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    func fetchImage(with url: URL, _ completionHandler: @escaping (UIImage)->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completionHandler(image)
                }
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
