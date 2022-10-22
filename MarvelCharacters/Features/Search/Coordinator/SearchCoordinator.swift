//
//  SearchCoordinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import UIKit

class SearchCoordinator: BaseCoordinator<Void> {
    
    private let router: Routing

    init(router: Routing) {
        self.router = router
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let viewController =  SearchVC()
        let viewModel = SearchViewModel(dataManager: DataSource.provideNetworkDataSource())
        viewController.viewModel = viewModel
        
        router.push(viewController, isAnimated: true, onNavigateBack: isCompleted)
        
        bindToScreenNavigation(viewModel: viewModel)
        return Observable.never()
    }
    
    // Binding
    func bindToScreenNavigation(viewModel: SearchViewModel) {
        viewModel.output.screenRedirectionObservable
            .subscribe(onNext: { [weak self](redirection) in
                guard let self = self else { return }
                switch redirection {
                case .back:
                    self.router.pop(true)
                case .characterDetails(let character):
                    self.redirectToCharacterDetailsScreen(character: character)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Navigation
extension SearchCoordinator {
    
    func redirectToCharacterDetailsScreen(character: MarvelCharacter) {
        let characterDetailsCoodinator = CharacterDetailsCoodinator(router: router,
                                                                    character: character)
        self.add(coordinator: characterDetailsCoodinator)
         
        characterDetailsCoodinator.isCompleted = { [weak self, weak characterDetailsCoodinator] in
             guard let coordinator = characterDetailsCoodinator else {
                 return
             }
             self?.remove(coordinator: coordinator)
         }
         
        characterDetailsCoodinator.start()
    }
}

enum SearchRedirection {
    case back
    case characterDetails(character: MarvelCharacter)
}
