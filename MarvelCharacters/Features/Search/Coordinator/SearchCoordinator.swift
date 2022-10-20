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
        
        router.present(viewController, isAnimated: true, onDismiss: isCompleted)
        
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
                    print("back")
                    self.router.dismissModule(animated: true)
                }
            })
            .disposed(by: bag)
    }
}

enum SearchRedirection {
    case back
}
