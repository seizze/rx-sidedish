//
//  ImageUseCase.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct ImageUseCase {
    static func performFetching(with manager: NetworkManageable,
                                url: String,
                                completion: @escaping (Data) -> ()) {
        guard let url = URL(string: url) else { return }
        let imageExists = readIfImageExists(url.lastPathComponent) { image in
            completion(image)
        }
        if imageExists { return }
        manager.downloadImage(with: URLRequest(url: url)) { result in
            if case let .success(image) = result { completion(image) }
        }
    }
    
    private static func readIfImageExists(_ name: String, block: @escaping (Data) -> ()) -> Bool {
        let path = DefaultLocation.download.appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: path.path) {
            block(try! Data(contentsOf: path))
            return true
        }
        return false
    }
}
