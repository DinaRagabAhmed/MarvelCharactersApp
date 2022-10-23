//
//  CharacterImageCell.swift
//  MarvelCharacters
//
//  Created by Dina Ragab on 21/10/2022.
//

import UIKit
import RxSwift
import RxGesture

class CharacterImageCell: DisposableTableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    let didTapBack = PublishSubject<Void>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        characterImageView.image = nil
    }
    
    func setupView() {
        backView.roundCorners([.topRight, .bottomRight], radius: 5)
    }
    
    func setData(thumbnail: Thumbnail?) {
        
        self.subscribeToBackEvent()
        
        if let thumbnail = thumbnail {
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
    
    func subscribeToBackEvent() {
        backView.rx.tapGesture()
        .subscribe(onNext: { [weak self] _ in
            self?.didTapBack.onNext(Void())
        })
        .disposed(by: disposeBag)
    }
}
