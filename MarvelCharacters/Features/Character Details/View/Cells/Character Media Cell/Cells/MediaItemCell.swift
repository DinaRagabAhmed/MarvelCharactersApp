//
//  AttributeItemCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import UIKit

class MediaItemCell: UICollectionViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(item: CharacterMediaItem) {
        itemName.text = item.title ?? ""
        if let thumbnail = item.thumbnail {
            let url = URL(string: "\(thumbnail.path ?? "").\(thumbnail.thumbnailExtension ?? "")")
            if let url = url {
                itemImageView.sd_setImage(with: url,
                                          placeholderImage: UIImage(named: "image-placeholder"))
            } else {
                itemImageView.image = UIImage(named: "image-placeholder")
            }
        } else {
            itemImageView.image = UIImage(named: "image-placeholder")
        }
    }
}
