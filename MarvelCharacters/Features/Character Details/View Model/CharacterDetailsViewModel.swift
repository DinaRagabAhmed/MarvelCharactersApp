//
//  CharacterDetailsViewModel.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CharacterDetailsViewModel: BaseViewModel {
    
    struct Output {
        let characterDataObservable: Observable<[CharacterDetailsItem]>
        let screenRedirectionObservable: Observable<CharacterDetailsRedirection>
    }
    
    let output: Output

    var dataManager: DataManager?
    var character: MarvelCharacter

    private let characterDataSubject: BehaviorRelay<[CharacterDetailsItem]> = BehaviorRelay(value: [CharacterDetailsItem]())
    private let screenRedirectionSubject = PublishSubject<CharacterDetailsRedirection>()

    init(dataManager: DataManager?, character: MarvelCharacter) {
        self.output = Output(characterDataObservable: characterDataSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable())
        self.dataManager = dataManager
        self.character = character
        super.init()
    }
    
    func setupCharacterBasicData(character: MarvelCharacter) {
        let characterImage = CharacterDetailsItem.characterImage(thumbnail: character.thumbnail)
        let characterData = CharacterDetailsItem.characterData(character: character)

        let models = [characterImage, characterData]
        characterDataSubject.accept(models)
    }
}

// MARK: - Handle Data
extension CharacterDetailsViewModel {
    
    func viewDidLoad() {
        self.setupCharacterBasicData(character: self.character)
        self.getAllMediaData()
    }
    
    func setupCharacterMediaData(series: [CharacterMediaItem],
                                 comics: [CharacterMediaItem],
                                 events: [CharacterMediaItem],
                                 stories: [CharacterMediaItem]) {
        
        var data = self.characterDataSubject.value

        if !comics.isEmpty {
            let comicsData = CharacterDetailsItem.characterMedia(data: CharacterMediaData(type: .comis, title: "comics".localized(), items: comics))
            data.append(comicsData)
        }
        
        if !events.isEmpty {
            let eventsData = CharacterDetailsItem.characterMedia(data: CharacterMediaData(type: .events, title: "events".localized(), items: events))
            data.append(eventsData)
        }
        
        if !series.isEmpty {
            let seriesData = CharacterDetailsItem.characterMedia(data: CharacterMediaData(type: .series, title: "series".localized(), items: series))
            data.append(seriesData)
        }
       
        if !stories.isEmpty {
            let storiesData = CharacterDetailsItem.characterMedia(data: CharacterMediaData(type: .stories, title: "stories".localized(), items: stories))
            data.append(storiesData)
        }
               
        self.characterDataSubject.accept(data)
    }
}

// MARK: - Network Calls
extension CharacterDetailsViewModel {
    
    func getAllMediaData() {
        self.controlLoading(showLoading: true)
        let seriesTarget = CharactersService.getSeries(characterID: self.character.id ?? 0)
        let storiesTarget = CharactersService.getStories(characterID: self.character.id ?? 0)
        let comicsTarget = CharactersService.getComics(characterID: self.character.id ?? 0)
        let eventsTarget = CharactersService.getEvents(characterID: self.character.id ?? 0)
        
        Observable.zip(getMediaTypeData(target: seriesTarget), getMediaTypeData(target: comicsTarget), getMediaTypeData(target: eventsTarget), getMediaTypeData(target: storiesTarget))
            .subscribe { [weak self] series, comics , events, stories in
               print("Got all data")
                self?.controlLoading(showLoading: false)
                self?.setupCharacterMediaData(series: series,
                                              comics: comics,
                                              events: events,
                                              stories: stories)
            }
            .disposed(by: disposeBag)
    }
    
    
    func getMediaTypeData(target: CharactersService) -> Observable<[CharacterMediaItem]>{
        return Observable<[CharacterMediaItem]>.create { [weak self] observer in
            self?.dataManager?.callApi(target: target,
                                      type: [CharacterMediaItem].self)
                .subscribe(onNext: { result in
                switch result {
                case .success (let data):
                    observer.onNext(data?.results ?? [])
                    observer.onCompleted()
                case .failure:
                    observer.onNext([])
                    observer.onCompleted()
                }
            }, onError: {(error) in
                observer.onNext([])
                observer.onCompleted()
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
}

// MARK: - Handling Navigation
extension CharacterDetailsViewModel {
    
    func dismissScreen() {
        self.screenRedirectionSubject.onNext(.back)
    }
}
