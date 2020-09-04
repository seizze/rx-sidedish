//
//  SideDishViewModel.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/23.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

struct SideDishListChangeDetails {
    
    let section: Int?
    let overallData: [Int: [SideDish]]
}

extension SideDishListChangeDetails {
    
    init(with data: [Int: [SideDish]]) {
        section = nil
        overallData = data
    }
}

class SideDishViewModel: NSObject, ViewModelBinding {
    
    typealias Key = SideDishListChangeDetails?
    
    private var change: Key = nil {
        didSet { changeHandler(change) }
    }
    
    private var changeHandler: (Key) -> Void
    
    init(with categorizedSideDish: Key = nil, handler: @escaping (Key) -> Void = { _ in }) {
        self.changeHandler = handler
        self.change = SideDishListChangeDetails(with: [Int: [SideDish]]())
        changeHandler(categorizedSideDish)
    }
    
    func update(categorizedSideDish: Key) {
        self.change = categorizedSideDish
    }
    
    func updateNotify(handler: @escaping (Key) -> Void) {
        changeHandler = handler
    }
    
    func append(key: Int, value: [SideDish]) {
        guard var data = change?.overallData else { return }
        data[key] = value
        change = SideDishListChangeDetails(section: key, overallData: data)
    }
    
    func sideDish(category: Int, index: Int) -> SideDish? {
        return change?.overallData[category]?[index]
    }
    
    func count(of category: Int) -> Int {
        return change?.overallData[category]?.count ?? 0
    }
}

extension SideDishViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideDishCell.identifier, for: indexPath) as? SideDishCell else { return SideDishCell() }
        cell.sideDish = sideDish(category: indexPath.section, index: indexPath.row)
        return cell
    }
}
