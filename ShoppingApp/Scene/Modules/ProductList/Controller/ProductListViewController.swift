//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Erdem Perşembe on 12.04.2022.
//

import UIKit
import CoreData
final class ProductListViewController: UIViewController {
    
    //MARK: -Vars
    private var viewModel: ProductListViewModelProtocol = ProductListViewModel()
    private var cartArray: [ProductModel] = []
    //MARK: -Outlets
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var cartTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchProducts()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartTotalLabel.text = "\(viewModel.getCartPrice())₺"
        setupTabBar()
    }
    
    private func setupView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.isHidden = true
    }
    
    private func setupTabBar() {
        let tabbar = self.tabBarController!.tabBar
        if viewModel.getCartPrice() == "0.00" {
            if  let arrayOfTabBarItems = tabbar.items! as AnyObject as? NSArray,
                let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.isEnabled = false
                addToCartButton.isHidden = true
            }
        } else {
            tabbar.items?[1].isEnabled = true
        }
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getProductCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell, let model = viewModel.getProduct(at: indexPath.row) else { return UICollectionViewCell() }
        cell.configureCell(model: model)
        cell.delegate = self
        cell.addProductButton.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "productDetailsVC") as? ProductDetailsVC else { return }
        vc.productDetail = viewModel.getProduct(at: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300)
    }
}

extension ProductListViewController: ProductListViewModelDelegate {
    func productsFailed(error: Error) {
        print("Error occured while fetching data..")
    }
    
    func productsLoaded() {
        productsCollectionView.reloadData()
    }
}

extension ProductListViewController: ProductsCellDelegate {
    func addButtonTapped(tag: Int) {
        
        addToCartButton.isHidden = false
        let selectedProduct = viewModel.getProduct(at: tag)
        
        if viewModel.ifProductExistInCart(selectedName: (selectedProduct?.productName.orEmpty).orEmpty) {
            showAlert(title: "You already have this product in your cart", message: "To add more please go to product detail")
            
        } else {
            viewModel.addProduct(id: UUID().uuidString,
                                 name: (selectedProduct?.productName.orEmpty).orEmpty,
                                 price: (selectedProduct?.productPrice.orEmpty).orEmpty,
                                 image: (selectedProduct?.productImage.orEmpty).orEmpty,
                                 quantity: "1")
        }
        cartTotalLabel.text = "\(viewModel.getCartPrice())₺"
        setupTabBar()
    }
}
