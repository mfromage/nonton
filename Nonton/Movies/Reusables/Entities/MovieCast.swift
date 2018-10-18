//
//  MovieCast.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieCast: Mappable {
    
    var id: Int?
    var character: String?
    var name: String?
    var profilePath: String?
    
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["cast_id"]
        character <- map["character"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
    
    func originalProfileImageURL() -> URL? {
        if let profilePath = profilePath {
            return NSURL(string: "https://image.tmdb.org/t/p/original"+profilePath) as URL?
        } else {
            return nil
        }
    }
    
    func thumbnailProfileImageURL() -> URL? {
        if let profilePath = profilePath {
            return NSURL(string: "https://image.tmdb.org/t/p/w500"+profilePath) as URL?
        } else {
            return nil
        }
    }
}
