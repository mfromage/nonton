//
//  Optional+Protocol.swift
//  Nonton
//
//  Created by Michael Fromage on 05/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation

/**
 Protocol for `Optional`'s bare requirements to allow creation of Optional-related protocols
 */
protocol OptionalType {
    
    associatedtype Wrapped
    
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension OptionalType {
    
    /**
     Proxy property to allow extensions use Optional normally.
     */
    var optionalValue: Wrapped? {
        
        return self.map { (value: Wrapped) -> Wrapped in
            return value
        }
    }
}
