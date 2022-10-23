//
//  DisposableTableViewCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import RxSwift
import UIKit

class DisposableTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
