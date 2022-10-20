//
//  UIView+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit

extension UIView {
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}

extension UIView {
    // MARK: - Reusable View
    func loadViewFromNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
