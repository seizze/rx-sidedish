//
//  BanchanHeaderView.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class BanchanHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var categoryLabel: BorderedLabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = UIColor.white
        backgroundView?.alpha = 0.8
    }
}
