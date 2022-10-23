//
//  BasicResponse.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation

// MARK: - General Response
//
class BasicResponse <T: Codable>:  Codable {
    var data: BasicDataResponse<T>?
    var code: Int?
}
