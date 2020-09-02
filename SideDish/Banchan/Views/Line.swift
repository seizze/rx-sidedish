//
//  Line.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

@IBDesignable
class Line: UIView {
    
    @IBInspectable var borderColor: UIColor? {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        let centerY = frame.height / 2
        aPath.move(to: CGPoint(x: 0, y: centerY))
        aPath.addLine(to: CGPoint(x: frame.width, y: centerY))
        aPath.close()
        borderColor!.set()
        aPath.lineWidth = borderWidth
        aPath.stroke()
    }
}
