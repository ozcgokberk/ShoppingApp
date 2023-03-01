//
//  ProductDetailVM.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 10.02.2023.
//

import Foundation
protocol ProductDetailViewModelProtocol {
    
    func getProductPrice(product: ProductModel) -> Float?
    func getProductName(product: ProductModel) -> String?
    func getProductImage(product: ProductModel) -> String?
    func getProductDescription(product: ProductModel) -> String?
    func addProduct(id: String, name: String, price: Float,image: String, quantity: String)
    func updateQuantity(name: String, quantity: String, price: Float)
    func ifProductExistInCart(selectedName: String) -> Bool
}

final class ProductDetailViewModel: ProductDetailViewModelProtocol {
    private var viewModel: ProductModel?
    
    func getProductPrice(product: ProductModel) -> Float? {
        return product.productPrice.orEmpty
    }

    func getProductName(product: ProductModel) -> String? {
        return product.productName.orEmpty
    }
    
    func getProductImage(product: ProductModel) -> String? {
        return product.productImage.orEmpty + Constants.imageRaw
    }
    
    func getProductDescription(product: ProductModel) -> String? {
        return product.productDescription.orEmpty
    }
    
    func ifProductExistInCart(selectedName: String) -> Bool {
        
        return CoreDataManager.shared.ifProductExist(productName: selectedName)
    }

    func updateQuantity(name: String, quantity: String, price: Float ) {
        CoreDataManager.shared.quantityUpdate(name: name, quantity: quantity, price: price * Float(quantity).orEmpty)
    }
    
    func addProduct(id: String, name: String, price: Float,image: String, quantity: String) {
        
        CoreDataManager.shared.saveProducts(id: id,
                                            name: name,
                                            price: price,
                                            image: image + Constants.imageRaw,
                                            quantity: quantity)
    }
}
