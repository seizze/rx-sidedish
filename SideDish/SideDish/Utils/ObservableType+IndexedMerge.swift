//
//  ObservableType+IndexedMerge.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/09/13.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation
import RxSwift

struct IndexedElement<E> {
    
    let index: Int
    let element: E
}

extension ObservableType {
    
    static func indexedMerge<Payload>(
        _ sources: [Observable<Payload>]
    ) -> Observable<Element> where Element == IndexedElement<Payload> {
        let observables = sources.enumerated().map { index, source in
            source.map { IndexedElement(index: index, element: $0) }
        }
        return Observable.merge(observables)
    }
}
