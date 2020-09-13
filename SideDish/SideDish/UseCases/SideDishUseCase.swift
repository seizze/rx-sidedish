//
//  SideDishUseCase.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation
import RxSwift

struct SideDishUseCase {
    
    func fetchSideDishes() -> Observable<TaggedSideDishes> {
        let tasks = SideDishRequest.allCases.map {
            SideDishTask(dispatcher: NetworkSession(session: .shared)).perform($0)
        }
        return Observable.indexedMerge(tasks)
            .map { TaggedSideDishes(category: $0.index, sideDishes: $0.element.body) }
    }
}
