//
//  MovieMoyaTarget.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import Alamofire
import Moya

enum MovieMoyaTarget {
    case inTheater(page: Int)
    case comingSoon(page: Int)
    case trending(page: Int)
    case detail(movieID: Int)
    case similar(movieID: Int)
    case credits(movieID: Int)
}

extension MovieMoyaTarget: TargetType {
    
    var baseURL: URL {
        if let baseURL = NSURL(string: "https://api.themoviedb.org/3/") {
            return baseURL as URL
        } else {
            return NSURL() as URL
        }
    }
    
    var path: String {
        switch self {
            case .inTheater: return "movie/now_playing"
            case .comingSoon: return "movie/upcoming"
            case .trending: return "movie/popular"
            case .detail(let movieID): return "movie/\(movieID)"
            case .similar(let movieID): return "movie/\(movieID)/similar"
            case .credits(let movieID): return "movie/\(movieID)/credits"
        }
    }
    
    var method: Moya.Method {
        switch self {
			default: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        return Task.requestParameters(
            parameters: ["api_key":"6475e83712ab66ba0c677461216809e3"],
            encoding: URLEncoding.queryString
        )
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
