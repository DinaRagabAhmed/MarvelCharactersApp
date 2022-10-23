//
//  SearchViewModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

/*
 I found that "name" parameter in Marvel API returns only characters that its names match exactly the text in search bar(== not contains) so i sent email asking about that and i used "nameStartsWith" to work around this issue
 */
class SearchViewModel: BaseViewModel {
    
    struct Input {
        let didTapCancelIcon: AnyObserver<Void>
        let selectedCharacterObserver: AnyObserver<MarvelCharacter>
    }

    struct Output {
        let charactersObservable: Observable<[MarvelCharacter]>
        let infiniteScrollObservable: Observable<InfiniteScrollStatus>
        let screenResultObservable: Observable<SearchResult>
        let screenStateObservable: Observable<ScreenState>
    }
    
    let output: Output
    let input: Input

    private let charactersSubject: BehaviorRelay<[MarvelCharacter]> = BehaviorRelay(value: [MarvelCharacter]())
    private let infiniteScrollSubject: PublishSubject<InfiniteScrollStatus> = PublishSubject()
    private let screenResultSubject = PublishSubject<SearchResult>()
    private let cancelSubject = PublishSubject<Void>()
    private let selectedCharacterSubject = PublishSubject<MarvelCharacter>()
    private let screenStateSubject = PublishSubject<ScreenState>()

    var dataManager: DataManager?

    init(dataManager: DataManager?) {
        self.dataManager = dataManager
        self.input = Input(didTapCancelIcon: cancelSubject.asObserver(),
                           selectedCharacterObserver: selectedCharacterSubject.asObserver())
        self.output = Output(charactersObservable: charactersSubject.asObservable(),
                             infiniteScrollObservable: infiniteScrollSubject.asObservable(),
                             screenResultObservable: screenResultSubject.asObservable(),
                             screenStateObservable: screenStateSubject.asObservable())
        
        super.init()
        subscribeToCancelEvent()
        subscribeToCharachterSelection()
    }
    
    func subscribeToCancelEvent() {
        cancelSubject.asObservable()
           .subscribe { [weak self] _ in
               self?.screenResultSubject.onNext(.back)
           }.disposed(by: disposeBag)
    }
    
    func subscribeToCharachterSelection() {
        selectedCharacterSubject.asObservable()
           .subscribe { [weak self] character in
               self?.screenResultSubject.onNext(.characterDetails(character: character))
           }.disposed(by: disposeBag)
    }
}

// MARK: - Hablde Network call and response
extension SearchViewModel {
    
    func getFavouriteCharachters(keyword: String) {
        self.offset = 0
        self.charactersSubject.accept([])
        self.infiniteScrollSubject.onNext(.reset)
        if !keyword.isEmpty {
            self.getCharactersList(keyword: keyword)
        } else {
            self.screenStateSubject.onNext(.dataLoaded)
        }
    }
    
    func getCharactersList(keyword: String) {
        
        if Utils.isConnectedToNetwork() {
            
            let target = CharactersService.getCharachters(name: keyword,
                                                          limit: self.limit,
                                                          offset: self.offset)
            self.dataManager?.cancelAllRequests()
            self.dataManager?.callApi(target: target,
                                      type: [MarvelCharacter].self)
                .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    self.handlePagination(result: data?.results ?? [])

                case .failure:
                    if !Utils.isConnectedToNetwork() {
                        self.setError(error: .networkError)
                    }
                }
            }, onError: { [weak self](error) in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                self.setError(error: ErrorTypes.generalError)
            }).disposed(by: disposeBag)
        } else {
            self.controlLoading(showLoading: false)
            self.setError(error: .networkError)
        }
    }
    
    func handlePagination(result: [MarvelCharacter]) {
        var charachters = self.charactersSubject.value

        self.infiniteScrollSubject.onNext(.finish)
        if( result.isEmpty && charachters.isEmpty) {
            self.screenStateSubject.onNext(.noData)
            self.infiniteScrollSubject.onNext(.remove)

        } else if (!charachters.isEmpty && result.isEmpty ) {
            self.screenStateSubject.onNext(.dataLoaded)
            self.infiniteScrollSubject.onNext(.remove)
        } else {
            self.infiniteScrollSubject.onNext(.finish)
            self.screenStateSubject.onNext(.dataLoaded)

            charachters.append(contentsOf: result)
            self.offset += self.limit

            self.charactersSubject.accept(charachters)
        }
    }
}
