//
//  ProductDetailsVC.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 9.02.2023.
//

import UIKit

final class ProductDetailsVC: UIViewController {
    //MARK: -Outlets
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var updateCartButton: UIButton!
    @IBOutlet weak var minestButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    
    //MARK: -Variables
    var productDetail: ProductModel!
    private var viewModel: ProductDetailViewModelProtocol = ProductDetailViewModel()
    private var quantity = 1
    
    private var productName: String? {
        return viewModel.getProductName(product: productDetail)
    }
    
    private var productImage: String? {
        return viewModel.getProductImage(product: productDetail) 
    }
    
    private var productPrice: Float? {
        return viewModel.getProductPrice(product: productDetail)
    }
    
    private var productDescription: String? {
        return viewModel.getProductDescription(product: productDetail)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let url = URL(string: (viewModel.getProductImage(product: productDetail).orEmpty)) else { return }
        detailsImage.load(url: url)
        detailPrice.text = "\(productPrice.orEmpty)"
        detailDescription.text = productDescription
        detailName.text = productName
        productQuantity.text  = "\(quantity)"
        
        updateCartButton.layer.cornerRadius = 10
        minestButton.layer.cornerRadius = 10
        plusButton.layer.cornerRadius = 10
    }
    
    @IBAction func updateCartButtonPressed(_ sender: Any) {
        
        if viewModel.ifProductExistInCart(selectedName: productName.orEmpty) {
            viewModel.updateQuantity(name: productName.orEmpty, quantity: "\(quantity)", price: productPrice.orEmpty)
        } else {
            viewModel.addProduct(id: UUID().uuidString, name: productName.orEmpty, price: productPrice.orEmpty, image: productImage.orEmpty, quantity: "\(quantity)")
        }
        quantity = 1
        productQuantity.text = "\(quantity)"
        showAlert(title: "Product Added to Cart", message: "You can view on Cart")
    }
    
    @IBAction func minestButtonPressed(_ sender: Any) {
        if quantity > 1 {
            DispatchQueue.main.async {
                self.quantity -= 1
                self.productQuantity.text = "\(self.quantity)"
            }
        }
    }
    
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.quantity += 1
            self.productQuantity.text = "\(self.quantity)"
        }
    }
}
