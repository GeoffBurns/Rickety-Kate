//
//  Awarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

/// Calculate the score value of the cards
/// Used by the Scorer
class Awarder
{
    var scores = [Int]()
    var wins = [Int]()
    var scoresForHand = [Int]()
    
    var players = [CardPlayer]()
    var lookup = Dictionary<String,Int>()
    
    static let sharedInstance = Awarder()
    private init() { }

    var allPoints : Int { return  9 + GameSettings.sharedInstance.noOfCardsInASuite }
    
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        var score = 0
        
        let ricketyKate = cards.filter{$0 == CardName.Queen.of(PlayingCard.Suite.Spades)}
        
        let spades = cards.filter{$0.suite == PlayingCard.Suite.Spades && $0 != CardName.Queen.of(PlayingCard.Suite.Spades)}
        if !ricketyKate.isEmpty
           {
            score = 10
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