//
//  CartViewController.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 10.02.2023.
//

import UIKit
import CoreData


final class CartViewController: UIViewController {
    //MARK: -Outlets
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    //MARK: -Variables
    private var viewModel: CartViewModelProtocol = CartViewModel()
    var emptyNoteView: EmptyNoteView?
    private var products: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        isCheckoOutActive()
        cartTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        emptyNoteView?.removeFromSuperview()
    }
    
    private func setupTableView() {
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
    }
    
    private func setupView() {
        totalLabel.text = viewModel.getPrice()
        viewModel.getProducts()
        viewModel.checkIfProductExist()
        checkOutButton.layer.cornerRadius = 10
    }
    
    private func isCheckoOutActive() {
        if viewModel.getPrice() == "0.00" {
            checkOutButton.isEnabled = false
            checkOutButton.alpha = 0.9
            totalLabel.isHidden = true
            
        } else {
            checkOutButton.isEnabled = true
            checkOutButton.alpha = 1.0
            totalLabel.isHidden = false
        }
    }
    
    @IBAction func checkOutPressed(_ sender: Any) {
        
        showAlert(title: "Ordered!", message: "Total Amount is \(viewModel.getPrice())")
        viewModel.deleteCoreDataItems()
        viewModel.checkOutPressed()
        cartTableView.reloadData()
        totalLabel.text = "0.00"
        isCheckoOutActive()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.getCartCount().orEmpty
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell , let model = viewModel.getProduct(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.viewModel.deleteProduct(index: indexPath.row)
            self.totalLabel.text = self.viewModel.getPrice()
            tableView.deleteRows(at: [], with: .fade)
            CoreDataManager.shared.save()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteButton])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension CartViewController: CartViewModelDelegate {
    func productNotExist() {
        guard let emptyView = UINib(nibName: "EmptyCartView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? EmptyNoteView else { return }
        self.emptyNoteView = emptyView
        self.emptyNoteView?.frame = self.cartTableView.bounds
        self.cartTableView.addSubview(self.emptyNoteView ?? UIView())
    }
    
    func productsLoaded() {
        cartTableView.reloadData()
    }
}
