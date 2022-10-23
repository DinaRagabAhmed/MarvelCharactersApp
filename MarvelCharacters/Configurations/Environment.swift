//
//  Environment.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation

enum Environment {
    
    enum PlistKeys {
        static let baseURL = "BASE_URL"
        static let API_KEY = "API_KEY"
        static let API_PRIVATE_KEY = "API_PRIVATE_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let infoDict = Bundle.main.infoDictionary else {
            fatalError("info.Plist file not found")
        }
        return infoDict
    }()
        
    static let baseURL: String = {
        guard let rootURLstring = Environment.infoDictionary[PlistKeys.baseURL] as? String else {
            fatalError("Storage URL not set in plist for this environment")
        }
        
        let baseUrl = "https://\(rootURLstring)"
        guard let url = URL(string: baseUrl) else {
            fatalError("Root URL is invalid")
        }
        return url.absoluteString
    }()
    
    static let APIKey: String = {
        guard let APIKey = Environment.infoDictionary[PlistKeys.API_KEY] as? String else {
            fatalError("Api key not set in plist for this environment")
        }
        return APIKey
    }()
    
    static let APIPrivateKey: String = {
        guard let APIPrivateKey = Environment.infoDictionary[PlistKeys.API_PRIVATE_KEY] as? String else {
            fatalError("Api private ket not set in plist for this environment")
        }
        return APIPrivateKey
    }()
}
