//
//  ViewModelBinding.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/23.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

protocol ViewModelBinding {
    associatedtype Key
    func updateNotify(handler: @escaping (Key) -> Void)
}
