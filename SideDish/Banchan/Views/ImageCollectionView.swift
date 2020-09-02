//
//  ImageCollectionView.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class ImageCollectionView: UIStackView {
    
    func configure(imageCount: Int, width: CGFloat? = nil, height: CGFloat? = nil) {
        (0..<imageCount).forEach { _ in
            let view = UIImageView()
            if let width = width { view.widthAnchor.constraint(equalToConstant: width).isActive = true }
            if let height = height { view.heightAnchor.constraint(equalToConstant: height).isActive = true }
            view.backgroundColor = .lightGray
            view.contentMode = .scaleAspectFill
            self.addArrangedSubview(view)
        }
    }
    
    func update(_ image: UIImage?, at index: Int) {
        guard let imageView = arrangedSubviews[index] as? UIImageView else { return }
        imageView.image = image
    }
    
    func fitImage(at index: Int) {
        guard let view = arrangedSubviews[index] as? UIImageView, let image = view.image else { return }
        let aspectRatio = image.size.width / image.size.height
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio).isActive = true
    }
}
