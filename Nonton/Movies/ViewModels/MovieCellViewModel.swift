//
//  MovieCellViewModel.swift
//  Nonton
//
//  Created by Michael Fromage on 05/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift

class MovieCellViewModel {
    
	let movie: Variable<Movie>
    
    init(movie: Movie) {
        self.movie = Variable<Movie>(movie)
    }
}
