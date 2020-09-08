//
//  SideDishViewModel.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/23.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SideDishViewModelBinding where Self: UITableViewDataSource {
    
    var sectionUpdate: Observable<IndexSet> { get }
    
    func update(category: Int, sideDishes: [SideDish])
    func sideDish(category: Int, index: Int) -> SideDish?
}

struct SideDishCollection {
    
    var count: Int { sideDishes.count }
    
    let sideDishes: [SideDish]
    
    subscript(index: Int) -> SideDish {
        return sideDishes[index]
    }
}

class SideDishViewModel: NSObject, SideDishViewModelBinding {
    
    private let sideDishCategoryUpdate = PublishRelay<IndexSet>()
    
    private var collections: [Int: SideDishCollection]
    
    var sectionUpdate: Observable<IndexSet>
    
    init(with collections: [Int: SideDishCollection] = [:]) {
        self.collections = collections
        self.sectionUpdate = sideDishCategoryUpdate.asObservable()
    }
    
    func update(category: Int, sideDishes: [SideDish]) {
        collections[category] = SideDishCollection(sideDishes: sideDishes)
        sideDishCategoryUpdate.accept(IndexSet(category...category))
    }
    
    func sideDish(category: Int, index: Int) -> SideDish? {
        return collections[category]?[index]
    }
    
    private func count(of section: Int) -> Int {
        return collections[section]?.count ?? 0
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
