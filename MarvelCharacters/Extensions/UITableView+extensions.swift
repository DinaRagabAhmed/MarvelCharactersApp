//
//  UITableView+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
