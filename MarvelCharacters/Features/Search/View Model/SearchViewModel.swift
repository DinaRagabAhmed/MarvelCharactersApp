//
//  SearchViewModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: BaseViewModel {
    
    struct Input {
        let didTapCancelIcon: AnyObserver<Void>
    }
    
    struct Output {
        let charactersObservable: Observable<[MarvelCharacter]>
        let infiniteScrollObservable: Observable<InfiniteScrollStatus>
        let screenRedirectionObservable: Observable<SearchRedirection>
    }
    
    let output: Output
    let input: Input

    private let charactersSubject: BehaviorRelay<[MarvelCharacter]> = BehaviorRelay(value: [MarvelCharacter]())
    private let infiniteScrollSubject: PublishSubject<InfiniteScrollStatus> = PublishSubject()
    private let screenRedirectionSubject = PublishSubject<SearchRedirection>()
    private let cancelSubject = PublishSubject<Void>()

    var dataManager: DataManager?

    init(dataManager: DataManager?) {
        self.dataManager = dataManager
        self.input = Input(didTapCancelIcon: cancelSubject.asObserver())
        self.output = Output(charactersObservable: charactersSubject.asObservable(),
                             infiniteScrollObservable: infiniteScrollSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable())
        
        super.init()
        subscribeToCancelEvent()
    }
    
    func subscribeToCancelEvent() {
        cancelSubject.asObservable()
           .subscribe { [weak self] _ in
               self?.screenRedirectionSubject.onNext(.back)
           }.disposed(by: disposeBag)
    }
}

// MARK: - Hablde Network call and response
extension SearchViewModel {
    
    func getFavouriteCharachters(keyword: String) {
        self.offset = 0
        self.charactersSubject.accept([])
        self.infiniteScrollSubject.onNext(.reset)
        self.getCharactersList(keyword: keyword)
    }
    
    func getCharactersList(keyword: String) {
        
        if Utils.isConnectedToNetwork() {
            
            let target = CharactersService.getCharachters(name: keyword,
                                                          limit: self.limit,
                                                          offset: self.offset)
            self.dataManager?.callApi(target: target, type: MarvelCharacter.self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    self.handlePagination(result: data?.results ?? [])

                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                       // self.screenStateSubject.onNext(.noNetwork)
                    } else {
                        self.setError(error: error.type ?? ErrorTypes.generalError)
                    }
                }
            }, onError: { [weak self](error) in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                self.setError(error: ErrorTypes.generalError)
            }).disposed(by: disposeBag)
        } else {
            self.controlLoading(showLoading: false)
           // self.screenStateSubject.onNext(.noNetwork)
        }
    }
    
    func handlePagination(result: [MarvelCharacter]) {
        var charachters = self.charactersSubject.value

        self.infiniteScrollSubject.onNext(.finish)
        if( result.isEmpty && charachters.isEmpty) {
            print("no data") // no data
            self.infiniteScrollSubject.onNext(.remove)
           // self.screenStateSubject.onNext(.noData)

        } else if (!charachters.isEmpty && result.isEmpty ) {
            print("stop infintie scrolling") // no more data
            self.infiniteScrollSubject.onNext(.remove)
         //   self.screenStateSubject.onNext(.dataLoaded)
        } else {
            print("Populate data") // data add it to array
            self.infiniteScrollSubject.onNext(.finish)
         //   self.screenStateSubject.onNext(.dataLoaded)

            charachters.append(contentsOf: result)
            self.offset += self.limit

            self.charactersSubject.accept(charachters)
        }
    }
}
