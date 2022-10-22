//
//  CharactersListViewModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CharactersListViewModel: BaseViewModel {
    
    struct Input {
        let didTapSearchIcon: AnyObserver<Void>
        let selectedCharacterObserver: AnyObserver<MarvelCharacter>
    }
    
    struct Output {
        let charactersObservable: Observable<[MarvelCharacter]>
        let infiniteScrollObservable: Observable<InfiniteScrollStatus>
        let screenRedirectionObservable: Observable<CharactersListRedirection>
        let screenStateObservable: Observable<ScreenState>
    }
    
    let output: Output
    let input: Input

    private let charactersSubject: BehaviorRelay<[MarvelCharacter]> = BehaviorRelay(value: [MarvelCharacter]())
    private let infiniteScrollSubject: PublishSubject<InfiniteScrollStatus> = PublishSubject()
    private let screenRedirectionSubject = PublishSubject<CharactersListRedirection>()
    private let searchSubject = PublishSubject<Void>()
    private let selectedCharacterSubject = PublishSubject<MarvelCharacter>()
    private let screenStateSubject = PublishSubject<ScreenState>()

    var dataManager: DataManager?

    init(dataManager: DataManager?) {
        self.dataManager = dataManager
        self.input = Input(didTapSearchIcon: searchSubject.asObserver(),
                           selectedCharacterObserver: selectedCharacterSubject.asObserver())
        self.output = Output(charactersObservable: charactersSubject.asObservable(),
                             infiniteScrollObservable: infiniteScrollSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable(),
                             screenStateObservable: screenStateSubject.asObservable())
        
        super.init()
        
        subscribeToSearchEvent()
        subscribeToCharachterSelection()
    }
    
    func subscribeToSearchEvent() {
        searchSubject.asObservable()
           .subscribe { [weak self] _ in
               self?.screenRedirectionSubject.onNext(.search)
           }.disposed(by: disposeBag)
    }
    
    func subscribeToCharachterSelection() {
        selectedCharacterSubject.asObservable()
           .subscribe { [weak self] character in
               self?.screenRedirectionSubject.onNext(.characterDetails(character: character))
           }.disposed(by: disposeBag)
    }
}

// MARK: - Handle Network call and response
extension CharactersListViewModel {
    
    func getCharactersList() {
        
        if Utils.isConnectedToNetwork() {
            if self.offset == 0 {
                self.controlLoading(showLoading: true)
            }
            let target = CharactersService.getCharachters(limit: self.limit, offset: self.offset)
            self.dataManager?.callApi(target: target, type: [MarvelCharacter].self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    self.handlePagination(result: data?.results ?? [])

                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                        self.screenStateSubject.onNext(.noNetwork)
                    } else {
                        self.setError(error: error.type ?? ErrorTypes.generalError)
                    }
                }
            }, onError: { [weak self](error) in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                self.setError(error: ErrorTypes.generalError)
                self.infiniteScrollSubject.onNext(.finish)
            }).disposed(by: disposeBag)
        } else {
            self.controlLoading(showLoading: false)
            self.infiniteScrollSubject.onNext(.finish)
            if self.offset == 0 {
                self.screenStateSubject.onNext(.noNetwork)
            } else {
                self.setError(error: .networkError)
            }
        }
    }
    
    func handlePagination(result: [MarvelCharacter]) {
        var charachters = self.charactersSubject.value

        self.infiniteScrollSubject.onNext(.finish)
        if( result.isEmpty && charachters.isEmpty) {
            print("no data") // no data
            self.infiniteScrollSubject.onNext(.remove)
            self.screenStateSubject.onNext(.noData)

        } else if (!charachters.isEmpty && result.isEmpty ) {
            print("stop infintie scrolling") // no more data
            self.infiniteScrollSubject.onNext(.remove)
            self.screenStateSubject.onNext(.dataLoaded)
        } else {
            print("Populate data") // data add it to array
            self.infiniteScrollSubject.onNext(.finish)
            self.screenStateSubject.onNext(.dataLoaded)

            charachters.append(contentsOf: result)
            self.offset += self.limit

            self.charactersSubject.accept(charachters)
        }
    }
}
