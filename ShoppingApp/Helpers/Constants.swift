//
//  Constants.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 9.02.2023.
//

import Foundation
struct Constants {
    static let API = "https://mocki.io/v1/6bb59bbc-e757-4e71-9267-2fee84658ff2"
    static var url: URL {
        return URL(string: API)!
    }
    static let imageRaw = "?raw=true"
}
