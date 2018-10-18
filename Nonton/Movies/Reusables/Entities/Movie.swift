//
//  Movie.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import ObjectMapper

final class Movie: Mappable {
    
    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double?
    var voteCount: Int?
    var genres: [MovieGenre]?
    var releaseDate: Date?
    var casts: [MovieCast]?
    var similars: [Movie]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        overview <- map["overview"]
		
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        
        genres <- map["genres"]
        
        mapToReleaseDate(from: map)
    }
    
    private func mapToReleaseDate(from map:Map) {
        var releaseDateStr: String = ""
        releaseDateStr <- map["release_date"]
        let formatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "")
        releaseDate = formatter.date(from: releaseDateStr)
    }
	
	func formattedVoteAverage() -> String? {
		if let voteAverage = voteAverage {
			return String(format: "★ %.2f", voteAverage)
		} else {
			return nil
		}
	}
    
    func originalPosterImageURL() -> URL? {
        if let posterPath = posterPath {
            return NSURL(string: "https://image.tmdb.org/t/p/original"+posterPath) as URL?
        } else {
            return nil
        }
    }
    
    func thumbnailPosterImageURL() -> URL? {
        if let posterPath = posterPath {
            return NSURL(string: "https://image.tmdb.org/t/p/w500"+posterPath) as URL?
        } else {
            return nil
        }
    }
    
    func originalBackdropImageURL() -> URL? {
        if let backdropPath = backdropPath {
            return NSURL(string: "https://image.tmdb.org/t/p/original"+backdropPath) as URL?
        } else {
            return nil
        }
    }
    
    func thumbnailBackdropImageURL() -> URL? {
        if let backdropPath = backdropPath {
            return NSURL(string: "https://image.tmdb.org/t/p/w500"+backdropPath) as URL?
        } else {
            return nil
        }
    }
    
    func releaseYear() -> String? {
        if let releaseDate = releaseDate {
            let formatter = DateFormatter(withFormat: "yyyy", locale: "")
            return formatter.string(from: releaseDate)
        } else {
            return nil
        }
    }
    
    func genreString(separator aSeparator:String) -> String {

        guard let genres = genres else {
            return ""
        }
        
        return genres.compactMap{ $0.name}.joined(separator: aSeparator)
    }
	
}
