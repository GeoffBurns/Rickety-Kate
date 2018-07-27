//
//  GameMove.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 27/7/18.
//  Copyright © 2018 Geoff Burns. All rights reserved.
//


import Cards

public protocol Move {

    var description : String? {get}
}
public enum GameMove : Move, Equatable
{
    case cardPlayed(CardHolderBase,PlayingCard)
    case cardDoesNotFollowSuite(PlayingCard.Suite)
    case trumpsHaveNotBeenBroken
    
    public var description : String?
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
   
public func ==(lhs: Move, rhs: Move) -> Bool {
         return lhs.description == rhs.description
}

