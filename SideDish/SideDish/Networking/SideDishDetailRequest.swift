//
//  SideDishDetailRequest.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct SideDishDetailRequest: Request {
    
    let sideDishID: String
    
    var path: String { Endpoints.detail(id: sideDishID) }
}
