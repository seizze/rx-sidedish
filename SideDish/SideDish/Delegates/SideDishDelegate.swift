//
//  SideDishDelegate.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class SideDishDelegate: NSObject {
    
    private let categories = [0: "든든한 반찬", 1: "국∙찌개", 2: "밑반찬"]
    private let titles = [
        0: "언제 먹어도 든든한 반찬",
        1: "김이 모락모락 국∙찌개",
        2: "언제 먹어도 든든한 밑반찬"
    ]
}

extension SideDishDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SideDishHeaderView.identifier) as? SideDishHeaderView else { return UIView() }
        view.titleLabel.text = titles[section]
        view.categoryLabel.text = categories[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
