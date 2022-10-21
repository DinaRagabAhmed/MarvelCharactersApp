//
//  CharactersListCoordinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import UIKit

class CharactersListCoordinator: BaseCoordinator<Void> {
    
    private let router: Routing

    init(router: Routing) {
        self.router = router
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let viewController =  CharactersListVC()
        let viewModel = CharactersListViewModel(dataManager: DataSource.provideNetworkDataSource())
        viewController.viewModel = viewModel
        
        router.push(viewController, isAnimated: true, onNavigateBack: isCompleted)
        
        bindToScreenNavigation(viewModel: viewModel)
        return Observable.never()
    }
    
    //Binding
    func bindToScreenNavigation(viewModel: CharactersListViewModel) {
        viewModel.output.screenRedirectionObservable
            .subscribe(onNext: { [weak self](redirection) in
                guard let self = self else { return }
                switch redirection {
                case .search:
                    self.redirectToSearchScreen()
                case .characterDetails(let character):
                    self.redirectToCharacterDetailsScreen(character: character)
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Navigation
extension CharactersListCoordinator {
    
    func redirectToSearchScreen() {
        let searchCoordinator = SearchCoordinator(router: router)
        self.add(coordinator: searchCoordinator)
         
        searchCoordinator.isCompleted = { [weak self, weak searchCoordinator] in
             guard let coordinator = searchCoordinator else {
                 return
             }
             self?.remove(coordinator: coordinator)
         }
         
        searchCoordinator.start()
    }
    
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

enum CharactersListRedirection {
    case search
    case characterDetails(character: MarvelCharacter)
}
