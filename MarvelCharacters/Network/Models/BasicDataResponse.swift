//
//  BasicDataResponse.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation

class BasicDataResponse <T: Codable>:  Codable {
    var results: [T]?
}
