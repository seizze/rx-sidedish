//
//  NetworkDispatcher.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/09/02.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

protocol NetworkDispatcher { }

protocol APIDispatcher: NetworkDispatcher {
    
    func request(_ request: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

protocol DownloadDispatcher: NetworkDispatcher {
    
    func request(_ request: Request, completion: @escaping (Result<URL, Error>) -> Void)
}

enum NetworkSessionError: Error {
    
    case invalidURL, notFound
}

struct NetworkSession {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}

extension NetworkSession: APIDispatcher {
    
    func request(_ request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = request.urlRequest() else {
            completion(.failure(NetworkSessionError.invalidURL))
            return
        }
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.isValid() {
                completion(.success(data))
            } else {
                completion(.failure(NetworkSessionError.notFound))
            }
        }.resume()
    }
}

extension NetworkSession: DownloadDispatcher {
    
    func request(_ request: Request, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let request = request.urlRequest() else {
            completion(.failure(NetworkSessionError.invalidURL))
            return
        }
        
        session.downloadTask(with: request) { location, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let location = location, let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.isValid() {
                completion(.success(location))
            } else {
                completion(.failure(NetworkSessionError.notFound))
            }
        }.resume()
    }
}

private extension HTTPURLResponse {
    
    func isValid() -> Bool {
        guard case 200..<300 = statusCode else { return false }
        return true
    }
}
