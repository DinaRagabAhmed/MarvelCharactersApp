//
//  CharactersListVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift
import UIScrollView_InfiniteScroll

class CharactersListVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var noDataView: NoDataView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var noNetworkView: NoNetworkView!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    // MARK: - Properties
    var viewModel: CharactersListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.setupPagination()
        self.setupCollectionView()
        
        self.viewModel.getCharactersList()
    }
    
    //Binding
    func setupBindings() {
        super.setupBindings(baseViewModel: viewModel)
        subscribeToInfiniteScroll()
        subscribeToSearchEvent()
        subscribeToCharacterSelection()
        subscribeToScreenState()
        subscribeToNetworkReconnection()
    }
    
    func setupCollectionView() {
        charactersCollectionView.contentInset = UIEdgeInsets.zero
        charactersCollectionView.register(CharacterCell.nib, forCellWithReuseIdentifier: CharacterCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: Constants.collectionViewCellHeight.rawValue)
        charactersCollectionView.setCollectionViewLayout(flowLayout, animated: true)

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        charactersCollectionView.infiniteScrollIndicatorView = indicator
        
        setupDataSource()
    }
    
    func setupDataSource() {
        viewModel.output.charactersObservable
            .observe(on: MainScheduler.instance)
            .bind(to: charactersCollectionView.rx.items(cellIdentifier: CharacterCell.identifier,
                                                        cellType: CharacterCell.self)) {( _, character, cell) in
                cell.setData(character: character)
            }.disposed(by: disposeBag)
    }
    
    func setupPagination() {
        charactersCollectionView.addInfiniteScroll { [weak self] _ -> Void in
            self?.viewModel.getCharactersList()
        }
    }
}

// MARK: - Subscribers and Binding
extension CharactersListVC {
    
    func subscribeToSearchEvent() {
        self.searchBtn.rx.tap.bind(to: self.viewModel.input.didTapSearchIcon).disposed(by: disposeBag)
    }
    
    func subscribeToCharacterSelection() {
        charactersCollectionView.rx.modelSelected(MarvelCharacter.self)
            .bind(to: self.viewModel.input.selectedCharacterObserver)
            .disposed(by: disposeBag)
    }
    
    func subscribeToInfiniteScroll() {
        viewModel
            .output.infiniteScrollObservable
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] scrollStatus in
                guard let self = self else { return }
                switch scrollStatus {
                case .remove:
                    self.charactersCollectionView.removeInfiniteScroll()
                case .finish:
                    self.charactersCollectionView.finishInfiniteScroll()
                case .reset:
                    self.setupPagination()
                }
            }).disposed(by: disposeBag)
    }
    
    func subscribeToScreenState() {
        viewModel
            .output.screenStateObservable
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] screenStatus in
                guard let self = self else { return }
                switch screenStatus {
                case .dataLoaded:
                    self.charactersCollectionView.isHidden = false
                    self.noDataView.isHidden = true
                    self.noNetworkView.isHidden = true
                case .noData:
                    self.charactersCollectionView.isHidden = true
                    self.noDataView.isHidden = false
                    self.noNetworkView.isHidden = true
                case .noNetwork:
                    self.charactersCollectionView.isHidden = true
                    self.noDataView.isHidden = true
                    self.noNetworkView.isHidden = false
                }
            }).disposed(by: disposeBag)
    }
    
    func subscribeToNetworkReconnection() {
        noNetworkView.retryBtn.rx.tap
        .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if Utils.isConnectedToNetwork() {
                self.viewModel.getCharactersList()
            }
        })
        .disposed(by: disposeBag)
    }
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 170
}
