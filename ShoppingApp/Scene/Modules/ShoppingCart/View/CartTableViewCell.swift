//
//  CartTableViewCell.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 10.02.2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: Products) {
        productImage.load(url: URL(string: "\(model.image.orEmpty)")!)
        productName.text = model.name.orEmpty
        productPrice.text = String(format: "%.2f", model.price)
        productQuantity.text = "Quantity: \(model.quantity.orEmpty)"
    }
    
    override func prepareForReuse() {
        productImage.image = nil
    }

    
}
