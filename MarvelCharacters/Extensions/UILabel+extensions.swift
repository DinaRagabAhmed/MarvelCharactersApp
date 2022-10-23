//
//  UILabel+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 23/10/2022.
//

import UIKit

extension UILabel {

   func highlight(searchedText: String?..., color: UIColor = .red) {
       guard let txtLabel = self.text else { return }

       let attributeTxt = NSMutableAttributedString(string: txtLabel)

       searchedText.forEach {
           if let searchedText = $0?.lowercased() {
               let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)

               attributeTxt.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
           }
       }

       self.attributedText = attributeTxt
   }
    
    func removeHightLight() {
        let attributeTxt = NSMutableAttributedString(string: "")
        self.attributedText = attributeTxt
    }
}
