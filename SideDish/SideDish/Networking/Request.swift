//
//  Request.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
}

protocol Request {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var url: URL? { get }
    
    func urlRequest() -> URLRequest?
}

extension Request {
    
    var method: HTTPMethod { .get }
    
    var queryItems: [String: String]? { nil }
    
    var headers: [String: String]? { nil }
    
    var body: Data? { nil }
    
    var url: URL? {
        guard var urlComponents = URLComponents(string: path) else { return nil }
        urlComponents.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents.url
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }
    
    func encode<T: Encodable>(_ value: T) -> Data? {
        let data: Data
        do {
            data = try JSONEncoder().encode(value)
        } catch {
            return nil
        }
        return data
    }
}

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

struct ImageRequest: Request {
    
    let path: String
}

struct SideDishDetailRequest: Request {
    
    let sideDishID: String
    
    var path: String { Endpoints.detail(id: sideDishID) }
}
