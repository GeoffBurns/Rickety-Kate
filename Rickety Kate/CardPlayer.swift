//
//  CardPlayer.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 11/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation



public protocol ICardPlayer
{
    var hand : [PlayingCard] {get set}
    var wonCards : [PlayingCard] {get set}
    var score : Int {get set}
    var name : String {get set}
    var sideOfTable : SideOfTable {get set}
    func clearHand()
    func newHand([PlayingCard])
    func resetScore()
}



public func ==(lhs: ICardPlayer, rhs: ICardPlayer) -> Bool
{

    return lhs.name == rhs.name
}

public func !=(lhs: ICardPlayer, rhs: ICardPlayer) -> Bool
{
    
    return lhs.name != rhs.name
}
public func ==(lhs: CardPlayer, rhs: CardPlayer) -> Bool
{
    
    return lhs.name == rhs.name
}


public class CardPlayer :ICardPlayer, Equatable, Hashable
{
    public var hand : [PlayingCard] = []
    public var wonCards : [PlayingCard] = []
    public var score : Int = 0
    public var sideOfTable = SideOfTable.Bottom
    public var name : String = "Base"
    public var hashValue: Int {
        return self.name.hashValue
    }

    init(name s: String) {
        self.name = s
    }
    public func clearHand()
    {
        hand  = [];
    }
    public func newHand(h: [PlayingCard]  )
    {
        hand  = h;
    }
    public func resetScore()
    {
        score = 0
    }
}

public class HumanPlayer :CardPlayer
{
    static let sharedInstance = HumanPlayer()
    private init() {

        super.init(name: "You")
    }
}

protocol TrickPlayingStrategy
{
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
  
}
// If all else fails close your eyes and pick at random
public class RandomStrategy : TrickPlayingStrategy
{
    static let sharedInstance = RandomStrategy()
    private init() { }
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
    {
        if let suite: PlayingCard.Suite = gameState.leadingSuite
        {
            var validCards = player.hand.filter {$0.suite == suite}
            if let choosenCard:PlayingCard = validCards.randomItem
            {
                return choosenCard
            }
        }
        // no leading suite or player has no cards in leading suite
         return player.hand.randomItem
    }
}

// It might be okay to win the trick if its early in the hand
public class EarlyGameLeadingStrategy : TrickPlayingStrategy
{
    var safetyMargin = 6
    let noOfPlayers = 4
    init(margin:Int) { safetyMargin = margin }
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
    {
       if(gameState.hasntLead)
        {
          return nil
        }
        let earlyLeadSuites = [PlayingCard.Suite.Diamonds,PlayingCard.Suite.Clubs,PlayingCard.Suite.Hearts]
     

        var maxCard : PlayingCard? = nil
        var max = -20
        var maxSuite = PlayingCard.Suite.Spades
        var i = 0
        
        // find safest suite
        for suite in earlyLeadSuites
        {
            let (possibleCard,safety) = bestEarlyGameCardFor(suite,player,gameState,safetyMargin)
            if let card = possibleCard
            {
                if safety > max
                {
                    max = safety
                    maxCard = card
                }
            }
      
        }
        
        if  max < 0
        {
              return nil
        }
        
        return maxCard
      
    }
}


// It might be okay to win the trick if its early in the hand
func bestEarlyGameCardFor(suite:PlayingCard.Suite,player:CardPlayer,gameState:GameState,margin:Int) -> (PlayingCard?,Int)
{
    
  //  let noOfPlayers = gameState.noOfPlayers
    let unplayedCardsInTrick = gameState.unplayedCardsInTrick
    var unaccountedForCards = 13
    
    // remove cards in hand
    
    let suiteCardsInHand = player.hand.filter { $0.suite == suite }
    unaccountedForCards -= suiteCardsInHand.count
    
    // remove cards that have been played
    
    let noCardsPlayed = gameState.noCardsPlayedFor(suite)
    
    unaccountedForCards -= noCardsPlayed
    
    // remove suites that  been unfollowed
    
    // TODO allow if player does not have any spades
    // do not use if one player does not have the suite
    if gameState.arePlayerWithoutCardsIn(suite)
    {
        unaccountedForCards = -10
    }
    
    
    var missing = unaccountedForCards

    
    let safety = missing - margin - unplayedCardsInTrick
    if  safety <= 0
    {
        return (nil,safety)
    }
    
    
    let cardsInChosenSuite = player.hand.filter {$0.suite == suite}
    let orderedCards = sorted(cardsInChosenSuite,{$0.value > $1.value})
    
    return (orderedCards.first,safety)
}

