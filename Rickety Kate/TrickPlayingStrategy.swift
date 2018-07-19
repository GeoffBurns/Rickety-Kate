//
//  TrickPlayingStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Nereids Gold. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// What cards are the computer player going to play
public protocol TrickPlayingStrategy
{
    func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    
    func chooseCard(_ cards:[PlayingCard],gameState:GameState) -> PlayingCard?
}

// If all else fails close your eyes and pick at random
open class RandomStrategy : TrickPlayingStrategy
{
    static let sharedInstance = RandomStrategy()
    fileprivate init() { }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite
        {
            let validCards = hand.cardsIn(suite)
            if let choosenCard = validCards.randomItem
            {
                return choosenCard
            }
        }
        
        if !gameState.canLeadTrumps && gameState.leadingSuite == nil
        {
            let cards = hand.cardsNotIn(Game.settings.rules.trumpSuite)
            
            if let card = cards.randomItem {
                return card
            }
        }
        // no leading suite or player has no cards in leading suite
        return hand.randomItem
    }
}

// It might be okay to win the trick if its early in the hand
open class EarlyGameLeadingStrategy : TrickPlayingStrategy
{
    var safetyMargin = 6
    let noOfPlayers = 4
    public init(margin:Int) { safetyMargin = margin }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        
        if(gameState.hasntLead)
        {
            return nil
        }
        let suites = Game.deck.setOfSuitesInDeck
        let earlyLeadSuites = Array(suites.subtracting([PlayingCard.Suite.jokers,Game.settings.rules.trumpSuite]))
        
        
        var maxCard : PlayingCard? = nil
        var max = -20
        
        // find safest suite
        for suite in earlyLeadSuites
        {
            let (possibleCard,safety) = bestEarlyGameCardFor(suite,highCard:nil,hand: hand,gameState: gameState,margin: safetyMargin)
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
func bestEarlyGameCardFor(_ suite:PlayingCard.Suite,highCard:PlayingCard?, hand:[PlayingCard],gameState:GameState,margin:Int) -> (PlayingCard?,Int)
{
    
    //  let noOfPlayers = gameState.noOfPlayers
    let unplayedCardsInTrick = gameState.unplayedCardsInTrick
    
    
    var unaccountedForCards = Game.deck.noCardIn(suite)
    
    // remove cards in hand
    
    let suiteCardsInHand = hand.cardsIn( suite)
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
    
    var cardsInChosenSuite = hand.cardsIn( suite)
    let scoringCards = gameState.penaltyCardsFor(suite)
    if !scoringCards.isEmpty
    {
        var min = scoringCards.min()
        if let high = highCard, high.value > min!.value
        {
            min = high
        }
        cardsInChosenSuite = cardsInChosenSuite.filter { $0.value < min!.value }
    }
    let orderedCards = cardsInChosenSuite.sorted {$0.value > $1.value}
    
    return (orderedCards.first,safety)
}

// It might be okay to win the trick if its early in the hand
open class EarlyGameFollowingStrategy : TrickPlayingStrategy
{
    var safetyMargin = 6
    let noOfPlayers = 4
    public init(margin:Int) { safetyMargin = margin }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if(gameState.hasLead)
        {
            return nil
        }
        
        if let suite = gameState.leadingSuite
        {
            
            // you don't want to win if its spades go to late game strategy
            if gameState.leadingSuite == Game.settings.rules.trumpSuite
            {
                return nil
            }
            
            let max = gameState.highestCardInTrick
            return bestEarlyGameCardFor(suite,highCard:max,hand: hand,gameState: gameState,margin: safetyMargin).0;
            
        }
        return nil
    }

}
// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
open class LateGameLeadingStrategy : TrickPlayingStrategy
{
    open static let sharedInstance = LateGameLeadingStrategy()
    fileprivate init() { }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    
    
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if(gameState.hasntLead)
        {
            return nil
        }
        // Avoid Jokers if posible
        var orderedCards = hand
            .filter
            {
                $0.suite != PlayingCard.Suite.jokers &&
                    ( gameState.canLeadTrumps ||
                        $0.suite != Game.settings.rules.trumpSuite)
            }
            .sorted {$0.value < $1.value}
        
        
        if let lowCard = orderedCards.first
        {
            return lowCard
        }
        orderedCards = hand.sorted(by: {$0.value < $1.value})
        
        return orderedCards.first
    }
}


// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
open class PerfectKnowledgeStrategy : TrickPlayingStrategy
{
    open static let sharedInstance = PerfectKnowledgeStrategy()
    fileprivate init() { }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite, gameState.isLastPlayer
        {
            let highcard = gameState.highestCardInTrick
            // give yourself a bonus card if you can
            
            
            let bonus = Array(gameState.bonusCardFor(suite).filter { $0.value > highcard.value })
            if let card = bonus.first,
                let bonusScore =  Game.settings.rules.cardScores[card], gameState.scoreOfPile + bonusScore < 0
            {
                return card
            }
            
            let cardsInSuite = hand.cardsIn( suite)
            let orderedCards = cardsInSuite.sorted(by: {$0.value > $1.value})
            
            // if you are not going to win a bad score go high
            let score = gameState.scoreOfPile
            if score <= 0
            {
                return orderedCards.first
            }
            // if its a bad score try to give it to someone else by being just under the highest card
            let underHighest = orderedCards.filter {  $0.value < gameState.highestCardInTrick.value }
            if let justUnderHighest = underHighest.first
            {
                return justUnderHighest
            }
            // you are going to win anyway get rid of your highest card
            return orderedCards.first
        }
        return nil
    }

}


