//
//  Observable+Mapper.swift
//  Nonton
//
//  Created by Michael Fromage on 05/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import ObjectMapper

extension Observable where Element: OptionalType {
    
    func flatMapForServerResponse() -> Observable<Element.Wrapped> {
        return self.flatMap({ (value: Element) -> Observable<Element.Wrapped> in
            if let validValue = value.optionalValue {
                return Observable<Element.Wrapped>.just(validValue)
            }
            
            let parseError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse server's response. Please try again later"])
            
            return Observable<Element.Wrapped>.error(parseError)
        })
    }
}


extension Observable where Element: Moya.Response {
    
    
    func mapResponse<T: Mappable>(to type:T.Type, keyPath: String? = "results") -> Observable<T?> {
        
        return self.map{ (response: Response) -> T? in
            guard let JSON = try? response.mapJSON(),
                let validJSON = JSON as? [String: Any] else {
                    return nil
            }
            
            guard let validPath = keyPath else {
                return Mapper<T>().map(JSON: validJSON)
            }
            
            if let rawData = validJSON[validPath] as? [String: Any] {
                return Mapper<T>().map(JSON: rawData)
            } else {
                return nil
            }
        }
    }
    
    func mapResponseArray<T: Mappable>(to type: T.Type, keyPath: String = "results") -> Observable<[T]?> {
        
        return self.map({ (response: Response) -> [T]? in
            
            guard let JSON = try? response.mapJSON(),
                let validJSON = JSON as? [String: Any],
                let rawData = validJSON[keyPath] as? [[String: Any]] else {
                return nil
            }
            
            return Mapper<T>().mapArray(JSONArray: rawData)
        })
    }
}