// It might be okay to win the trick if its early in the hand
public class EarlyGameFollowingStrategy : TrickPlayingStrategy
{
     var safetyMargin = 6
    let noOfPlayers = 4
    init(margin:Int) { safetyMargin = margin }
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
    {
         if(gameState.hasLead)
        {
          return nil
        }

        if let suite = gameState.leadingSuite
        {
   
         // you don't want to win if its spades
        if gameState.leadingSuite == PlayingCard.Suite.Spades
        {
            return nil
        }
        return bestEarlyGameCardFor(suite,player,gameState,safetyMargin).0;
      
    }
        return nil
}
    }
// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
public class LateGameLeadingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = LateGameLeadingStrategy()
    private init() { }
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
    {
        if(gameState.hasntLead)
        {
          return nil
        }
        let orderedCards = sorted(player.hand,{$0.value < $1.value})
        return orderedCards.first
    }
}



// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
public class LateGameFollowingStrategy : TrickPlayingStrategy
{
    static let sharedInstance = LateGameFollowingStrategy()
    private init() { }
    func chooseCard(player:CardPlayer,gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite
        {
            let cardsInSuite = player.hand.filter { $0.suite == suite}
            let canFollowSuite = !cardsInSuite.isEmpty
            if(canFollowSuite)
            {
                let cardsFollowingSuite = gameState.cardsFollowingSuite
                let orderedFollowingCards = sorted(cardsFollowingSuite,{$0.value > $1.value})
                let highCard = orderedFollowingCards.first
                
                let cardsLessThanHighCard = cardsInSuite.filter { $0.value < highCard!.value }
                let canGoLow = !cardsLessThanHighCard.isEmpty
                if canGoLow
                {
                    let orderedLowCards = sorted(cardsLessThanHighCard,{$0.value > $1.value})
                    return orderedLowCards.first
                }
                else
                {
                    if suite == PlayingCard.Suite.Spades
                    {
                        // don't give yourself rickety kate
                        let notRicketyKate = player.hand.filter { $0.isntRicketyKate }
                        var reverseOrderedCards = sorted(notRicketyKate,{$0.value < $1.value})
                        if let lowcard = reverseOrderedCards.first
                        {
                        return reverseOrderedCards.first
                        }
                        
                        reverseOrderedCards = sorted(cardsInSuite,{$0.value < $1.value})
                        return reverseOrderedCards.first
                    }
                    let isLastPlayer = gameState.isLastPlayer
                    let isNoSpadesInPile = gameState.isntSpadesInPile
                    if isLastPlayer && isNoSpadesInPile
                    {
                        
                        let orderedCards = sorted(cardsInSuite,{$0.value > $1.value})
                        return orderedCards.first
                    }
                    let reverseOrderedCards = sorted(cardsInSuite,{$0.value < $1.value})
                    return reverseOrderedCards.first
                }
            }
       
                let RicketyKate = player.hand.filter { $0.isRicketyKate}
                if !RicketyKate.isEmpty
                {
                    return RicketyKate.first
                }
                 let Spades = player.hand.filter { $0.suite == PlayingCard.Suite.Spades }
                if !Spades.isEmpty
                {
                    let orderedSpades = sorted(Spades,{$0.value > $1.value})
                    return orderedSpades.first
                }
                let orderedHand = sorted(player.hand,{$0.value > $1.value})
                
                return orderedHand.first
        }
        
        return nil
    }
    
}
public class ComputerPlayer :CardPlayer
{
    
    var strategies : [TrickPlayingStrategy] = []
    
    public func playCard(gameState:GameState) -> PlayingCard?
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
    public init(name s: String,margin:Int) {
       super.init(name: s)
        strategies  = [
        EarlyGameLeadingStrategy(margin:margin),
        EarlyGameFollowingStrategy(margin:margin),
        LateGameLeadingStrategy.sharedInstance,
        LateGameFollowingStrategy.sharedInstance]
    }
    
}