// If its late in the hand might not be a good idea to win the trick you could be stuck with the lead
open class LateGameFollowingStrategy : TrickPlayingStrategy
{
    open static let sharedInstance = LateGameFollowingStrategy()
    fileprivate init() { }
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
 open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite
        {
            let cardsInSuite = hand.cardsIn( suite)
            let canFollowSuite = !cardsInSuite.isEmpty
            if(canFollowSuite)
            {
                let cardsFollowingSuite = gameState.cardsFollowingSuite
                let orderedFollowingCards = cardsFollowingSuite.sorted(by: {$0.value > $1.value})
                let highCard = orderedFollowingCards.first
                
                // Get rid of any Scoring Cards to someone else
                let scoringCards = gameState.penaltyCardsFor(suite)
                if scoringCards.count > 0
                {
                    let scoringCardsInHand = Set<PlayingCard>(scoringCards).intersection(hand.cardsIn(suite))
                    if scoringCardsInHand.count > 0
                    {
                        let scorecardsLessThanHighCard = scoringCardsInHand.filter { $0.value < highCard!.value }
                        let canGoLowScoring = !scorecardsLessThanHighCard.isEmpty
                        if canGoLowScoring
                        {
                            let orderedLowScoreCards = scorecardsLessThanHighCard.sorted(by: {$0.value > $1.value})
                            return orderedLowScoreCards.first
                        }
                    }
                }
                
                let cardsLessThanHighCard = cardsInSuite.filter { $0.value < highCard!.value }
                let canGoLow = !cardsLessThanHighCard.isEmpty
                if canGoLow
                {
                    let orderedLowCards = cardsLessThanHighCard.sorted(by: {$0.value > $1.value})
                    return orderedLowCards.first
                }
                else
                {
                    if suite == Game.settings.rules.trumpSuite
                    {
                        // don't give yourself rickety kate
                        let notRicketyKate = cardsInSuite.filter { $0.isntRicketyKate }
                        var reverseOrderedCards = notRicketyKate.sorted(by: {$0.value < $1.value})
                        // put out the lowest card you can
                        if let lowcard = reverseOrderedCards.first
                        {
                            return lowcard
                        }
                        // if you have to yourself rickety kate here is no help for it
                        reverseOrderedCards = cardsInSuite.sorted(by: {$0.value < $1.value})
                        return reverseOrderedCards.first
                    }
                    let isLastPlayer = gameState.isLastPlayer
                    
                    
                    // try not to  give yourself any Scoring Cards
                    let scoringCards = gameState.penaltyCards
                    if scoringCards.count > 0
                    {
                        let unscoringCardsInHand = Set<PlayingCard>(hand).subtracting(scoringCards)
                        if unscoringCardsInHand.count > 0
                        {
                            // if you are not going to win scoring cards go high
                            if isLastPlayer && gameState.scoreOfPile > 0
                            {
                                
                                let orderedCards = unscoringCardsInHand.sorted(by: {$0.value > $1.value})
                                return orderedCards.first
                            }
                            // go low
                            let reverseOrderedCards = unscoringCardsInHand.sorted(by: {$0.value < $1.value})
                            return reverseOrderedCards.first
                        }
                    }
                    
                    // if you are not going to win scoring cards go high
                    if isLastPlayer && gameState.scoreOfPile > 0
                    {
                        let orderedCards = cardsInSuite.sorted(by: {$0.value > $1.value})
                        return orderedCards.first
                    }
                    
                    // go low
                    let reverseOrderedCards = cardsInSuite.sorted(by: {$0.value < $1.value})
                    return reverseOrderedCards.first
                }
            }
            // if not following suit get rid of your highest scoring card
            /*  if let RicketyKate = player.RicketyKate
             {
             return RicketyKate
             }
             let Spades = gameState.penaltyCards.intersect(player.hand)
             if !Spades.isEmpty
             {
             let orderedSpades = Spades.sort {$0.value > $1.value}
             return orderedSpades.first
             }
             
             // if no your scoring cards then your highest card
             let orderedHand = player.hand.sort {$0.value > $1.value}
             
             return orderedHand.first
             */
        }
        
        return nil
    }

}
// If you can not follow suite you are free to get rid of bad cards
open class NonFollowingStrategy : TrickPlayingStrategy
{
    open static let sharedInstance = NonFollowingStrategy()
    fileprivate init() { }
    
    open func chooseCard(_ player:CardHolder,gameState:GameState) -> PlayingCard?
    {
        return chooseCard(player.hand,gameState:gameState)
    }
    
    open func chooseCard(_ hand:[PlayingCard],gameState:GameState) -> PlayingCard?
    {
        if let suite = gameState.leadingSuite
        {
            let cardsInSuite = hand.cardsIn( suite)
 
            if !cardsInSuite.isEmpty
            {
               return nil
            }
  
            let penaltyCardsInHand = gameState.penaltyCards.intersection(hand)
            if penaltyCardsInHand.isEmpty
            {
                // if no your scoring cards then your highest card
                let orderedHand = hand.sorted {$0.value > $1.value}
                
                return orderedHand.first
            }
            
            // if not following suit get rid of your highest scoring card
            let orderedSpades = penaltyCardsInHand
                    .sorted {
                        let score0 = Game.settings.rules.cardScores[$0]
                        let score1 = Game.settings.rules.cardScores[$1]
                        
                        return score0 > score1 ||
                            ( score0 == score1 && $0.value > $1.value )
                }
                return orderedSpades.first
           
            
        
        }
        
        return nil
    }
    
}
