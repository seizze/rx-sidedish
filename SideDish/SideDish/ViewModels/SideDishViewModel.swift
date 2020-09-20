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
    
    var updateSideDish: AnyObserver<TaggedSideDishes> { get }
    
    var sectionUpdate: Observable<IndexSet> { get }
    
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
    
    private let disposeBag = DisposeBag()
    
    private let sideDishCategoryUpdate = PublishRelay<IndexSet>()
    
    private var collections = [Int: SideDishCollection]()
    
    var updateSideDish: AnyObserver<TaggedSideDishes>
    
    var sectionUpdate: Observable<IndexSet>
    
    override init() {
        let updating = PublishSubject<TaggedSideDishes>()
        
        updateSideDish = updating.asObserver()
        sectionUpdate = sideDishCategoryUpdate.asObservable()
        
        super.init()
        
        updating.subscribe(onNext: { self.update(with: $0) })
            .disposed(by: disposeBag)
    }
    
    func sideDish(category: Int, index: Int) -> SideDish? {
        return collections[category]?[index]
    }
    
    private func update(with sideDishes: TaggedSideDishes) {
        collections[sideDishes.category] = SideDishCollection(sideDishes: sideDishes.sideDishes)
        sideDishCategoryUpdate.accept(IndexSet(sideDishes.category...sideDishes.category))
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
