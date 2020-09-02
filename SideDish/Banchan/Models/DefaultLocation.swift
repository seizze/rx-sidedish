//
//  DefaultLocation.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/28.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct DefaultLocation {
    static let download = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
