//
//  BadgeView.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

@IBDesignable
class BadgeView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 19)
    }
    
    func addBadge(_ badge: Badge) {
        let view = BadgeLabel()
        view.setColor(to: UIColor.badgePurple)
        view.setText(to: badge.name)
        addArrangedSubview(view)
    }
}
