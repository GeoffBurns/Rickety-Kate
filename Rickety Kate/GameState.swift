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
    var scoreOfPile : Int { get }
    var noOfPlayers : Int { get }
    var playedCardsInTrick : Int { get }
    var unplayedCardsInTrick : Int { get }
    var highestCardInTrick : PlayingCard { get }
    var penaltyCards : Set<PlayingCard> { get }
    var bonusCards : Set<PlayingCard> { get }
    var canLeadTrumps : Bool { get }
    
    func arePlayerWithoutCardsIn(suite:PlayingCard.Suite) -> Bool
    func noCardsPlayedFor(suite:PlayingCard.Suite) -> Int
    func penaltyCardsFor(suite:PlayingCard.Suite) -> [PlayingCard]
    func bonusCardFor(suite:PlayingCard.Suite) -> [PlayingCard]
   
}

public class GameStateBase
{
    var trickFan = CardFan(name: CardPileType.Trick.description)
    var tricksPile = [(player:CardPlayer, playedCard:PlayingCard)]() { didSet { trickFan.cards = tricksPile.map { return $0.playedCard }}}
    var gameTracker = GameProgressTracker()
    
    public var playedCardsInTrick : Int {
        return tricksPile.count
    }
    
    public var highestCardInTrick : PlayingCard { return cardsFollowingSuite.maxElement()! }
    public var canLeadTrumps :Bool { return gameTracker.trumpsHaveBeenBroken || GameSettings.sharedInstance.allowBreakingTrumps }
    
    
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
    
    public var scoreOfPile : Int {
        return tricksPile.reduce(0) { $0 + ( GameSettings.sharedInstance.rules.cardScores[$1.playedCard] ?? 0) }
    }
    
    public func noCardsPlayedFor(suite:PlayingCard.Suite) -> Int
    {
        return gameTracker.cardCount[suite.rawValue]
    }
    
    public func penaltyCardsFor(suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return penaltyCards.filter { $0.suite == suite }
    }
    public func bonusCardFor(suite:PlayingCard.Suite) -> [PlayingCard]
    {
        return bonusCards.filter { $0.suite == suite }
    }
    

    public var penaltyCards : Set<PlayingCard> {
        return Set<PlayingCard>(gameTracker.unplayedScoringCards.filter {
            (GameSettings.sharedInstance.rules.cardScores[$0] ?? 0) > 0
        })}
    
    public var bonusCards : Set<PlayingCard> {
        return Set<PlayingCard>(gameTracker.unplayedScoringCards.filter {
            (GameSettings.sharedInstance.rules.cardScores[$0] ?? 0) < 0
        })}

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
 