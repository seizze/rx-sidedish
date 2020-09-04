//
//  SideDishCell.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class SideDishCell: UITableViewCell, Identifiable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var badgeView: BadgeView!
    @IBOutlet weak var roundImageView: RoundImageView!
    
    var sideDish: SideDish? = nil {
        didSet { configureCell() }
    }
    
    override func prepareForReuse() {
        badgeView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func configureCell() {
        titleLabel.text = sideDish?.title
        detailLabel.text = sideDish?.sideDishDescription
        normalPriceLabel.text = sideDish?.nPrice
        salePriceLabel.text = sideDish?.salePrice
        priceStackView.spacing = CGFloat(!(sideDish?.isOnSale ?? true) ? 4 : 0)
        sideDish?.badge?.forEach { badgeView.addBadge($0) }
        guard let url = sideDish?.image else { return }
        ImageUseCase().image(from: url) { image in
            DispatchQueue.main.async { self.roundImageView.image = image }
        }
    }
}
