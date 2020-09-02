//
//  SideDishRequest.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/09/02.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

enum SideDishRequest: Request, CaseIterable {
    
    case main, soup, side
    
    var path: String {
        switch self {
        case .main: return Endpoints.main
        case .soup: return Endpoints.soup
        case .side: return Endpoints.side
        }
    }
}
