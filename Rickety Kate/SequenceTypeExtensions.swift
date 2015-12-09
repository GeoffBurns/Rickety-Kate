//
//  SequenceTypeExtention.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 28/10/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import Foundation

public extension SequenceType {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    
    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            dict[key]?.append(el) ?? {dict[key] = [el]}()
        }
        return dict
    }
    
    public func from(n: Int, forLength: Int) -> [Generator.Element] {
        
        var result : [Generator.Element]
        result = []
        result.reserveCapacity(forLength)
        
        var g = generate()
        for _ in 0..<n {
            if let _ = g.next() { /* skip */ } else { return [] }
        }
        for _ in 0..<forLength {
            if let e = g.next() { result.append(e) } else { return result }
        }
        
        return result
    }
    
    public var head : Generator.Element? {
        

        
        var g = generate()
    
        return g.next() 
    }
    public var tail : [Generator.Element] {
        
        var result : [Generator.Element]
        result = []
        result.reserveCapacity(self.underestimateCount())
        
        var g = generate()
        
        if let _ = g.next() { /* skip */ } else { return [] }
        
        repeat {
            if let e = g.next() { result.append(e) } else { return result }
        } while true
        
    }

}
