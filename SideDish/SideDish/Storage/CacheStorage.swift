//
//  CacheStorage.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/09/03.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

protocol CacheStorage {
    
    func store(at tempURL: URL)
    
    func data(url: String) -> Data?
}

struct DiskStorage: CacheStorage {
    
    private let manager: FileManager
    
    private let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    init(manager: FileManager) {
        self.manager = manager
    }
    
    func store(at tempURL: URL) {
        guard let destination = directory?.appendingPathComponent(key(from: tempURL.path)) else { return }
        try? manager.removeItem(at: destination)
        try? manager.copyItem(at: tempURL, to: destination)
    }
    
    func data(url: String) -> Data? {
        guard let path = directory?.appendingPathComponent(key(from: url)),
            manager.fileExists(atPath: path.path) else { return nil }
        return try? Data(contentsOf: path)
    }
    
    private func key(from url: String) -> String {
        return "\(url.hashValue)"
    }
}
