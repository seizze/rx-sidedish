//
//  NetworkManager.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/22.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case notFound
    
    var localizedDescription: String {
        switch self {
        case .notFound: return "Not Found"
        }
    }
}

protocol NetworkManageable {
    func request<T: Decodable>(_ responseType: T.Type,
                               with request: URLRequest?,
                               completion: @escaping (Result<T, Error>) -> Void)
    func downloadImage(with request: URLRequest?,
                       completion: @escaping (Result<Data, Error>) -> Void)
}
 
extension NetworkManageable {
    func request<T: Decodable>(_ responseType: T.Type,
                               with request: URLRequest?,
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = request else { return }
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.isValid() {
                self.decode(responseType, from: data) { completion($0) }
            } else {
                completion(.failure(HTTPError.notFound))
            }
        }.resume()
    }
    
    func downloadImage(with request: URLRequest?,
                       completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = request else { return }
        
        URLSession(configuration: .default).downloadTask(with: request) { location, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let location = location, let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.isValid() {
                self.saveImage(from: location, name: request.url?.lastPathComponent) { completion($0) }
            } else {
                completion(.failure(HTTPError.notFound))
            }
        }.resume()
    }
    
    private func saveImage(from source: URL,
                           name: String?,
                           completion: @escaping (Result<Data, Error>) -> Void) {
        guard let name = name else { return }
        let destination = DefaultLocation.download.appendingPathComponent(name)
        try? FileManager.default.removeItem(at: destination)
        
        do {
            try FileManager.default.copyItem(at: source, to: destination)
            completion(.success(try Data(contentsOf: destination)))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type,
                                      from data: Data,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
}

struct NetworkManager: NetworkManageable { }

private extension HTTPURLResponse {
    func isValid() -> Bool {
        switch statusCode {
        case 200..<300: return true
        default: return false
        }
    }
}
