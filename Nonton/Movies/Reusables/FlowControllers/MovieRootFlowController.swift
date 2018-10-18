//
//  MovieListFlowController.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit

class MovieRootFlowController {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func navigateToMovieList() {

        self.navigationController.pushViewController(createMovieListViewController(), animated: true)
    }
    
    /// MARK: - Private methods
    private func createMovieListViewController() -> MovieListViewController {
        let movieListViewModel = MovieListViewModel()
        let movieListViewController = MovieListViewController(viewModel: movieListViewModel)
        
        movieListViewController.onNavigationEvent = { [weak self] (event: MovieListViewController.NavigationEvent) in
            
            switch event {
            case .movieDetail(let movie):
                guard let detailViewController = self?.createMovieDetailViewController(movie: movie) else {
                    return
                }
                
                self?.navigationController.pushViewController(detailViewController, animated: true)
            }
        }
        
        return movieListViewController
    }
        
    private func createMovieDetailViewController(movie: Movie) -> MovieDetailViewController {
        let movieDetailViewModel = MovieDetailViewModel(movie: movie)
        let movieDetailViewController = MovieDetailViewController(viewModel: movieDetailViewModel)
        
        movieDetailViewController.onNavigationEvent = { [weak self] (event: MovieDetailViewController.NavigationEvent) in
            
            switch event {
            case .movieDetail(let movie):
                guard let detailViewController = self?.createMovieDetailViewController(movie: movie) else {
                    return
                }
                
                self?.navigationController.pushViewController(detailViewController, animated: true)
            }
        }
        
        return movieDetailViewController
    }
}
