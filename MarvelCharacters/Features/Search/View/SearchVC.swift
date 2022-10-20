//
//  SearchVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift

class SearchVC: BaseVC {

    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
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
        charactersCollectionView.infiniteScrollIndicatorView?.backgroundColor = .white
        charactersCollectionView.infiniteScrollIndicatorView?.tintColor = .red

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

}

// MARK: - Subscribers and Binding
extension SearchVC {
    func subscribeToSearchBar() {
        searchBar.rx.text
            .filter { $0 != nil && !($0?.isEmpty ?? false) }
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
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
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 100
    case searchBarHeight = 50

}
