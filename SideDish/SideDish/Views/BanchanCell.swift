//
//  BanchanCell.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class BanchanCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var badgeView: BadgeView!
    @IBOutlet weak var banchanImageView: RoundImageView!
    
    var banchan: Banchan? = nil {
        didSet { configureCell() }
    }
    
    override func prepareForReuse() {
        badgeView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func configureCell() {
        titleLabel.text = banchan?.title
        detailLabel.text = banchan?.banchanDescription
        normalPriceLabel.text = banchan?.nPrice
        salePriceLabel.text = banchan?.salePrice
        priceStackView.spacing = CGFloat(!(banchan?.isOnSale ?? true) ? 4 : 0)
        banchan?.badge?.forEach { badgeView.addBadge($0) }
        guard let url = banchan?.image else { return }
        ImageUseCase().image(from: url) { image in
            DispatchQueue.main.async { self.banchanImageView.image = image }
        }
    }
}
