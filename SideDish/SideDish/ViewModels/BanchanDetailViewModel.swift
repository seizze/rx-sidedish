//
//  BanchanDetailViewModel.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

class BanchanDetailViewModel: ViewModelBinding {
    typealias Key = BanchanDetail?
    
    private var banchanDetail: Key = nil {
        didSet { changeHandler(banchanDetail) }
    }
    
    private var changeHandler: (Key) -> Void
    
    init(with banchanDetail: Key = nil, handler: @escaping (Key) -> Void = { _ in }) {
        self.changeHandler = handler
        self.banchanDetail = banchanDetail
        changeHandler(banchanDetail)
    }
    
    func update(banchanDetail: Key) {
        self.banchanDetail = banchanDetail
    }
    
    func updateNotify(handler: @escaping (Key) -> Void) {
        self.changeHandler = handler
    }
}
