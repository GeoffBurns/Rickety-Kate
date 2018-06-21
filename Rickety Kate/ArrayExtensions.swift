//
//  ArrayExtentions.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

import GameplayKit

extension Array {
    
    func numOfPagesOf(_ noOfItemsOnPage:Int) -> Int
    {
        return self.count / noOfItemsOnPage + (self.count % noOfItemsOnPage == 0 ? 0 : 1)
        
    }
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

    func flatMap<U>(_ transform: (Element) -> U?) -> [U] {
        var result = [U]()
        result.reserveCapacity(self.count)
        for item in map(transform) {
            if let item = item {
                result.append(item)
            }
        }
        return result
    }

    mutating func shuffleThis () {
        for i in stride(from: (self.count-1), to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
    
    func shuffle () -> Array {
        var temp = self
        for i in stride(from: (temp.count-1), to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (temp[ix1], temp[ix2]) = (temp[ix2], temp[ix1])
        }
        return temp
    } }
/*
extension Array {
    func shuffle () -> Array {
        
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(self)
        
    } }
*/
