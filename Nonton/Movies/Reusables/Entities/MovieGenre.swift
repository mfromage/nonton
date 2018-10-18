//
//  MovieGenre.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import ObjectMapper

final class MovieGenre: Mappable {
    
    var id: Int?
    var name: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
