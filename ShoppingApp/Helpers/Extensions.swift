//
//  Extensions.swift
//  ShoppingApp
//
//  Created by Gokberk Ozcan on 9.02.2023.
//

import Foundation
import UIKit

extension Optional where Wrapped == Int {
    var orEmpty: Int {
        if self == nil {
            return 0
        }
        return self!
    }
}

extension Optional where Wrapped == Float {
    var orEmpty: Float {
        if self == nil {
            return 0
        }
        return self!
    }
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        if self == nil {
            return ""
        }
        return self!
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true)
         })
        
        alert.addAction(okeyButton)
        self.present(alert, animated: true, completion: nil)
    }

}
