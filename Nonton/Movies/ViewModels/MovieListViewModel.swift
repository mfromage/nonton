//
//  MovieListViewModel.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift

class MovieListViewModel {
    
    let movieInTheater = Variable<[Movie]>([])
    let movieComingSoon = Variable<[Movie]>([])
    let movieTrending = Variable<[Movie]>([])
    
    let movieInTheaterCellViewModels = Variable<[MovieCellViewModel]>([])
    let movieComingSoonCellViewModels = Variable<[MovieCellViewModel]>([])
    let movieTrendingCellViewModels = Variable<[MovieCellViewModel]>([])
    
    private let networkModel = MovieNetworkModel()
    private let disposeBag = DisposeBag()
    

    init() {
        bindForCellViewModels()
    }
    
    private func bindForCellViewModels() {
        movieInTheater.asObservable()
            .map { (movies: [Movie]) -> [MovieCellViewModel] in
				
                return movies.map({ movie -> MovieCellViewModel in
                    return MovieCellViewModel(movie: movie)
                })
            }
            .bind(to: movieInTheaterCellViewModels)
            .disposed(by: disposeBag)
        
        movieComingSoon.asObservable()
            .map { (movies: [Movie]) -> [MovieCellViewModel] in
                
				return movies.map({ movie -> MovieCellViewModel in
					return MovieCellViewModel(movie: movie)
				})
            }
            .bind(to: movieComingSoonCellViewModels)
            .disposed(by: disposeBag)
        
        movieTrending.asObservable()
            .map { (movies: [Movie]) -> [MovieCellViewModel] in
                
				return movies.map({ movie -> MovieCellViewModel in
					return MovieCellViewModel(movie: movie)
				})
            }
            .bind(to: movieTrendingCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func retrieveInTheaterMovies() {
        //
        networkModel.retrieveInTheaterMovie(page: 1).asObservable()
            .subscribe(onNext: { [weak self] (movies: [Movie]) in
                guard let `self` = self else {
                    return
                }
                
                self.movieInTheater.value += movies
                
                }, onError: { (error: Error) in
                    //
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveComingSoonMovies() {
        //
        networkModel.retrieveComingSoonMovie(page: 1).asObservable()
            .subscribe(onNext: { [weak self] (movies: [Movie]) in
                guard let `self` = self else {
                    return
                }
                
                self.movieComingSoon.value += movies
                
                }, onError: { (error: Error) in
                    //
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveTrendingMovies() {
        //
        networkModel.retrieveTrendingMovie(page: 1).asObservable()
            .subscribe(onNext: { [weak self] (movies: [Movie]) in
                guard let `self` = self else {
                    return
                }
                
                self.movieTrending.value += movies
                
                }, onError: { (error: Error) in
                    //
            })
            .disposed(by: disposeBag)
    }
}
