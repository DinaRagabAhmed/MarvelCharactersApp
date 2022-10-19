//
//  BaseViewModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import RxCocoa
import RxSwift
import UIKit

class BaseViewModel: ViewModelProtocol {
    
    struct Input {}
    
    struct Output {
        let loadingObservable: Observable<Bool>
        let errorsObservable: Observable<ErrorTypes>
    }
    
    let baseInput: Input
    let baseOutput: Output
    private let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let generalErrors: PublishSubject<ErrorTypes> = PublishSubject()

    var disposeBag = DisposeBag()

    init() {
        baseInput = Input()
        baseOutput = Output(loadingObservable: isLoading.asObservable(),
                            errorsObservable: generalErrors.asObservable())
    }
    
    func controlLoading(showLoading: Bool) {
        isLoading.accept(showLoading)
    }
    
    func getLoadingStatus() -> Bool {
        return isLoading.value
    }
    
    func setError(error: ErrorTypes) {
        generalErrors.onNext(error)
    }
}
