//
//  RoundImageView.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    @IBInspectable var cornerRadius: Bool = false {
        didSet { layer.cornerRadius = frame.width / 2 }
    }
}
