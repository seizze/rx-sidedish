//
//  NetworkTask.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/09/02.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

protocol NetworkTask {
    
    associatedtype Input: Request
    
    associatedtype Output
}

protocol APITask: NetworkTask {
    
    var dispatcher: APIDispatcher { get }
    
    func perform(_ request: Input, completion: @escaping (Result<Output, Error>) -> Void)
}

extension APITask where Output: Decodable {
    
    func perform(_ request: Input, completion: @escaping (Result<Output, Error>) -> Void) {
        dispatcher.request(request) { result in
            switch result {
            case let .success(data): completion(self.decode(data))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    
    private func decode(_ data: Data) -> Result<Output, Error> {
        do {
            let response = try JSONDecoder().decode(Output.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}

protocol DownloadTask: NetworkTask {
    
    var dispatcher: DownloadDispatcher { get }
    
    var storage: CacheStorage { get }
    
    func perform(_ request: Input, completion: @escaping (Result<Output, Error>) -> Void)
}

extension DownloadTask where Output == Data {
    
    func perform(_ request: Input, completion: @escaping (Result<Output, Error>) -> Void) {
        dispatcher.request(request) { result in
            switch result {
            case let .success(url):
                self.storage.store(at: url)
                completion(.success((try? Data(contentsOf: url)) ?? Data()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

struct SideDishTask: APITask {
    
    typealias Input = SideDishRequest
    
    typealias Output = SideDishResponse
    
    let dispatcher: APIDispatcher
    
    init(dispatcher: APIDispatcher) {
        self.dispatcher = dispatcher
    }
}

struct SideDishDetailTask: APITask {
    
    typealias Input = SideDishDetailRequest
    
    typealias Output = SideDishDetailResponse
    
    let dispatcher: APIDispatcher
    
    init(dispatcher: APIDispatcher) {
        self.dispatcher = dispatcher
    }
}

struct ImageTask: DownloadTask {
    
    typealias Input = ImageRequest
    
    typealias Output = Data
    
    let dispatcher: DownloadDispatcher
    
    let storage: CacheStorage
    
    init(dispatcher: DownloadDispatcher, storage: CacheStorage) {
        self.dispatcher = dispatcher
        self.storage = storage
    }
}
