//
//  SideDishViewController.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class SideDishViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CategorizedBanchanViewModel()
    private let delegate = BanchanDelegate()
    private let queue = DispatchQueue(label: "sidedish.networking")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureViewModel()
        configureDelegate()
        
        fetchSideDishes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureTableView() {
        tableView.register(BanchanHeaderView.nib, forHeaderFooterViewReuseIdentifier: BanchanHeaderView.identifier)
        tableView.delegate = delegate
        tableView.dataSource = viewModel
    }
    
    private func configureViewModel() {
        viewModel.updateNotify { change in
            DispatchQueue.main.sync {
                if let section = change?.section {
                    self.tableView.reloadSections(IndexSet(section...section), with: .automatic)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func configureDelegate() {
        delegate.didSelectRowAt = { [weak self] indexPath in
            guard let item = self?.viewModel.banchan(category: indexPath.section, index: indexPath.row) else { return }
            let viewModel = SideDishDetailViewModel(with: item.detailHash)
            let viewController = SideDishDetailViewController.instantiate(title: item.title, viewModel: viewModel)
            self?.navigationController?.show(viewController ?? UIViewController(), sender: nil)
        }
    }
    
    private func fetchSideDishes() {
        BanchanUseCase().fetchSideDishes { index, banchans in
            self.queue.sync {
                self.viewModel.append(key: index, value: banchans)
            }
        }
    }
}

extension SideDishViewController: Identifiable {
    
    static func instantiate(from storyboard: StoryboardRouter = .sideDish) -> Self? {
        return storyboard.load(viewControllerType: self)
    }
}