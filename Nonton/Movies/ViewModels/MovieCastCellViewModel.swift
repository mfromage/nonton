//
//  MovieCastCellViewModel.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift

class MovieCastCellViewModel {
	
    let cast: Variable<MovieCast>
    
    init(movieCast: MovieCast) {
        self.cast = Variable<MovieCast>(movieCast)
    }
}
