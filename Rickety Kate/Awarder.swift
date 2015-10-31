//
//  Awarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation


public protocol IAwarder
{
    var allPoints : Int { get }
    var ricketyKatePoints : Int { get }
    var trumpSuite : PlayingCard.Suite { get }
    var trumpSuiteSingular : String { get }
    var trumpSuitePlural : String  { get }
    var description : String { get }
    var cardScores : Dictionary<PlayingCard,Int> { get }
    var bonusCards : Set<PlayingCard> { get }
    var penaltyCards : Set<PlayingCard> { get }
    var omnibus : PlayingCard? { get }
    var hooligan : PlayingCard? { get }
    var backgroundCards : [PlayingCard] { get }
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    
}

class AwarderBase
{
    var omnibus_ : PlayingCard  { return CardName.Jack.of(PlayingCard.Suite.Diamonds)! }
    var hooligan_ = 7.of(PlayingCard.Suite.Clubs)
    var omnibus : PlayingCard? = nil
    var hooligan : PlayingCard? = nil
    // Overriden in derived class

    lazy var cardScores : Dictionary<PlayingCard,Int>  = self.createCardScores()
    lazy var allPoints : Int  = { return self.cardScores.reduce(0) { $0 + ($1.1 > 0 ? $1.1:0)} }()
    var bonusCards : Set<PlayingCard> {
        return Set<PlayingCard>(
         cardScores
            // only cards with negative sdores
            .filter { $0.1 < 0 }
            // only interested in the key
            .map { $0.0 }
        )
    }
    var penaltyCards : Set<PlayingCard> {
        return Set<PlayingCard>(
        cardScores
            // only cards with positive sdores
            .filter { $0.1 > 0 }
            // only interested in the key
            .map { $0.0 }
        )
    }
    var gameSettings:IGameSettings? = nil
    
    internal init(gameSettings:IGameSettings  )
    {
        self.gameSettings = gameSettings
      
    }
    // overriden in derived class
    func countTrumps(cards: [PlayingCard]) -> Int
    {
        return 0
    }
    func createCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  createBaseCardScores()
        if gameSettings!.includeHooligan
        {
            result[hooligan_] = 7
            hooligan = hooligan_
        }
        if gameSettings!.includeOmnibus
        {
            result[self.omnibus_] = -10
            omnibus=self.omnibus_
        }
        return result
    }
    func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        return Dictionary<PlayingCard,Int>()
    

    }
   
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        let ricketyKate = cards.filter{$0 == CardName.Queen.of(PlayingCard.Suite.Spades)}
        
        let noTrumps = countTrumps(cards)
        
        let omni = omnibus == nil ? [] : cards.filter{$0 == self.omnibus_}
        let hool = hooligan == nil ? [] : cards.filter{$0 == hooligan_}
        
        let score = cards.reduce(0) { $0 + (cardScores[$1] ?? 0) }
        
        if !ricketyKate.isEmpty
        {
            Bus.sharedInstance.send(GameEvent.WinRicketyKate(winnersName))
        }
        else if !omni.isEmpty
        {
            Bus.sharedInstance.send(GameEvent.WinOmnibus(winnersName))
        }
        else if !hool.isEmpty
        {
            Bus.sharedInstance.send(GameEvent.WinHooligan(winnersName))
        }
            
        else if noTrumps > 0
        {
            Bus.sharedInstance.send(GameEvent.WinSpades(winnersName,noTrumps))
        }
        else
        {
            Bus.sharedInstance.send(GameEvent.WinTrick(winnersName))
        }
        
        return score
    }
}

/// Calculate the score value of the cards
/// For the Spades Variant of Rickety Kate
/// Used by the Scorer
class SpadesAwarder : AwarderBase, IAwarder
{
    var backgroundCards : [PlayingCard] {
    let cards : Array = GameSettings.sharedInstance.deck!.orderedDeck
        .filter { $0.suite == trumpSuite }
        .sort()
        .reverse()
    
    return Array(cards[0..<GameSettings.sharedInstance.noOfPlayersAtTable])
    }
    
