//
//  CharacterDetailsVC.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift

class CharacterDetailsVC: BaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: CharacterDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
        self.setupTableView()
        self.viewModel.viewDidLoad()
    }
    
    //Binding
    func setupBindings() {
        super.setupBindings(baseViewModel: viewModel)
    }
    
    func setupTableView() {
        registerCells()
        setupCellCustomization()
        setupDataSource()
    }
    
    func registerCells() {
        tableView.register(CharacterImageCell.nib,
                           forCellReuseIdentifier: CharacterImageCell.identifier)
        tableView.register(CharacterDataCell.nib,
                           forCellReuseIdentifier: CharacterDataCell.identifier)
        tableView.register(CharacterMediaCell.nib,
                           forCellReuseIdentifier: CharacterMediaCell.identifier)
    }
    
    func setupCellCustomization() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupDataSource() {
        self.viewModel.output.characterDataObservable
            .bind(to: tableView.rx.items){ [weak self] (tableView, row, item) -> UITableViewCell in
                switch item {
                case .characterImage(let thumbnail):
                    return self?.configureCharacterImageCell(from: tableView, index: row, thumbnail: thumbnail) ?? UITableViewCell()
                case .characterData(let character):
                    return self?.configureCharacterDataCell(from: tableView, index: row, character: character) ?? UITableViewCell()
                case .characterMedia(let attributes):
                    if !(attributes.items.isEmpty) {
                        return self?.configureCharacterMediaCell(from: tableView, index: row, mediaData: attributes) ?? UITableViewCell()
                    } else {
                        return UITableViewCell()
                    }
                }
             
            }.disposed(by: disposeBag)
    }
}

// MARK: - Table view cells
extension CharacterDetailsVC {
    
    //Charcter Image
    private func configureCharacterImageCell(from table: UITableView,
                                             index: Int,
                                             thumbnail: Thumbnail?) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterImageCell.identifier,
                                             for: IndexPath(row: index, section: 0)) as? CharacterImageCell
        cell?.setData(thumbnail: thumbnail)
        subscribeToDismissScreenEvent(cell: cell)
        return cell ?? UITableViewCell()
    }
    
    //Charcter Name and description
    private func configureCharacterDataCell(from table: UITableView,
                                            index: Int,
                                            character: MarvelCharacter?) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterDataCell.identifier,
                                             for: IndexPath(row: index, section: 0)) as? CharacterDataCell
        cell?.setData(character: character)
        return cell ?? UITableViewCell()
    }
    
    //Charcter Attributes
    private func configureCharacterMediaCell(from table: UITableView,
                                             index: Int,
                                             mediaData: CharacterMediaData) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterMediaCell.identifier,
                                             for: IndexPath(row: index, section: 0)) as? CharacterMediaCell
        cell?.setData(data: mediaData)
        return cell ?? UITableViewCell()
    }
}

// MARK: - Subscribtion and binding
extension CharacterDetailsVC {
    
    private func subscribeToDismissScreenEvent(cell: CharacterImageCell?) {
        cell?.didTapBack
            .asObservable()
            .subscribe(onNext: { [weak self] status in
                self?.viewModel.dismissScreen()
            })
            .disposed(by: cell?.disposeBag ?? DisposeBag())
    }
}
