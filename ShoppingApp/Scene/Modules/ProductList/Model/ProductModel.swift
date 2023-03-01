//
//  ProductModel.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 8.02.2023.
//

import Foundation

struct ProductModel: Codable {
    let productName: String?
    let productDescription: String?
    let productPrice: Float?
    let productImage: String?
}
