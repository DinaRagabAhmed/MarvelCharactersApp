//
//  AppDelegate+extensions.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 22/10/2022.
//

import Foundation
import IQKeyboardManagerSwift

// MARK: - Responsible For any UI Modification and handle application flow
extension AppDelegate {
    
    func setupApplicationCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationCoordinator = AppCoordinator(window: window)
    }
    
    // Setup entry screen
    func setupIntialView() {
        applicationCoordinator?.start()
    }
    
    func enableIQkeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
