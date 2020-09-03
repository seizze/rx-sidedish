//
//  BanchanUseCase.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct BanchanUseCase {
    
    func fetchSideDishes(completion: @escaping (Int, [Banchan]) -> Void) {
        SideDishRequest.allCases.enumerated().forEach { index, request in
            SideDishTask(dispatcher: NetworkSession(session: .shared)).perform(request) { result in
                if case let .success(response) = result {
                    completion(index, response.body)
                }
            }
        }
    }
}
