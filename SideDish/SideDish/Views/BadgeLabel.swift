//
//  BadgeLabel.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class BadgeLabel: BorderedLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        horizontalInset = 4
        verticalInset = 1
        textColor = .white
        font = font.withSize(10)
    }
    
    func setColor(to color: UIColor) {
        backgroundColor = color
    }
    
    func setText(to text: String) {
        self.text = text
    }
}
