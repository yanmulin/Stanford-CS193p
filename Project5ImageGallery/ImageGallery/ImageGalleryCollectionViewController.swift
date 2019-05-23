//
//  ImageGalleryCollectionViewController.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/19.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:))))
    }
    
    var gallery: ImageGallery?
    
    func fetchImage(_ url: URL, completionHandler: @escaping (URL, UIImage)->Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completionHandler(url, image)
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.images.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let imageCell = cell as? ImageCell {
            imageCell.image = nil
            if let url = gallery?.images[indexPath.row].url {
                fetchImage(url) { (url, image) in
                    DispatchQueue.main.async {
                        imageCell.image = image
                    }
                }
            }
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    var cellWidth: CGFloat = 200.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: CGFloat(gallery?.images[indexPath.row].sizeRatio ?? 1.0) * cellWidth)
    }
    
    
    // MARK: Drag/Drop
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(indexPath)
    }
    
    func dragItems(_ indexPath: IndexPath) -> [UIDragItem] {
        if let url = gallery?.images[indexPath.row].url as NSURL? {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: url))
            dragItem.localObject = url
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return gallery != nil && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertIntoDestinationIndexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if gallery != nil {
            var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: gallery!.images.count, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    collectionView.performBatchUpdates({
                        let image = self.gallery!.images.remove(at: sourceIndexPath.row)
                        if destinationIndexPath.row > gallery!.images.count {
                            destinationIndexPath = IndexPath(row: gallery!.images.count, section: 0)
                        }
                        gallery!.images.insert(image, at: destinationIndexPath.row)
                        self.collectionView.deleteItems(at: [sourceIndexPath])
                        self.collectionView.insertItems(at: [destinationIndexPath])
                        
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                } else {
                    let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(
                            insertionIndexPath: destinationIndexPath,
                            reuseIdentifier: "loadingImageCell"
                        )
                    )
                    
                    var newValue = ImageGallery.Image()
                    
                    item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (itemProvider, error) in
                        DispatchQueue.main.async {
                            if let image = itemProvider as? UIImage {
                                newValue.sizeRatio = Double(image.size.height / image.size.width)
                                if newValue.url != nil, newValue.sizeRatio != nil { placeholderContext.commitInsertion(dataSourceUpdates: { insertIndexPath in
                                        self.gallery!.images.insert(newValue, at: self.gallery!.images.count)
                                    })
                                }
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }

                    item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (itemProvider, error)  in
                        DispatchQueue.main.async {
                            if let url = itemProvider as? URL {
                                newValue.url = url.imageURL
                                if newValue.url != nil, newValue.sizeRatio != nil {
                                    placeholderContext.commitInsertion(dataSourceUpdates: { insertIndexPath in
                                        self.gallery!.images.insert(newValue, at: self.gallery!.images.count)
                                    })
                                }
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageDetail" {
            if let vc = segue.destination as? ImageDetailViewController {
                if let cell = sender as? UICollectionViewCell, let row = collectionView.indexPath(for: cell)?.row {
                    vc.imageUrl = gallery?.images[row].url
                }
            }
        }
    }
    
    // MARK: actions
    @objc func pinch(_ gr: UIPinchGestureRecognizer) {
        switch gr.state {
        case .began, .changed:
            cellWidth = cellWidth * gr.scale
            gr.scale = 1.0
            flowLayout?.invalidateLayout()
        default: break
        }
    }
}

extension UICollectionViewController {
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
}
