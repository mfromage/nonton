//
//  CastCollectionViewCell.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MovieCastCellViewModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
		profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.lightGray
        profileImageView.contentMode = .scaleAspectFill
    }
    
    func bindViewModel(viewModel: MovieCastCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.cast.asObservable()
            .map { cast -> URL? in
                return cast.thumbnailProfileImageURL()
            }
            .subscribe(onNext: { [weak self] profileImageURL in
                guard let `self` = self else {
                    return
                }
                
                self.profileImageView.sd_setImage(with: profileImageURL, completed: { (image, error, cacheType, url) in
                    
                    if image != nil {
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
                    }
                })
                
            })
            .disposed(by: disposeBag)
        
        viewModel.cast.asObservable()
            .map { cast -> String? in
                
                return cast.name
            }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    

}
