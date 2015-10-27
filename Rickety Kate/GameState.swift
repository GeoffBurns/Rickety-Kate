//
//  GameState.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

// makes visible the state of play to computer player and tests
public protocol GameState
{
    var hasLead : Bool { get }
    var hasntLead : Bool { get }
    var leadingSuite : PlayingCard.Suite? { get }
    var cardsFollowingSuite : [PlayingCard] { get }
    var isLastPlayer : Bool { get }
    var isSpadesInPile : Bool { get }
    var isntSpadesInPile : Bool { get }
    var noOfPlayers : Int { get }
    var playedCardsInTrick : Int { get }
    var unplayedCardsInTrick : Int { get }
    
    func arePlayerWithoutCardsIn(suite:PlayingCard.Suite) -> Bool
    func noCardsPlayedFor(suite:PlayingCard.Suite) -> Int
    
}

public class GameStateBase
{
    var trickFan = CardFan(name: CardPileType.Trick.description)
    var tricksPile = [(player:CardPlayer, playedCard:PlayingCard)]() { didSet { trickFan.cards = tricksPile.map { return $0.playedCard }}}
    var gameTracker = GameProgressTracker()
    
    public var playedCardsInTrick : Int {
        return tricksPile.count
    }
    

    
    public func arePlayerWithoutCardsIn(suite:PlayingCard.Suite) -> Bool
    {
        return !gameTracker.notFollowing[suite.rawValue].isEmpty
    }
    
    public var hasLead : Bool {
        return tricksPile.isEmpty
    }
    
    public var hasntLead : Bool {
        return !hasLead
    }
    
    public var leadingSuite : PlayingCard.Suite? {
        return tricksPile.first?.playedCard.suite
    }
    
    public var cardsFollowingSuite : [PlayingCard] {
        if  let suite = leadingSuite
        {
            return tricksPile
                .filter { $0.playedCard.suite == suite }
                .map {$0.playedCard}
        }
        return []
    }
    

    
    public var isntSpadesInPile : Bool {
        return tricksPile.filter { $0.playedCard.suite == GameSettings.sharedInstance.rules.trumpSuite }.isEmpty &&
        tricksPile.filter { $0.playedCard == CardName.Queen.of(PlayingCard.Suite.Spades) }.isEmpty
    }
    
    public var isSpadesInPile : Bool {
        
        return !isntSpadesInPile
    }
    
    public func noCardsPlayedFor(suite:PlayingCard.Suite) -> Int
    {
        return gameTracker.cardCount[suite.rawValue]
    }
    
    
}


// Used for testing
public class FakeGameState : GameStateBase, GameState
{
    let cardSource = CardSource.sharedInstance

    //////////
    // GameState Protocol
    //////////
public var noOfPlayers  = 0

public var unplayedCardsInTrick : Int
{
    return  noOfPlayers - playedCardsInTrick
}

public var isLastPlayer : Bool {
    return tricksPile.count >= noOfPlayers - 1
}
    
    //////////
    // constructor
    //////////
    public init(noPlayers:Int)
    {
    noOfPlayers = noPlayers
    }
    
    //////////
    // internal functions
    //////////
    public func addCardsToTrickPile(cardCodes:[String])
    {
        for code in cardCodes
        {
            let playedCard : PlayingCard = cardSource[code]
            let player : CardPlayer =  HumanPlayer.sharedInstance
            tricksPile.append(player:player,playedCard:playedCard)
            
        }
    }
    public func addNotFollowed(suite:PlayingCard.Suite)
    {
        gameTracker.notFollowing[suite.rawValue].insert(HumanPlayer.sharedInstance)
    }
    
}
 