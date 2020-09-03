//
//  ImageUseCase.swift
//  SideDish
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import UIKit

struct ImageUseCase {
    
    func image(
        from path: String,
        completion: @escaping (UIImage?) -> ()
    ) {
        let diskCache = DiskStorage(manager: .default)
        if let data = diskCache.data(url: path) {
            completion(UIImage(data: data))
            return
        }
        let request = ImageRequest(path: path)
        ImageTask(dispatcher: NetworkSession(session: .shared), storage: diskCache).perform(request) { result in
            if case let .success(data) = result { completion(UIImage(data: data)) }
        }
    }
}
