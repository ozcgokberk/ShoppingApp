//
//  ProductViewModel.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 9.02.2023.
//

import Foundation
protocol ProductListViewModelProtocol {
    var delegate: ProductListViewModelDelegate? { get set }
    func fetchProducts()
    func getProductCount() -> Int
    func getProduct(at index: Int) -> ProductModel?
    func getPriceAtIndex(at index: Int) -> Float?
    func getCartPrice() -> String
    func ifProductExistInCart(selectedName: String) -> Bool
    func addProduct(id: String, name: String, price: Float,image: String, quantity: String)
}

protocol ProductListViewModelDelegate: AnyObject {
    func productsLoaded()
    func productsFailed(error: Error)
}

final class ProductListViewModel: ProductListViewModelProtocol {
    weak var delegate: ProductListViewModelDelegate?
    private var products: [ProductModel]?
    
    func fetchProducts() {
        Client.getProducts{ [weak self] products, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.productsFailed(error: error)
            }
            self.products = products
            self.delegate?.productsLoaded()
        }
    }
    
    func getProductCount() -> Int {
        
        return products?.count ?? 0
    }
    
    func getProduct(at index: Int) -> ProductModel? {
        
        products?[index]
    }
    
    func getPriceAtIndex(at index: Int) -> Float? {
        
        products?[index].productPrice.orEmpty
    }
    
    func getCartPrice() -> String {
        
        return CoreDataManager.shared.fetchPrice()
    }
    
    func ifProductExistInCart(selectedName: String) -> Bool {
        
        return CoreDataManager.shared.ifProductExist(productName: selectedName)
    }
    
    
    func addProduct(id: String, name: String, price: Float,image: String, quantity: String) {
        
        CoreDataManager.shared.saveProducts(id: id,
                                            name: name,
                                            price: price,
                                            image: image + Constants.imageRaw,
                                            quantity: quantity)
    }
}
