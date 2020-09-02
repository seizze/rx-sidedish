//
//  ImageCollectionViewModel.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

struct ImagesChangeDetails {
    let index: Int?
    let images: [Int: UIImage]
}

extension ImagesChangeDetails {
    init() {
        index = nil
        images = [:]
    }
}

class ImageCollectionViewModel: ViewModelBinding {
    typealias Key = ImagesChangeDetails?
    
    private var imagesChageDetails: Key = nil {
        didSet { changeHandler(imagesChageDetails) }
    }
    
    private var changeHandler: (Key) -> Void
    
    init(with images: Key = ImagesChangeDetails(), handler: @escaping (Key) -> Void = { _ in }) {
        self.changeHandler = handler
        self.imagesChageDetails = images
        changeHandler(images)
    }
    
    func update(images: Key) {
        self.imagesChageDetails = images
    }
    
    func updateNotify(handler: @escaping (Key) -> Void) {
        self.changeHandler = handler
    }
    
    func add(_ image: UIImage, at index: Int) {
        guard var images = imagesChageDetails?.images else { return }
        images[index] = image
        imagesChageDetails = ImagesChangeDetails(index: index, images: images)
    }
}
