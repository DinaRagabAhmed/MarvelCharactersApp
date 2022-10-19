//
//  Coordinator.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

// MARK: - Coordinator
// To add coordinators in array and remove it from memory after deallocations
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
}
