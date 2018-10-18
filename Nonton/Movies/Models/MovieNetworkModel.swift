//
//  MovieNetworkModel.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import ObjectMapper

class MovieNetworkModel {
    
    private let provider: MoyaProvider<MovieMoyaTarget>
    
    init() {
        provider = MoyaProvider<MovieMoyaTarget>()
    }
    
    func retrieveInTheaterMovie(page: Int) -> Observable<[Movie]>{
		
        return provider.rx.requestWithProgress(MovieMoyaTarget.inTheater(page: page))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                    case responseSuccess: return Observable<Response>.just(response)
                    default:
						
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                        return Observable<Response>.error(error)
                }
        }
        .mapResponseArray(to: Movie.self)
        .flatMapForServerResponse()
        
    }
    
    func retrieveComingSoonMovie(page: Int) -> Observable<[Movie]>{
        
        return provider.rx.requestWithProgress(MovieMoyaTarget.comingSoon(page: page))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                case responseSuccess: return Observable<Response>.just(response)
                default:
					
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                    return Observable<Response>.error(error)
                }
            }
            .mapResponseArray(to: Movie.self)
            .flatMapForServerResponse()
        
    }
    
    func retrieveTrendingMovie(page: Int) -> Observable<[Movie]>{
        
        return provider.rx.requestWithProgress(MovieMoyaTarget.trending(page: page))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                case responseSuccess: return Observable<Response>.just(response)
                default:
					
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                    return Observable<Response>.error(error)
                }
            }
            .mapResponseArray(to: Movie.self)
            .flatMapForServerResponse()
        
    }
    
    func retrieveDetailMovie(movieID: Int) -> Observable<Movie>{
        
        return provider.rx.requestWithProgress(MovieMoyaTarget.detail(movieID: movieID))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                case responseSuccess: return Observable<Response>.just(response)
                default:
					
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                    return Observable<Response>.error(error)
                }
            }
			.mapResponse(to: Movie.self, keyPath: nil)
            .flatMapForServerResponse()
        
    }
    
    func retrieveCastMovie(movieID: Int) -> Observable<[MovieCast]>{
		
		
        return provider.rx.requestWithProgress(MovieMoyaTarget.credits(movieID: movieID))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                case responseSuccess: return Observable<Response>.just(response)
                default:
					
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                    return Observable<Response>.error(error)
                }
            }
            .mapResponseArray(to: MovieCast.self, keyPath: "cast")
            .flatMapForServerResponse()
    }
    
    func retrieveSimilarMovie(movieID: Int) -> Observable<[Movie]>{
        
        return provider.rx.requestWithProgress(MovieMoyaTarget.similar(movieID: movieID))
            .flatMap { (progressResponse: ProgressResponse) -> Observable<Response> in
                
                if !progressResponse.completed {
                    return Observable<Response>.empty()
                }
                
                let responseSuccess: CountableRange<Int> = (200..<300)
                
                guard let response = progressResponse.response else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to get server response"])
                    return Observable<Response>.error(error)
                }
                
                switch response.statusCode {
                case responseSuccess: return Observable<Response>.just(response)
                default:
                    
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server response"])
                    return Observable<Response>.error(error)
                }
            }
            .mapResponseArray(to: Movie.self)
            .flatMapForServerResponse()
    }
}