    var ricketyKatePoints = 10
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.Spades }
    var trumpSuiteSingular = "Spade"
    var trumpSuitePlural : String  { return trumpSuite.description }

    var description = "Rickety Kate (Spade Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and the other spades are worth 1 point against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."
    
    
    override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        let trumps = gameSettings!.deck!.orderedDeck.filter { $0.suite == trumpSuite }
        var trumpsSet = Set(trumps)
        
        result[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        
        trumpsSet.remove(CardName.Queen.of(PlayingCard.Suite.Spades)!)
        
        for card in trumpsSet
        {
            result[card] = 1
        }
        

        return result
    }
    
    override func countTrumps(cards: [PlayingCard]) -> Int
    {
        return cards.filter {$0.suite == PlayingCard.Suite.Spades && $0 != CardName.Queen.of(PlayingCard.Suite.Spades)}.count
    }
}
/// Calculate the score value of the cards
/// Used by the Scorer
class HeartsAwarder : AwarderBase, IAwarder
{
    var description = "Rickety Kate (Hearts Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 13 points against you and the hearts are worth fewer points against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."

    override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        let trumps = gameSettings!.deck!.orderedDeck.filter { $0.suite == trumpSuite }

        for card in trumps
        {
            result[card] = 1
        }
        result[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        result[CardName.Ace.of(PlayingCard.Suite.Hearts)!] = 4
        result[CardName.King.of(PlayingCard.Suite.Hearts)!] = 3
        result[CardName.Queen.of(PlayingCard.Suite.Hearts)!] = 2
        result[CardName.Jack.of(PlayingCard.Suite.Hearts)!] = 5
      
     
        return result
    }

    var backgroundCards : [PlayingCard] {
        let cards : Array = GameSettings.sharedInstance.deck!.orderedDeck
            .filter { $0.suite == trumpSuite }
            .sort()
            .reverse()
        
        return Array(cards[0..<GameSettings.sharedInstance.noOfPlayersAtTable])
    }
    var ricketyKatePoints = 13
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.Hearts }
    var trumpSuiteSingular = "Heart"
    var trumpSuitePlural : String  { return trumpSuite.description }
    
    
    override func countTrumps(cards: [PlayingCard]) -> Int
    {
        return cards.filter{$0.suite == trumpSuite }.count
    }
}


/// Calculate the score value of the cards
/// Used by the Scorer
class JacksAwarder : AwarderBase, IAwarder
{
    var description = "Rickety Kate (Jacks Variant) is a trick taking card game. This means every player tosses in a card and the player with the highest card in the same suite as the first card wins the trick and the cards. But wait! the person with the lowest running score wins. So winning a trick is not necessarially good.  The Queen of Spades (Rickety Kate) is worth 10 points against you and each Jack is worth two points against you. When you run out of cards you are dealt another hand. If you obtain all the spades in a hand it is called 'Shooting the Moon' and your score drops to zero. At the beginning of each hand the player pass their three worst cards to their neighbour. Aces and King are the worst cards."
    
    override var omnibus_ : PlayingCard { return CardName.Queen.of(PlayingCard.Suite.Diamonds)! }

    override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        result[CardName.Queen.of(PlayingCard.Suite.Spades)!] = ricketyKatePoints
        
        for suite in gameSettings!.deck!.suitesInDeck
        {
            result[CardName.Jack.of(suite)!] = 2
        }


        
        return result
    }
    
    var ricketyKatePoints = 10 
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.None }
    var trumpSuiteSingular : String  { return "Jack" }
    var trumpSuitePlural : String  { return "Jacks" }

    var backgroundCards : [PlayingCard] {
        let cards : Array = GameSettings.sharedInstance.deck!.orderedDeck
            .filter { $0.suite == PlayingCard.Suite.Diamonds }
            .sort()
            .reverse()
        
        return Array(cards[0..<GameSettings.sharedInstance.noOfPlayersAtTable])
    }

    override func countTrumps(cards: [PlayingCard]) -> Int
    {
        return  cards.filter{$0.value == CardName.Jack.cardValue }.count
    }
    
   }

