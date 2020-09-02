//
//  BanchanViewController.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/21.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class BanchanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CategorizedBanchanViewModel()
    private let delegate = BanchanDelegate()
    private let queue = DispatchQueue(label: "networking")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureViewModel()
        configureUseCase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow,
            let item = viewModel.banchan(category: indexPath.section, index: indexPath.row) else { return }
        viewController.title = item.title
        BanchanDetailUseCase.performFetching(with: NetworkManager(), banchanID: item.detailHash) {
            viewController.descriptionViewModel.update(banchanDetail: $0)
        }
    }
    
    private func configureTableView() {
        tableView.register(BanchanHeaderView.nib, forHeaderFooterViewReuseIdentifier: BanchanHeaderView.reuseIdentifier)
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
    
    private func configureUseCase() {
        BanchanUseCase.performFetching(with: NetworkManager()) { index, banchans in
            self.queue.sync {
                self.viewModel.append(key: index, value: banchans)
            }
        }
    }
}
