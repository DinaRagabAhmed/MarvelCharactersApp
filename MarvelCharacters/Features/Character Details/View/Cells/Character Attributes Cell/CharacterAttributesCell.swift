//
//  CharacterAttributesCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import UIKit

class CharacterAttributesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var items = [CharacterAttributeItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func setData(data: CharacterAttributeData) {
        self.titleLabel.text = data.title
        self.items = data.items
        self.collectionView.reloadData()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.register(AttributeItemCell.nib, forCellWithReuseIdentifier: AttributeItemCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3.25) - 10,
                                     height: Constants.collectionViewCellHeight.rawValue)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

extension CharacterAttributesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AttributeItemCell.identifier, for: indexPath)
            as? AttributeItemCell {
            itemCell.setData(item: self.items[indexPath.row])
            return itemCell
        }
        
        return UICollectionViewCell()
    }
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 200
}
