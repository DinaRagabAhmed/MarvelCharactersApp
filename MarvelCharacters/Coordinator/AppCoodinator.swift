//
//  AppCoodinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private var router: Routing?
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        self.childCoordinators.removeAll()
        return Observable.never()
      //  return navigateToCartVC()
    }
 

    func startIntialScreen(coordinator: BaseCoordinator<Void>) -> Observable<Void> {
        self.add(coordinator: coordinator)
        
        coordinator.isCompleted = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinator.start()
    }
    
//    func navigateToCartVC() -> Observable<Void> {
//        let router = Router(navigationController: navigationController)
//        let cartCoordinator = CartCoordinator(router: router)
//
//        self.router = router
//        return startIntialScreen(coordinator: cartCoordinator)
//    }
}
