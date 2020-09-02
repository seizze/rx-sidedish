//
//  BanchanDetailUseCase.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct BanchanDetailUseCase {
    static func performFetching(with manager: NetworkManageable,
                                banchanID id: String,
                                completion: @escaping (BanchanDetail) -> Void) {
        manager.request(BanchanDetailResponse.self,
                        with: DetailPageAPIRouter.detail(banchanID: id).urlRequest()) { result in
            if case let .success(response) = result { completion(response.data) }
        }
    }
}
