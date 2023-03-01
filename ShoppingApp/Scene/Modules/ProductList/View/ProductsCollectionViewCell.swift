//
//  ProductsCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 9.02.2023.
//

import UIKit
protocol ProductsCellDelegate: AnyObject {
    func addButtonTapped(tag: Int)
}
final class ProductsCollectionViewCell: UICollectionViewCell {
    
    //MARK: -Properties
    weak var delegate: ProductsCellDelegate?
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var addProductButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCell()
    }
    
    func configureCell(model: ProductModel) {
        productImage.load(url: URL(string: "\(model.productImage.orEmpty)" + Constants.imageRaw)!)
        productPrice.text = "\(model.productPrice.orEmpty) "
        productName.text = model.productName.orEmpty
    }
    
    private func setCell() {
        layer.cornerRadius = 10
        productImage.layer.cornerRadius = 10
        addProductButton.layer.borderWidth = 0.5
        addProductButton.layer.borderColor = UIColor.blue.cgColor
        addProductButton.layer.cornerRadius = 10
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.addButtonTapped(tag: sender.tag)
    }
    
    override func prepareForReuse() {
        productImage.image = nil
    }
}
