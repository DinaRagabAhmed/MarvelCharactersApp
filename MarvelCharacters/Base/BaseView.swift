//
//  BaseView.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation

// MARK: - Base View
protocol BaseView: AnyObject {
    
    func showLoading()
    func hideLoading()
    func showNetworkError()
    func showGeneralError()
}
