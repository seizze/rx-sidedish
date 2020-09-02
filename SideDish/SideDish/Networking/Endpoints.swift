//
//  Endpoints.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

class Endpoints {
    static let baseURL = "https://h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com/develop/baminchan"
    
    static let main = "\(baseURL)/main"
    static let soup = "\(baseURL)/soup"
    static let side = "\(baseURL)/side"
    static let detail = "\(baseURL)/detail"
}
