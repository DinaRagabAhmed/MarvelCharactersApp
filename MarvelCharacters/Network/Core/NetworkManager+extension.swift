//
//  NetworkManager+extension.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation
import Moya
import RxSwift

extension NetworkManager {
    
    func callApi<T: Codable>(target: TargetType, type: T.Type) -> Observable<Result<BasicDataResponse<T>?, NetworkError>> {
        
        return Observable.create { [weak self] observer in
          
            self?.provider.rx.request(MultiTarget(target)).asObservable().subscribe { (response) in
                
                print("status code : \(response.statusCode)")

                do {
                    let basicReponse = try JSONDecoder().decode(BasicResponse<T>.self, from: response.data)
                    
                    
                    if response.statusCode == StatusCode.success.rawValue ||  response.statusCode == StatusCode.successCode.rawValue {
                        observer.onNext(.success(basicReponse.data))
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
                print("onDisposed")
            }.disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }

    }
    
    func cancelAllRequests() {
        self.provider.session.cancelAllRequests()
    }

}
