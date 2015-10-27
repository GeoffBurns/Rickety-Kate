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
    var unplayedScoringCards  = Set<PlayingCard>()
    
    
    public func reset()
    {
        for (i,_) in cardCount.enumerate()
        {
        cardCount[i] = 0
        notFollowing[i].removeAll(keepCapacity: true)
        }
        unplayedScoringCards = Set<PlayingCard>(GameSettings.sharedInstance.rules.cardScores.keys)
    }
    
    func trackNotFollowingBehaviourForAIStrategy(first:(player:CardPlayer, playedCard:PlayingCard)?,player: CardPlayer, suite: PlayingCard.Suite )
    {
        if let firstcard = first //tricksPile.first
        {
            let leadingSuite = firstcard.playedCard.suite
            if suite != leadingSuite
            {
                playerNotFollowingSuite(player, suite: suite)
            }
        }
    }
    
    func trackProgress(first:(player:CardPlayer, playedCard:PlayingCard)?,player:CardPlayer, playedCard:PlayingCard)
    {
        countCardIn(playedCard.suite)
        trackNotFollowingBehaviourForAIStrategy(first, player: player, suite: playedCard.suite)
        unplayedScoringCards.remove(playedCard)
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