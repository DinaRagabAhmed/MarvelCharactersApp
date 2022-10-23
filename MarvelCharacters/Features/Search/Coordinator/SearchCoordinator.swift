//
//  SearchCoordinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import Foundation
import RxSwift
import UIKit

/*
 I found that "name" parameter in Marvel API returns only characters that its names match exactly the text in search bar(== not contains) so i sent email asking about that and i used "nameStartsWith" to workaroud this issue
 */
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

