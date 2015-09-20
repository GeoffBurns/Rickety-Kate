//
//  Awarder.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 19/09/2015.
//  Copyright © 2015 Geoff Burns. All rights reserved.
//

import Foundation

class Awarder
{
    var scores : [Int] = []
    var wins : [Int] = []
    var scoresForHand : [Int] = []
    
    var players : [CardPlayer] = []
    var lookup : Dictionary<String,Int> = [:]
    
    static let sharedInstance = Awarder()
    private init() { }

    
    func scoreFor(cards: [PlayingCard], winnersName: String) ->Int
    {
        var score = 0
        
        let ricketyKate = cards.filter{$0.imageName == "QS"}
        
        let spades = cards.filter{$0.suite == PlayingCard.Suite.Spades && $0.imageName != "QS"}
        if !ricketyKate.isEmpty
        {
            score = 10
        }
        score += spades.count
        
        if !ricketyKate.isEmpty
        {
            StatusDisplay.publish("\(winnersName) won Rickety Kate",message2: "Poor \(winnersName)")
        }
        else if spades.count == 1
        {
            StatusDisplay.publish("\(winnersName) won a spade",message2: "Bad Luck")
        }
        else if spades.count > 1
        {
            StatusDisplay.publish("\(winnersName) won \(spades.count) spades",message2: "Bad Luck")
        }
        else
        {
            StatusDisplay.publish("\(winnersName) won the Trick")
        }
        
        return score
    }
}