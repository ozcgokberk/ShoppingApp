//
//  GetProductResponseModel.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 8.02.2023.
//

import Foundation

struct GetProductResponseModel: Codable {
    let success: Bool
    let message: String
    let result: [ProductModel]
}
