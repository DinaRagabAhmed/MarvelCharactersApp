//
//  BaseVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 19/10/2022.
//

import Foundation
import RxSwift
import MBProgressHUD
import Toast_Swift

// MARK: - Base View Controller
class BaseVC: UIViewController {
    
    var loadingView: MBProgressHUD!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBindings(baseViewModel: BaseViewModel) {
        bindLoading(baseViewModel: baseViewModel)
        bindErrors(baseViewModel: baseViewModel)
    }
    
    // MARK: - Binding Errors
    func bindErrors(baseViewModel: BaseViewModel) {
        baseViewModel
            .baseOutput
            .errorsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (error) in
                
                switch error {
                case .networkError:
                    self?.showNetworkError()
                case .customError(msg: let msg):
                    self?.showMessageToUser(msg: msg)
                case .generalError:
                    self?.showGeneralError()
                case .unKnown:
                    if Utils.isConnectedToNetwork() {
                        self?.showGeneralError()
                    } else {
                        self?.showNetworkError()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Binding Loading
    func bindLoading(baseViewModel: BaseViewModel) {
        baseViewModel
            .baseOutput.loadingObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (isLoading) in
                isLoading ? self?.showLoading() : self?.hideLoading()
            }).disposed(by: disposeBag)
    }
}

// MARK: - Base View Controller conform Base View (vc general functions)
extension BaseVC: BaseView {
    
    func showGeneralError() {
        showMessageToUser(msg: "generalError".localized())
    }
    
    func showLoading() {
        if loadingView != nil {
            loadingView = nil
        }
        loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.mode = MBProgressHUDMode.indeterminate
    }
    
    func hideLoading() {
        if loadingView != nil {
            loadingView.hide(animated: true)
            loadingView = nil
        }
    }
    
    func showNetworkError() {
        showMessageToUser(msg: "networkError".localized())
    }
    
    func showMessageToUser(msg: String) {
        self.view.makeToast(msg)
    }
}
