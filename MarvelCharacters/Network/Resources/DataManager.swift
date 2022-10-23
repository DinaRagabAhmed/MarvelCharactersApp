//
//  DataManager.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Moya
import RxSwift

protocol DataManager {
    func callApi<T: Codable>(target: TargetType, type: T.Type) -> Observable<Result<BasicDataResponse<T>?, NetworkError>>
    func cancelAllRequests()
}
