//
//  CartViewModel.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 10.02.2023.
//

import Foundation
protocol CartViewModelProtocol {
    var delegate: CartViewModelDelegate? { get set }
    
    func getProducts()
    func getCart() -> [Products]
    func getCartCount() -> Int?
    func getProduct(at index: Int) -> Products?
    func getPrice() -> String
    func deleteProduct(index: Int)
    func checkIfProductExist()
    func checkOutPressed()
    func deleteCoreDataItems()
}

protocol CartViewModelDelegate: AnyObject {
    func productsLoaded()
    func productNotExist()
}

final class CartViewModel: CartViewModelProtocol {
    
    private var products: [Products]?
    weak var delegate: CartViewModelDelegate?
    func getProducts() {
        products = CoreDataManager.shared.fetchProducts()
    }
    
    func getCart() -> [Products] {
        return products ?? []
    }
    
    
    func getCartCount() -> Int? {
        return products?.count
    }
    
    func getProduct(at index: Int) -> Products? {
        return products?[index]
    }
    
    func deleteProduct(index: Int) {
        let model = products?[index]
        products?.remove(at: index)
        CoreDataManager.shared.deleteProduct(model: model!)
        delegate?.productsLoaded()
        checkIfProductExist()
    }
    
    
    func getPrice() -> String {
        return CoreDataManager.shared.fetchPrice()
    }
    
    func checkIfProductExist() {
        if products?.count == 0 {
            delegate?.productNotExist()
        }
    }
    
    func checkOutPressed() {
        getProducts()
        checkIfProductExist()
    }
    
    func deleteCoreDataItems() {
        return CoreDataManager.shared.deleteAllProducts()
    }
    
}
