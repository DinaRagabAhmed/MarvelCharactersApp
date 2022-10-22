//
//  CharacterDetailsCoodinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import RxSwift
import UIKit

class CharacterDetailsCoodinator: BaseCoordinator<Void> {
    
    private let router: Routing
    private let character: MarvelCharacter
    
    init(router: Routing, character: MarvelCharacter) {
        self.router = router
        self.character = character
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let viewController =  CharacterDetailsVC()
        let viewModel = CharacterDetailsViewModel(dataManager: DataSource.provideNetworkDataSource(), character: character)
        viewController.viewModel = viewModel
        router.present(viewController, isAnimated: true, onDismiss: isCompleted)

        bindToScreenNavigation(viewModel: viewModel)
        return Observable.never()
    }
    
    // Binding
    func bindToScreenNavigation(viewModel: CharacterDetailsViewModel) {
        viewModel.output.screenRedirectionObservable
            .subscribe(onNext: { [weak self](redirection) in
                guard let self = self else { return }
                switch redirection {
                case .back:
                    self.router.dismissModule(animated: true)
                }
            })
            .disposed(by: bag)
    }
}

enum CharacterDetailsRedirection {
    case back
}
