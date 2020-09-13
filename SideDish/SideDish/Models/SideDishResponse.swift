//
//  SideDishResponse.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct SideDishResponse: Decodable {
    
    let body: [SideDish]
}

struct TaggedSideDishes {
    
    let category: Int
    let sideDishes: [SideDish]
}
