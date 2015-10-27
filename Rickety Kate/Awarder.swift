//
//  Awarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation


protocol IAwarder
{
    var allPoints : Int { get }
    var ricketyKatePoints : Int { get }
    var trumpSuite : PlayingCard.Suite { get }
    var trumpSuiteSingular : String { get }
    var trumpSuitePlural : String  { get }
    var description : String { get }
    var cardScores : Dictionary<PlayingCard,Int> { get }
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
}
/// Calculate the score value of the cards
/// Used by the Scorer
class SpadesAwarder : IAwarder
{

    var allPoints : Int { return  9 + GameSettings.sharedInstance.noOfCardsInASuite }
    var ricketyKatePoints : Int { return  10 }
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.Spades }
    var trumpSuiteSingular : String  { return "spade" }
    var trumpSuitePlural : String  { return trumpSuite.description }
    var cardScores = Dictionary<PlayingCard,Int>()
    var description = "Rickety Kate (Spade Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and the other spades are worth 1 point against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."
    
    
    var gameSettings:IGameSettings? = nil

    internal init(gameSettings:IGameSettings )
    {
        self.gameSettings = gameSettings
   
        let trumps = gameSettings.deck!.orderedDeck.filter { $0.suite == trumpSuite }
        var trumpsSet = Set(trumps)
        
        cardScores[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        
        trumpsSet.remove(CardName.Queen.of(PlayingCard.Suite.Spades)!)
        
        for card in trumpsSet
        {
            cardScores[card] = 1
        }
        
    }
    
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        var score = 0
        
        let ricketyKate = cards.filter{$0 == CardName.Queen.of(PlayingCard.Suite.Spades)}
        
        let spades = cards.filter{$0.suite == PlayingCard.Suite.Spades && $0 != CardName.Queen.of(PlayingCard.Suite.Spades)}
        if !ricketyKate.isEmpty
           {
            score = ricketyKatePoints
           }
        score += spades.count
        
        if !ricketyKate.isEmpty
           {
            Bus.sharedInstance.send(GameEvent.WinRicketyKate(winnersName))
           }
        else if spades.count > 0
           {
            Bus.sharedInstance.send(GameEvent.WinSpades(winnersName,spades.count))
           }
        else
           {
            Bus.sharedInstance.send(GameEvent.WinTrick(winnersName))
           }
        
        return score
    }
}

/// Calculate the score value of the cards
/// Used by the Scorer
class HeartsAwarder : IAwarder
{
    var description = "Rickety Kate (Hearts Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 13 points against you and the hearts are worth fewer points against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."
    var cardScores = Dictionary<PlayingCard,Int>()
    var ricketyKatePoints : Int { return  13 }
    var allPoints : Int = 0
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.Hearts }
    var trumpSuiteSingular : String  { return "heart" }
    var trumpSuitePlural : String  { return trumpSuite.description }
    
    func addScoreIfIn(inout deck: Set<PlayingCard>,card:PlayingCard, score:Int)
    {
     if deck.contains(card)
       {
       cardScores[card] = 4
       deck.remove(card)
       }
    }
    
    var gameSettings:IGameSettings? = nil
    
    init(gameSettings:IGameSettings  )
    {
        self.gameSettings = gameSettings
        let trumps = gameSettings.deck!.orderedDeck.filter { $0.suite == trumpSuite }
        var trumpsSet = Set(trumps)
        
        cardScores[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        
        addScoreIfIn(&trumpsSet,card:CardName.Ace.of(PlayingCard.Suite.Hearts)!, score:4)
        addScoreIfIn(&trumpsSet,card:CardName.King.of(PlayingCard.Suite.Hearts)!, score:3)
        addScoreIfIn(&trumpsSet,card:CardName.Queen.of(PlayingCard.Suite.Hearts)!, score:2)
        addScoreIfIn(&trumpsSet,card:CardName.Jack.of(PlayingCard.Suite.Hearts)!, score:5)

        for card in trumpsSet
        {
           cardScores[card] = 1
        }

        allPoints = cardScores.reduce(0) { $0 + $1.1 }
      
    }
    
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        var score = 0
        
        let ricketyKate = cards.filter{$0 == CardName.Queen.of(PlayingCard.Suite.Spades)}
        
        let hearts = cards.filter{$0.suite == trumpSuite }
        if !ricketyKate.isEmpty
        {
            score = 10
        }
        
        let heartScore = hearts.reduce(0) { $0 + (cardScores[$1] ?? 0) }
        score += heartScore
        
        if !ricketyKate.isEmpty
        {
            Bus.sharedInstance.send(GameEvent.WinRicketyKate(winnersName))
        }
        else if hearts.count > 0
        {
            Bus.sharedInstance.send(GameEvent.WinSpades(winnersName,hearts.count))
        }
        else
        {
            Bus.sharedInstance.send(GameEvent.WinTrick(winnersName))
        }
        
        return score
    }
}


/// Calculate the score value of the cards
/// Used by the Scorer
class JacksAwarder : IAwarder
{
    var description = "Rickety Kate (Jacks Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and each Jack is worth two points against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."
    var cardScores = Dictionary<PlayingCard,Int>()
    var ricketyKatePoints : Int { return  10 }
    var allPoints : Int { return 10 + GameSettings.sharedInstance.noOfSuitesInDeck * 2 }
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.None }
    var trumpSuiteSingular : String  { return "jack" }
    var trumpSuitePlural : String  { return "Jacks" }

    

    var gameSettings:IGameSettings? = nil
    
    internal init(gameSettings:IGameSettings  )
    {
        self.gameSettings = gameSettings
        
        cardScores[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        
        for suite in gameSettings.deck!.suitesInDeck
        {
            cardScores[CardName.Jack.of(suite)!] = 2
        }
    
    }
    
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        var score = 0
        
        let ricketyKate = cards.filter{$0 == CardName.Queen.of(PlayingCard.Suite.Spades)}
        
        let jacks = cards.filter{$0.value == CardName.Jack.cardValue }
        if !ricketyKate.isEmpty
        {
            score = 10
        }
  
        score += jacks.count * 2
        
        if !ricketyKate.isEmpty
        {
            Bus.sharedInstance.send(GameEvent.WinRicketyKate(winnersName))
        }
        else if jacks.count > 0
        {
            Bus.sharedInstance.send(GameEvent.WinSpades(winnersName,jacks.count))
        }
        else
        {
            Bus.sharedInstance.send(GameEvent.WinTrick(winnersName))
        }
        
        return score
}
}