//
//  TrickPlayingStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//

import Foundation

// What cards are the computer player going to play
public protocol TrickPlayingStrategy
{
    func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
    
}

// If all else fails close your eyes and pick at random
public class RandomStrategy : TrickPlayingStrategy
{
    static let sharedInstance = RandomStrategy()
    private init() { }
    public func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        if let suite: PlayingCard.Suite = gameState.leadingSuite
        {
            let validCards = player.cardsIn( suite)
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
    public init(margin:Int) { safetyMargin = margin }
    public func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        if(gameState.hasntLead)
        {
            return nil
        }
        var earlyLeadSuites = GameSettings.sharedInstance.deck!.suitesInDeck
        if let j = earlyLeadSuites.indexOf(PlayingCard.Suite.Jokers)
        {
            earlyLeadSuites.removeAtIndex(j)
        }
        if let t = earlyLeadSuites.indexOf(GameSettings.sharedInstance.rules.trumpSuite)
        {
            earlyLeadSuites.removeAtIndex(t)
        }
        
        var maxCard : PlayingCard? = nil
        var max = -20
        
        // find safest suite
        for suite in earlyLeadSuites
        {
            let (possibleCard,safety) = bestEarlyGameCardFor(suite,player: player,gameState: gameState,margin: safetyMargin)
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
func bestEarlyGameCardFor(suite:PlayingCard.Suite,player:CardHolder,gameState:GameState,margin:Int) -> (PlayingCard?,Int)
{
    
    //  let noOfPlayers = gameState.noOfPlayers
    let unplayedCardsInTrick = gameState.unplayedCardsInTrick
    
    /// TODO ask deck for unaccountedForCards
    var unaccountedForCards = GameSettings.sharedInstance.noOfCardsInASuite
    
    // remove cards in hand
    
    let suiteCardsInHand = player.cardsIn( suite)
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
    
    let missing = unaccountedForCards
    
    let safety = missing - margin - unplayedCardsInTrick
    if  safety <= 0
    {
        return (nil,safety)
    }
    
    let cardsInChosenSuite = player.cardsIn( suite)
    let orderedCards = cardsInChosenSuite.sort({$0.value > $1.value})
    
    return (orderedCards.first,safety)
}

// It might be okay to win the trick if its early in the hand
public class EarlyGameFollowingStrategy : TrickPlayingStrategy
{
    var safetyMargin = 6
    let noOfPlayers = 4
    public init(margin:Int) { safetyMargin = margin }
    public func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
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
            return bestEarlyGameCardFor(suite,player: player,gameState: gameState,margin: safetyMargin).0;
            
        }
        return nil
    }
}
// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
public class LateGameLeadingStrategy : TrickPlayingStrategy
{
    public static let sharedInstance = LateGameLeadingStrategy()
    private init() { }
    public func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        if(gameState.hasntLead)
        {
            return nil
        }
       // Avoid Jokers if posible
       var orderedCards = player.hand.filter { $0.suite != PlayingCard.Suite.Jokers }.sort({$0.value < $1.value})
        
        
        if let lowCard = orderedCards.first
        {
            return lowCard
        }
        orderedCards = player.hand.sort({$0.value < $1.value})
        
        return orderedCards.first
    }
}



// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
public class LateGameFollowingStrategy : TrickPlayingStrategy
{
    public static let sharedInstance = LateGameFollowingStrategy()
    private init() { }
    public func chooseCard(player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite
        {
            let cardsInSuite = player.cardsIn( suite)
            let canFollowSuite = !cardsInSuite.isEmpty
            if(canFollowSuite)
            {
                let cardsFollowingSuite = gameState.cardsFollowingSuite
                let orderedFollowingCards = cardsFollowingSuite.sort({$0.value > $1.value})
                let highCard = orderedFollowingCards.first
                
                let cardsLessThanHighCard = cardsInSuite.filter { $0.value < highCard!.value }
                let canGoLow = !cardsLessThanHighCard.isEmpty
                if canGoLow
                {
                    let orderedLowCards = cardsLessThanHighCard.sort({$0.value > $1.value})
                    return orderedLowCards.first
                }
                else
                {
                    if suite == PlayingCard.Suite.Spades
                    {
                        // don't give yourself rickety kate
                        let notRicketyKate = cardsInSuite.filter { $0.isntRicketyKate }
                        var reverseOrderedCards = notRicketyKate.sort({$0.value < $1.value})
                        if let lowcard = reverseOrderedCards.first
                        {
                            return lowcard
                        }
                        
                        reverseOrderedCards = cardsInSuite.sort({$0.value < $1.value})
                        return reverseOrderedCards.first
                    }
                    let isLastPlayer = gameState.isLastPlayer
                    let isNoSpadesInPile = gameState.isntSpadesInPile
                    if isLastPlayer && isNoSpadesInPile
                    {
                        
                        let orderedCards = cardsInSuite.sort({$0.value > $1.value})
                        return orderedCards.first
                    }
                    let reverseOrderedCards = cardsInSuite.sort({$0.value < $1.value})
                    return reverseOrderedCards.first
                }
            }
            
            if let RicketyKate = player.RicketyKate
            {
                return RicketyKate
            }
            let Spades = player.cardsIn(PlayingCard.Suite.Spades )
            if !Spades.isEmpty
            {
                let orderedSpades = Spades.sort({$0.value > $1.value})
                return orderedSpades.first
            }
            let orderedHand = player.hand.sort({$0.value > $1.value})
            
            return orderedHand.first
        }
        
        return nil
    }
    
}