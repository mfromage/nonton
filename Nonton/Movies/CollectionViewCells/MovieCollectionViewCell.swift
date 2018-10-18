//
//  MovieCell.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MovieCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.posterImageView.clipsToBounds = true
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.backgroundColor = UIColor.gray
        
    }
    
    func bind(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.movie.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (movie: Movie?) -> String? in
				
                return movie?.title
            }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (movie: Movie?) -> String? in
                
                return movie?.formattedVoteAverage()
            }
            .bind(to: voteAverageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (movie: Movie?) -> String? in
                
                guard let movie = movie,
				let voteCount = movie.voteCount else {
                    return ""
                }
				
				return String(format: "(%d)", voteCount)
                
            }
            .bind(to: voteCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ (movie) -> URL? in
				
                return movie.thumbnailPosterImageURL()
            })
            .subscribe(onNext: { [weak self] (posterImageURL) in
				
                self?.posterImageView.sd_setImage(with: posterImageURL, completed: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    func configureCell(title: String, voteAverage: String, voteCount: String) {
        self.titleLabel.text = title
        self.voteAverageLabel.text = voteAverage
        self.voteCountLabel.text = voteCount
    }
    
}
