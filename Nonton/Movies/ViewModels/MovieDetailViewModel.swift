//
//  MovieDetailViewModel.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
    
	let movie: Variable<Movie>
    let movieCasts = Variable<[MovieCast]>([])
    let similarMovies = Variable<[Movie]>([])
    
    let movieCastCellViewModels = Variable<[MovieCastCellViewModel]>([])
    let movieSimilarCellViewModels = Variable<[MovieCellViewModel]>([])
    
    private let networkModel = MovieNetworkModel()
    private let disposeBag = DisposeBag()
    
    init(movie: Movie) {
        self.movie = Variable<Movie>(movie)
		
        bindForCellViewModel()
    }
	
	func retrieveDetailMovie() {
		
		guard let movieID = movie.value.id else {
			return
		}
		
		Observable.zip(
			networkModel.retrieveDetailMovie(movieID: movieID),
			networkModel.retrieveCastMovie(movieID: movieID),
			networkModel.retrieveSimilarMovie(movieID: movieID))
			.subscribe(onNext: { [weak self] (movie, casts, similarMovies) in
				
				guard let `self` = self else {
					return
				}
				self.movie.value = movie
				self.movieCasts.value += casts
				self.similarMovies.value += similarMovies
				
			})
			.disposed(by: disposeBag)
	}
	
    private func bindForCellViewModel() {
        
        movieCasts.asObservable()
            .map { (movieCasts: [MovieCast]) -> [MovieCastCellViewModel] in
                
				return movieCasts.map({ cast -> MovieCastCellViewModel in
					return MovieCastCellViewModel(movieCast: cast)
				})
            }
            .bind(to: movieCastCellViewModels)
            .disposed(by: disposeBag)
        
        similarMovies.asObservable()
            .map { (similarMovies: [Movie]) -> [MovieCellViewModel] in
                
				return similarMovies.map({ movie -> MovieCellViewModel in
					return MovieCellViewModel(movie: movie)
				})
            }
            .bind(to: movieSimilarCellViewModels)
            .disposed(by: disposeBag)
    }
}
