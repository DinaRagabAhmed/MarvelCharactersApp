//
//  UISearchBar+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit

extension UISearchBar {
    
    func updateHeight(height: CGFloat, radius: CGFloat = 15.0) {
        let image: UIImage? = UIImage.imageWithColor(color:
                                                        UIColor().hexStringToUIColor(hex: "313131"),
                                                     size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                            textField.textAlignment = .left
                            textField.leftView?.tintColor = .white
                            textField.clearButtonMode = .never
                            textField.textColor = .white
                        }
                    }
                }
            }
        }
    }
}
