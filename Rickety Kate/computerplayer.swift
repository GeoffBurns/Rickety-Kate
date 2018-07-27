//
//  computerplayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 14/7/18.
//  Copyright © 2018 Nereids Gold. All rights reserved.
//

import Foundation
import Cards

open class ComputerPlayer :CardPlayer, RobotPasser
{
    //////////////////////////////////////
    /// Variables
    //////////////////////////////////////
    var strategies = [TrickPlayingStrategy]()
    var passingStrategy = HighestCardsPassingStrategy.sharedInstance
    
    /////////////////////////////////
    /// Constructors and setup
    /////////////////////////////////
    public init(name s: String,margin:Int) {
        super.init(name: s)
        strategies  = [
            PerfectKnowledgeStrategy.sharedInstance,
            NonFollowingStrategy.sharedInstance,
            EarlyGameLeadingStrategy(margin:margin),
            EarlyGameFollowingStrategy(margin:margin),
            LateGameLeadingStrategy.sharedInstance,
            LateGameFollowingStrategy.sharedInstance]
    }
    
    ///////////////////////////////////
    /// Instance Methods
    ///////////////////////////////////
    open func playCard(_ gameState:GameState) -> PlayingCard?
    {
        for strategy in strategies
        {
            if let card : PlayingCard = strategy.chooseCard( self, gameState:gameState)
            {
                return card
            }
        }
        return RandomStrategy.sharedInstance.chooseCard(self,gameState:gameState)
    }
    
    open func passCards() -> [PlayingCard]
    {
        return passingStrategy.chooseWorstCards(self)
    }
    
    
}
