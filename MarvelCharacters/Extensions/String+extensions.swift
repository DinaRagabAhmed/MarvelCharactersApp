//
//  String+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import Foundation
import UIKit

extension String {
    
    func localized() -> String {
        //Read from localization file
        let language : String = "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
