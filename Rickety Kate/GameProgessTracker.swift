//
//  GameProgessTracker.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 13/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation


// Used by Computer Player to calculate strategy
public class GameProgressTracker
{
    var cardCount = [Int](count: PlayingCard.Suite.NoOfSuites.rawValue, repeatedValue: 0)
    var notFollowing  = [Set<CardPlayer>]()
     
    
    
    public func reset()
    {
        for (i,_) in cardCount.enumerate()
        {
        cardCount[i] = 0
        notFollowing[i].removeAll(keepCapacity: true)
        }
    }
     func countCardIn(suite: PlayingCard.Suite)
     {
        let index = suite.rawValue
        
        self.cardCount[index]++
     }

    
    func playerNotFollowingSuite(player: CardPlayer, suite: PlayingCard.Suite )
     {

            let index = suite.rawValue
            self.notFollowing[index].insert(player)
     }
    
     init() {

        for _ in cardCount
        {
             notFollowing.append( Set<CardPlayer>())
        }
      }
}