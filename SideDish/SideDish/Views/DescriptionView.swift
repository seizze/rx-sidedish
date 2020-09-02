//
//  DescriptionView.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class DescriptionView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryInfoLabel: UILabel!
    
    var banchanDetail: BanchanDetail? {
        didSet { configureView() }
    }
    
    private func configureView() {
        guard let banchan = banchanDetail else { return }
        descriptionLabel.text = banchan.productDescription
        if banchan.prices.count > 1 {
            normalPriceLabel.text = banchan.prices[0]
            salePriceLabel.text = banchan.prices[1]
        } else {
            salePriceLabel.text = banchan.prices[0]
        }
        pointLabel.text = banchan.point
        deliveryFeeLabel.text = banchan.deliveryFee
        deliveryInfoLabel.text = banchan.deliveryInfo
    }
}
