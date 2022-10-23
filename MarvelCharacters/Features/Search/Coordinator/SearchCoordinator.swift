//
//  SearchCoordinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import UIKit

class SearchCoordinator: BaseCoordinator<SearchResult> {
    
    private let router: Routing

    init(router: Routing) {
        self.router = router
    }
    
    
    override func start() -> Observable<SearchResult> {
        let viewController =  SearchVC()
        let viewModel = SearchViewModel(dataManager: DataSource.provideNetworkDataSource())
        viewController.viewModel = viewModel
        
        router.present(viewController, isAnimated: true, onDismiss: isCompleted)
        
        return subscribeToViewControllerResult(viewModel: viewModel)
    }
    
    // Binding
    func subscribeToViewControllerResult(viewModel: SearchViewModel)
    -> Observable<SearchResult> {
        
        return viewModel.output.screenResultObservable.do(onNext: {[weak self]  _ in
            self?.router.dismissModule(animated: true)
        })
    }
}

enum SearchResult {
    case back
    case characterDetails(character: MarvelCharacter)
}

