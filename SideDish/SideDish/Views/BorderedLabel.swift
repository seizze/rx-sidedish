//
//  CategoryLabel.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedLabel: UILabel {
    
    @IBInspectable var horizontalInset: CGFloat = 0
    @IBInspectable var verticalInset: CGFloat = 0
    
    @IBInspectable var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(horizontalInset: horizontalInset, verticalInset: verticalInset)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        let edgeInset = UIEdgeInsets(horizontalInset: horizontalInset, verticalInset: verticalInset)
        contentSize.height += edgeInset.top + edgeInset.bottom
        contentSize.width += edgeInset.left + edgeInset.right
        return contentSize
    }
}

private extension UIEdgeInsets {
    init(horizontalInset: CGFloat, verticalInset: CGFloat) {
        self.init(top: verticalInset,
                  left: horizontalInset,
                  bottom: verticalInset,
                  right: horizontalInset)
    }
}
