//
//  CharacterAttributesCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import UIKit
import RxSwift

class CharacterMediaCell: DisposableTableViewCell {

    @IBOutlet weak var mediaItemsCollectionView: UICollectionView!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    var items = [CharacterMediaItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        self.mediaItemsCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func setData(data: CharacterMediaData) {
        self.mediaTypeLabel.text = data.title
        self.items = data.items
        self.mediaItemsCollectionView.reloadData()
    }
    
    func setupCollectionView() {
        mediaItemsCollectionView.dataSource = self
        mediaItemsCollectionView.contentInset = UIEdgeInsets.zero
        mediaItemsCollectionView.register(MediaItemCell.nib, forCellWithReuseIdentifier: MediaItemCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3.25) - 10,
                                     height: Constants.collectionViewCellHeight.rawValue)
        mediaItemsCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

extension CharacterMediaCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaItemCell.identifier, for: indexPath)
            as? MediaItemCell {
            itemCell.setData(item: self.items[indexPath.row])
            return itemCell
        }
        
        return UICollectionViewCell()
    }
}

private enum Constants: CGFloat {
    case collectionViewCellHeight = 200
}
