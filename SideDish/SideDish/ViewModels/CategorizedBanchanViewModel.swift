//
//  CategorizedBanchanViewModel.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/23.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

struct BanchanChangeDetails {
    let section: Int?
    let overallData: [Int: [Banchan]]
}

extension BanchanChangeDetails {
    init(with data: [Int: [Banchan]]) {
        section = nil
        overallData = data
    }
}

class CategorizedBanchanViewModel: NSObject, ViewModelBinding {
    typealias Key = BanchanChangeDetails?
    
    private var banchanChange: Key = nil {
        didSet { changeHandler(banchanChange) }
    }
    
    private var changeHandler: (Key) -> Void
    
    init(with categorizedBanchan: Key = nil, handler: @escaping (Key) -> Void = { _ in }) {
        self.changeHandler = handler
        self.banchanChange = BanchanChangeDetails(with: [Int: [Banchan]]())
        changeHandler(categorizedBanchan)
    }
    
    func update(categorizedBanchan: Key) {
        self.banchanChange = categorizedBanchan
    }
    
    func updateNotify(handler: @escaping (Key) -> Void) {
        changeHandler = handler
    }
    
    func append(key: Int, value: [Banchan]) {
        guard var data = banchanChange?.overallData else { return }
        data[key] = value
        banchanChange = BanchanChangeDetails(section: key, overallData: data)
    }
    
    func banchan(category: Int, index: Int) -> Banchan? {
        return banchanChange?.overallData[category]?[index]
    }
    
    func banchanCount(of category: Int) -> Int {
        return banchanChange?.overallData[category]?.count ?? 0
    }
}

extension CategorizedBanchanViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banchanCount(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BanchanCell.reuseIdentifier, for: indexPath) as? BanchanCell else { return BanchanCell() }
        cell.banchan = banchan(category: indexPath.section, index: indexPath.row)
        return cell
    }
}
