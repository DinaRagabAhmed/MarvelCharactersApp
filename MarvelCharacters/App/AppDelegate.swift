//
//  AppDelegate.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var applicationCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupApplicationCoordinator()
        setupIntialView()
        
        print(Environment.baseURL)
        return true
    }
    
    func setupApplicationCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationCoordinator = AppCoordinator(window: window)
    }
    
    // Setup entry screen
    func setupIntialView() {
        applicationCoordinator?.start()
    }
}

