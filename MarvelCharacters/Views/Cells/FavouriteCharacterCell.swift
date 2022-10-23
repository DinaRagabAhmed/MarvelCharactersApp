//
//  FavouriteCharacterCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 20/10/2022.
//

import UIKit
import RxSwift

class FavouriteCharacterCell: DisposableCollectionViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        characterImageView.image = nil
        characterNameLabel.removeHightLight()
    }
    
    func setData(character: MarvelCharacter, keyword: String) {
        characterNameLabel.text = character.name
        characterNameLabel.highlight(searchedText: keyword, color: .red)

        if let thumbnail = character.thumbnail {
            let url = URL(string: "\(thumbnail.path ?? "").\(thumbnail.thumbnailExtension ?? "")")
            if let url = url {
                characterImageView.sd_setImage(with: url,
                                               placeholderImage: UIImage(named: "image-placeholder"))
            } else {
                characterImageView.image = UIImage(named: "image-placeholder")
            }
        } else {
            characterImageView.image = UIImage(named: "image-placeholder")
        }
    }

}
