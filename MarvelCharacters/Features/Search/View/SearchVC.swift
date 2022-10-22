//
//  SearchVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift

class SearchVC: BaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        setupPagination()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //Binding
    func setupBindings() {
       super.setupBindings(baseViewModel: viewModel)
       subscribeToSearchBar()
       subscribeToCancelEvent()
       subscribeToCharacterSelection()
       subscribeToInfiniteScroll()
    }
    
    func setupView() {
        self.view.addBlurEffect()
        searchBar.updateHeight(height: Constants.searchBarHeight.rawValue)
    }
    
    func setupCollectionView() {
        charactersCollectionView.contentInset = UIEdgeInsets.zero
        charactersCollectionView.register(FavouriteCharacterCell.nib, forCellWithReuseIdentifier: FavouriteCharacterCell.identifier)
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
            .bind(to: charactersCollectionView.rx.items(cellIdentifier: FavouriteCharacterCell.identifier,
                                                        cellType: FavouriteCharacterCell.self)) {( _, character, cell) in
                cell.setData(character: character)
            }.disposed(by: disposeBag)
    }
    
    func setupPagination() {
        charactersCollectionView.addInfiniteScroll { [weak self] _ -> Void in
            self?.viewModel.getCharactersList(keyword: self?.searchBar.text ?? "")
        }
    }
}

// MARK: - Subscribers and Binding
extension SearchVC {
    func subscribeToSearchBar() {
        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[MarvelCharacter]?> in
                self?.viewModel.getFavouriteCharachters(keyword: query ?? "")
                return Observable.never()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    
    func subscribeToCancelEvent() {
        self.cancelBtn.rx.tap
            .bind(to: self.viewModel.input.didTapCancelIcon)
            .disposed(by: disposeBag)
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
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 110
    case searchBarHeight = 50
}
