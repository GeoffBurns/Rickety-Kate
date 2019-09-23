//
//  Awarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation
import Cards


class AwarderBase
{
    var omnibus_ : PlayingCard  { return CardName.jack.of(PlayingCard.Suite.diamonds)! }
    var hooligan_ = 7.of(PlayingCard.Suite.clubs)
    var omnibus : PlayingCard? = nil
    var hooligan : PlayingCard? = nil
    
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
    func countTrumps(_ cards: [PlayingCard]) -> Int
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
   
    func scoreFor(_ cards: [PlayingCard], winnersName: String) ->Int
    {
        let ricketyKate = cards.filter{$0 == CardName.queen.of(PlayingCard.Suite.spades)}
        
        let noTrumps = countTrumps(cards)
        
        let omni = omnibus == nil ? [] : cards.filter{$0 == self.omnibus_}
        let hool = hooligan == nil ? [] : cards.filter{$0 == hooligan_}
        
        let score = cards.reduce(0) { $0 + (cardScores[$1] ?? 0) }
        
        if !ricketyKate.isEmpty
        {
            Bus.send(GameNotice.player(Scored.winRicketyKate(winnersName)))
        }
        else if !omni.isEmpty
        {
            Bus.send(GameNotice.player(Scored.winOmnibus(winnersName)))
        }
        else if !hool.isEmpty
        {
            Bus.send(GameNotice.player(Scored.winHooligan(winnersName)))
        }
        else if noTrumps > 0
        {
            Bus.send(GameNotice.player(Scored.winSpades(winnersName,noTrumps)))
        }
        else
        {
            Bus.send(GameNotice.winTrick(winnersName))
        }
        
        return score
    }
}

/// Calculate the score value of the cards
/// For the Spades Variant of Rickety Kate
/// Used by the Scorer
class SpadesAwarder : AwarderBase, IAwarder
{
    var shortDescription = "Spade"
    
    var leaderboard = LearderBoard.Spades
    
    var backgroundCards : [PlayingCard] {
    let cards : Array = Game.deck.orderedDeck
        .filter { $0.suite == trumpSuite }
        .sorted()
        .reversed()
    
    return Array(cards[0..<Game.settings.noOfPlayersAtTable])
    }
    
    var ricketyKatePoints = 10
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.spades }
    var trumpSuiteSingular = "Spade".localize
    var trumpSuitePlural : String  { return trumpSuite.description }

    var description = "Rickety Kate Spades Rules".localize
    
    
    func AchievementForWin(_ gameFlavor:GameFlavor) ->  Achievement
        {
            switch gameFlavor
            {
            case .soccer : return .SoccerSpades
            case .hooligan : return .HooliganSpades
            case .bussing : return .BussingSpades
            case .straight : return .StraightSpades
            }
    }
    override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        let trumps = Game.deck.orderedDeck.filter { $0.suite == trumpSuite }
        var trumpsSet = Set(trumps)
        
        result[CardName.queen.of(PlayingCard.Suite.spades)!] = ricketyKatePoints
        
        trumpsSet.remove(CardName.queen.of(PlayingCard.Suite.spades)!)
        
        for card in trumpsSet
        {
            result[card] = 1
        }
        

        return result
    }
    
    override func countTrumps(_ cards: [PlayingCard]) -> Int
    {
        return cards.filter {$0.suite == PlayingCard.Suite.spades && $0 != CardName.queen.of(PlayingCard.Suite.spades)}.count
    }
}
/// Calculate the score value of the cards
/// Used by the Scorer
class HeartsAwarder : AwarderBase, IAwarder
{
    var description = "Rickety Kate Hearts Rules".localize
    var shortDescription = "Heart"
    var leaderboard = LearderBoard.Hearts
    
    func AchievementForWin(_ gameFlavor:GameFlavor) ->  Achievement
    {
        switch gameFlavor
        {
        case .soccer : return .SoccerHearts
        case .hooligan : return .HooliganHearts
        case .bussing : return .BussingHearts
        case .straight : return .StraightHearts
        }
    }
            override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        let trumps = Game.deck.orderedDeck.filter { $0.suite == trumpSuite }

        for card in trumps
        {
            result[card] = 1
        }
        result[CardName.queen.of(PlayingCard.Suite.spades)!] = ricketyKatePoints
        result[CardName.ace.of(PlayingCard.Suite.hearts)!] = 4
        result[CardName.king.of(PlayingCard.Suite.hearts)!] = 3
        result[CardName.queen.of(PlayingCard.Suite.hearts)!] = 2
        result[CardName.jack.of(PlayingCard.Suite.hearts)!] = 5
      
     
        return result
    }

    var backgroundCards : [PlayingCard] {
        let cards : Array = Game.deck.orderedDeck
            .filter { $0.suite == trumpSuite }
            .sorted()
            .reversed()
        
        return Array(cards[0..<Game.settings.noOfPlayersAtTable])
    }
    var ricketyKatePoints = 13
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.hearts }
    var trumpSuiteSingular = "Heart"
    var trumpSuitePlural : String  { return trumpSuite.description }
    
    
    override func countTrumps(_ cards: [PlayingCard]) -> Int
    {
        return cards.filter{$0.suite == trumpSuite }.count
    }
}


/// Calculate the score value of the cards
/// Used by the Scorer
class JacksAwarder : AwarderBase, IAwarder
{
    var description = "Rickety Kate Jacks Rules".localize
    override var omnibus_ : PlayingCard { return CardName.queen.of(PlayingCard.Suite.diamonds)! }
    var shortDescription = "Jack"
    var leaderboard = LearderBoard.Jacks
    
    
    func AchievementForWin(_ gameFlavor:GameFlavor) ->  Achievement
    {
        switch gameFlavor
        {
        case .soccer : return .SoccerJacks
        case .hooligan : return .HooliganJacks
        case .bussing : return .BussingJacks
        case .straight : return .StraightJacks
        }
    }
    
    override func createBaseCardScores() -> Dictionary<PlayingCard,Int>
    {
        var result =  Dictionary<PlayingCard,Int>()
        result[CardName.queen.of(PlayingCard.Suite.spades)!] = ricketyKatePoints
        
        for suite in Game.deck.normalSuitesInDeck
        {
            result[CardName.jack.of(suite)!] = 2
        }

        return result
    }
    
    var ricketyKatePoints = 10 
    var trumpSuite : PlayingCard.Suite { return PlayingCard.Suite.none }
    var trumpSuiteSingular : String  { return "Jack".localize }
    var trumpSuitePlural : String  { return "Jacks".localize }

    var backgroundCards : [PlayingCard] {
        let cards : Array = Game.deck.orderedDeck
            .filter { $0.suite == PlayingCard.Suite.clubs }
            .sorted()
            .reversed()
        
        
        return Array(cards[0..<Game.settings.noOfPlayersAtTable])
    }

    override func countTrumps(_ cards: [PlayingCard]) -> Int
    {
        return  cards.filter{$0.value == CardName.jack.cardValue }.count
    }
    
   }

