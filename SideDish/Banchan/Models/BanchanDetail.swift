//
//  BanchanDetail.swift
//  Banchan
//
//  Created by Chaewan Park on 2020/04/29.
//  Copyright © 2020 Chaewan Park. All rights reserved.
//

import Foundation

struct BanchanDetail: Decodable {
    let topImage: String
    let thumbImages: [String]
    let productDescription, point, deliveryInfo, deliveryFee: String
    let prices: [String]
    let detailSection: [String]

    enum CodingKeys: String, CodingKey {
        case topImage = "top_image"
        case thumbImages = "thumb_images"
        case productDescription = "product_description"
        case point
        case deliveryInfo = "delivery_info"
        case deliveryFee = "delivery_fee"
        case prices
        case detailSection = "detail_section"
    }
}
