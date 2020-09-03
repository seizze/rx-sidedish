//
//  SideDishDetailViewController.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/28.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

class SideDishDetailViewController: UIViewController {
    
    @IBOutlet weak var pagingView: ImageCollectionView!
    @IBOutlet weak var descriptionView: DescriptionView!
    @IBOutlet weak var detailView: ImageCollectionView!
    
    var viewModel: SideDishDetailViewModel?
    
    private var pagingViewModel = ImageCollectionViewModel()
    private var detailViewModel = ImageCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModels()
        
        fetchSideDishDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewModels() {
        pagingViewModel.updateNotify { [weak self] change in
            guard let index = change?.index else { return }
            DispatchQueue.main.async { self?.pagingView.update(change?.images[index] ?? nil, at: index) }
        }
        detailViewModel.updateNotify { [weak self] change in
            guard let index = change?.index else { return }
            DispatchQueue.main.async { self?.detailView.update(change?.images[index] ?? nil, at: index) }
        }
        viewModel?.updateNotify { [weak self] detail in
            DispatchQueue.main.async {
                self?.descriptionView.titleLabel.text = self?.title
                self?.descriptionView.banchanDetail = detail
                self?.pagingView.configure(imageCount: detail?.thumbImages.count ?? 0,
                                           width: self?.view.frame.width)
                self?.detailView.configure(imageCount: detail?.detailSection.count ?? 0,
                                           width: self?.view.frame.width)
            }
            self?.request(detail?.thumbImages) { self?.pagingViewModel.add($0, at: $1) }
            self?.request(detail?.detailSection) { image, index in
                self?.detailViewModel.add(image, at: index)
                DispatchQueue.main.async { self?.detailView.fitImage(at: index) }
            }
        }
    }
    
    private func request(_ images: [String]?, completion: @escaping (UIImage?, Int) -> Void) {
        images?.enumerated().forEach { index, url in
            ImageUseCase().image(from: url) { completion($0, index) }
        }
    }
    
    private func fetchSideDishDetail() {
        guard let id = viewModel?.sideDishID else { return }
        BanchanDetailUseCase().fetchDetail(of: id) {
            self.viewModel?.update(banchanDetail: $0)
        }
    }
}

extension SideDishDetailViewController: Identifiable {
    
    static func instantiate(
        from storyboard: StoryboardRouter = .sideDishDetail,
        title: String,
        viewModel: SideDishDetailViewModel
    ) -> Self? {
        guard let viewController = storyboard.load(viewControllerType: self) else { return nil }
        viewController.title = title
        viewController.viewModel = viewModel
        return viewController
    }
}
