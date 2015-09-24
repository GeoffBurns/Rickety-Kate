//
//  CardPassingStrategy.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 16/09/2015.
//  Copyright (c) 2015 Geoff Burns. All rights reserved.
//

import Foundation


// What Strategy does a computer player use when passing the 3 worst cards.
protocol CardPassingStrategy
{
    func chooseWorstCards(player:CardHolder) -> [PlayingCard]
    
}
public class HighestCardsPassingStrategy : CardPassingStrategy
{
    static let sharedInstance = HighestCardsPassingStrategy()
    private init() { }
    func chooseWorstCards(player:CardHolder) -> [PlayingCard]
    {
        let orderedArray = player.hand.sort({$0.value > $1.value})
        let slice = orderedArray[0...2]
        return Array(slice)
    }
}

// TODO an alternative strategy is creating a suite with few cards
/*
public class ShortSuitePassingStrategy : CardPassingStrategy
{
static let sharedInstance = ShortSuitePassingStrategy()
private init() { }
func chooseWorstCards(player:CardHolder) -> [PlayingCard]
{

return result
}
}
*/
// TODO an alternative strategy is to get rid of cards form suites where your lowest card is high
/*
public class ProtectHighMiniumSuitePassingStrategy : CardPassingStrategy
{
static let sharedInstance = ProtectHighMiniumSuitePassingStrategy()
private init() { }
func chooseWorstCards(player:CardHolder) -> [PlayingCard]
{

//return result
}
}*/
