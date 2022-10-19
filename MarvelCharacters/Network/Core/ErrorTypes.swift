//
//  ErrorTypes.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation

enum ErrorTypes: Equatable {
      case generalError
      case networkError
      case customError(msg: String)
      case unKnown
}

struct NetworkError: Error {
    var type: ErrorTypes?
}

enum StatusCode: Int {
    case success = 200
    case successCode = 201
    case validationError = 422
    case serverError = 500
    case unVerified = 403
    case authenticationError = 401
}
