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
    
    private var viewModel: SideDishViewModelBinding!
    
    private let delegate = SideDishDelegate()
    
    private let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "sidedish.networking")
    
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
        
        viewModel.sectionUpdate
            .subscribeOn(scheduler)
            .catchErrorJustReturn(IndexSet(0..<0))
            .subscribe(onNext: { [weak self] in self?.reloadSynchronously(self?.tableView, at: $0) })
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
        SideDishUseCase().fetchSideDishes()
            .subscribeOn(scheduler)
            .bind(to: viewModel.updateSideDish)
            .disposed(by: disposeBag)
    }
    
    private func showSideDishDetails(of indexPath: IndexPath) -> Void {
        guard let item = viewModel.sideDish(category: indexPath.section, index: indexPath.row) else { return }
        let viewModel = SideDishDetailViewModel(with: item.detailHash)
        let viewController = SideDishDetailViewController.instantiate(title: item.title, viewModel: viewModel)
        navigationController?.show(viewController ?? UIViewController(), sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func reloadSynchronously(_ tableView: UITableView?, at indexSet: IndexSet) {
        DispatchQueue.main.sync { tableView?.reloadSections(indexSet, with: .automatic) }
    }
}

extension SideDishViewController: Identifiable {
    
    static func instantiate(
        from storyboard: StoryboardRouter = .sideDish,
        viewModel: SideDishViewModelBinding
    ) -> Self? {
        guard let viewController = storyboard.load(viewControllerType: self) else { return nil }
        viewController.viewModel = viewModel
        return viewController
    }
}
