//
//  CharactersService.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import Moya

enum CharactersService {
    case getCharachters(name: String? = nil, limit: Int, offset: Int)
    case getSeries(characterID: Int)
    case getComics(characterID: Int)
    case getEvents(characterID: Int)
    case getStories(characterID: Int)
}

extension CharactersService: TargetType {
    
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        let serverURL = "\(Environment.baseURL)?ts=1&apikey=\(Environment.APIKey)&hash=\(Environment.APIHash)"

        guard let url = URL(string: serverURL) else { fatalError("wrong baseURL in Route") }
        return url
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getCharachters:
            return "characters"
        case .getSeries(let characterID):
            return "characters/\(characterID)/series"
        case .getComics(let characterID):
            return "characters/\(characterID)/comics"
        case .getEvents(let characterID):
            return "characters/\(characterID)/events"
        case .getStories(let characterID):
            return "characters/\(characterID)/stories"
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getCharachters, .getComics, .getEvents, .getSeries, .getStories:
            return .get
        }
    }
    
    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    var task: Task {
        switch self {
        case .getCharachters(let name, let limit, let offset):
            var parameters = ["offset": offset, "limit": limit] as [String: Any]
            if name != nil {
                parameters["name"] = name
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getSeries, .getComics, .getEvents, .getStories:
            return .requestPlain
        }
    }
    
    // These are the headers that our service requires.
    var headers: [String: String]? {
        return ["accept": "application/json"]
    }
    
    // This is sample return data that you can use to mock and test your services,
    var sampleData: Data {
        return Data()
    }
}