//
//  NetworkManager+extension.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation
import Moya
import RxMoya
import RxSwift

extension NetworkManager {
    
    func callApi<T: Codable>(target: TargetType, type: T.Type) -> Observable<Result<T?, NetworkError>> {
        
        return Observable.create { [weak self] observer in
          
            self?.provider.rx.request(MultiTarget(target)).asObservable().subscribe { (response) in
                
                print("status code : \(response.statusCode)")
                do {
                    let responseData = try JSONDecoder().decode(T.self, from: response.data)
                    
                    if response.statusCode == StatusCode.success.rawValue ||  response.statusCode == StatusCode.successCode.rawValue {
                         observer.onNext(.success(responseData))
                    } else {
                         observer.onNext(.failure(NetworkError(type: ErrorTypes.generalError)))
                    }
                    
                } catch {
                    observer.onNext(.failure(NetworkError(type: ErrorTypes.generalError)))
                    
                }
                
            } onError: { error in
                // Handle error
                print("error \(error)")
                 observer.onNext(.failure(NetworkError(type: ErrorTypes.unKnown)))
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed in network manager")
            }.disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }

    }
}
