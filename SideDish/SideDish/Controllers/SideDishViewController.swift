//
//  SideDishViewController.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit
import RxSwift

class SideDishViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SideDishViewModelBinding? = SideDishViewModel()
    
    private let delegate = SideDishDelegate()
    
    private let queue = DispatchQueue(label: "sidedish.networking")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
        configureTableView()
        
        fetchSideDishes()
    }
    
    private func configureBindings() {
        tableView.rx.setDelegate(delegate)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { self.showSideDishDetails(of: $0) })
            .disposed(by: disposeBag)
        
        viewModel?.sectionUpdate
            .asDriver(onErrorJustReturn: IndexSet(0..<0))
            .drive(onNext: { self.tableView.reloadSections($0, with: .automatic) })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureTableView() {
        tableView.register(SideDishHeaderView.nib, forHeaderFooterViewReuseIdentifier: SideDishHeaderView.identifier)
        tableView.dataSource = viewModel
    }
    
    private func fetchSideDishes() {
        SideDishUseCase().fetchSideDishes { index, sideDishes in
            self.queue.sync {
                self.viewModel?.update(category: index, sideDishes: sideDishes)
            }
        }
    }
    
    private func showSideDishDetails(of indexPath: IndexPath) -> Void {
        guard let item = viewModel?.sideDish(category: indexPath.section, index: indexPath.row) else { return }
        let viewModel = SideDishDetailViewModel(with: item.detailHash)
        let viewController = SideDishDetailViewController.instantiate(title: item.title, viewModel: viewModel)
        navigationController?.show(viewController ?? UIViewController(), sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SideDishViewController: Identifiable {
    
    static func instantiate(from storyboard: StoryboardRouter = .sideDish) -> Self? {
        return storyboard.load(viewControllerType: self)
    }
}
