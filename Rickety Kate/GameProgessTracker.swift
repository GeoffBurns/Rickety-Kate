//
//  GameProgessTracker.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 13/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation

// Used by Computer Player for strategy
public class GameProgressTracker
{
    var cardCount = [Int](count: 4, repeatedValue: 0)
    var cardCounter = Publink<PlayingCard.Suite>()
    var notFollowingTracker = Publink<(PlayingCard.Suite, CardPlayer)>()
    // TODO replace - repeat generator does not work so great with classes
    var notFollowing = [Set<CardPlayer>](count: 4, repeatedValue: Set<CardPlayer>())
     
    
    
    public func reset()
    {
        for i in 0...3
        {
        cardCount[i] = 0
        notFollowing[i].removeAll(keepCapacity: true)
        }
    }
    
     init() {
        
        cardCounter.subscribe() { (suite: PlayingCard.Suite) in
            
        let index = suite.rawValue
            
            self.cardCount[index]++
            
        }
        for i in 0...3
        {
             notFollowing[i] = Set<CardPlayer>()
        }
        notFollowingTracker.subscribe() { (message: (PlayingCard.Suite, CardPlayer)) in
            
        let index = message.0.rawValue
        self.notFollowing[index].insert(message.1)
        }
}
}