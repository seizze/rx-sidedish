//
//  APIRouter.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

enum MainPageAPIRouter: APIBuilder, CaseIterable {
    case main
    case soup
    case side
    
    var path: String {
        switch self {
        case .main: return Endpoints.main
        case .soup: return Endpoints.soup
        case .side: return Endpoints.side
        }
    }
}

enum DetailPageAPIRouter: APIBuilder {
    case detail(banchanID: String)
    
    var path: String {
        switch self {
        case let .detail(id): return Endpoints.detail + "/\(id)"
        }
    }
}
