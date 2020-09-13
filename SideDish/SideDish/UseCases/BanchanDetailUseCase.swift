//
//  BanchanDetailUseCase.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation
import RxSwift

struct BanchanDetailUseCase {
    
    func fetchDetail(of id: String) -> Observable<BanchanDetail> {
        let request = SideDishDetailRequest(sideDishID: id)
        return SideDishDetailTask(dispatcher: NetworkSession(session: .shared)).perform(request)
            .map { $0.data }
    }
}
