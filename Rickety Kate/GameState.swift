//
//  GameState.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 17/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import SpriteKit

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
    var trickFan = CardFan()
    var tricksPile : [(player:CardPlayer, playedCard:PlayingCard)] = [] { didSet { trickFan.cards = tricksPile.map { return $0.playedCard }}}
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
        return tricksPile.filter { $0.playedCard.suite == PlayingCard.Suite.Spades }.isEmpty
    }
    
    public var isSpadesInPile : Bool {
        
        return !isntSpadesInPile
    }
    
    public func noCardsPlayedFor(suite:PlayingCard.Suite) -> Int
    {
        return gameTracker.cardCount[suite.rawValue]
    }
    
    
}
public class GameStateEngine : GameStateBase
{


    func addToTrickPile(player:CardPlayer,cardName:String)
    {
        if let displayedCard = CardSprite.register[cardName]
        {
            
            self.gameTracker.cardCounter.publish(displayedCard.card.suite)
            
            if let firstcard = tricksPile.first
            {
                let leadingSuite = firstcard.playedCard.suite
                if displayedCard.card.suite != leadingSuite
                {
                    self.gameTracker.notFollowingTracker.publish(displayedCard.card.suite,player)
                }
            }
            displayedCard.player=player
            let playedCard = displayedCard.card
            tricksPile.append(player:player,playedCard:playedCard)
          //  tricksPile.append(player:player, playedCard:displayedCard.card)
        }
    }
    func isMoveValid(player:CardPlayer,cardName:String) -> Bool
    {
        if self.tricksPile.isEmpty
        {
            return true
        }
        if let trick = self.tricksPile.first
        {
            let leadingSuite = trick.playedCard.suite
            let cardsInSuite = player.hand.filter { $0.suite == leadingSuite}
            if cardsInSuite.isEmpty
            {
                return true
            }
            let displayedCard = CardSprite.register[cardName]
            
            return displayedCard!.card.suite == leadingSuite
            
        }
        return false
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
 