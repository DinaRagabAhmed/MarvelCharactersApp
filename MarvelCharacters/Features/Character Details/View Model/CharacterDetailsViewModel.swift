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
    
    struct Input {
    }
    
    struct Output {
        let screenModelObservable: Observable<[CharacterDetailsItem]>
        let screenRedirectionObservable: Observable<CharacterDetailsRedirection>
    }
    
    let output: Output
    let input: Input

    var dataManager: DataManager?
    var character: MarvelCharacter

    private let screenModelSubject: BehaviorRelay<[CharacterDetailsItem]> = BehaviorRelay(value: [CharacterDetailsItem]())
    private let screenRedirectionSubject = PublishSubject<CharacterDetailsRedirection>()

    init(dataManager: DataManager?, character: MarvelCharacter) {
        self.input = Input()
        self.output = Output(screenModelObservable: screenModelSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable())
        self.dataManager = dataManager
        self.character = character
        super.init()
    }
    
    func prepareData(character: MarvelCharacter) {
        let characterImage = CharacterDetailsItem.characterImage(thumbnail: character.thumbnail)
        let characterData = CharacterDetailsItem.characterData(character: character)

        let models = [characterImage, characterData]
        screenModelSubject.accept(models)
    }
}

// MARK: - Network Calls
extension CharacterDetailsViewModel {
    
    func viewDidLoad() {
        self.prepareData(character: self.character)
        self.getData()
    }
    
    func getData() {
        self.controlLoading(showLoading: true)
        Observable.zip(getCharacterSeries(), getCharacterComics() , getCharacterEvents(), getCharacterStories())
            .subscribe { [weak self] series, comics , events, stories in
               print("Got all data")
                self?.controlLoading(showLoading: false)
                self?.prepareDataAgain(series: series, comics: comics, events: events, stories: stories)
            }
            .disposed(by: disposeBag)
    }
    
    func prepareDataAgain(series: [CharacterAttributeItem],
                          comics: [CharacterAttributeItem],
                          events: [CharacterAttributeItem],
                          stories: [CharacterAttributeItem]) {
        
        var data = self.screenModelSubject.value

        if !comics.isEmpty {
            let comicsData = CharacterDetailsItem.characterAttributes(attributes: CharacterAttributeData(type: .comis, title: "comics".localized(), items: comics))
            data.append(comicsData)
        }
        
        if !events.isEmpty {
            let eventsData = CharacterDetailsItem.characterAttributes(attributes: CharacterAttributeData(type: .events, title: "events".localized(), items: events))
            data.append(eventsData)
        }
        
        if !series.isEmpty {
            let seriesData = CharacterDetailsItem.characterAttributes(attributes: CharacterAttributeData(type: .series, title: "series".localized(), items: series))
            data.append(seriesData)
        }
       
        if !stories.isEmpty {
            let storiesData = CharacterDetailsItem.characterAttributes(attributes: CharacterAttributeData(type: .stories, title: "stories".localized(), items: stories))
            data.append(storiesData)
        }
               
        self.screenModelSubject.accept(data)
    }
    
    
    func getCharacterSeries() -> Observable<[CharacterAttributeItem]> {
           
        return Observable<[CharacterAttributeItem]>.create { [weak self] observer in
            let target = CharactersService.getSeries(characterID: self?.character.id ?? 0)
            self?.dataManager?.callApi(target: target,
                                      type: CharacterAttributeItem.self)
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
    
    func getCharacterStories() -> Observable<[CharacterAttributeItem]> {
        return Observable<[CharacterAttributeItem]>.create { [weak self] observer in
            let target = CharactersService.getStories(characterID: self?.character.id ?? 0)
            self?.dataManager?.callApi(target: target,
                                      type: CharacterAttributeItem.self)
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
    
    func getCharacterComics() -> Observable<[CharacterAttributeItem]> {
        return Observable<[CharacterAttributeItem]>.create { [weak self] observer in
            let target = CharactersService.getComics(characterID: self?.character.id ?? 0)
            self?.dataManager?.callApi(target: target,
                                      type: CharacterAttributeItem.self)
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
    
    func getCharacterEvents() -> Observable<[CharacterAttributeItem]> {
        return Observable<[CharacterAttributeItem]>.create { [weak self] observer in
            let target = CharactersService.getEvents(characterID: self?.character.id ?? 0)
            self?.dataManager?.callApi(target: target,
                                      type: CharacterAttributeItem.self)
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
 enum CharacterDetailsItem {
    case characterImage(thumbnail: Thumbnail?)
    case characterData(character: MarvelCharacter?)
    case characterAttributes(attributes: CharacterAttributeData)
}

class CharacterAttributeData {
    var type: CharacterAttributesTypes
    var title: String
    var items: [CharacterAttributeItem]
    
    init(type: CharacterAttributesTypes, title: String = "", items: [CharacterAttributeItem] = []) {
        self.type = type
        self.title = title
        self.items = items
    }
}

enum CharacterAttributesTypes {
    case comis
    case events
    case series
    case stories
}
