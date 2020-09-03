//
//  SideDishDetailViewModel.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

class SideDishDetailViewModel: ViewModelBinding {
    
    typealias Key = BanchanDetail?
    
    let sideDishID: String
    
    private var banchanDetail: Key = nil {
        didSet { changeHandler(banchanDetail) }
    }
    
    private var changeHandler: (Key) -> Void
    
    init(with sideDishID: String, handler: @escaping (Key) -> Void = { _ in }) {
        self.sideDishID = sideDishID
        self.changeHandler = handler
        self.banchanDetail = nil
        changeHandler(banchanDetail)
    }
    
    func update(banchanDetail: Key) {
        self.banchanDetail = banchanDetail
    }
    
    func updateNotify(handler: @escaping (Key) -> Void) {
        self.changeHandler = handler
    }
}
