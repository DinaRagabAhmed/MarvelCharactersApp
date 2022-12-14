//
//  SearchVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift

/*
 I found that "name" parameter in Marvel API returns only characters that its names match
 exactly the text in search bar(== not contains) so i sent email asking about that and i used
 "nameStartsWith" to work around this issue
 */
class SearchVC: BaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noDataView: NoDataView!

    // MARK: - Properties
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        setupPagination()
        setupCollectionView()
    }
    
    //Binding
    func setupBindings() {
       super.setupBindings(baseViewModel: viewModel)
       subscribeToSearchBar()
       subscribeToCancelEvent()
       subscribeToCharacterSelection()
       subscribeToInfiniteScroll()
       subscribeToScreenState()
    }
    
    func setupView() {
        setStrings()
        self.view.addBlurEffect()
        self.searchBar.updateHeight(height: Constants.searchBarHeight.rawValue)
      
    }
    
    func setStrings() {
        self.cancelBtn.setTitle("cancel".localized(), for: .normal)
        self.cancelBtn.setTitle("cancel".localized(), for: .selected)
        self.searchBar.placeholder = "search".localized()
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
                                                        cellType: FavouriteCharacterCell.self)) {[weak self]( _, character, cell) in
                cell.setData(character: character, keyword: self?.searchBar.text ?? "")
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
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
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
                case .noData:
                    self.charactersCollectionView.isHidden = true
                    self.noDataView.isHidden = false
                case .noNetwork:
                    print("no network")
                }
            }).disposed(by: disposeBag)
    }
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 110
    case searchBarHeight = 50
}
