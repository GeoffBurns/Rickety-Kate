//
//  GameProgessTracker.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 13/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation


// Used by Computer Player to calculate strategy
open class GameProgressTracker
{
    var cardCount = [Int](repeating: 0, count: PlayingCard.Suite.noOfSuites.rawValue)
    var notFollowing  = [Set<CardPlayer>]()
    var unplayedScoringCards = Set<PlayingCard>()
    var trumpsHaveBeenBroken = false
    var gameSettings:IGameSettings
    
    public init(gameSettings:IGameSettings = Game.moreSettings)
    {
        self.gameSettings = gameSettings
        for _ in cardCount
        {
            notFollowing.append( Set<CardPlayer>())
        }
    }
    
    open func reset()
    {
        for (i,_) in cardCount.enumerated()
        {
        cardCount[i] = 0
        notFollowing[i].removeAll(keepingCapacity: true)
        }
        unplayedScoringCards = Set<PlayingCard>(gameSettings.rules.cardScores.keys)
        trumpsHaveBeenBroken = false
    }
    
    func trackNotFollowingBehaviourForAIStrategy(_ first:TrickPlay?,player: CardPlayer, suite: PlayingCard.Suite )
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
    
    func trackProgress(_ first:TrickPlay?,player:CardPlayer, playedCard:PlayingCard)
    {
        
        if playedCard.suite == Game.moreSettings.rules.trumpSuite
        {
            trumpsHaveBeenBroken = true
        }
        countCardIn(playedCard.suite)
        trackNotFollowingBehaviourForAIStrategy(first, player: player, suite: playedCard.suite)
        unplayedScoringCards.remove(playedCard)
    }
    
     func countCardIn(_ suite: PlayingCard.Suite)
     {
        let index = suite.rawValue
        
        self.cardCount[index] += 1
     }

    
    func playerNotFollowingSuite(_ player: CardPlayer, suite: PlayingCard.Suite )
     {

            let index = suite.rawValue
            self.notFollowing[index].insert(player)
     }
    
  
}
