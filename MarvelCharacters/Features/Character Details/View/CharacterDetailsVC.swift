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
        setupBindings()
        setupTableView()
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
        tableView.register(CharacterAttributesCell.nib,
                           forCellReuseIdentifier: CharacterAttributesCell.identifier)
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
        self.viewModel.output.screenModelObservable
            .bind(to: tableView.rx.items){ [weak self] (tableView, row, item) -> UITableViewCell in
                switch item {
                case .characterImage(let thumbnail):
                    return self?.configureCharacterImageCell(from: tableView, index: IndexPath.init(row: row, section: 0), thumbnail: thumbnail) ?? UITableViewCell()
                case .characterData(let character):
                    return self?.configureCharacterDataCell(from: tableView, index: IndexPath.init(row: row, section: 0), character: character) ?? UITableViewCell()
                case .characterAttributes(let attributes):
                    if !(attributes.items.isEmpty) {
                        return self?.configureCharacterAttributesCell(from: tableView, index: IndexPath.init(row: row, section: 0), attributes: attributes) ?? UITableViewCell()
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
                                             index: IndexPath,
                                             thumbnail: Thumbnail?) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterImageCell.identifier, for: index) as? CharacterImageCell
        cell?.setData(thumbnail: thumbnail)
        subscribeToDismissScreenEvent(cell: cell)
        return cell ?? UITableViewCell()
    }
    
    //Charcter Name and description
    private func configureCharacterDataCell(from table: UITableView,
                                            index: IndexPath,
                                            character: MarvelCharacter?) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterDataCell.identifier, for: index) as? CharacterDataCell
        cell?.setData(character: character)
        return cell ?? UITableViewCell()
    }
    
    //Charcter Attributes
    private func configureCharacterAttributesCell(from table: UITableView,
                                                  index: IndexPath,
                                                  attributes: CharacterAttributeData) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CharacterAttributesCell.identifier, for: index) as? CharacterAttributesCell
        cell?.setData(data: attributes)
        return cell ?? UITableViewCell()
    }
}

// MARK: - Subscribtion and binding
extension CharacterDetailsVC {
    
    private func subscribeToDismissScreenEvent(cell: CharacterImageCell?) {
        cell?.didTapBack
            .asObservable()
            .subscribe(onNext: { [weak self] status in
                print("back")
                self?.viewModel.dismissScreen()
            })
            .disposed(by: cell?.disposeBag ?? DisposeBag())
    }
}
