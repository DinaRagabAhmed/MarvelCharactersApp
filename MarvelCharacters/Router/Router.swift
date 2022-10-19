//
//  Router.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit

final class Router: NSObject {
    
    private var navigationController: UINavigationController
    private var closures: [String: NavigationBackClosure] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
}

extension Router: Routing {
   
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else {
            return
        }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss closure: NavigationBackClosure?) {
        
        guard let viewController = drawable.viewController else {
            return
        }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true, completion: nil)
        viewController.presentationController?.delegate = self
    }
    
    func dismissModule(animated: Bool) {
        navigationController.dismiss(animated: true)
    }
        
    func controlPopGesture(enable: Bool) {
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        //Excute closure is completed to deallocate coordinator reference
        closure()
    }
    
    func pushToRoot(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        
        if drawable.viewController != nil {
            //Hide nabigation bar back and push new vc
         //   drawable.viewController?.navigationItem.setHidesBackButton(true, animated: true)
            self.push(drawable, isAnimated: isAnimated, onNavigateBack: closure)
            //Remove all previous view controllers
            let viewControllerCount = self.navigationController.viewControllers.count
            if viewControllerCount > 1 {
                self.navigationController.viewControllers.removeFirst(viewControllerCount-1)
            }
        } else {
            return
        }
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        //Detect if is it is push or pop
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(previousController) else {
            return
        }
        // Detect view controller has heen Poped to excute remove coordinator reference
        executeClosure(previousController)
    }
}

extension Router: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Detect view controller has heen dismissed to excute remove coordinator reference
        executeClosure(presentationController.presentedViewController)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        executeClosure(presentationController.presentedViewController)
    }
}


