//
//  CharacterDataCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import UIKit

class CharacterDataCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStrings()
    }
    
    func setStrings() {
        descriptionLabel.text = "description".localized()
    }
    
    func setData(character: MarvelCharacter?) {
        self.characterNameLabel.text = character?.name ?? ""
        if let characterDescription = character?.description, !characterDescription.isEmpty {
            characterDescriptionLabel.text = characterDescription
        } else {
            characterDescriptionLabel.text = "description_empty".localized()
        }
    }
    
}
