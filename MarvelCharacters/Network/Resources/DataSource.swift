//
//  DataSource.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//


class DataSource {
    static func provideNetworkDataSource() -> NetworkManager {
        return NetworkManager.shared
    }
}
