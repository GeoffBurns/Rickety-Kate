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
}
