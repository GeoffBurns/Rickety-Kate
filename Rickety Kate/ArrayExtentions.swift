//
//  ArrayExtentions.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//

import Foundation



extension Array {
    var randomItem: Element? {
  
        switch self.count
        {
        case 0 : return nil
        case 1 : return self.first
        default :
            
            let index = Int(arc4random_uniform(UInt32(self.count)))
            return self[index]
        }
    }
}

extension Array {
    mutating func shuffleThis () {
        for i in (self.count-1).stride(to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    } }
extension Array {
    func shuffle () -> Array {
        var temp = self
        for i in (temp.count-1).stride(to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (temp[ix1], temp[ix2]) = (temp[ix2], temp[ix1])
        }
        return temp
    } }