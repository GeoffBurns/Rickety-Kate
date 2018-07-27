//
//  GameMove.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 27/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//


import Foundation
import Cards

public enum GameMove : Equatable
{
    case cardPlayed(CardHolderBase,PlayingCard)
    case cardDoesNotFollowSuite(PlayingCard.Suite)
    case trumpsHaveNotBeenBroken
    
    var description : String?
    {
        switch self
        {
        case .trumpsHaveNotBeenBroken :
            return "Can not Lead with a %@".localizeWith(Game.moreSettings.rules.trumpSuiteSingular)
        case .cardDoesNotFollowSuite( let suite )  :
            return "Card Does Not Follow Suite".localize + "\n" + "Play a %@".localizeWith(suite.singular)
            
        case .cardPlayed :
            return nil
            
        }
    }
    
}


public func ==(lhs: GameMove, rhs: GameMove) -> Bool {
    switch (lhs, rhs) {
        
    case let (.cardDoesNotFollowSuite(la), .cardDoesNotFollowSuite(ra)): return la == ra
    default: return false
    }
}
