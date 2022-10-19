//
//  Drawable.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}
