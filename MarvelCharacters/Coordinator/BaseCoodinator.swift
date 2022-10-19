//
//  BaseCoodinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import RxSwift

class BaseCoordinator<ResultType>: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var isCompleted : (() -> Void)? // Closure to be executed when vc deallocated from memory
    let bag = DisposeBag()
    
    func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented")
    }
}
