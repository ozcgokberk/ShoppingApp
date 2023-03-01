//
//  EmptyNoteView.swift
//  Gamio
//
//  Created by Gokberk Ozcan on 18.12.2022.
//

import UIKit

final class EmptyNoteView: UIView {
    
    @IBOutlet weak var noProductImage: UIImageView! {
        didSet {
            noProductImage.image = UIImage(named: "cart")
        }
    }
    
    @IBOutlet weak var noProductTitle: UILabel! {
        didSet {
            noProductTitle.text = "Add product to see."
        }
    }
}
