//
//  RootFlowController.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit

class RootFlowController {

    let navigationController: UINavigationController
    
    private let movieRootFlowController: MovieRootFlowController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        movieRootFlowController = MovieRootFlowController(navigationController: navigationController)
    }
    
    func createInitialScreen() {
        movieRootFlowController.navigateToMovieList()
    }
}
