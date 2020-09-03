//
//  BanchanDetailUseCase.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct BanchanDetailUseCase {
    
    func fetchDetail(
        of id: String,
        completion: @escaping (BanchanDetail) -> Void
    ) {
        let request = SideDishDetailRequest(sideDishID: id)
        SideDishDetailTask(dispatcher: NetworkSession(session: .shared)).perform(request) { result in
            if case let .success(detail) = result {
                completion(detail.data)
            }
        }
    }
}
