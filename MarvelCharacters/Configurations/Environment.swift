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
}
