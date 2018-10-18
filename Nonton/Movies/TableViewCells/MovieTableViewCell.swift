//
//  MovieTableViewCell.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MovieCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.posterImageView.clipsToBounds = true
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.backgroundColor = UIColor.gray
        
        self.selectionStyle = .none
    }
    
    func bindViewModel(viewModel: MovieCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.movie.asObservable()
            .map { movie -> String? in
				
                return movie.title
            }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map { movie -> String? in
				
                return movie.formattedVoteAverage()
            }
            .bind(to: voteAverageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map { movie -> String? in
                guard let voteCount = movie.voteCount else {
                    return nil
                }
                return String(format: "(%d)", voteCount)
            }
            .bind(to: voteCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map { movie -> String? in
				
                return movie.overview
            }
            .bind(to: overviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map { movie -> String? in
				
                return movie.genreString(separator: " | ")
            }
            .bind(to: genreLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map { movie -> URL? in
				
                return movie.thumbnailPosterImageURL()
            }
            .subscribe(onNext: { [weak self] posterImageURL in

                self?.posterImageView.sd_setImage(with: posterImageURL, completed: nil)
            })
            .disposed(by: disposeBag)
        
    }
}
