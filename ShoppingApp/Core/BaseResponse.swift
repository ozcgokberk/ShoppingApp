//
//  BaseResponse.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 8.02.2023.
//

import Foundation

struct BaseResponse: Codable {
    let success: Bool
    let message: String
}

extension BaseResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
